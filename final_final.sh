#!/bin/bash

#Section for Functions to be put in a separate library later
#At the moment I'm only working on one screen so I need everything in one place

main() {
#Input Validation
if [ $# -eq 1 ]; then
	echo -e "Scanning Target: $1\nPlease wait for the scan to complete"
else
	echo "Usage: $0 <target_ip_or_hostname>" >&2
	exit 1
fi

OUTPUT="/home/codio/workspace/final_output.txt"
FULL_OUTPUT="/home/codio/workspace/full_final_output.txt"
TARGET="$1"

write_header

write_ports

write_vulns

write_recs

write_footer
}

write_header() {
#A simple header that displays the address being scanned
echo -e "-NETWORK SECURITY SCAN REPORT-\n------------------------------\n" > $OUTPUT
echo -e "--- Target IP Address/Host ---\n[1] $TARGET\n" >> $OUTPUT
}

write_ports() {
#Utilizes nmap to scan the machine and display open ports found on the machine
echo "- Open Ports and Detected Services -" >> $OUTPUT
SCAN_RESULTS=$(nmap -sV -O --script vuln "$TARGET")
echo "$SCAN_RESULTS" | grep "open" >> $OUTPUT
echo "$SCAN_RESULTS" > $FULL_OUTPUT
echo >> $OUTPUT
}

write_vulns() {
#Out of the results gathered by the nmap scan, any vulnerabilities will be mentioned and why
echo "- Vulnerabilities Identified -" >> $OUTPUT
echo "$SCAN_RESULTS" | grep "VULNERABLE" >> $OUTPUT
echo "$SCAN_RESULTS" | while read -r line; do
	#For the purpose of the scanner for the final, several services and known vulnerabilities are used
	case "$line" in 
		*"Apache httpd 2.4.7"*)
			local product_name="Apache httpd"
			local product_version="2.4.7"
			query_nvd "$product_name" "$product_version" >> "$OUTPUT"
			;;
		*"Slowloris"*)
			echo "[!!] POTENTIAL VULNERABILITY: Slowloris Denial-of-Service tool detected! Please investigate as soon as possible." >> "$OUTPUT"
			;;
		*"vsftpd 2.3.4"*)
			echo "[!!] POTENTIAL VULNERABILITY: This version of vsftpd is not up-to-date." >> "$OUTPUT"
			;;
		*"OpenSSH 6.6.1p1"*)
			echo "[!!] POTENTIAL VULNERABILITY: This version of OpenSSH is outdated." >> "$OUTPUT"
			;;
		*"Linux 2.6.32"*)
			echo "[!!] POTENTIAL VULNERABILITY: This version of Linux is outdated and may be subject to several CVEs" >> "$OUTPUT"
			;;
	#Note: Find more services
	esac

done
echo >> $OUTPUT
}

write_recs() {
#Each vulnerability found in the write_vulns function will have a mitigation strategy here.
echo "--- Network Recommendation ---" >> $OUTPUT
echo "1. Ensure that Apache httpd is updated to at least version 2.4.63 for the most recent protections" >> $OUTPUT
echo "2. Remove all presence of Slowloris from your systems to prevent Denial-of-service attacks" >> $OUTPUT
echo "3. Ensure that vsftpd is updated to at least version 3.0.5 for the most recent protections" >> $OUTPUT
echo "4. Ensure that OpenSSH is updated to at least version 8.3 for the most recent protections." >> $OUTPUT
echo "5. Ensure that the Linux kernel is updated to at least version 6.12 for the most recent protections." >> $OUTPUT
#Note: Automate recommendations
}

write_footer() {
#Adds an ending to both the terminal and the outout to signal the script finishing.
echo -e "\n$SCAN_RESULTS" | grep "seconds" >> $OUTPUT
echo -e "\nEnd of Report $(date)" >> $OUTPUT
echo -e "\nScan complete! You can review the scan results at $OUTPUT"
echo -e "\n$SCAN_RESULTS" | grep "seconds"
}

query_nvd() {
#Takes the product and version from the nmap scan and runs it through the NVD to find the CVEs connected to them
    local product="$1"
    local version="$2"
    local results_limit=3
    
    echo
    echo "Querying NVD for vulnerabilities in: $product $version..."

    local search_query
    search_query=$(echo "$product $version" | sed 's/ /%20/g')

    local nvd_api_url="https://services.nvd.nist.gov/rest/json/cves/2.0?keywordSearch=${search_query}&resultsPerPage=${results_limit}"

    local vulnerabilities_json
    vulnerabilities_json=$(curl -s "$nvd_api_url")

    if [[ -z "$vulnerabilities_json" ]]; then
        echo "  [!] Error: Failed to fetch data from NVD. The API might be down or unreachable."
        return
    fi
    if echo "$vulnerabilities_json" | jq -e '.message' > /dev/null; then
        echo "  [!] NVD API Error: $(echo "$vulnerabilities_json" | jq -r '.message')"
        return
    fi
    if ! echo "$vulnerabilities_json" | jq -e '.vulnerabilities[0]' > /dev/null; then
        echo "  [+] No vulnerabilities found in NVD for this keyword search."
        return
    fi
	echo "$vulnerabilities_json" | jq -r \
        '.vulnerabilities[] | "  CVE ID: \(.cve.id)\n  Description: \((.cve.descriptions[] | select(.lang=="en")).value | gsub("\n"; " "))\n  Severity: \(.cve.metrics.cvssMetricV31[0].cvssData.baseSeverity // .cve.metrics.cvssMetricV2[0].cvssData.baseSeverity // "N/A")\n---"'
}
#End of Functions

main "$@"

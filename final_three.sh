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
SCAN_RESULTS=$(nmap -sV --script vuln "$TARGET")
echo "$SCAN_RESULTS" | grep "open" >> $OUTPUT
echo "$SCAN_RESULTS" > $FULL_OUTPUT
echo
}

write_vulns() {
#Out of the results gathered by the nmap scan, any vulnerabilities will be mentioned and why
echo "- Vulnerabilities Identified -" >> $OUTPUT
echo "$SCAN_RESULTS" | grep "VULNERABLE" >> $OUTPUT
echo "$SCAN_RESULTS" | while read -r line; do
	case "$line" in 
		*"Apache httpd 2.4.7"*)
			echo "[!!] POTENTIAL VULNERABILITY: Apache httpd 2.4.7 is being used, which has several CVE entries within the database." >> $OUTPUT
			;;
		*"Slowloris"*)
			echo "[!!] POTENTIAL VULNERABILITY: Slowloris Denial-of-Service tool detected! Please investigate as soon as possible." >> $OUTPUT
			;;
		*"vsftpd 2.3.4"*)
			echo "[!!] POTENTIAL VULNERABILITY: vsftpd 2.3.4 is running. This version is know to have a critical backdoor." >> $OUTPUT
			;;
	esac
done
}

write_recs() {
echo "--- Network Recommendation ---" >> $OUTPUT
echo -e "1. Ensure all software is up to date\n2. Check complexity of account passwords\n3. Augment firewall settings\n" >> $OUTPUT
}

write_footer() {
echo "End of Report $(date)" >> $OUTPUT
echo "Scan complete! You can review the scan results at $OUTPUT"
}
#End of Functions

main "$@"

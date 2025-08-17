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
TARGET="$1"

write_header

write_ports

write_vulns

write_recs

write_footer
}

#This is now in the GitHub repository

write_header() {
echo -e "-NETWORK SECURITY SCAN REPORT-\n------------------------------\n" > $OUTPUT
echo -e "--- Target IP Address/Host ---\n[1] $TARGET\n" >> $OUTPUT
}

write_ports() {
echo "--------- Open Ports ---------" >> $OUTPUT
echo -e "Port 80/tcp - http\nPort 443/tcp - https\n" >> $OUTPUT
}

write_vulns() {
echo "- Vulnerabilities Identified -" >> $OUTPUT
echo -e "1. CVE-2023-XXXX - Outdated Web Server\n2. Default Credentials - FTP Server\n3. Undesired Port open - Port 21\n" >> $OUTPUT
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

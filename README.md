# NTSFinal - Network Vulnerability Scanner and Report Generator - Version 1.0

## Purpose
The network address chosen will be scanned by Nmap, revealing opened ports and services. That data will be sorted and categorized into an output report. The script will react to input provided by the scan to notice potential vulnerabilities to the network and provide guidance to improving the security of the network.

This the project in this repository is the culmination of a semester of learning and understanding from my Shell Scripting class which dives into several of the basics and best practices for Bash scripting.

## Features

### Multiple Outputs
A sorted final output file will be created and replaced everytime a new scan is conducted. A separate output file is used to place the raw data for the nmap scan to be analyzed at the user's discretion.

### Open Ports and Active Services
All open ports will be displayed as well as any services, positive or negative, that the target address is currently running. All services will be collected and applied to the National Vulnerability Database to look for potential flaws that must be addressed in future sections.

### Dectected Vulnerabilities
A list of all vulnerabilities collected from the NVD are displayed within the output document. Each entry outlines the CVE ID and the problem that can be taken advantage of to bypass each service. The severity of the vulnerability will also be part of the entry to give a hierarchy to which problems should be solved first. Depending on the vulnerabilities detected, the feedback for the remediation section may be different.

### Network Recommendations
Depending on the vulnerabilities outlined in the previous section, mitigation and recovery strategies will be given to maximize potential security and simplify the process.

## Usage Guidelines
### Root privileges are required to scan the OS

Syntax: sudo ./final_scan.sh <target>

## Current Status
The initial scanner has been released with implementation for all features above. Depending on user inputs, the script may become volatile.

## Future Implementation
* Enhancing Efficency for Reduced Scan Times (Rustscan Implementation?)
* Additional Vulnerability Types
* Scaled Scanning Capabilities (Normal or Full Scan)
* Miscellaneous Enhancements

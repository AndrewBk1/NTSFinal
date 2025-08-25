# NTSFinal - Network Vulnerability Scanner and Report Generator - Version 1.0

## Purpose
Scan a network using nmap, categorize the information, and provide help on how to most efficiently strengthen the chosen network.

This the project in this repository is the culmination of a semester of learning and understanding from my Shell Scripting class which dives into several of the basics and best practices for Bash scripting.

## Features

### Multiple Outputs
A sorted final output file will be created and replaced everytime a new scan is conducted. A separate output file is used to place the raw data for the nmap scan to be analyzed at the user's discretion.

### Open Ports and Active Services
All open ports will be displayed as well as any services, positive or negative, that the target address is currently running. All services will be collected and applied to the National Vulnerability Database to look for potential flaws that must be addressed in future sections.

### Dectected Vulnerabilities
A list of all vulnerabilities collected from the NVD are displayed within the output document. Each entry outlines the CVE ID and the problem that can be taken advantage of to bypass each service. Depending on the vulnerabilities detected, the feedback for the remediation section may be different.

## Current Status
Scanner Output into a Text Document implemented

## Future Implementation
* Vulnerability Analysis
* Miscellaneous Enhancements

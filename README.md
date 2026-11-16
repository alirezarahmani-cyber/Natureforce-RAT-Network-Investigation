# Natureforce — RAT Network Investigation

![SOC Tier 1](https://img.shields.io/badge/SOC-Tier%201-blue)
![Wireshark](https://img.shields.io/badge/Tool-Wireshark-1679A7)
![Severity](https://img.shields.io/badge/Severity-High-red)
![Status](https://img.shields.io/badge/Status-Completed-green)

## Project Overview

A hands-on SOC Tier 1 investigation of malicious executable delivery and suspected Remote Access Trojan (RAT) command-and-control activity.

This project analyzes the Natureforce traffic analysis exercise dated October 1, 2026, using network packet analysis, malware hash identification, threat intelligence, and evidence correlation.

The objective is to validate security alerts, identify the affected workstation, investigate suspicious network communications, and produce a defensible incident assessment for escalation to SOC Tier 2.

## Investigation Environment

| Property | Details |
|---|---|
| Dataset | Natureforce — October 1, 2026 |
| Evidence Source | PCAP |
| Total Packets | 42,497 |
| Capture Duration | 40 minutes 31 seconds |
| Network | 10.10.1.0/24 |
| Domain | natureforce.com |
| Investigation Level | SOC Tier 1 |

## Tools Used

- **Wireshark:** Network traffic analysis, protocol inspection, TCP stream analysis, and I/O graphs.
- **TShark:** Extraction of reconstructed HTTP file data.
- **PowerShell:** SHA-256 calculation directly from extracted bytes in memory.
- **VirusTotal:** Hash-based malware identification and threat intelligence.

## Investigation Workflow

1. Capture properties and protocol hierarchy analysis.
2. Endpoint and conversation analysis.
3. TCP, HTTP, DNS, and TLS traffic investigation.
4. Host identification using NBNS and Kerberos.
5. Suspicious executable transfer validation.
6. Network behavioral analysis and TCP Keep-Alive identification.
7. Security alert validation and IP discrepancy investigation.
8. SHA-256 extraction and malware identification.
9. Evidence correlation, incident assessment, and escalation.

## Key Findings

### 1. Affected Workstation

| Attribute | Value |
|---|---|
| IP Address | 10.10.1.128 |
| Hostname | DESKTOP-4VGYQX7 |
| MAC Address | 00:22:fb:ec:7e:e7 |
| Computer Account | DESKTOP-4VGYQX7$ |
| Domain | NATUREFORCE.COM |

### 2. Confirmed Malicious Executable Delivery

A Windows executable named `runner_ilove.exe` was transferred from an external server over HTTP on TCP port 9000.

- External endpoint: `107.175.82[.]242:9000`
- TCP Stream: `128`
- HTTP Request Frame: `23091`
- HTTP Response Frame: `24916`
- HTTP Status: `200 OK`
- User-Agent: `curl/8.21.0`
- File Size: `1,646,592 bytes`

The reconstructed HTTP payload contained an MZ signature and Windows PE indicators. Hash-based threat intelligence identified the file as malicious with high confidence.

### 3. Suspicious Post-Download Communication

Approximately 5.7 seconds after the completed executable transfer, the same workstation established a TCP connection to `195.63.128[.]106:443`.

The connection lasted approximately 37 minutes and exhibited:

- An unusual application protocol classification.
- A high-volume initial data exchange.
- Periodic TCP Keep-Alive activity at approximately 20-second intervals.

The connection was classified as suspicious potential C2 activity. TCP Keep-Alive behavior alone does not establish malware beaconing.

### 4. Malware Identification

The executable's SHA-256 hash was calculated directly from the PCAP using TShark and PowerShell, without executing the sample.

**SHA-256:**

`b789adce70c028a6d17be45ec34667aa95586350ee0c4057e75b138b1ad35061`

| VirusTotal Result | Details |
|---|---|
| Detection Ratio | 48/71 |
| Known Filename | service.exe |
| Threat Category | Trojan |
| Popular Threat Label | trojan.capdoor/zusy |

[View VirusTotal Report](https://www.virustotal.com/gui/file/b789adce70c028a6d17be45ec34667aa95586350ee0c4057e75b138b1ad35061)

### 5. Alert Validation

The executable-transfer alert was successfully validated.

The reported CNCmachineRMS RAT C2 alert referenced `195.64.128[.]106:443`, whereas the suspicious connection observed in the PCAP involved `195.63.128[.]106:443`.

No packets matching the reported IP were found. This discrepancy was documented rather than assumed to be a confirmed typographical error.

## Incident Assessment

| Assessment | Result |
|---|---|
| Incident Type | Malware Delivery / Suspected RAT Infection |
| Recommended Severity | High |
| Malware Delivery | Confirmed |
| Malware Execution | Not Established |
| C2 Activity | Suspected — Unconfirmed |
| Disposition | Escalate to Tier 2 |

The confirmed malicious executable delivery and subsequent suspicious external communication provide sufficient justification for escalation.

Endpoint investigation is required to establish execution, persistence, process attribution, and potential command-and-control activity.

## Investigation Report

The detailed technical report includes packet-level evidence, investigation methodology, the incident timeline, indicators of compromise, investigation limitations, and escalation recommendations.

[Read the Full Investigation Report](investigation-report.md)

## Repository Contents

- `README.md` — Project overview and key findings.
- `investigation-report.md` — Complete SOC Tier 1 incident report.
- `evidence/` — Supporting Wireshark and VirusTotal screenshots.
- `scripts/` — PowerShell script for SHA-256 extraction.

## Skills Demonstrated

- Network traffic analysis and protocol investigation.
- Security alert validation.
- Suspicious file transfer identification.
- TCP stream and behavioral analysis.
- Active Directory host attribution.
- Malware hash extraction and threat intelligence.
- Evidence correlation and incident timeline reconstruction.
- SOC Tier 1 incident reporting and escalation.

## Limitations

This investigation was conducted using PCAP evidence and publicly available hash-based threat intelligence. No endpoint logs, EDR telemetry, or live system access were available.

The human user, malware execution, and exact CNCmachineRMS RAT attribution could not be independently established.

## Disclaimer

This project was created for cybersecurity education and SOC analyst portfolio development. No malicious executable was executed or included in this repository.

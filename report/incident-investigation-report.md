# Natureforce — Incident Investigation Report

**Incident date:** 2026-10-01 | **Scope:** SOC Tier 1 educational simulation | **Status:** Completed; escalation recommended | **Provisional severity:** High

## 1. Executive Summary

The internal workstation 10.10.1.128 received a malicious Windows executable from 107.175.82.242:9000 over HTTP. Its reconstructed SHA-256 matched a VirusTotal record with 48/71 malicious detections. Approximately 5.75 seconds after the reassembled response, the same workstation initiated an unusual TCP connection to 195.63.128.106:443 lasting about 37 minutes. The supplied RAT alert names a different IP. The evidence supports escalation but does not establish execution or confirmed C2.

## 2. Scope and methodology

See [dataset details](../dataset/README.md). Wireshark, TShark, PowerShell and VirusTotal were used. Only the capture and hash-based intelligence were reviewed; no endpoint telemetry or live system access was available. All event times are UTC.

## 3. Host identification

| Attribute | Value |
|---|---|
| IP | 10.10.1.128 |
| MAC | 00:22:fb:ec:7e:e7 |
| Hostname | DESKTOP-4VGYQX7 |
| Computer account | DESKTOP-4VGYQX7$ |
| Domain | NATUREFORCE.COM |
| DNS / DC | 10.10.1.10 |
| Gateway | 10.10.1.1 |
| Human user | Not established |

Frame 33 NBNS registration and Kerberos frames 93/95 support the host and computer account identity. LDAP frames 25/27 show RootDSE discovery, not human-user attribution. The initial Kerberos preauthentication-required response (86) was followed by AS-REQ (93) and AS-REP (95).

## 4. Network investigation

### F-001 — Malicious executable delivery

Stream 128, frame 23091, contains GET /wilow/runner_ilove.exe with Host 107.175.82.242:9000 and User-Agent curl/8.21.0. Frame 24916 contains HTTP 200 OK, binary/octet-stream, and 1,646,592 bytes of reconstructed body matching Content-Length. MZ, DOS stub and PE section names support Windows executable identification. The transfer is confirmed; file execution is not.

### F-002 — Suspicious external session

Stream 130 begins at frame 24963 to 195.63.128.106:443; handshake frames 24963/24967/24968; first payload frame 24969. Approximately 14 MB inbound traffic and 2,233.6358 seconds duration were observed. Wireshark labeled traffic SSLv2, but a valid SSLv2 handshake was not established. I/O graph review showed an initial burst and much lower subsequent activity. After relative second 220, 220 payload-bearing packets were observed; the displayed sample was labeled TCP Keep-Alive, with repeated sequence numbers and about 20-second spacing. No application polling was established. The session remains suspicious, not confirmed C2.

Stream 127 to 57.150.53.97:443 showed TLS 1.3 and SNI consistent with Azure Blob Storage, with roughly 12 MB inbound. Encrypted content was not inspected; this connection was deprioritized, not declared benign.

## 5. Alert validation

- Alert 1: executable transfer from 107.175.82.242:9000 — validated by stream 128.
- Alert 2: CNCmachineRMS RAT C2 at 195.64.128.106:443 — the filter `ip.addr == 195.64.128.106` returned zero packets. The observed endpoint is 195.63.128.106:443. A typo is possible but unverified; direct alert validation is unresolved.

## 6. File identification

The reconstructed HTTP body was hashed in memory with TShark and PowerShell. Byte count matched 1,646,592. See [script](../scripts/extract_sha256.ps1).

SHA-256: `b789adce70c028a6d17be45ec34667aa95586350ee0c4057e75b138b1ad35061`

[VirusTotal record](https://www.virustotal.com/gui/file/b789adce70c028a6d17be45ec34667aa95586350ee0c4057e75b138b1ad35061): 48/71 detections at the recorded lookup; service.exe; 64-bit PE; Trojan; popular label trojan.capdoor/zusy; vendor labels include AsyncRAT and Backdoor. Exact CNCmachineRMS attribution is not established. Relations showed dns.google, not the suspected IP; this does not disprove the link. No sample was executed.

## 7. Timeline and indicators

See [timeline](../evidence/timeline.csv), [IOCs](../evidence/iocs.csv) and [findings](../evidence/findings.md). The observed ordering supports suspicion but not causality. The reported alert IP is an unverified lead, not a confirmed IOC.

## 8. Assessment and escalation

High confidence malicious file delivery; suspected workstation compromise and potential C2, unconfirmed. Recommend High severity and escalation to Tier 2. Confirm execution and process/network linkage using endpoint telemetry, investigate persistence and scope, validate the RAT alert and consider isolation under organizational procedure. These are recommendations, not completed actions.

## 9. Limitations

No endpoint logs, disk evidence, EDR or live host access. Human user, execution, persistence, exfiltration, wider scope, actual protocol in stream 130 and exact malware family remain unresolved. The supplied alert IP discrepancy is retained. Severity is a provisional analyst assessment.

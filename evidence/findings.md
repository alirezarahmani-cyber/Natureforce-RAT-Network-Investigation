# Findings and Confidence Assessment

| ID | Finding | Evidence | Assessment |
|---|---|---|---|
| F-001 | Malicious executable delivery | [HTTP request](screenshots/08_http_request.png), [response](screenshots/09_http_response.png), [VirusTotal](screenshots/14_virustotal.png) | Confirmed transfer; high confidence maliciousness |
| F-002 | Suspicious post-download communication | [Stream 130](screenshots/11_suspicious_stream.png), frame 40202 | Suspected C2; unconfirmed |
| F-003 | Alert IP discrepancy | `ip.addr == 195.64.128.106` returned zero packets | Second alert not directly validated |
| F-004 | Host identity | Frame 33; [Kerberos](screenshots/12_kerberos.png), frames 93/95 | High confidence computer identity; human user unknown |

**Disposition:** Escalate to Tier 2. Recommended severity High; endpoint execution, persistence, exact RAT family and C2 attribution unresolved.

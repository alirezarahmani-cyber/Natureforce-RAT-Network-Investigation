param([Parameter(Mandatory=$true)][string]$Pcap, [string]$TShark = "C:\Program Files\Wireshark\tshark.exe")
$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $Pcap -PathType Leaf)) { throw "Provide the PCAP file, not its folder." }
$hex = & $TShark -r $Pcap -Y "frame.number == 24916" -T fields -e http.file_data
if ($LASTEXITCODE -ne 0) { throw "TShark failed" }
$hex = ($hex -join '') -replace '[:\s]',''
if ($hex.Length -ne 3293184 -or $hex -notmatch '^[0-9a-fA-F]+$') { throw "Invalid or incomplete file data" }
$bytes = [byte[]]::new($hex.Length / 2)
for ($i=0; $i -lt $bytes.Length; $i++) { $bytes[$i]=[Convert]::ToByte($hex.Substring($i*2,2),16) }
$sha=[Security.Cryptography.SHA256]::Create()
try { $bytes.Length; [BitConverter]::ToString($sha.ComputeHash($bytes)).Replace('-','').ToLowerInvariant() } finally { $sha.Dispose() }

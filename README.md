# SMB Client Protocol Fuzzer

[![Metasploit](https://img.shields.io/badge/Metasploit-Auxiliary-blue.svg)](https://metasploit.com)
[![License](https://img.shields.io/badge/License-MSF-green.svg)](https://github.com/rapid7/metasploit-framework/wiki)
[![Python](https://img.shields.io/badge/Python-3.8%2B-blue.svg)](https://www.python.org)

**Windows Explorer, smbclient, WinSCP**  
Target: **SMB1/2/3 negotiation**, **session setup**, **tree connect** parsing bugs.

Windows CMD: dir \127.0.0.1\SHARE > CRASH!    
Linux: smbclient //127.0.0.1 > CRASH!     
FileZilla: smb://127.0.0.1 > CRASH!      

Fuzzes **critical SMB protocol parsers**:
- SMB2 Negotiate Context List (most crashes here)
- Session Setup security blob
- Tree Connect share paths
- Dialect selection overflow

## **Quick Start**

### 1.Metasploit
```bash
# Save as: modules/auxiliary/smb_client_fuzzer.rb
msfconsole
msf6 > reload_all
msf6 > use auxiliary/smb_client_fuzzer
msf6 > set SRVPORT 1445
msf6 > run
```

### 2. Test Targets

# Windows (CMD/PowerShell)
```
dir \\127.0.0.1:1445\SHARE
net use Z: \\127.0.0.1:1445\SHARE
```

# Linux
```
smbclient -L //127.0.0.1:1445 -p 1445 -N
smbclient //127.0.0.1/SHARE -p 1445 -N
```
# Output
SMB Fuzzer listening on 0.0.0.0:1445   
SMB client connected: 127.0.0.1:54321  
SMB2/3 Negotiate fuzz (4612B)     
SMB CRASH: 127.0.0.1:54321 (SMB2/3)     

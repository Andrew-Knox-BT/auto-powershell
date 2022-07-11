Set-NetFirewallRule -PolicyStore localhost -DisplayName 'TCP 445( SMB )' -Enabled True

Invoke-CimMethod -CimSession $cimsession -ClassName Win32_Process -MethodName "Create" -Arguments @{
    CommandLine = 'gpupdate.exe'; CurrentDirectory = "C:\windows\system32"
  }
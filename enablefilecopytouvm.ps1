Set-Service -Name LanmanServer -StartupType Automatic
Start-Service -name LanmanServer
Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system\' -Name 'LocalAccountTokenFilterPolicy' -Value 1
Set-NetFirewallRule -PolicyStore   -DisplayName 'TCP 445( SMB )' -Enabled True 
gpupdate /force


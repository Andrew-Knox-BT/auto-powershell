
Get-NetFirewallRule | fl mandatory | Get-Member 

Get-NetFirewallRule  | Get-Member 
Get-NetFirewallRule -PolicyStore activestore  | Where-Object {$_.DisplayName -eq 'TCP 445( SMB )'} | Format-Custom -Property * 
Get-NetFirewallRule -PolicyStore activestore  | Where-Object {$_.DisplayName -eq 'TCP 445( SMB )'} | fl -Property * 

Get-NetFirewallRule -PolicyStore activestore | Where-Object {$_.Direction -eq 'Inbound'} |    Sort-Object -Property DisplayName | fl DisplayName, Direction, PolicyStoreSource, PolicyStoreSourceType, enabled
Get-NetFirewallRule -PolicyStore localhost | fl DisplayName, Enabled, PolicyStoreSource, PolicyStoreSourceType, PrimaryStatus
Get-NetFirewallRule -PolicyStore activestore | fl DisplayName, Enabled, PolicyStoreSource, PolicyStoreSourceType, PrimaryStatus


Set-NetFirewallRule -PolicyStore localhost -DisplayName 'TCP 445( SMB )' -Enabled false
gpupdate /force


Set-Service -Name LanmanServer -StartupType Automatic
Start-Service -name LanmanServer

Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system\' -Name 'LocalAccountTokenFilterPolicy' -Value 1
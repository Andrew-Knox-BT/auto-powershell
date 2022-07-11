#

$cred = Get-Credential
$cimsession = New-CimSession -ComputerName 10.200.114.165 $cred

Set-NetFirewallrule -CimSession 


Get-NetFirewallRule -PolicyStore activestore | Where-Object {$_.Direction -eq 'Inbound'} |    Sort-Object -Property DisplayName | fl DisplayName, Direction, PolicyStoreSource
Get-NetFirewallRule -PolicyStore localhost | Where-Object {$_.Direction -eq 'Inbound'} |    Sort-Object -Property DisplayName | fl DisplayName, Direction, PolicyStoreSource


Get-NetFirewallRule -CimSession $cimsession -PolicyStore localhost | Where-Object {$_.displayname -eq 'TCP 445( SMB )'} | Format-List DisplayName, Enabled

Get-NetFirewallRule -CimSession $cimsession -PolicyStore localhost | Where-Object {$_.displayname -eq 'TCP 445( SMB )'} | Format-List *
#CimClass                : root/standardcimv2:MSFT_NetFirewallRule
Get-NetFirewallRule -CimSession $cimsession -PolicyStore ActiveStore | Where-Object {$_.displayname -eq 'TCP 445( SMB )'} | Format-List DisplayName, Enabled


Get-CimInstance -CimSession $cimsession -Namespace root/StandardCimv2/  -ClassName __NAMESPACE
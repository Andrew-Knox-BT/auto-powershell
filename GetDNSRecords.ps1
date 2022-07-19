$cred = Get-Credential
$cimsession = New-CimSession -ComputerName 10.200.114.105 $cred 

get-Item wsman:localhost\client\trustedhosts

Get-DnsServerResourceRecord -CimSession $cimsession -ZoneName "uvm.lab"

Get-DnsServer -CimSession $cimsession
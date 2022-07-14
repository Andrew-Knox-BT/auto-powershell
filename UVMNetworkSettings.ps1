#To make the servers easier to manage they need to be added to DNS
#Set DNS Address. Currently in lab the DNS server is 10.200.114.105
$cred = Get-Credential
$cimsession = New-CimSession -ComputerName 10.200.114.165 $cred 

Set-DnsClientServerAddress -CimSession $cimsession -InterfaceAlias 'Ethernet0' -ServerAddresses ("10.200.114.105")
set-dnsclient -CimSession $cimsession -InterfaceAlias 'Ethernet0' -ConnectionSpecificSuffix 'red.local' -UseSuffixWhenRegistering $true
Register-DnsClient -CimSession $cimsession
#Set DNS suffix for this connection
#Curretly in lab the main domain is red.local


#Set Use this connections DNS suffix in DNS registration
#With this box checked it will use the DNS suffix specified in the DNS suffix for this connection box


#Run command to register the server in DNS
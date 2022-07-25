#This is the first script to run on the UVM. 

$EAFRWinRM5985 = 'Escalation Automation - Windows Remote Management (HTTP-In)'

#This will enable WinRM access to the UVMs
if ((Get-NetFirewallRule -PolicyStore ActiveStore).PolicyStoreSourceType -eq 'GroupPolicy') {
    #For 2016 UVMs - Firewall rules are managed with Local Group Policy
    # -PolicyStore localhost will create the rule in the GPO 
    New-NetFirewallRule -PolicyStore localhost -DisplayName $EAFRWinRM5985 -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow -Profile Public -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 
}
else {
    #For 2012R2 UVMs - Firewall Rules are managed with Windows Firewall and not through GPO like the newer 2016 UVMs
    New-NetFirewallRule -DisplayName $EAFRWinRM5985 -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow -Profile Public -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 
}



$downloadgpo = 'https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/ExternalFiles/gpo.txt'
$downloadLGPO = 'https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/ExternalFiles/LGPO.exe'

Invoke-WebRequest -UseBasicParsing -Uri $downloadgpo -OutFile .\gpo.txt 
Invoke-WebRequest -UseBasicParsing -Uri $downloadLGPO -OutFile .\LGPO.exe
$currentdir = Get-Location
&$currentdir\lgpo.exe /t $currentdir\gpo.txt

#To make the servers easier to manage they need to be added to DNS
#Set DNS Address. Currently in lab the DNS server is 10.200.114.105
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet0' -ServerAddresses ("10.200.114.105")

#Set DNS suffix for this connection and Set Use this connections DNS suffix in DNS registration
#Curretly in lab the main domain is red.local
set-dnsclient -InterfaceAlias 'Ethernet0' -ConnectionSpecificSuffix 'uvm.lab' -UseSuffixWhenRegistering $true
#With this setting it will use the DNS suffix specified in the DNS suffix for this connection box to regeister the machein in DNS

#Run command to register the server in DNS
Register-DnsClient -CimSession $cimsession


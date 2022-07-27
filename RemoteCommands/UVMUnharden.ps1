#Main file to run against a UVM to unharden the firewall and start needed services to allow outside access into the UVM for copying files and running tests 
get-Item wsman:localhost\client\trustedhosts
#setup credentials for the session
$cred = Get-Secret -Name UVMUsernameAndPassword
$cimsession = New-CimSession -ComputerName 10.200.114.165 $cred 
#If you get access denied make sure LocalAccountTokenFilterPolicy is enabled on the server

#Turn off LocalAccountTokenFiltering in GPO - Computer Configuration > Administrative Settings > SCM Pass the hash > Apply UAC Restrictions
#Change from Enabled to Disabled 
#If this is left enabled Local Account Token Filtering will get disabled on next policy update


#Noticed on new UVM the server service is already running out of the box. 
#Add a check here to see if the server service is already running if so skip this step

#Get Server service object from remote server 
$lanmanserver = Get-CimInstance -CimSession $cimsession win32_service | Where-Object Name -eq "lanmanserver" 
#Set Server serice to start automatically on the remote computer
Invoke-CimMethod -CimSession $cimsession -InputObject $lanmanserver -methodname ChangeStartmode -Arguments @{startmode='automatic'}
#Start the server service on the remote computer
Invoke-CimMethod -CimSession $cimsession -InputObject $lanmanserver -methodname StartService 


<#
Enable Port 445 on the firewall
Using PolicyStore -localhost this will make the change on the local GPO firewall setting. 
This setting can be found via gpedit.msc > Computer Configuration > Windows Settings > Security Settings > Windows Defender Firewall
#>
$EAFRWinRM445 = 'Escalation Automation - TCP 445( SMB )'
if ((Get-NetFirewallRule -CimSession $cimsession -PolicyStore ActiveStore).PolicyStoreSourceType -eq 'GroupPolicy') {
  #For 2016 UVMs - Firewall rules are managed with Local Group Policy
  # -PolicyStore localhost will create the rule in the GPO 
  New-NetFirewallRule -CimSession $cimsession -PolicyStore localhost -DisplayName $EAFRWinRM445 -Direction Inbound -LocalPort 445 -Protocol TCP -Action Allow -Profile Any -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 
  #After the rule is enabled to Local GPO has to be applied to update the new firewall rule in the PolicyStore -ActiveStore
  Invoke-CimMethod -CimSession $cimsession -ClassName Win32_Process -MethodName "Create" -Arguments @{CommandLine = 'gpupdate.exe'; CurrentDirectory = "C:\windows\system32"
}
}
else {
  #For 2012R2 UVMs - Firewall Rules are managed with Windows Firewall and not through GPO like the newer 2016 UVMs
  New-NetFirewallRule -CimSession $cimsession -DisplayName $EAFRWinRM445 -Direction Inbound -LocalPort 445 -Protocol TCP -Action Allow -Profile Any -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 
}


#See status of firewall rule
Get-NetFirewallRule -CimSession $cimsession -PolicyStore localhost | Where-Object {$_.displayname -eq $EAFRWinRM445} | Format-List DisplayName, Enabled
Get-NetFirewallRule -CimSession $cimsession -PolicyStore ActiveStore | Where-Object {$_.displayname -eq $EAFRWinRM445} | Format-List DisplayName, Enabled




#To make the servers easier to manage they need to be added to DNS
#Set DNS Address. Currently in lab the DNS server is 10.200.114.105
Set-DnsClientServerAddress -CimSession $cimsession -InterfaceAlias 'Ethernet0' -ServerAddresses ("10.200.114.105")

#Set DNS suffix for this connection and Set Use this connections DNS suffix in DNS registration
#Curretly in lab the main domain is red.local
set-dnsclient -CimSession $cimsession -InterfaceAlias 'Ethernet0' -ConnectionSpecificSuffix 'uvm.lab' -UseSuffixWhenRegistering $true
#With this setting it will use the DNS suffix specified in the DNS suffix for this connection box to regeister the machein in DNS

#Run command to register the server in DNS
Register-DnsClient -CimSession $cimsession
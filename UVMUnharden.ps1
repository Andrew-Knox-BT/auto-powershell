#Main file to run against a UVM to unharden the firewall and start needed services to allow outside access into the UVM for copying files and running tests 
get-Item wsman:localhost\client\trustedhosts
#setup credentials for the session
$cred = Get-Credential
$cimsession = New-CimSession -ComputerName 10.200.114.165 $cred 
#If you get access denied make sure LocalAccountTokenFilterPolicy is enabled on the server

#Turn off LocalAccountTokenFiltering in GPO - Computer Configuration > Administrative Settings > SCM Pass the hash > Apply UAC Restrictions
#Change from Enabled to Disabled 
#if this is left enabled Local Account Token Filtering will get disabled on next policy update


#Set DNS server address

#Set DNS connection suffix - red.local (current domain and dns server is 10.200.114.105)

#Enable Use the connections suffix in DNS registration

#Run ipconfig /registerdns - With the above setting this should register the UVM in DNS. 




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
The rule already exists on the UVM and just needs to be enabled. 
#>
Set-NetFirewallRule -CimSession $cimsession -PolicyStore localhost -DisplayName 'TCP 445( SMB )' -Enabled True 

#see status of firewall rule
Get-NetFirewallRule -CimSession $cimsession -PolicyStore localhost | Where-Object {$_.displayname -eq 'TCP 445( SMB )'} | Format-List DisplayName, Enabled
Get-NetFirewallRule -CimSession $cimsession -PolicyStore ActiveStore | Where-Object {$_.displayname -eq 'TCP 445( SMB )'} | Format-List DisplayName, Enabled


#after the rule is enabled to Local GPO has to be applied to update the new firewall rule in the PolicyStore -ActiveStore
Invoke-CimMethod -CimSession $cimsession -ClassName Win32_Process -MethodName "Create" -Arguments @{
  CommandLine = 'gpupdate.exe'; CurrentDirectory = "C:\windows\system32"
}



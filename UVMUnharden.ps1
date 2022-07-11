#Main file to run against a UVM to unharden the firewall and start needed services to allow outside access into the UVM for copying files and running tests 

#setup credentials for the session
$cred = Get-Credential
$cimsession = New-CimSession -ComputerName 10.200.114.67 $cred 
#If you get access denied make sure LocalAccountTokenFilterPolicy is enabled on the server


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

#after the rule is enabled to Local GPO has to be applied to update the new firewall rule in the PolicyStore -ActiveStore
Invoke-CimMethod -CimSession $cimsession -ClassName Win32_Process -MethodName "Create" -Arguments @{
  CommandLine = 'gpupdate.exe'; CurrentDirectory = "C:\windows\system32"
}



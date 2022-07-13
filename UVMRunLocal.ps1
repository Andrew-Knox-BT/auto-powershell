#Create Firewall rule to open port 5985 for WIN RM
#This will create the firewall rule in the local gpo

#TODO - Add a check that is the rule exists skip this step
New-NetFirewallRule -PolicyStore localhost -DisplayName "Escalation Automation - Windows Remote Management (HTTP-In)" -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow -Profile Public -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 


#TODO - If previous rule exists check the activestore to see if the rule exists and that it's enabled. If so skip the gpupdate. 



<#
#Only use when firewall rules need to be removed and cleaned up. 
Remove-NetFirewallRule -PolicyStore localhost | Where-Object {$_.displayname -like 'Escalation Automation*'}
Remove-NetFirewallRule -PolicyStore ActiveStore | Where-Object {$_.displayname -like 'Escalation Automation*'}
#>

<#
#After the gpo is updated need to run gpupdate to apply the new changes. 
Invoke-CimMethod -ClassName Win32_Process -MethodName "Create" -Arguments @{
  CommandLine = 'gpupdate.exe'; CurrentDirectory = "C:\windows\system32"
} | Out-Null
#>

$downloadgpo = 'https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/gpo.txt'
$downloadLGPO = 'https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/LGPO.exe'
Invoke-WebRequest -UseBasicParsing -Uri $downloadgpo -OutFile .\gpo.txt 
Invoke-WebRequest -UseBasicParsing -Uri $downloadLGPO -OutFile .\LGPO.exe

&$HOME\lgpo.exe /t $HOME\gpo.txt


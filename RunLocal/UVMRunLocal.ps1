#This is the first script to run on the UVM. 
#A firewall rule will be created that will allow remote access through WinRM. 
#The local GPO will be updated to disable LocalAccountTokenFiltering so local admin accounts can be used remotely



#Create Firewall rule to open port 5985 for WIN RM
#TODO - Add a check that is the rule exists skip this step
New-NetFirewallRule -PolicyStore localhost -DisplayName "Escalation Automation - Windows Remote Management (HTTP-In)" -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow -Profile Public -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 


#TODO - If previous rule exists check the activestore to see if the rule exists and that it's enabled. If so skip the gpupdate. 



<#
#Only use when firewall rules need to be removed and cleaned up. 
Remove-NetFirewallRule -PolicyStore localhost | Where-Object {$_.displayname -like 'Escalation Automation*'}
Remove-NetFirewallRule -PolicyStore ActiveStore | Where-Object {$_.displayname -like 'Escalation Automation*'}
#>


$downloadgpo = 'https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/ExternalFiles/gpo.txt'
$downloadLGPO = 'https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/ExternalFiles/LGPO.exe'
Invoke-WebRequest -UseBasicParsing -Uri $downloadgpo -OutFile .\gpo.txt 
Invoke-WebRequest -UseBasicParsing -Uri $downloadLGPO -OutFile .\LGPO.exe
$currentdir = Get-Location
&$currentdir\lgpo.exe /t $currentdir\gpo.txt


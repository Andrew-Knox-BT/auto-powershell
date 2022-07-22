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



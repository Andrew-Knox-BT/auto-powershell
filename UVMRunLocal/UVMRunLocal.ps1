#This is the first script to run on the UVM. 

$win10 = "Microsoft Windows 10 Enterprise"
$win2012r2 = "Microsoft Windows SErver 2012 R2 Standard"
$win2016 = "Microsoft Windows Server 2016 Standard"
$win2019 = "Microsoft Windows SErver 2012 R2 Standard"
$win2022 = ""


$winversion = (Get-CimInstance Win32_OperatingSystem).caption

if ((get-service -name lanmanserver).status -eq 'Stopped' ) {
    Set-Service -Name LanmanServer -Status Running -StartupType Automatic
}

if ((Get-NetFirewallRule -PolicyStore ActiveStore).PolicyStoreSourceType -eq 'GroupPolicy') {
    #For 2016 UVMs - Firewall rules are managed with Local Group Policy
    #-PolicyStore localhost will create the rule in the GPO - gpupdate needs to run for the rule to take effect
    New-NetFirewallRule -PolicyStore localhost -DisplayName "Escalation Automation - Windows Remote Management (HTTP-In)" -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow -Profile Public -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 
}
else {
    #For 2012R2 UVMs - Firewall Rules are managed with Windows Firewall
    New-NetFirewallRule -DisplayName "Escalation Automation - Windows Remote Management (HTTP-In)" -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow -Profile Public -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 
}



$downloadgpo = 'https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/ExternalFiles/gpo.txt'
$downloadLGPO = 'https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/ExternalFiles/LGPO.exe'

Invoke-WebRequest -UseBasicParsing -Uri $downloadgpo -OutFile .\gpo.txt 
Invoke-WebRequest -UseBasicParsing -Uri $downloadLGPO -OutFile .\LGPO.exe
$currentdir = Get-Location
&$currentdir\lgpo.exe /t $currentdir\gpo.txt



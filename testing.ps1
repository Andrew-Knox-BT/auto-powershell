try {
    (Get-NetFirewallRule -PolicyStore ActiveStore -PolicyStoreSourceType GroupPolicy).PolicyStoreSourceType -ne 'GroupPolicy'
    
}
catch {
    write-host "No GPO firewall Rules found"
}

$gpoerror | Get-Member
$gpoerror | fl *

Get-NetFirewallRule 

if ((Get-NetFirewallRule -PolicyStore ActiveStore).PolicyStoreSourceType -eq 'GroupPolicy') {
    write-host '2016'
}
else {
    write-host '2012'
}


$win10 = "Microsoft Windows 10 Enterprise"
$win2012r2 = "Microsoft Windows SErver 2012 R2 Standard"
$win2016 = "Microsoft Windows Server 2016 Standard"
$win2019 = "Microsoft Windows SErver 2012 R2 Standard"
$win2022 = ""


$winversion = (Get-CimInstance Win32_OperatingSystem).caption

<#
if ((get-service -name lanmanserver).status -eq 'Stopped' ) {
    Set-Service -Name LanmanServer -Status Running -StartupType Automatic
}
#>
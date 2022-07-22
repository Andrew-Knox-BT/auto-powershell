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

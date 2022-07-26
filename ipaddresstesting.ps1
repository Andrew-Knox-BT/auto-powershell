$allips = Get-NetIPAddress | Select-Object -ExpandProperty IPv4Address


foreach ($ipaddress in $allips) {
    if ($ipaddress -like '10.200.113.*' -OR $ipaddress -like '10.200.114*' ) { 
       
        Get-NetIPAddress | Where-Object ipv4address -eq $ipaddress | Select-Object -ExpandProperty InterfaceAlias
    }
    else {
        Write-Host 'no ip found'
    }
}







if ((Get-NetIPAddress | fl -Property IPv4Address) -contains "10.200.113" ) { 
    write-host 'set-ip'
}
else {
    Write-Host 'no ip found'
}


$Script:cred = Get-Secret -Name RedDomainAdmin
$Script:cimsession = New-CimSession -ComputerName 10.200.114.105 $cred 

$ips = Get-DnsServerResourceRecord -CimSession $cimsession -ZoneName "uvm.lab" -RRType A

$object = foreach($record in $ips){
    [pscustomobject]@{
        Hostname   = $record.hostname
        IPAddress  = $record.RecordData.IPv4Address.IPAddressToString
    }
}

$object | sort-object ipaddress -Unique

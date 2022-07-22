param
(
    $domain = $(Read-Host -Prompt 'Enter domain')
)
Unlock-SecretStore -Password $vaultpassword
$Script:cred = Get-Secret -Name RedDomainAdmin
$Script:cimsession = New-CimSession -ComputerName 10.200.114.105 $cred 


$zones = Get-DnsServerZone -CimSession $cimsession -ZoneName $domain


$ips = Get-DnsServerResourceRecord -CimSession $cimsession -ZoneName $domain -RRType A



$object = foreach($record in $ips){
    [pscustomobject]@{
        Hostname   = $record.hostname+'.'+$zones.ZoneName
        IPAddress  = $record.RecordData.IPv4Address.IPAddressToString
    }
}

$object | sort-object ipaddress -Unique


#Turn off LocalAccountTokenFiltering in GPO - Computer Configuration > Administrative Settings > SCM Pass the hash > Apply UAC Restrictions
#Change from Enabled to Disabled 
#if this is left enabled Local Account Token Filtering will get disabled on next policy update


$cred = Get-Credential
$cimsession = New-CimSession -ComputerName 10.200.114.165 $cred 

$instanceParams = @{
    ClassName    = 'RSOP_GPO'
    Namespace   = 'root\rsop\computer'
    Filter               = 'name LIKE "Screen%"'
}
Get-CimInstance -CimSession $cimsession @instanceParams
Get-CimInstance -ClassName RS 
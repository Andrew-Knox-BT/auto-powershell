#get class and methods

$class = Get-CimClass -ClassName Win32_Service
$class.CimClassMethods
$class.CimClassMethods[“Create”].Parameters 

$class = Get-CimClass -ClassName Win32_Process
$class.CimClassMethods
$class.CimClassMethods[“Create”].Parameters

$class = Get-CimClass -Namespace root/standardcimv2 -ClassName MSFT_NetFirewallRule
$class.CimClassMethods
$class.CimClassMethods[“Enable”].Parameters
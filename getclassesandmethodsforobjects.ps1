#get class and methods

$class = Get-CimClass -ClassName Win32_Service
$class.CimClassMethods
$class.CimClassMethods[“StartService”].Parameters
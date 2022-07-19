Set-NetFirewallRule -CimSession   -PolicyStore localhost -DisplayName 'TCP 445( SMB )' -Enabled True 
Set-Service -Name LanmanServer -StartupType Automatic
Start-Service -name LanmanServer
Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system\' -Name 'LocalAccountTokenFilterPolicy' -Value 1


Set-NetFirewallRule -CimSession ak-uvm221.red.local -PolicyStore localhost -DisplayName 'TCP 445( SMB )' -Enabled True 

winrm set winrm/config/client '@{TrustedHosts=""}'
$cred = Get-Credential
New-CimSession -ComputerName ak-uvm221.red.local -Credential $cred -Authentication Default
New-CimSession -ComputerName 10.200.113.82 -Credential $cred -Authentication Default
$cimses = New-CimSession -ComputerName ak-uvm221.red.local -Credential $cred

Set-Item wsman:localhost\client\trustedhosts -Value ak-test01.lab.com

winrm set winrm/config/client '@{TrustedHosts="ak-test01.lab.com"}'



$cred = Get-Credential
$cimses = New-CimSession -ComputerName ak-test01.lab.com -Credential $cred -Authentication Default
Get-NetFirewallRule -CimSession $cimses 



Get-NetFirewallRule -CimSession $cimses 
Test-WSMan -ComputerName ak-uvm221.red.local



$aktest01 = New-PSSession -ComputerName  ak-jira -UseSSL

#curretnly working
winrm set winrm/config/client '@{TrustedHosts="ak-test01.lab.com"}'
$cred = Get-Credential
$cimses = New-CimSession -ComputerName ak-test01.lab.com $cred
Get-NetFirewallRule -CimSession $cimses | Sort-Object


$test = Get-CimInstance win32_service | Where-Object Name -eq "lanmanserver"
$test 
Invoke-CimMethod -InputObject $test -methodname ChangeStartmode -Arguments @{startmode='automatic'}



Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList "gpupdate.exe" -ComputerName <computername>
Invoke-CimMethod -CimSession $cimses -InputObject $lanmanserver -methodname StartService 
Invoke-CimMethod -CimSession $cimses -ClassName Win32_Process -MethodName "Create" -Arguments @{
  CommandLine = 'gpupdate.exe'; CurrentDirectory = "C:\windows\system32"
}

$session = New-PSSession -computername ak-uvm221.red.local -Credential $cred
Invoke-Command -ComputerName ak-uvm221.red.local -SessionName 

Start-Service | Get-Member

Invoke-WSManAction -Action startservice -ResourceURI wmicimv2/win32_service -SelectorSet @{name="spooler"}  -Authentication default
Invoke-WSManAction -Action startservice -ResourceURI wmicimv2/win32_service -SelectorSet @{name="server"} -ComputerName 10.200.114.67 -Authentication default


$test = Get-Location
#$test | format-table $test


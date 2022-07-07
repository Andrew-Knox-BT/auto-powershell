#Main file to run against a UVM to unharden the firewall and start needed services to allow outside access into the UVM for copying files and running tests 

#Test WSMan connection on remote computer
Test-WSMan -ComputerName 10.200.114.67


#Used to cleast the trusthosts on the local computer. 
#Trusted hosts are used when HTTPS is not configured for remote connections. 
clear-Item wsman:localhost\client\trustedhosts -Force
get-Item wsman:localhost\client\trustedhosts
winrm set winrm/config/client '@{TrustedHosts="10.200.114.67"}'
$cred = Get-Credential
$cimses = New-CimSession -ComputerName 10.200.114.67 $cred 
#if you get access denied make sure LocalAccountTokenFilterPolicy is enabled on the server

$lanmanserver = Get-CimInstance -CimSession $cimses win32_service | Where-Object Name -eq "lanmanserver" 
$lanmanserver | get-member
Invoke-CimMethod -CimSession $cimses -InputObject $lanmanserver -methodname ChangeStartmode -Arguments @{startmode='automatic'}
Invoke-CimMethod -CimSession $cimses -InputObject $lanmanserver -methodname StartService 


Get-NetFirewallRule -CimSession $cimses -PolicyStore localhost | Where-Object {$_.displayname -eq 'TCP 445( SMB )'} 
Get-NetFirewallRule -CimSession $cimses -PolicyStore ActiveStore | Where-Object {$_.displayname -eq 'TCP 445( SMB )'} 
Get-NetFirewallRule -CimSession $cimses -PolicyStore localhost | Where-Object {$_.displayname -eq 'Windows Remote Management (HTTP-In)'}
Get-NetFirewallRule -CimSession $cimses -PolicyStore ActiveStore | Where-Object {$_.displayname -eq 'Windows Remote Management (HTTP-In)'} 
Get-NetFirewallRule -CimSession $cimses -PolicyStore localhost | Where-Object {$_.displayname -eq 'TCP 5985 ( WinRM - Required by AWS )'}
Get-NetFirewallRule -CimSession $cimses -PolicyStore ActiveStore | Where-Object {$_.displayname -eq 'TCP 5985 ( WinRM - Required by AWS )'}


Set-NetFirewallRule -CimSession $cimses -PolicyStore localhost -DisplayName 'TCP 445( SMB )' -Enabled True 
Get-NetFirewallRule -CimSession $cimses -PolicyStore localhost | Where-Object {$_.displayname -eq 'TCP 445( SMB )'} 
Get-NetFirewallRule -CimSession $cimses -PolicyStore ActiveStore | Where-Object {$_.displayname -eq 'TCP 445( SMB )'} 


Invoke-CimMethod -CimSession $cimses -ClassName Win32_Process -MethodName "Create" -Arguments @{
  CommandLine = 'gpupdate.exe'; CurrentDirectory = "C:\windows\system32"
}

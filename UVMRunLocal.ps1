#Create Firewall rule to open port 5985 for WIN RM
#This will create the firewall rule in the local gpo
New-NetFirewallRule -PolicyStore localhost -DisplayName "Windows Remote Management (HTTP-In) - For Automation" -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow -Profile Public -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 



#After the gpo is updated need to run gpupdate to apply the new changes. 
Invoke-CimMethod -ClassName Win32_Process -MethodName "Create" -Arguments @{
  CommandLine = 'gpupdate.exe'; CurrentDirectory = "C:\windows\system32"
}



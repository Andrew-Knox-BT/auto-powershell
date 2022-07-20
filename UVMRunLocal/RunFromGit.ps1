#This will pull down the script that will setup the UVM for outside access via Win RM.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ScriptFromGitHub = Invoke-WebRequest https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/UVMRunLocal/UVMRunLocal.ps1
Invoke-Expression $($ScriptFromGitHub.Content)


$ScriptFromGitHub = Invoke-WebRequest https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/UVMRunLocal.ps1
Invoke-Expression $($ScriptFromGitHub.Content)


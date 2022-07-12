$ScriptFromGitHub = Invoke-WebRequest https://github.com/Andrew-Knox-BT/auto-powershell/blob/main/UVMRunLocal.ps1
Invoke-Expression $($ScriptFromGitHub.Content)


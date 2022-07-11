#connect to the remote computer over DCOM and invoke methods
<#Lucky for you, WMI has a Win32_Process classes that allows you to invoke processes. By invoking a Create method against the Win32_Process, Invoke-CimMethod connects to the remote computer, invoking PowerShell and running Enable-PSRemoting as shown below.

The below example is creating a hash table for the session connection where the server name, credentials and protocol are specified. Then in the following hash table, the parameters for the Invoke-CimMethod are being set. Once these are run a CIM session is being created over the DCOM protocol that starts a PowerShell process than in turn runs the Enable-PSRemoting command.#>



$SessionArgs = @{
    ComputerName  = '10.200.114.165'  
    Credential    = Get-Credential
    SessionOption = New-CimSessionOption -Protocol Dcom
}
$MethodArgs = @{
    ClassName     = 'Win32_Process'
    MethodName    = 'Create'
    CimSession    = New-CimSession @SessionArgs
    Arguments     = @{
        CommandLine = "Start-service lanmanserver"
    }
}
<#
$MethodArgs = @{
    ClassName     = 'Win32_Process'
    MethodName    = 'Create'
    CimSession    = New-CimSession @SessionArgs
    Arguments     = @{
        CommandLine = "powershell Start-Process powershell -ArgumentList 'Enable-PSRemoting -Force'"
    }
}
#>
Invoke-CimMethod @MethodArgs
#This is the first script to run on the UVM. 



#This will enable WinRM access to the UVMs
$EAFRWinRM5985 = 'Escalation Automation - Windows Remote Management (HTTP-In)'
if ((Get-NetFirewallRule -PolicyStore ActiveStore).PolicyStoreSourceType -eq 'GroupPolicy') {
    #For 2016 UVMs - Firewall rules are managed with Local Group Policy
    # -PolicyStore localhost will create the rule in the GPO 
    New-NetFirewallRule -PolicyStore localhost -DisplayName $EAFRWinRM5985 -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow -Profile Public -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 
}
else {
    #For 2012R2 UVMs - Firewall Rules are managed with Windows Firewall and not through GPO like the newer 2016 UVMs
    New-NetFirewallRule -DisplayName $EAFRWinRM5985 -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow -Profile Public -Enabled True -RemoteAddress Any -LocalAddress Any -RemotePort Any 
}



$downloadgpo = 'https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/ExternalFiles/gpo.txt'
$downloadLGPO = 'https://raw.githubusercontent.com/Andrew-Knox-BT/auto-powershell/main/ExternalFiles/LGPO.exe'

Invoke-WebRequest -UseBasicParsing -Uri $downloadgpo -OutFile .\gpo.txt 
Invoke-WebRequest -UseBasicParsing -Uri $downloadLGPO -OutFile .\LGPO.exe
$currentdir = Get-Location
&$currentdir\lgpo.exe /t $currentdir\gpo.txt


$allips = Get-NetIPAddress | Select-Object -ExpandProperty IPv4Address
foreach ($ip in $allips) {
    if ($ip -like '10.200.113.*' -OR $ip -like '10.200.114*' ) { 
       
        $interfacealias = Get-NetIPAddress | Where-Object ipv4address -eq $ip | Select-Object -ExpandProperty InterfaceAlias
        #To make the servers easier to manage they need to be added to DNS
        #Set DNS Address. Currently in lab the DNS server is 10.200.114.105
        Set-DnsClientServerAddress -InterfaceAlias $interfacealias -ServerAddresses ("10.200.114.105")

        #Set DNS suffix for this connection and Set Use this connections DNS suffix in DNS registration
        #Curretly in lab the main domain for UVM's is - uvm.lab
        set-dnsclient -InterfaceAlias $interfacealias -ConnectionSpecificSuffix 'uvm.lab' -UseSuffixWhenRegistering $true
        #With this setting it will use the DNS suffix specified in the DNS suffix for this connection box to regeister the machein in DNS

        #Run command to register the server in DNS
        Register-DnsClient 
    }
    else {
        Write-Output "No Matching IP address found"
    }
   
}

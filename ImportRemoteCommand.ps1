#You can use this to import powershell commands installed on another computer. 
#In this example you could connect to a computer that has the DNS cmdlets installed (i.e. domain controller running DNS)
#Import the command and assign a prefix to the command. The prefix will allow you to easily identify the commands the were imported. 
$session = new-pssession -ComputerName server
Invoke-Command -command {Import-Module dnsserver} -Session $session
Import-PSSession -Session $session -Module dnsserver -Prefix RemoteDNS
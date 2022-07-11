Get-PSDrive

get-item wsman::localhost\client\trustedhosts

winrm set winrm/config/client '@{TrustedHosts="10.200.114.67"}'
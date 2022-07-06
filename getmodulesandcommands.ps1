[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Get-Module
Find-Command -Repository PSGallery -Name Invoke-CimMethod
Find-Command -Repository PSGallery | Out-File .\Downloads\psgallery.txt
Find-Script -Repository PSGallery -Name Invoke-CimMethod

Get-PSRepository
Find-Command -Name Invoke-GPUpdate -Repository PSGallery -ModuleName SystemLocaleDsc

#to insatll the module that has the gpo commandlets you need to install GPMC 
Install-WindowsFeature gpmc


Invoke-GPUpdate


Get-Module -ListAvailable
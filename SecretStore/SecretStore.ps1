<#This command will install the Secret Management and Secret Store modules from PSGallery
If the modules happen to be missing run the command below
#>
<#-----------------
Install-Module -Name Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
----------------#>

#This will create a new secret vault for storing secrets such as usernames and passwords etc. 
Register-SecretVault -Name AutomationSecrets -ModuleName Microsoft.PowerShell.SecretStore -Description "Credential for running automation tasks" -DefaultVault 
#Remember that the secret store is only accessible to the user account that created it

#***Do not create multiple vaults with the same vault module. If you do, each vault will contain duplicate entries, and there’s no added benefit.



<#
The Microsoft Secret Store accepts the following data types as secrets.

PSCredential
HashTable
SecureString
String
byte[]
#>
Get-SecretVault


#completey resets secret store and deletes all secrets
#Reset-SecretStore

# Create a credential object.
$secretcredential = Get-Credential
# Create a new secret 
Set-Secret -Name RedDomainAdmin -Secret $secretcredential -Vault AutomationSecrets

#this will allow access the secret store. You will be prompted for the password you used when creating the secret store
Unlock-SecretStore

#this will show a list of secrets and their types that are in the vault. 
get-secretinfo -Vault AutomationSecrets

#this will retrieve the secrets value
get-secret -name UVMUsernameAndPassword
get-secret -name RedDomainAdmin

#This will actually show the value of the stored secret i.e. password in clear text. 
(Get-Secret -Name UVMUsernameAndPassword).GetNetworkCredential()| Select-Object *
(Get-Secret -Name UVMUsernameAndPassword).GetNetworkCredential()| Select-Object UserName, Password


#This will store the credential in an xml file that can be later imported for use in other scripts to get the password
#This one is storing the password for unlocking the vault
Get-Credential | Export-CliXml ~/vaultpassword.xml

#This just gets the content of the xml file created above. 
Get-Content ~/vaultpassword.xml

#This will store the password from the xml file in a variable for use in your script
$vaultpassword = (Import-CliXml ~/vaultpassword.xml).Password
<#If you’re wondering, decrypting/importing the encrypted password from XML only works for the user account that encrypted the password. Even if someone else copies the XML file, they cannot decrypt the password.#>

Unlock-SecretStore -Password $vaultpassword
(Get-Secret -Name UVMUsernameAndPassword).GetNetworkCredential()| Select-Object UserName, Password



Get-SecretStoreConfiguration
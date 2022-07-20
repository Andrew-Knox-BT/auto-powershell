#Trusted hosts are used when HTTPS is not configured for remote connections. 

#show list of WSMan Trusted hosts
get-Item wsman:localhost\client\trustedhosts

#Used to clear the trusthosts on the local computer. 
clear-Item wsman:localhost\client\trustedhosts



#get a current list of trusted hosts and then add to the current list
$current=(get-item WSMan:\localhost\Client\TrustedHosts).value
$current+=",10.200.114.67"
set-item WSMan:\localhost\Client\TrustedHosts –value $current -force


#another method using a list from a txt file
Get-Content "C:\ServerList.txt"
machineA,machineB,machineC,machineD


$ServerList = Get-Content "C:\ServerList.txt"
    $currentTrustHost=(get-item WSMan:\localhost\Client\TrustedHosts).value
    if ( ($currentTrustHost).Length -gt "0" ) {
        $currentTrustHost+= ,$ServerList
        set-item WSMan:\localhost\Client\TrustedHosts –value $currentTrustHost -Force -ErrorAction SilentlyContinue
        }
    else {
        $currentTrustHost+= $ServerList
        set-item WSMan:\localhost\Client\TrustedHosts –value $currentTrustHost -Force -ErrorAction SilentlyContinue
    }
Get-Date | Get-Member | fl *

Get-Date -UFormat %B

$date = (get-date).AddMonths(-1) 
$date -UFormat 

(Get-Date).AddMonths(-5).ToString('fffff')

Get-ChildItem .\README.md | Get-Member | fl *
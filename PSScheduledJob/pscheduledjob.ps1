$date = (Get-Date).AddMinutes(2)
$trigger = New-JobTrigger -Once -At $date  -RandomDelay 00:01:00 
Register-ScheduledJob -Trigger $trigger -FilePath C:\Users\btadmin\Downloads\runfromgit.ps1 -Name RunFromGit


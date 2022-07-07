#
Get-NetFirewallRule -PolicyStore activestore | Where-Object {$_.Direction -eq 'Inbound'} |    Sort-Object -Property DisplayName | fl DisplayName, Direction, PolicyStoreSource
Get-NetFirewallRule -PolicyStore localhost | Where-Object {$_.Direction -eq 'Inbound'} |    Sort-Object -Property DisplayName | fl DisplayName, Direction, PolicyStoreSource
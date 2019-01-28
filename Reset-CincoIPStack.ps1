$NIC_CARD = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet*";

Remove-NetIPAddress -IPAddress $NIC_CARD.IPAddress -Confirm:$false

Remove-NetRoute -InterfaceAlias $NIC_CARD.InterfaceAlias -DestinationPrefix 0.0.0.0/0 -Confirm:$false

Set-DnsClientServerAddress -InterfaceIndex $NIC_CARD.InterfaceIndex -ResetServerAddresses

ipconfig /all
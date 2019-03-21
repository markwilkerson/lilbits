$NIC_CARD = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet*";

Clear-Host

$SERVER_NAME = Read-Host "Provide computer name (e.g. GPWS1)"

Write-Host "Configuring interface " -NoNewline; Write-Host $NIC_CARD.InterfaceAlias.ToString() -ForegroundColor black -BackgroundColor white

$IP_ADDRESS = Read-Host "Provide IP address (e.g. 10.0.31.10)"

$CIDR =  Read-Host "Provide CIDR mask (e.g. 255.255.255.192 is 26)"

$GATEWAY = Read-Host "Provide gateway IP address"

Write-Host "Provide DNS IP address, comma separated (e.g. 10.0.31.1,10.0.31.2)."
if ( ( $DNSSERVER_ADDRESS = Read-Host "Press enter to accept default value [10.0.31.1,10.0.31.2]" ) -eq '' )
		{
			$DNSSERVER_ADDRESS = "10.0.31.1","10.0.31.2"
		}
			else
				{
					$DNSSERVER_ADDRESS
				}

New-NetIPAddress –InterfaceAlias $NIC_CARD.InterfaceAlias.ToString() –IPAddress $IP_ADDRESS –PrefixLength $CIDR -DefaultGateway $GATEWAY

Set-DnsClientServerAddress -InterfaceAlias $NIC_CARD.InterfaceAlias.ToString() -ServerAddresses ($DNSSERVER_ADDRESS)

Rename-Computer -NewName $SERVER_NAME -Restart

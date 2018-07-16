# Provide an OU to search.
$SearchBaseOU = "OU=hurp,OU=durp,OU=twiddly,DC=derrmain,DC=dotlocal"

# Provide a username to search.
$SearchForThisName = "*klgadm"

# Recursively parse the $SearchBaseOU OU for computer objects, return only their name (no header) using "ExpandProperty", and sort alphabetically.
$servers = Get-ADComputer -Filter * -SearchBase $SearchBaseOU | Select-Object -ExpandProperty Name | Sort

# For every computer object returned from Get-ADComputer...
foreach ( $server in $servers )
    {
        # ...give me an indication of what computer object you found.
        Write-Host "Querying server" $server".  Results will appear after all servers are queried."
        
        # ...get a list of Windows services running on the computer object and look for services that use the $SearchForThisName account to authenticate.  
        # ...ignore errors returned from stale computer objects and non-Windows servers.
        $output = Get-WmiObject -ComputerName $server win32_service -EA SilentlyContinue | where Startname -like $SearchForThisName | Select Name, Startname
        
        # ...tell me how many services you found that use the "$SearchForThisName" user account to authenticate.
        Write-Host $server "has" $output.Count "instances of $SearchForThisName."
        
        # ...show me the services that use the $SearchForThisName user account credentials to authenticate.
        $output
    }

# Tell me how many computer objects you discovered in the $SearchBaseOU OU.
Write-Host $servers.Count "server objects queried in Active Directory."
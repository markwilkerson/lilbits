#Get Base/Template username.
#This will be the regular username (i.e. dripke or cary.burhrer)
#The -Properties * will grab ALL of the AdUser details
$USER = Get-AdUser -Identity (Read-Host "Copy From Username") -Properties *

#Grab just the Distinguished Name property
$DN = $User.distinguishedName

#Get Base/Template LDAP Distinguished Name
$OldUser = [ADSI]"LDAP://$DN"

#Get the Parent OU for Base/Template for separate processing
$Parent = $OldUser.Parent

#Get LDAP details for Parent
$OU = [ADSI]$Parent

#Grab just the Distinguished Name property
$OUDN = $OU.distinguishedName

#Prompt user For First and Last name
$Firstname = Read-Host "First Name"
$Lastname = Read-Host "Last Name"
$EmployeeID = Read-Host "Employee ID"

#Build username (SamAccountName) from entered data
$NewUser = "$Firstname.$Lastname".ToLower()


#String it all together to build the new user, Stick it in the Base/Template's OU
New-ADUser `
-SamAccountName $NewUser `
-Name "$Firstname $Lastname" `
-UserPrincipalName $NewUser@cinco.com `
-DisplayName "$Firstname $Lastname" `
-GivenName $Firstname -Surname $Lastname `
-EmployeeID $EmployeeID `
-EmailAddress "$NewUser@cinco.com" `
-Instance $DN -Path "$OUDN" `
-AccountPassword "$Lastname + $EmployeeID" `
-ChangePasswordAtLogon:$true `
-Enabled:$true `

#Set Group Memberships to be the same as Base/Template
foreach ($Group in $USER.memberof)
	{
		Add-AdGroupMember -Members $NewUser -Identity $Group -PassThru}
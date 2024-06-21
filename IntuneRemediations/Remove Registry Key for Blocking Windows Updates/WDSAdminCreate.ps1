$localAdminName = "WDSAdmin"
$password = "W3$t3rn@Loc@l530"

New-LocalUser "$localAdminName" -Password $password -FullName "$localAdminName" -Description "Temp local admin"
Add-LocalGroupMember -Group "Administrators" -Member "$localAdminName"
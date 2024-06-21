$localAdminName = "WDSAdmin"

if(Get-LocalUser | where-Object Name -eq $localAdminName){
    Write-Host "User does already exist"
    Exit 0
}else{
    Write-Host "User does not exist"
    Exit 1
}
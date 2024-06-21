<#
Version: 1.0
Author: Drew Erwin
Script: UnprotectBitLockerDetect
Description: Turns off protection for BitLocker
#> 

$BitlockerDrives = Get-BitLockerVolume

$pass = $false

foreach ($Drive in $BitlockerDrives)
{
    if($Drive.ProtectionStatus -eq "On")
    {
        Write-Output "Bitlocker needs to be turned off for drive $($Drive.MountPoint)"
        $pass = $true
    }
    else
    {
        Write-Output "Drive is already unprotected for drive $($Drive.MountPoint)"
    }
}

if ($pass -eq $true)
{
    Write-Ouput "To Remediation"
    exit 1
}
else
{
    exit 0
}
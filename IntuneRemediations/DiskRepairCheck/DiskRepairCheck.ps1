<#
Version: 1.0
Author: Drew Erwin
Script: DiskRepairCheck.ps1
Description: Checks for disk errors
    No remediation script needed. Just outputs if disk errors are found.
Run as: System
Context: 64 Bit
#> 

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\DiskRepairCheck.log"

$disk = ($env:SystemDrive).Substring(0,1)

$repair = repair-volume -DriveLetter $disk -scan -Verbose

write-output $repair

if ($repair -eq "NoErrorsfound") {
write-host "No issues"
Exit 0
}
else {
write-host "Needs checking"
exit 1
}

Stop-Transcript
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\UptimeCheck.log"

$Uptime= get-computerinfo | Select-Object OSUptime 

if ($Uptime.OsUptime.Days -ge 7){
    Write-Output "Device has not restarted in $($Uptime.OsUptime.Days) days, notify user to reboot"
    Exit 1
}else {
    Write-Output "Device restarted $($Uptime.OsUptime.Days) days ago, all good"
    Exit 0
}

Stop-Transcript
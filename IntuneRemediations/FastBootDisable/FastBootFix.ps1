<#
Version: 1.0
Author: Drew Erwin
Script: FastBootFix.ps1
Description: Disables Fastboot via registry key
Run as: System
Context: 64 Bit
#> 

#Change log name here to match new script name
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\FastBootFix.log"

#Fill in Key Path Here - ex: HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters
$KeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
#Fill in Key Name Here - ex: SMB1
$KeyName = "HiberbootEnabled"
#Fill in Key Value Here - example is below of 0
$DesiredValue = 0

$TestPath = Test-Path $KeyPath
if  ($TestPath -eq $true)
{
    Write-Output "Path $KeyPath exists"
    $KeyCheck = Get-Item -LiteralPath $KeyPath
    if ($KeyCheck.GetValue($KeyName, $null) -ne $null)
    {
        $KeyData = Get-ItemProperty -Path $KeyPath -Name $KeyName
        $KeyValue = $KeyData.$KeyName
        if ($KeyValue -eq $DesiredValue)
        {
            Write-Output "$KeyName is showing the correct value of $KeyValue"
        }
        else
        {
            Write-Output "$KeyName is showing the value of $KeyValue instead of $DesiredValue"
            Set-ItemProperty -Path $KeyPath -Name $KeyName -Value $DesiredValue
        }
    }
    else
    {
        Write-Output "The key $KeyName does not exist"
        New-ItemProperty -Path $KeyPath -Name $KeyName -Value $DesiredValue -PropertyType DWord -Force
    }
}
else
{
    Write-Output "$KeyPath does not exist"
    New-Item $KeyPath -Force | New-ItemProperty -Name $KeyName -Value $DesiredValue -PropertyType DWord -Force
}

Stop-Transcript
<#
Version: 1.0
Author: Drew Erwin
Script: Invoke-OutlookSizeIncrease
Description: Script for manually increasing Outlook size
Run as: System
Context: 64 Bit
#> 

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Invoke-OutlookSizeIncrease.log"

$keys = @(
    @{KeyPath="HKCU:\Software\Policies\Microsoft\Office\16.0\Outlook\PST";KeyName="MaxLargeFileSize";DesiredValue="102,400"}
    @{KeyPath="HKCU:\Software\Policies\Microsoft\Office\16.0\Outlook\PST";KeyName="WarnLargeFileSize";DesiredValue="97,280"}
    @{KeyPath="HKCU:\Software\Policies\Microsoft\Office\16.0\Outlook\PST";KeyName="MaxFileSize";DesiredValue="4,150,298,624"}
    @{KeyPath="HKCU:\Software\Policies\Microsoft\Office\16.0\Outlook\PST";KeyName="WarnFileSize";DesiredValue="3,900,737,536"}
    @{KeyPath="HKCU:\Software\Microsoft\Office\16.0\Outlook\PST";KeyName="MaxLargeFileSize";DesiredValue="102,400"}
    @{KeyPath="HKCU:\Software\Microsoft\Office\16.0\Outlook\PST";KeyName="WarnLargeFileSize";DesiredValue="97,280"}
    @{KeyPath="HKCU:\Software\Microsoft\Office\16.0\Outlook\PST";KeyName="MaxFileSize";DesiredValue="4,150,298,624"}
    @{KeyPath="HKCU:\Software\Microsoft\Office\16.0\Outlook\PST";KeyName="WarnFileSize";DesiredValue="3,900,737,536"}
)

foreach ($key in $keys)
{
    $TestPath = Test-Path $key.KeyPath
    if  ($TestPath -eq $true)
    {
        Write-Output "Path $($key.KeyPath) exists"
        $KeyCheck = Get-Item -LiteralPath $key.KeyPath
        if ($KeyCheck.GetValue($key.KeyName, $null) -ne $null)
        {
            $KeyData = Get-ItemProperty -Path $key.KeyPath -Name $key.KeyName
            $KeyValue = $KeyData.$($key.KeyName)
            if ($KeyValue -eq $key.DesiredValue)
            {
                Write-Output "$($key.KeyName) is showing the correct value of $($key.KeyValue)"
            }
            else
            {
                Write-Output "$($key.KeyName) is showing the value of $($key.KeyValue) instead of $($key.DesiredValue)"
                Set-ItemProperty -Path $key.KeyPath -Name $key.KeyName -Value $key.DesiredValue
            }
        }
        else
        {
            Write-Output "The key $($key.KeyName) does not exist"
            New-ItemProperty -Path $key.KeyPath -Name $key.KeyName -Value $key.DesiredValue -PropertyType DWord -Force
        }
    }
    else
    {
        Write-Output "$KeyPath does not exist"
        New-Item $key.KeyPath -Force | New-ItemProperty -Name $key.KeyName -Value $key.DesiredValue -PropertyType DWord -Force
    }
}

Stop-Transcript
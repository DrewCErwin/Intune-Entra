<#
Version: 1.0
Author: Drew Erwin
Script: DomainComplianceDetection
Description: Script to check for domain compliance
#> 

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\DomainComplianceDetection.log"

$ComputerData = Get-WmiObject win32_computersystem
Write-Output $ComputerData

$Domain = $ComputerData.Domain
$DomainTrust = Test-ComputerSecureChannel

#Fill in trusted domains
$TrustedDomains = @('','','','')

if ($Domain -in $TrustedDomains)
{
    $DomainJoined = $true
}
else
{
    $DomainJoined = $false
}

$hash = @{DomainJoined = $DomainJoined; DomainTrust = $DomainTrust}

Write-Output $hash
Stop-Transcript

return $hash | ConvertTo-Json -Compress
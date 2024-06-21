<#
Version: 1.0
Author: Drew Erwin
Script: IntuneEnrollmentCheck
Description: Checks PC for some settings for Intune. Main setting is if the PC never cleared SCCM enrollment
#> 

#Need to fill in Entra Tenant ID
$TenantID = ""

$key = 'SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\*'
$DesiredValue = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\$TenantID'

#Test for tenant enrollment ID
try{
    $keyinfo = Get-Item "HKLM:\$key"
    if (!($keyinfo.name -eq $DesiredValue)) {Write-Host "Tenant ID is not correct"}
}
catch{
    Write-Host "Tenant ID is not found. GPO for hybrid join needs to be applied"
    #exit 1
}

#Test for Intune enrollment URLs
$url = $keyinfo.name
$url = $url.Split("\")[-1]
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\$url"
if(!(Test-Path $path))
{
    Write-Host "KEY $path not found. GPO for Intune needs to be applied"
    #exit 1
}
else
{
    $test = $null
    $test = Get-ItemProperty $path -Name MdmEnrollmentUrl -ErrorAction SilentlyContinue
    if ($test -eq $null)
    {
        Write-Host "MDM Enrollment registry keys not found. Registering now..."
        New-ItemProperty -LiteralPath $path -Name 'MdmEnrollmentUrl' -Value 'https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc' -PropertyType String -Force -ErrorAction SilentlyContinue;
        New-ItemProperty -LiteralPath $path -Name 'MdmTermsOfUseUrl' -Value 'https://portal.manage.microsoft.com/TermsofUse.aspx' -PropertyType String -Force -ErrorAction SilentlyContinue;
        New-ItemProperty -LiteralPath $path -Name 'MdmComplianceUrl' -Value 'https://portal.manage.microsoft.com/?portalAction=Compliance' -PropertyType String -Force -ErrorAction SilentlyContinue;
    }
}

#Test for SCCM Enrollment Key
$path = "HKLM:\Software\Microsoft\Enrollments"
if(!(Test-Path $path))
{
    Write-Host "Path for SCCM enrollment key does not exist"
}
else
{
    $test = $null
    $test = Get-ItemProperty $path -Name ExternallyManaged -ErrorAction SilentlyContinue
    if ($test -ne $null)
    {
        Write-Host "Removing SCCM key"
        Remove-ItemProperty -Path $path -Name ExternallyManaged -ErrorAction SilentlyContinue
    }
    else
    {
        Write-Host "SCCM key does not exist"
    }
}

Start-Sleep -Seconds 10

C:\Windows\system32\deviceenroller.exe /c /AutoEnrollMDM

#exit 0
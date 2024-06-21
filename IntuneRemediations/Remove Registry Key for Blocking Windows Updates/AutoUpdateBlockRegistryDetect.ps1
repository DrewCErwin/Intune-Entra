$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$TestPath = Test-Path $Path
if  ($TestPath -eq $true)
    {
    Write-Output "$Path exists"
    exit 1
    }
else{
    Write-Output "$Path does not exist"
    exit 0
    }
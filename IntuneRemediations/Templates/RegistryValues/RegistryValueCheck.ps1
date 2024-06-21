#Change log name here to match new script name
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\CHANGENEWNAME.log"

#Fill in Key Path Here - ex: HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters
$KeyPath = "KEY PATH"
#Fill in Key Name Here - ex: SMB1
$KeyName = "KEY NAME"
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
            exit 0
        }
        else
        {
            Write-Output "$KeyName is showing the value of $KeyValue instead of $DesiredValue"
            exit 1
        }
    }
    else
    {
        Write-Output "The key $KeyName does not exist"
        exit 1
    }
}
else
{
    Write-Output "$KeyPath does not exist"
    exit 1
}

Stop-Transcript
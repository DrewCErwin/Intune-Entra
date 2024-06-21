#NTP Commands that can be used for Entra Enrollment

#Set to 1 for PST, 2 for Mountain, 3 for CST, and 4 for EST 
$TimeZone = 2
switch ($TimeZone)
{
    1 {Set-TimeZone -Id "Pacific Standard Time"}
    2 {Set-TimeZone -Id "Mountain Standard Time"}
    3 {Set-TimeZone -Id "Central Standard Time"}
    4 {Set-TimeZone -Id "Eastern Standard Time"}
}

#Get the current time
Get-Date

#Change the time by a set amount
Set-Date -Adjust -0:37:0 -DisplayHint Time

dsregcmd /join /debug
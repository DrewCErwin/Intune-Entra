<#
Version: 1.0
Author: Drew Erwin
Script: GetManufacturer
Description: Gets Manufacturer of Computer
#> 

$ComputerData = Get-CimInstance -ClassName Win32_ComputerSystem
$ComputerManufacturer = $ComputerData.Manufacturer.ToLower()

return $ComputerManufacturer
<#
Version: 1.0
Author: Drew Erwin
Script: GetModel
Description: Gets Model of Computer
#> 

$ComputerData = Get-CimInstance -ClassName Win32_ComputerSystem
$ComputerModel = $ComputerData.Model.ToLower()

return $ComputerModel
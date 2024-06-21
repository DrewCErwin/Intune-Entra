$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
Write-Output "Deleting $Path"
try{
    Remove-Item -Path $Path -Recurse -Verbose
}
catch{
    Write-Output "An error occurred while trying to delete $Path"
}
<#
.SYNOPSIS
    Lists installed software.

.DESCRIPTION
    This script collects installed software from common registry locations and displays
    the application name, version, and publisher.

.NOTES
    Author: Daniel O'Leary
    Purpose: Portfolio / Software Inventory
#>

Write-Host "===== Installed Software Inventory =====" -ForegroundColor Cyan

$RegistryPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$Software = foreach ($Path in $RegistryPaths) {
    Get-ItemProperty $Path -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName } |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
}

$Software |
    Sort-Object DisplayName |
    Format-Table -AutoSize

Write-Host "`nTotal Applications Found: $($Software.Count)" -ForegroundColor Green
Write-Host "===== Inventory Complete =====" -ForegroundColor Cyan

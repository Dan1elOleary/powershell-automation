<#
.SYNOPSIS
    Checks disk space on local fixed drives.

.DESCRIPTION
    This script reviews fixed drives and reports total space, free space, and free space percentage.
    It warns when a drive has less than 15% free space.

.NOTES
    Author: Daniel O'Leary
    Purpose: Portfolio / IT Support Automation
#>

Write-Host "===== Disk Space Report =====" -ForegroundColor Cyan

$Drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

foreach ($Drive in $Drives) {
    $FreeGB = [math]::Round($Drive.FreeSpace / 1GB, 2)
    $TotalGB = [math]::Round($Drive.Size / 1GB, 2)
    $FreePercent = [math]::Round(($Drive.FreeSpace / $Drive.Size) * 100, 2)

    Write-Host "`nDrive: $($Drive.DeviceID)"
    Write-Host "Total Space: $TotalGB GB"
    Write-Host "Free Space: $FreeGB GB"
    Write-Host "Free Percentage: $FreePercent%"

    if ($FreePercent -lt 15) {
        Write-Host "Status: LOW DISK SPACE" -ForegroundColor Red
    } else {
        Write-Host "Status: OK" -ForegroundColor Green
    }
}

Write-Host "`n===== Report Complete =====" -ForegroundColor Cyan

<#
.SYNOPSIS
    Reviews local user profiles.

.DESCRIPTION
    This script lists local user profiles and identifies profiles that have not been used recently.
    It does not delete anything. It is intended for review and documentation only.

.NOTES
    Author: Daniel O'Leary
    Purpose: Portfolio / Endpoint Maintenance
#>

Write-Host "===== User Profile Cleanup Check =====" -ForegroundColor Cyan

$DaysOld = 90
$CutoffDate = (Get-Date).AddDays(-$DaysOld)

$Profiles = Get-CimInstance Win32_UserProfile |
    Where-Object {
        $_.Special -eq $false -and
        $_.LocalPath -like "C:\Users\*"
    }

foreach ($Profile in $Profiles) {
    $LastUse = $Profile.LastUseTime

    Write-Host "`nProfile Path: $($Profile.LocalPath)"
    Write-Host "SID: $($Profile.SID)"
    Write-Host "Last Used: $LastUse"

    if ($LastUse -lt $CutoffDate) {
        Write-Host "Review Status: Older than $DaysOld days" -ForegroundColor Yellow
    } else {
        Write-Host "Review Status: Recently used" -ForegroundColor Green
    }
}

Write-Host "`nNo profiles were deleted. This script is review-only." -ForegroundColor Cyan
Write-Host "===== Profile Review Complete =====" -ForegroundColor Cyan

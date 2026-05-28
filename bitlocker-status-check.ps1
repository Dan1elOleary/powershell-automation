<#
.SYNOPSIS
    Checks BitLocker encryption status.

.DESCRIPTION
    This script checks BitLocker status for available volumes and reports protection status,
    encryption percentage, and encryption method.

.NOTES
    Author: Daniel O'Leary
    Purpose: Portfolio / Endpoint Security Check
#>

Write-Host "===== BitLocker Status Check =====" -ForegroundColor Cyan

try {
    $Volumes = Get-BitLockerVolume

    foreach ($Volume in $Volumes) {
        Write-Host "`nMount Point: $($Volume.MountPoint)"
        Write-Host "Volume Status: $($Volume.VolumeStatus)"
        Write-Host "Protection Status: $($Volume.ProtectionStatus)"
        Write-Host "Encryption Percentage: $($Volume.EncryptionPercentage)%"
        Write-Host "Encryption Method: $($Volume.EncryptionMethod)"

        if ($Volume.ProtectionStatus -eq "On") {
            Write-Host "Status: Protected" -ForegroundColor Green
        } else {
            Write-Host "Status: Not Protected or Protection Suspended" -ForegroundColor Yellow
        }
    }
}
catch {
    Write-Host "Unable to retrieve BitLocker information. Try running PowerShell as Administrator." -ForegroundColor Red
}

Write-Host "`n===== BitLocker Check Complete =====" -ForegroundColor Cyan

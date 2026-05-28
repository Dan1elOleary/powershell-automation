<#
.SYNOPSIS
    Collects basic workstation health information.

.DESCRIPTION
    This script gathers common system information used during IT support and endpoint troubleshooting.
    It checks hostname, logged-in user, OS version, uptime, disk space, IP configuration, and basic network details.

.NOTES
    Author: Daniel O'Leary
    Purpose: Portfolio / IT Support Automation
#>

Write-Host "===== Workstation Health Check =====" -ForegroundColor Cyan

# Computer information
$ComputerName = $env:COMPUTERNAME
$CurrentUser = $env:USERNAME
$OS = Get-CimInstance Win32_OperatingSystem
$LastBoot = $OS.LastBootUpTime
$Uptime = (Get-Date) - $LastBoot

Write-Host "`n--- System Information ---" -ForegroundColor Yellow
Write-Host "Computer Name: $ComputerName"
Write-Host "Current User: $CurrentUser"
Write-Host "OS Version: $($OS.Caption)"
Write-Host "OS Build: $($OS.BuildNumber)"
Write-Host "Last Boot Time: $LastBoot"
Write-Host "Uptime: $($Uptime.Days) days, $($Uptime.Hours) hours, $($Uptime.Minutes) minutes"

# Disk information
Write-Host "`n--- Disk Space ---" -ForegroundColor Yellow
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    $FreeGB = [math]::Round($_.FreeSpace / 1GB, 2)
    $TotalGB = [math]::Round($_.Size / 1GB, 2)
    $FreePercent = [math]::Round(($_.FreeSpace / $_.Size) * 100, 2)

    Write-Host "Drive $($_.DeviceID) - Free: $FreeGB GB / Total: $TotalGB GB ($FreePercent% free)"

    if ($FreePercent -lt 15) {
        Write-Host "Warning: Drive $($_.DeviceID) has low free space." -ForegroundColor Red
    }
}

# Network information
Write-Host "`n--- Network Information ---" -ForegroundColor Yellow
Get-NetIPConfiguration | ForEach-Object {
    Write-Host "Interface: $($_.InterfaceAlias)"
    Write-Host "IPv4 Address: $($_.IPv4Address.IPAddress)"
    Write-Host "Default Gateway: $($_.IPv4DefaultGateway.NextHop)"
    Write-Host "DNS Servers: $($_.DNSServer.ServerAddresses -join ', ')"
    Write-Host ""
}

# Basic connectivity test
Write-Host "`n--- Connectivity Test ---" -ForegroundColor Yellow
$TestTarget = "8.8.8.8"

if (Test-Connection -ComputerName $TestTarget -Count 2 -Quiet) {
    Write-Host "Internet connectivity test passed." -ForegroundColor Green
} else {
    Write-Host "Internet connectivity test failed." -ForegroundColor Red
}

Write-Host "`n===== Health Check Complete =====" -ForegroundColor Cyan

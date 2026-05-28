<#
.SYNOPSIS
    Collects basic network configuration information.

.DESCRIPTION
    This script displays network adapter details, IPv4 address, default gateway, DNS servers,
    and performs a basic internet connectivity test.

.NOTES
    Author: Daniel O'Leary
    Purpose: Portfolio / Network Troubleshooting
#>

Write-Host "===== Network Information Check =====" -ForegroundColor Cyan

$NetworkConfigs = Get-NetIPConfiguration

foreach ($Config in $NetworkConfigs) {
    Write-Host "`nInterface: $($Config.InterfaceAlias)"
    Write-Host "IPv4 Address: $($Config.IPv4Address.IPAddress)"
    Write-Host "Default Gateway: $($Config.IPv4DefaultGateway.NextHop)"
    Write-Host "DNS Servers: $($Config.DNSServer.ServerAddresses -join ', ')"
}

Write-Host "`n--- Adapter Status ---" -ForegroundColor Yellow

Get-NetAdapter | Select-Object Name, Status, LinkSpeed, MacAddress | Format-Table -AutoSize

Write-Host "`n--- Connectivity Test ---" -ForegroundColor Yellow

$Targets = @("8.8.8.8", "google.com")

foreach ($Target in $Targets) {
    if (Test-Connection -ComputerName $Target -Count 2 -Quiet) {
        Write-Host "$Target reachable" -ForegroundColor Green
    } else {
        Write-Host "$Target unreachable" -ForegroundColor Red
    }
}

Write-Host "`n===== Network Check Complete =====" -ForegroundColor Cyan

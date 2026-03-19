#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
Write-Host "==> Windows bootstrap" -ForegroundColor Cyan

$wslCheck = wsl --list --quiet 2>$null
if (-not $wslCheck) {
    Write-Host "==> Installing WSL + Ubuntu LTS..." -ForegroundColor Yellow
    wsl --install -d Ubuntu
    Write-Host ""
    Write-Host "==> After Ubuntu first-run setup, open Ubuntu and run:" -ForegroundColor Green
    Write-Host "    git clone https://github.com/sametj/dotfiles-2026.git ~/.dotfiles && ~/.dotfiles/bootstrap/install.sh" -ForegroundColor Cyan
    Write-Host "    Reboot if prompted." -ForegroundColor Yellow
} else {
    Write-Host "==> WSL already installed. Run this inside Ubuntu:" -ForegroundColor Green
    Write-Host "    git clone https://github.com/sametj/dotfiles-2026.git ~/.dotfiles && ~/.dotfiles/bootstrap/install.sh" -ForegroundColor Cyan
}

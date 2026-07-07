param([string]$Message = "")
$ErrorActionPreference = "Stop"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
# Self-contained: edit index.html in THIS repo folder, then run ./publish.ps1
Set-Location $PSScriptRoot
git pull --rebase origin main
$changes = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changes)) { Write-Host "No changes. Site already up to date." -ForegroundColor Yellow; exit 0 }
if ([string]::IsNullOrWhiteSpace($Message)) { $Message = "Update: " + (Get-Date -Format "yyyy-MM-dd HH:mm") }
git add -A
git commit -m $Message | Out-Null
git push origin main
Write-Host "Pushed to GitHub." -ForegroundColor Green
Write-Host "Live in a few minutes: https://torinzhen001.github.io/work-money-simulator/" -ForegroundColor Cyan
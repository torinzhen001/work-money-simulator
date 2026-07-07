param([string]$Message = "")
$ErrorActionPreference = "Stop"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$source = "c:\Users\tori.zheng\Documents\外包管理工具\index.html"
$deployDir = $PSScriptRoot
$dest = Join-Path $deployDir "index.html"
if (-not (Test-Path $source)) { Write-Host "Source not found: $source" -ForegroundColor Red; exit 1 }
Set-Location $deployDir
Copy-Item $source $dest -Force
Write-Host "Synced index.html from main folder." -ForegroundColor Green
$changes = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changes)) { Write-Host "No changes. Site already up to date." -ForegroundColor Yellow; exit 0 }
if ([string]::IsNullOrWhiteSpace($Message)) { $Message = "Update: " + (Get-Date -Format "yyyy-MM-dd HH:mm") }
git add -A
git commit -m $Message | Out-Null
git push origin main
Write-Host "Pushed to GitHub." -ForegroundColor Green
Write-Host "Live in a few minutes: https://torinzhen001.github.io/work-money-simulator/" -ForegroundColor Cyan
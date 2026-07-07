# 一键发布脚本：把主文件夹的 index.html 同步到部署仓库并推送上线
# 用法：在本文件所在文件夹打开 PowerShell，运行  ./publish.ps1  "可选的更新说明"
# 主文件夹（唯一真源）：外包管理工具\index.html
# 上线网址：https://torinzhen001.github.io/work-money-simulator/

param(
    [string]$Message = ""
)

$ErrorActionPreference = 'Stop'

# 让当前会话能找到 git / gh
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

$source = 'c:\Users\tori.zheng\Documents\外包管理工具\index.html'
$deployDir = $PSScriptRoot
$dest = Join-Path $deployDir 'index.html'

if (-not (Test-Path $source)) {
    Write-Host "找不到主文件：$source" -ForegroundColor Red
    exit 1
}

Set-Location $deployDir

# 1) 从主文件夹同步最新版本
Copy-Item $source $dest -Force
Write-Host "已从主文件夹同步 index.html" -ForegroundColor Green

# 2) 检查是否有改动
$changes = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changes)) {
    Write-Host "没有检测到改动，网站已是最新，无需发布。" -ForegroundColor Yellow
    exit 0
}

# 3) 提交并推送
if ([string]::IsNullOrWhiteSpace($Message)) {
    $Message = "更新：" + (Get-Date -Format 'yyyy-MM-dd HH:mm')
}

git add index.html
git commit -m $Message | Out-Null
git push origin main
Write-Host "已推送到 GitHub。" -ForegroundColor Green
Write-Host "几分钟后刷新即可看到更新：https://torinzhen001.github.io/work-money-simulator/" -ForegroundColor Cyan

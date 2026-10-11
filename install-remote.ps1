# Invoke-WebRequest .../install-remote.ps1 -OutFile $env:TEMP\i.ps1; & $env:TEMP\i.ps1
$ErrorActionPreference = "Stop"

$Repo = "andreev-sy/cursor-tools"
$Branch = "master"
$tmp = Join-Path ([IO.Path]::GetTempPath()) ("cursor-tools-" + [guid]::NewGuid().ToString("n"))
New-Item -ItemType Directory -Path $tmp | Out-Null

try {
    $zip = Join-Path $tmp "kit.zip"
    $url = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"
    Write-Host "Downloading $url"
    Invoke-WebRequest -Uri $url -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $tmp
    $kitDir = Get-ChildItem -Path $tmp -Directory | Select-Object -First 1
    & (Join-Path $kitDir.FullName "install.ps1") -Target (Get-Location).Path
}
finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}

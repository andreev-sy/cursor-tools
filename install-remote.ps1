# One-shot install from GitHub into the current project (Windows).
# Usage (from target project root):
#   irm https://raw.githubusercontent.com/OWNER/REPO/main/install-remote.ps1 | iex
#   irm https://raw.githubusercontent.com/andreev-sy/cursor-tools/main/install-remote.ps1 | iex
param(
    [string]$Repo = $env:GITHUB_REPO,
    [string]$Branch = $(if ($env:GITHUB_BRANCH) { $env:GITHUB_BRANCH } else { "main" }),
    [string]$Name = $env:KIT_NAME,
    [switch]$User,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Defaults from sibling kit.conf when run from a clone
$here = if ($PSScriptRoot) { $PSScriptRoot } else { $null }
if ($here -and (Test-Path (Join-Path $here "kit.conf"))) {
    Get-Content (Join-Path $here "kit.conf") | ForEach-Object {
        if (-not $Repo -and $_ -match '^\s*GITHUB_REPO=(.+)$') { $Repo = $Matches[1].Trim() }
        if ($_ -match '^\s*GITHUB_BRANCH=(.+)$' -and $Branch -eq "main") { $Branch = $Matches[1].Trim() }
        if (-not $Name -and $_ -match '^\s*KIT_NAME=(.+)$') { $Name = $Matches[1].Trim() }
    }
}

if (-not $Repo) { $Repo = "andreev-sy/cursor-tools" }

$repoBase = [IO.Path]::GetFileNameWithoutExtension(($Repo -split '/')[-1])
if (-not $Name) { $Name = $repoBase }

$tmp = Join-Path ([IO.Path]::GetTempPath()) ("adp-kit-" + [guid]::NewGuid().ToString("n"))
New-Item -ItemType Directory -Path $tmp | Out-Null
try {
    $zipUrl = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"
    $zipPath = Join-Path $tmp "kit.zip"
    Write-Host "Downloading $zipUrl"
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $tmp
    $kitDir = Get-ChildItem -Path $tmp -Directory | Select-Object -First 1
    if (-not $kitDir) { throw "Archive did not contain a directory" }
    $install = Join-Path $kitDir.FullName "install.ps1"
    $args = @{
        Target = (Get-Location).Path
        Name   = $Name
        Force  = $Force
        User   = $User
    }
    Write-Host "Running install into: $($args.Target)"
    & $install @args
}
finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}

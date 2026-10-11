#Requires -Version 5.1
<#
.SYNOPSIS
  Install ADP kit under .cursor/kits/<KIT_NAME>/ + namespaced skills.
#>
param(
    [string]$Target = (Get-Location).Path,
    [string]$Name = "",
    [switch]$User,
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$KitRoot = $PSScriptRoot

$KitName = $Name
if (-not $KitName) { $KitName = $env:KIT_NAME }
$conf = Join-Path $KitRoot "kit.conf"
if ((-not $KitName) -and (Test-Path $conf)) {
    Get-Content $conf | ForEach-Object {
        if ($_ -match '^\s*KIT_NAME=(.+)$') { $KitName = $Matches[1].Trim() }
    }
}
if (-not $KitName) { $KitName = "cursor-tools" }
$KitName = ($KitName.ToLower() -replace '[^a-z0-9._-]', '-')

$SkillsSource = Join-Path $KitRoot "skills"
if (-not (Test-Path $SkillsSource)) {
    Write-Error "Skills source not found: $SkillsSource"
}

if ($User) {
    $CursorRoot = Join-Path $HOME ".cursor"
    $ProjectRoot = $null
} else {
    if (-not [System.IO.Path]::IsPathRooted($Target)) {
        $Target = Join-Path (Get-Location).Path $Target
    }
    $Target = [System.IO.Path]::GetFullPath($Target)
    if (-not (Test-Path -LiteralPath $Target)) {
        New-Item -ItemType Directory -Force -Path $Target | Out-Null
    }
    $ProjectRoot = $Target
    $CursorRoot = Join-Path $Target ".cursor"
}

$KitDest = Join-Path $CursorRoot "kits\$KitName"
$SkillsDest = Join-Path $CursorRoot "skills"
New-Item -ItemType Directory -Force -Path $KitDest, $SkillsDest | Out-Null

Write-Host "Installing kit '$KitName' -> $KitDest"

$payload = @("ADP.md", "README.md", "kit.conf", "examples", "templates", "skills")
foreach ($item in $payload) {
    $src = Join-Path $KitRoot $item
    if (-not (Test-Path $src)) { continue }
    $dest = Join-Path $KitDest $item
    if ((Test-Path $dest) -and -not $Force -and $item -ne "skills") {
        Write-Host "Skip (exists): kits/$KitName/$item"
        continue
    }
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    if (Test-Path $src -PathType Container) {
        Copy-Item -Recurse -Path $src -Destination $dest
    } else {
        Copy-Item -Force -Path $src -Destination $dest
    }
    Write-Host "Installed: .cursor/kits/$KitName/$item"
}

Set-Content -Path (Join-Path $KitDest ".kit-id") -Value $KitName -NoNewline

$installed = @()
$skipped = @()
$skillSrcRoot = Join-Path $KitDest "skills"
Get-ChildItem -Path $skillSrcRoot -Directory | ForEach-Object {
    $base = $_.Name
    $skillId = "$KitName-$base"
    $dest = Join-Path $SkillsDest $skillId
    if ((Test-Path $dest) -and -not $Force) {
        $skipped += $skillId
        Write-Host "Skip (exists): skills/$skillId"
        return
    }
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse -Path $_.FullName -Destination $dest
    $skillMd = Join-Path $dest "SKILL.md"
    if (Test-Path $skillMd) {
        $text = Get-Content -Raw $skillMd
        $text = [regex]::Replace($text, '(?m)^name:\s*.*$', "name: $skillId")
        Set-Content -Path $skillMd -Value $text -NoNewline
    }
    $installed += $skillId
    Write-Host "Installed: .cursor/skills/$skillId"
}

if ($ProjectRoot) {
    $legacyAdp = Join-Path $ProjectRoot "ADP.md"
    if (Test-Path $legacyAdp) {
        $raw = Get-Content -Raw $legacyAdp
        if ($raw -match 'Anchor' -and $raw -match 'Delta' -and $raw -match 'Prove') {
            Remove-Item -Force $legacyAdp
            Write-Host "Removed legacy: ./ADP.md (moved under .cursor/kits/$KitName/)"
        }
    }
}

foreach ($legacy in @("adp", "project-bootstrap", "brief")) {
    $p = Join-Path $SkillsDest $legacy
    if (Test-Path $p) {
        $md = Join-Path $p "SKILL.md"
        if (Test-Path $md) {
            Remove-Item -Recurse -Force $p
            Write-Host "Removed legacy skill: $legacy"
        }
    }
}

Write-Host ""
Write-Host "Done."
Write-Host "  Kit files:  $KitDest"
Write-Host "  Skills:     $SkillsDest\$KitName-*"
if ($installed.Count -gt 0) { Write-Host "  Installed:  $($installed -join ', ')" }
if ($skipped.Count -gt 0) { Write-Host "  Skipped:    $($skipped -join ', ')" }
Write-Host ""
Write-Host "Commands: /$KitName-project-bootstrap   then   /$KitName-adp"
Write-Host "Docs:     $KitDest\ADP.md"

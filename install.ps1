#Requires -Version 5.1
# Copy kit into the target project. Always overwrites this kit's files.
param(
    [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

# Full GitHub path: owner/repo
$KitPath = "andreev-sy\cursor-tools"
$SkillPrefix = "andreev-sy-cursor-tools"
$KitRoot = $PSScriptRoot

if (-not [System.IO.Path]::IsPathRooted($Target)) {
    $Target = Join-Path (Get-Location).Path $Target
}
$Target = [System.IO.Path]::GetFullPath($Target)
if (-not (Test-Path -LiteralPath $Target)) {
    New-Item -ItemType Directory -Force -Path $Target | Out-Null
}

$KitDest = Join-Path $Target ".cursor\kits\$KitPath"
$SkillsDest = Join-Path $Target ".cursor\skills"

if (Test-Path $KitDest) { Remove-Item -Recurse -Force $KitDest }
New-Item -ItemType Directory -Force -Path $KitDest, $SkillsDest | Out-Null

foreach ($item in @("ADP.md", "README.md", "examples", "templates", "skills")) {
    $src = Join-Path $KitRoot $item
    if (-not (Test-Path $src)) { continue }
    Copy-Item -Recurse -Force -Path $src -Destination (Join-Path $KitDest $item)
}

Get-ChildItem -Path (Join-Path $KitRoot "skills") -Directory | ForEach-Object {
    $dest = Join-Path $SkillsDest $_.Name
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Recurse -Path $_.FullName -Destination $dest
}

foreach ($legacy in @("cursor-tools-adp", "cursor-tools-project-bootstrap")) {
    $p = Join-Path $SkillsDest $legacy
    if (Test-Path $p) { Remove-Item -Recurse -Force $p }
}
$oldKit = Join-Path $Target ".cursor\kits\cursor-tools"
if (Test-Path $oldKit) { Remove-Item -Recurse -Force $oldKit }

Write-Host "Installed into $Target"
Write-Host "  $KitDest"
Write-Host "  $SkillsDest\$SkillPrefix-*"
Write-Host "Commands: /$SkillPrefix-project-bootstrap  then  /$SkillPrefix-adp"

param(
    [string]$OutputZip = "ChattyFactory.zip"
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$target = Join-Path $root 'target' 'release' 'chattyfactory_gui.exe'
$staging = Join-Path $root 'dist'

Write-Host "Packaging ChattyFactory..."

if (-not (Test-Path $target)) {
    Write-Host "Release binary missing, building..."
    pushd $root
    cargo build -p chattyfactory_gui --release | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "cargo build failed with exit code $LASTEXITCODE" }
    popd
}

Write-Host "Running core tests..."
pushd $root
cargo test -p chattyfactory_core | Out-Host
if ($LASTEXITCODE -ne 0) { throw "core tests failed with exit code $LASTEXITCODE" }
popd

if (Test-Path $staging) { Remove-Item -Recurse -Force $staging }
New-Item -ItemType Directory -Path $staging | Out-Null

# Copy binary and base folders (empty if missing) to staging
Copy-Item $target (Join-Path $staging 'chattyfactory_gui.exe')
foreach ($dir in @('config','runtime','output','models','bookshelf')) {
    $src = Join-Path $root $dir
    if (-not (Test-Path $src)) { New-Item -ItemType Directory -Path $src | Out-Null }
    Copy-Item $src (Join-Path $staging $dir) -Recurse -Force
}

# Include docs
foreach ($doc in @('USER_MANUAL.md','RELIABILITY.md','work-orders.txt')) {
    $src = Join-Path $root $doc
    if (Test-Path $src) { Copy-Item $src $staging }
}

$zipPath = Join-Path $root $OutputZip
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path (Join-Path $staging '*') -DestinationPath $zipPath
Write-Host "Package created: $zipPath"

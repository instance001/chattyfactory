param(
    [Parameter(Mandatory = $true)]
    [string]$Url,

    [string]$Sha256 = "",

    [string]$OutDir = "runtime/bin/windows"
)

$ErrorActionPreference = 'Stop'

function Get-RepoRoot {
    $here = Split-Path -Parent $MyInvocation.MyCommand.Path
    return (Split-Path -Parent $here)
}

$root = Get-RepoRoot
$outPath = Join-Path $root $OutDir

New-Item -ItemType Directory -Force -Path $outPath | Out-Null

$tmp = Join-Path $env:TEMP ("chattyfactory_llama_cpp_" + [Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

try {
    $zipPath = Join-Path $tmp "llama.cpp.zip"
    Write-Host "Downloading $Url"
    Invoke-WebRequest -Uri $Url -OutFile $zipPath -UseBasicParsing

    $hash = (Get-FileHash -Path $zipPath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($Sha256 -and $Sha256.Trim().Length -gt 0) {
        $expected = $Sha256.Trim().ToLowerInvariant()
        if ($hash -ne $expected) {
            throw "SHA-256 mismatch. expected=$expected actual=$hash"
        }
        Write-Host "SHA-256 OK ($hash)"
    } else {
        Write-Host "SHA-256 (record this for reproducibility): $hash"
    }

    $extractDir = Join-Path $tmp "extract"
    Expand-Archive -Path $zipPath -DestinationPath $extractDir -Force

    $payload = Get-ChildItem -Path $extractDir -Recurse -File | Where-Object {
        $_.Name -like "*.exe" -or $_.Name -like "*.dll"
    }

    if (-not $payload -or $payload.Count -eq 0) {
        throw "No .exe/.dll files found in the extracted zip. Check that the URL points to a Windows release archive."
    }

    foreach ($f in $payload) {
        Copy-Item -Force -Path $f.FullName -Destination (Join-Path $outPath $f.Name)
    }

    if (-not (Test-Path (Join-Path $outPath "llama-cli.exe"))) {
        Write-Warning "llama-cli.exe was not found after extraction. ChattyFactory expects runtime/bin/windows/llama-cli.exe."
    }

    Write-Host "Installed backend binaries into: $outPath"
} finally {
    if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
}


param(
    [string]$SourceDir = "C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze",
    [string]$PocDir = "C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\poc",
    [string]$OutDir = "C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\analysis\poc01_bronze"
)

$ErrorActionPreference = "Stop"

$selected = @(
    "epidemiology.csv",
    "hospitalizations.csv",
    "deaths.csv",
    "mobility.csv",
    "lawatlas-emergency-declarations.csv",
    "demographics.csv",
    "us-counties-2022.csv"
)

$rawLanding = Join-Path $PocDir "bronze_raw_subset"
New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
New-Item -ItemType Directory -Path $rawLanding -Force | Out-Null

$runId = "POC01-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$runTs = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$manifest = @()

foreach ($name in $selected) {
    $src = Join-Path $SourceDir $name
    if (-not (Test-Path $src)) {
        $manifest += [pscustomobject]@{
            run_id = $runId
            run_ts = $runTs
            file_name = $name
            source_path = $src
            copied = $false
            reason = "missing_source"
            row_count = $null
            column_count = $null
        }
        continue
    }

    $dst = Join-Path $rawLanding $name
    Copy-Item -Path $src -Destination $dst -Force

    $rows = @(Import-Csv -Path $dst | Select-Object -First 1)
    $headers = if ($rows.Count -gt 0) { $rows[0].PSObject.Properties.Name } else { @() }
    $lineCount = (Get-Content -Path $dst | Measure-Object -Line).Lines
    $rowCount = $lineCount - 1
    if ($rowCount -lt 0) { $rowCount = 0 }

    $manifest += [pscustomobject]@{
        run_id = $runId
        run_ts = $runTs
        file_name = $name
        source_path = $src
        copied = $true
        reason = ""
        row_count = $rowCount
        column_count = $headers.Count
    }
}

$manifestPath = Join-Path $OutDir "poc01_bronze_manifest.csv"
$summaryPath = Join-Path $OutDir "poc01_bronze_summary.md"

$manifest | Export-Csv -Path $manifestPath -NoTypeInformation -Encoding UTF8

$copied = @($manifest | Where-Object { $_.copied -eq $true }).Count
$missing = @($manifest | Where-Object { $_.copied -eq $false }).Count

$md = @"
# POC-01 Bronze Subset Summary

- Run ID: $runId
- Run Timestamp: $runTs
- Selected tables: $($selected.Count)
- Copied: $copied
- Missing: $missing

## Raw landing path

- $rawLanding

## Manifest

- $manifestPath
"@

$md | Set-Content -Path $summaryPath -Encoding UTF8

Write-Output "Created: $manifestPath"
Write-Output "Created: $summaryPath"
Write-Output "Raw landing: $rawLanding"


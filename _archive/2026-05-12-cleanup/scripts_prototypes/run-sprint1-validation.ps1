param(
    [string]$SourceDir = "C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze",
    [string]$OutDir = "C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\analysis\sprint1",
    [int]$MaxRowsPerFile = 50000
)

$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Path $OutDir -Force | Out-Null

$runTs = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$runId = "RUN-" + (Get-Date -Format "yyyyMMdd-HHmmss")

$files = Get-ChildItem -Path $SourceDir -Filter *.csv | Sort-Object Name

$manifest = @()
$conformance = @()
$validation = @()

foreach ($f in $files) {
    $rows = @(Import-Csv -Path $f.FullName | Select-Object -First $MaxRowsPerFile)
    $rowCount = $rows.Count
    $headers = if ($rowCount -gt 0) { $rows[0].PSObject.Properties.Name } else { @() }
    $colCount = $headers.Count

    $requiredCandidates = @("date","county","state","fips")
    $requiredInFile = @()
    foreach ($rc in $requiredCandidates) {
        if ($headers | Where-Object { $_.ToLower() -match "(^|_|-)$rc($|_|-)" }) {
            $requiredInFile += $rc
        }
    }

    # Bronze-style ingestion manifest
    $manifest += [pscustomobject]@{
        run_id = $runId
        run_ts = $runTs
        file_name = $f.Name
        source_path = $f.FullName
        sampled_row_count = $rowCount
        column_count = $colCount
    }

    # Silver key/date conformance profiling
    $dateCols = @($headers | Where-Object { $_ -match '(?i)(^|_|-)(date|day|week|month|year)($|_|-)' })
    $keyCols = @($headers | Where-Object { $_ -match '(?i)(^|_|-)(fips|county|state|geo|id)($|_|-)' })

    foreach ($dc in $dateCols) {
        $nonnull = @($rows | Where-Object { $_.$dc -and $_.$dc.ToString().Trim() -ne "" })
        $valid = 0
        foreach ($r in $nonnull) {
            try {
                [void](Get-Date $r.$dc)
                $valid++
            } catch {
            }
        }
        $validPct = if ($nonnull.Count -gt 0) { [math]::Round(($valid / $nonnull.Count) * 100, 2) } else { 0 }

        $conformance += [pscustomobject]@{
            run_id = $runId
            file_name = $f.Name
            column_name = $dc
            check_type = "date_parse_success_pct"
            value = $validPct
            threshold = 99.0
            pass = ($validPct -ge 99.0)
        }
    }

    foreach ($kc in $keyCols) {
        $nonnull = @($rows | Where-Object { $_.$kc -and $_.$kc.ToString().Trim() -ne "" })
        $nonnullPct = if ($rowCount -gt 0) { [math]::Round(($nonnull.Count / $rowCount) * 100, 2) } else { 0 }
        $uniqueCount = @($nonnull | Select-Object -ExpandProperty $kc -Unique).Count

        $conformance += [pscustomobject]@{
            run_id = $runId
            file_name = $f.Name
            column_name = $kc
            check_type = "key_nonnull_pct"
            value = $nonnullPct
            threshold = 99.5
            pass = ($nonnullPct -ge 99.5)
        }

        $conformance += [pscustomobject]@{
            run_id = $runId
            file_name = $f.Name
            column_name = $kc
            check_type = "key_unique_count"
            value = $uniqueCount
            threshold = 1
            pass = ($uniqueCount -ge 1)
        }
    }

    # Layer A validation scaffolding
    foreach ($req in $requiredInFile) {
            $cols = @($headers | Where-Object { $_.ToLower() -match "(^|_|-)$req($|_|-)" })
        foreach ($c in $cols) {
            $nonnull = @($rows | Where-Object { $_.$c -and $_.$c.ToString().Trim() -ne "" })
            $nonnullPct = if ($rowCount -gt 0) { [math]::Round(($nonnull.Count / $rowCount) * 100, 2) } else { 0 }
            $validation += [pscustomobject]@{
                run_id = $runId
                file_name = $f.Name
                rule_id = "A1_required_column_completeness"
                column_name = $c
                observed_value = $nonnullPct
                threshold = 99.5
                pass = ($nonnullPct -ge 99.5)
            }
        }
    }
}

$manifestPath = Join-Path $OutDir "bronze_ingestion_manifest.csv"
$conformancePath = Join-Path $OutDir "silver_key_date_conformance.csv"
$validationPath = Join-Path $OutDir "validation_results_layerA.csv"
$summaryPath = Join-Path $OutDir "sprint1_validation_summary.md"

$manifest | Export-Csv -Path $manifestPath -NoTypeInformation -Encoding UTF8
$conformance | Export-Csv -Path $conformancePath -NoTypeInformation -Encoding UTF8
$validation | Export-Csv -Path $validationPath -NoTypeInformation -Encoding UTF8

$totalRules = $validation.Count
$passRules = @($validation | Where-Object { $_.pass -eq $true }).Count
$failRules = $totalRules - $passRules
$passPct = if ($totalRules -gt 0) { [math]::Round(($passRules / $totalRules) * 100, 2) } else { 0 }

$md = @"
# Sprint 1 Validation Summary

- Run ID: $runId
- Run Timestamp: $runTs
- Source Directory: $SourceDir
- Files Profiled: $($files.Count)
- Max Rows Per File: $MaxRowsPerFile

## Layer A1 Required Column Completeness

- Total checks: $totalRules
- Passed: $passRules
- Failed: $failRules
- Pass rate: $passPct%

## Output Artifacts

- bronze_ingestion_manifest.csv
- silver_key_date_conformance.csv
- validation_results_layerA.csv
"@

$md | Set-Content -Path $summaryPath -Encoding UTF8

Write-Output "Created: $manifestPath"
Write-Output "Created: $conformancePath"
Write-Output "Created: $validationPath"
Write-Output "Created: $summaryPath"


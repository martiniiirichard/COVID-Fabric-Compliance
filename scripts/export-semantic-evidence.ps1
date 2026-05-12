param(
    [string]$ServerInstance = ".\SQLEXPRESS",
    [string]$Database = "CovidMedallionPOC",
    [string]$ProjectRoot = "C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance"
)

$ErrorActionPreference = "Stop"

$runId = "SEMANTIC-EVIDENCE-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$runTs = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$outDir = Join-Path $ProjectRoot "evidence\semantic\$runId"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

$connectionString = "Server=$ServerInstance;Database=$Database;Integrated Security=True;Encrypt=False;TrustServerCertificate=True;"

function Export-Query {
    param(
        [string]$Query,
        [string]$FileName
    )

    $connection = New-Object System.Data.SqlClient.SqlConnection $connectionString
    $command = $connection.CreateCommand()
    $command.CommandText = $Query
    $command.CommandTimeout = 0

    $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
    $table = New-Object System.Data.DataTable
    [void]$adapter.Fill($table)

    $path = Join-Path $outDir $FileName
    $table | Export-Csv -Path $path -NoTypeInformation -Encoding UTF8

    [pscustomobject]@{
        run_id = $runId
        run_ts = $runTs
        file_name = $FileName
        row_count = $table.Rows.Count
        output_path = $path
    }
}

$manifest = @()
Write-Output "Exporting semantic.vw_trust_gate_status..."
$manifest += Export-Query -Query "SELECT * FROM semantic.vw_trust_gate_status;" -FileName "semantic.vw_trust_gate_status.csv"
Write-Output "Exporting semantic.vw_metric_contracts..."
$manifest += Export-Query -Query "SELECT * FROM semantic.vw_metric_contracts;" -FileName "semantic.vw_metric_contracts.csv"
Write-Output "Exporting semantic.vw_powerbi_poc_dataset sample..."
$powerBiSampleQuery = @"
WITH sample_epi AS (
    SELECT TOP 100 *
    FROM silver.vw_epidemiology
)
SELECT
    e.DateKey,
    e.GeoKey,
    e.[Date],
    e.NewConfirmed,
    e.NewDeceased,
    h.CurrentHospitalized,
    h.CurrentICU,
    m.MobilityWorkplaces,
    m.MobilityResidential,
    d.Population,
    CASE
        WHEN d.Population IS NULL OR d.Population = 0 THEN NULL
        ELSE (e.NewConfirmed / NULLIF(d.Population, 0)) * 100000.0
    END AS NewConfirmedPer100k,
    CASE
        WHEN e.NewConfirmed IS NULL OR e.NewConfirmed = 0 THEN NULL
        ELSE e.NewDeceased / NULLIF(e.NewConfirmed, 0)
    END AS DailyFatalityRatio
FROM sample_epi e
LEFT JOIN silver.vw_hospitalizations h
    ON e.DateKey = h.DateKey
   AND e.GeoKey = h.GeoKey
LEFT JOIN silver.vw_mobility m
    ON e.DateKey = m.DateKey
   AND e.GeoKey = m.GeoKey
LEFT JOIN silver.vw_demographics d
    ON e.GeoKey = d.GeoKey;
"@
$manifest += Export-Query -Query $powerBiSampleQuery -FileName "semantic.vw_powerbi_poc_dataset_top100.csv"

$manifestPath = Join-Path $outDir "export_manifest.csv"
$summaryPath = Join-Path $outDir "README.md"

$manifest | Export-Csv -Path $manifestPath -NoTypeInformation -Encoding UTF8

$summary = @"
# Semantic Evidence Export

- Run ID: $runId
- Run Timestamp: $runTs
- Server: $ServerInstance
- Database: $Database

## Files

- semantic.vw_trust_gate_status.csv
- semantic.vw_metric_contracts.csv
- semantic.vw_powerbi_poc_dataset_top100.csv
- export_manifest.csv

## Notes

Exports are generated through PowerShell `Export-Csv`, so column headers are preserved.
"@

$summary | Set-Content -Path $summaryPath -Encoding UTF8

Write-Output "Created semantic evidence export:"
Write-Output $outDir
Write-Output ""
$manifest | Format-Table -AutoSize

param(
    [string]$ServerInstance = ".\SQLEXPRESS01",
    [string]$Database = "CovidMedallionPOC",
    [string]$ProjectRoot = "C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance"
)

$ErrorActionPreference = "Stop"

$runId = "T0-DIAGNOSTICS-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$runTs = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$outDir = Join-Path $ProjectRoot "evidence\diagnostics\$runId"
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

$manifest += Export-Query -FileName "deaths_null_datekey_sample.csv" -Query @"
SELECT TOP 100
    country, placename, frequency, start_date, end_date, year_col, month_col, week_col, deaths,
    TRY_CONVERT(date, start_date) AS parsed_start_date,
    TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, start_date), 'yyyyMMdd')) AS parsed_datekey
FROM bronze.deaths
WHERE TRY_CONVERT(date, start_date) IS NULL
ORDER BY country, year_col, month_col, week_col;
"@

$manifest += Export-Query -FileName "deaths_null_datekey_summary.csv" -Query @"
SELECT country, frequency, COUNT(*) AS null_datekey_rows
FROM bronze.deaths
WHERE TRY_CONVERT(date, start_date) IS NULL
GROUP BY country, frequency
ORDER BY null_datekey_rows DESC, country;
"@

$manifest += Export-Query -FileName "us_counties_2022_null_geokey_sample.csv" -Query @"
SELECT TOP 100
    date_col, county, state, fips, cases, deaths,
    RIGHT('00000' + NULLIF(LTRIM(RTRIM(fips)), ''), 5) AS parsed_geokey
FROM bronze.us_counties_2022
WHERE RIGHT('00000' + NULLIF(LTRIM(RTRIM(fips)), ''), 5) IS NULL
ORDER BY state, county, date_col;
"@

$manifest += Export-Query -FileName "us_counties_2022_null_geokey_summary.csv" -Query @"
SELECT state, county, COUNT(*) AS null_geokey_rows
FROM bronze.us_counties_2022
WHERE RIGHT('00000' + NULLIF(LTRIM(RTRIM(fips)), ''), 5) IS NULL
GROUP BY state, county
ORDER BY null_geokey_rows DESC, state, county;
"@

$manifestPath = Join-Path $outDir "diagnostic_manifest.csv"
$summaryPath = Join-Path $outDir "README.md"

$manifest | Export-Csv -Path $manifestPath -NoTypeInformation -Encoding UTF8

$summary = @"
# T0 Trust Gate Diagnostics

- Run ID: $runId
- Run Timestamp: $runTs
- Server: $ServerInstance
- Database: $Database

## Files

- deaths_null_datekey_sample.csv
- deaths_null_datekey_summary.csv
- us_counties_2022_null_geokey_sample.csv
- us_counties_2022_null_geokey_summary.csv
- diagnostic_manifest.csv
"@

$summary | Set-Content -Path $summaryPath -Encoding UTF8

Write-Output "Created T0 diagnostics:"
Write-Output $outDir
$manifest | Format-Table -AutoSize

param(
    [string]$ProjectRoot = "C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance",
    [int]$MaxRowsPerFile = 50000
)

$ErrorActionPreference = "Stop"

$dw = Join-Path $ProjectRoot "local_dw"
$bronze = Join-Path $dw "layers/bronze"
$silver = Join-Path $dw "layers/silver"
$gold = Join-Path $dw "layers/gold"
$logs = Join-Path $dw "logs"

New-Item -ItemType Directory -Path $silver -Force | Out-Null
New-Item -ItemType Directory -Path $gold -Force | Out-Null

function Get-DateKey($value) {
    try { return (Get-Date $value).ToString("yyyyMMdd") } catch { return $null }
}

function Get-GeoKey($row) {
    $fipsField = $row.PSObject.Properties.Name | Where-Object { $_ -match '(?i)(^|_|-)(fips)($|_|-)' } | Select-Object -First 1
    if ($fipsField) {
        $v = "$($row.$fipsField)".Trim()
        if ($v) { return $v.PadLeft(5,'0') }
    }
    $stateField = $row.PSObject.Properties.Name | Where-Object { $_ -match '(?i)(^|_|-)(state)($|_|-)' } | Select-Object -First 1
    $countyField = $row.PSObject.Properties.Name | Where-Object { $_ -match '(?i)(^|_|-)(county)($|_|-)' } | Select-Object -First 1
    if ($stateField -and $countyField) {
        return ("$($row.$stateField)|$($row.$countyField)").ToUpper().Trim()
    }
    return $null
}

function Build-Silver($fileName, $outputName) {
    $path = Join-Path $bronze $fileName
    if (-not (Test-Path $path)) { return $null }
    $rows = @(Import-Csv -Path $path | Select-Object -First $MaxRowsPerFile)
    $out = @()
    foreach ($r in $rows) {
        $dateField = $r.PSObject.Properties.Name | Where-Object { $_ -match '(?i)(^|_|-)(date|day)($|_|-)' } | Select-Object -First 1
        $dateKey = if ($dateField) { Get-DateKey $r.$dateField } else { $null }
        $geoKey = Get-GeoKey $r
        $obj = [ordered]@{
            DateKey = $dateKey
            GeoKey = $geoKey
        }
        foreach ($p in $r.PSObject.Properties.Name) { $obj[$p] = $r.$p }
        $out += [pscustomobject]$obj
    }
    $outPath = Join-Path $silver $outputName
    $out | Export-Csv -Path $outPath -NoTypeInformation -Encoding UTF8
    return $out
}

$epi = Build-Silver -fileName "epidemiology.csv" -outputName "silver_epidemiology.csv"
$hsp = Build-Silver -fileName "hospitalizations.csv" -outputName "silver_hospitalizations.csv"
$dth = Build-Silver -fileName "deaths.csv" -outputName "silver_deaths.csv"

$goldRows = @()
if ($epi) {
    $grp = $epi | Group-Object DateKey, GeoKey
    foreach ($g in $grp) {
        $parts = $g.Name -split ", "
        $goldRows += [pscustomobject]@{
            DateKey = $parts[0]
            GeoKey = $parts[1]
            RecordCount = $g.Count
        }
    }
}
$goldPath = Join-Path $gold "gold_spread_risk_poc.csv"
$goldRows | Export-Csv -Path $goldPath -NoTypeInformation -Encoding UTF8

$summary = @"
# Local Medallion POC Run

- MaxRowsPerFile: $MaxRowsPerFile
- Silver outputs:
  - silver_epidemiology.csv
  - silver_hospitalizations.csv
  - silver_deaths.csv
- Gold outputs:
  - gold_spread_risk_poc.csv
"@
$summary | Set-Content -Path (Join-Path $logs "poc_run_summary.md") -Encoding UTF8
Write-Output "Created local medallion Silver/Gold outputs under $dw"


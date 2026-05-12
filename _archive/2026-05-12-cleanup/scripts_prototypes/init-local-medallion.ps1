param(
    [string]$ProjectRoot = "C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance",
    [string]$SourceDir = "C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze"
)

$ErrorActionPreference = "Stop"

$dw = Join-Path $ProjectRoot "local_dw"
$bronze = Join-Path $dw "layers/bronze"
$silver = Join-Path $dw "layers/silver"
$gold = Join-Path $dw "layers/gold"
$sql = Join-Path $dw "sql"
$logs = Join-Path $dw "logs"

@($dw, $bronze, $silver, $gold, $sql, $logs) | ForEach-Object {
    New-Item -ItemType Directory -Path $_ -Force | Out-Null
}

$subset = @(
    "epidemiology.csv",
    "hospitalizations.csv",
    "deaths.csv",
    "mobility.csv",
    "lawatlas-emergency-declarations.csv",
    "demographics.csv",
    "us-counties-2022.csv"
)

$manifest = @()
$runId = "LMDL-INIT-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$runTs = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

foreach ($f in $subset) {
    $src = Join-Path $SourceDir $f
    $dst = Join-Path $bronze $f
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dst -Force
        $manifest += [pscustomobject]@{ run_id=$runId; run_ts=$runTs; file_name=$f; copied=$true }
    } else {
        $manifest += [pscustomobject]@{ run_id=$runId; run_ts=$runTs; file_name=$f; copied=$false }
    }
}

$manifest | Export-Csv -Path (Join-Path $logs "init_manifest.csv") -NoTypeInformation -Encoding UTF8
Write-Output "Initialized local medallion at $dw"


param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("User", "Codex")]
    [string]$Speaker,

    [Parameter(Mandatory = $true)]
    [string]$Summary,

    [string]$Decisions = "",
    [string]$Risks = "",
    [string]$NextAction = ""
)

$root = Split-Path -Parent $PSScriptRoot
$logDir = Join-Path $root "logs/chat"
$date = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$logFile = Join-Path $logDir "$date.md"

if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}

if (-not (Test-Path $logFile)) {
    Set-Content -Path $logFile -Value "# Chat Log - $date`r`n"
}

$entry = @"

## $timestamp - $Speaker
- Summary: $Summary
- Decisions: $Decisions
- Risks: $Risks
- Next Action: $NextAction
"@

Add-Content -Path $logFile -Value $entry
Write-Output "Appended log entry to $logFile"

# mllog Stop hook (Windows): reads transcript_path from Claude Code stdin, passes to mllog capture.
$mllog = "$env:CLAUDE_PROJECT_ROOT\.venv\Scripts\mllog.exe"
if (-not (Test-Path $mllog)) { exit 0 }

$input = [Console]::In.ReadToEnd()
$transcriptPath = ""
try {
    $data = $input | ConvertFrom-Json
    $transcriptPath = $data.transcript_path
} catch {}

$captureArgs = @("capture", "--type", "analysis", "--outcome", "success", "--auto")
if ($transcriptPath -and (Test-Path $transcriptPath)) {
    $captureArgs += @("--transcript", $transcriptPath)
}

& $mllog @captureArgs 2>$null
exit 0

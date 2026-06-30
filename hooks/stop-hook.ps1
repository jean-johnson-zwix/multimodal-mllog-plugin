# mllog Stop hook (Windows): reads transcript_path from Claude Code stdin, passes to mllog capture.
$input = [Console]::In.ReadToEnd()
$transcriptPath = ""
try {
    $data = $input | ConvertFrom-Json
    $transcriptPath = $data.transcript_path
} catch {}

$args = @("capture", "--type", "analysis", "--outcome", "success", "--auto")
if ($transcriptPath -and (Test-Path $transcriptPath)) {
    $args += @("--transcript", $transcriptPath)
}

& mllog @args 2>$null
exit 0

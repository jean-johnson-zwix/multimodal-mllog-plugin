# multimodal-mllog-plugin — Claude Code Plugin

Automatic experiment logging for ML coding sessions.

## What it does

- **SessionStart hook** — writes a session marker (timestamp + git commit)
- **Stop hook** — auto-captures a run record (metrics, git delta, conversation transcript)
- `/mllog` — manually capture a run
- `/logbook` — generate a markdown logbook from stored records

## Prerequisites

```bash
pip install multimodal-mllog
```

The `mllog` CLI must be on PATH (installed via pip in your project's venv).

## Install the plugin

```
/plugins add jean-johnson-zwix/multimodal-mllog-plugin
```

Or add to your Claude Code settings:

```json
{
  "enabledPlugins": {
    "mllog@jean-johnson-zwix": true
  }
}
```

## Usage

1. Start a Claude Code session in your ML project — the session marker is written automatically.
2. Do your work (train, eval, analyze).
3. When the session ends, the Stop hook captures a record with git state + transcript.
4. Run `/logbook --from yesterday` to generate a report.

## Storage

Records are stored locally at `./mllog/records/<date>/<run_id>.json`.
Override with the `MLLOG_DIR` environment variable.

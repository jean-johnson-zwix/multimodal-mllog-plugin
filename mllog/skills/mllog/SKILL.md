---
name: mllog
description: >
  Capture the run that just completed as a JSON record in the local mllog store
  (prompts, results, metrics, git, optional MLflow).
argument-hint: "[train|eval|analysis]"
allowed-tools: Bash(mllog:*), Bash(git:*), Read, Glob, Grep
license: MIT
---

# /mllog — capture this run

You are the **capture step** of the mllog pipeline. mllog is an external observer that
documents experiments alongside this coding agent — it records, it does not replace anything.
This command runs after a run (training, evaluation, or analysis) and writes **one JSON record**
of that run to the local store. It does NOT write narrative or a logbook — that is `/logbook`'s
job.

**Hard rules**

- Store **facts only**: raw prompts and results, recorded metrics, git commit info, optional
  MLflow info, type, and outcome. Do not synthesize prose here.
- Never invent values. If something isn't available (e.g. no MLflow, no commit), record its
  **absence** rather than guessing.
- MLflow is **optional**. Capture must succeed without it.

## Inputs

- Requested activity type: `$ARGUMENTS` (`train`, `eval`, or `analysis`; may be empty).

## Steps

1. **Determine the activity type.** Use `$ARGUMENTS` if given; otherwise classify from the
   session: model training -> `train`; metrics on a held-out set -> `eval`;
   inspecting/plotting/explaining without a new run -> `analysis`.

2. **Determine the outcome** (`success` | `fail`) from the session — errors, crashes, or
   aborted runs mean `fail`. If `fail`, note the likely cause from the evidence.

3. **Gather metrics.**
   - If an MLflow run exists for this work, take metrics from it and record the run id.
   - Otherwise take metrics from **your own session memory** of this run.
   - Record which source was used.

4. **Gather git info** (assume the researcher commits). Capture the current commit hash and
   the relevant change info directly via git. If there is no commit, record that absence.

5. **Gather MLflow info — only if present.** If a tracking server / run is available, record
   run id and params. If not, skip and note it. Do not block on MLflow.

6. **Write the run record** to the local store via the CLI, embedding the full transcript
   (prompts + results) for this run plus everything gathered above:
   `mllog capture --type <type> --outcome <outcome> --metrics-json <path>` (the CLI handles
   the JSON write).

7. **Confirm** briefly: type, outcome, metrics source (MLflow vs session), whether git and
   MLflow info were present, and the record location. Flag anything missing rather than
   filling it in.

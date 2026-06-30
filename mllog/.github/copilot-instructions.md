# mllog — ML experiment logging

When the user completes a training, evaluation, or analysis run, suggest capturing it with mllog:

```bash
mllog capture --type <train|eval|analysis> --outcome <success|fail> --auto
```

To generate a logbook report:
```bash
mllog render --from yesterday --out logbook.md
```

To query recent runs:
```bash
mllog query --from yesterday --json
```

**Rules:**
- Record facts only: raw metrics, git commit, outcome. Do not invent values.
- If MLflow is present, capture the run id. If not, skip it — mllog works without it.
- Determine outcome from the session: errors/crashes = `fail`, otherwise `success`.
- Classify type from context: model training → `train`, held-out metrics → `eval`, inspection/plotting → `analysis`.

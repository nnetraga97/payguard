# PayGuard ML Workspace

This workspace exists so the user can build the ML/AI portions of PayGuard directly.
Codex should review, question, and unblock, but should not implement models, feature
engineering, training loops, scoring logic, retrieval logic, fine-tuning, or evaluation
logic unless the user has already attempted the work and is stuck.

## Local Setup

From the repo root:

```bash
./scripts/setup-ml-env.sh
```

Then activate the environment:

```bash
source ml/.venv/bin/activate
```

Run local checks from `ml/`:

```bash
pytest
ruff check .
```

At the beginning there may be no tests beyond the ones the user writes for each
exercise. That is intentional: test design is part of the ML engineering work.

## Data Rules

- Do not commit downloaded datasets.
- Do not commit real cardholder data, PANs, or raw private payment identifiers.
- Store local datasets under `ml/local-data/` or another ignored path.
- Commit only small synthetic samples if a milestone explicitly asks for them.
- Document every dataset in `docs/ml/dataset-registry.md` before using it.

## First Learning Track

Start with:

- `docs/ml/phase-1-classical-fraud.md`
- `docs/ml/experiment-log-template.md`
- `docs/ml/model-card-template.md`

The first implementation task is intentionally not scaffolded as code. The user
should create the EDA/training code after reading the Phase 1 task brief.

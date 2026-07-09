# Phase 1: Classical Fraud Scoring

Goal: build the user's ML fundamentals through a realistic issuer-side fraud
decisioning path.

Codex should not implement this code. The user writes it, then Codex reviews it.

## Why This Matters

Fraud detection is not an accuracy problem. In card authorization flows, fraud is
rare, false positives can block legitimate customers, and false negatives can
create direct loss. Staff-level judgment means choosing metrics and thresholds
based on operating cost, latency, explainability, and leakage risk.

## First Milestone: ULB Baseline

User task:

1. Register the ULB dataset in `docs/ml/dataset-registry.md`.
2. Create an experiment under `ml/experiments/phase-1-classical-fraud/`.
3. Load the data from an ignored local path.
4. Perform EDA focused on class imbalance and feature distributions.
5. Create a baseline model without feature leakage.
6. Evaluate with precision, recall, PR-AUC, and a confusion matrix.
7. Pick at least two candidate thresholds and explain the business tradeoff.
8. Record the run using `docs/ml/experiment-log-template.md`.
9. Draft a model card using `docs/ml/model-card-template.md`.

Suggested first files for the user to create:

```text
ml/experiments/phase-1-classical-fraud/README.md
ml/experiments/phase-1-classical-fraud/eda.py
ml/experiments/phase-1-classical-fraud/train_baseline.py
ml/experiments/phase-1-classical-fraud/evaluate.py
```

## Acceptance Criteria

- The dataset is not committed.
- The split strategy is documented.
- The model never sees the target through a derived feature.
- Accuracy is not used as the primary success metric.
- Threshold discussion includes false-positive and false-negative cost.
- The user can explain PR-AUC and why ROC-AUC can mislead under extreme imbalance.

## Staff Review Questions

- Which features would be available during real-time authorization?
- What is your definition of a false positive in issuer decisioning terms?
- What is your definition of a false negative in loss terms?
- How would you monitor this model if fraud patterns shift next month?
- What would break first if this moved from batch scoring to online scoring?
- Which part of your pipeline is most likely to leak future information?

## Stop Conditions

Do not move to XGBoost, LightGBM, Redis feature serving, or FastAPI scoring until
the user can defend the baseline evaluation.

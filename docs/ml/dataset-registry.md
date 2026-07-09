# Dataset Registry

Document every dataset before using it. Do not commit downloaded datasets.

## Template

```text
Dataset:
Source URL:
License / terms:
Downloaded by:
Downloaded on:
Local path:
Committed to repo: no
Contains real cardholder data: no
Synthetic or anonymized fields:
Target label:
Known leakage risks:
Known bias / representativeness risks:
Intended milestone:
```

## Approved Starting Candidates

### ULB Credit Card Fraud Detection

Purpose: first classical ML exercise for extreme class imbalance.

Expected use:

- EDA.
- Train/validation/test split discipline.
- Baseline classifier.
- Precision, recall, PR-AUC, confusion matrix, and threshold analysis.
- Business-cost framing for false positives and false negatives.

Do before modeling:

- Record the source URL and terms.
- Record the local path.
- Confirm the data remains outside git.

### IEEE-CIS Fraud Detection

Purpose: larger feature-engineering and leakage-risk exercise after the ULB
baseline is understood.

Do before modeling:

- Record the competition/data source URL and terms.
- Record the local path.
- Identify which fields are unavailable at real-time authorization decision time.

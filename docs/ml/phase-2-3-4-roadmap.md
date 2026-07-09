# ML/AI Roadmap After The Classical Baseline

This document keeps the later ML/AI work visible without pulling the user into
implementation before the foundations are ready.

## Phase 2: Deep Learning And NLP

User-owned implementation:

- PyTorch sequence model over per-card transaction histories.
- Text classifier for dispute or chargeback reason codes.
- Free GPU workflow in Colab or Kaggle.
- Quantization or distillation experiment.
- Latency comparison against the classical model.

Review focus:

- Whether sequence modeling adds signal beyond tree models.
- Train/validation leakage across card histories.
- Tokenization choices.
- Accuracy versus latency on constrained hardware.

## Phase 3: GenAI And RAG

User-owned implementation:

- Corpus ingestion from approved public guidance.
- Chunking strategy.
- Embeddings and vector store integration.
- Retrieval evaluation set.
- Recall@k and MRR measurement.
- Guardrails and refusals.
- Tool calling into PayGuard APIs.

Review focus:

- Retrieval quality before answer polish.
- Citation quality.
- Faithfulness and refusal behavior.
- Sensitive-data boundaries.

## Phase 4: MLOps

User-owned implementation:

- MLflow experiment tracking and model registry usage.
- Holdout gates in CI.
- Model promotion and rollback.
- Drift checks.
- Canary routing.

Review focus:

- Whether the promotion gate would block a bad model.
- How rollback works under live traffic.
- What drift signals trigger human action.

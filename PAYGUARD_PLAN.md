# PayGuard Plan

PayGuard is a payments fraud and dispute intelligence platform built as a staff-level learning project. The point is not only to make the system run, but to make every design choice defensible in an architecture review.

## Background To Use, Not Re-Teach

The user already has strong production experience with Java, Spring Boot, REST microservices, concurrency, idempotency, Kafka, Redis, Docker, Kubernetes, Jenkins CI/CD, React, PostgreSQL, AWS, JUnit/Mockito/TDD, and OIDC auth with Entra ID and MSAL.

The user also has working Python experience from a multi-agent code-review system and Amazon Bedrock usage, but has not yet built ML engineering depth.

## Target Competency Gaps

1. ML fundamentals: EDA, preprocessing, feature engineering, scikit-learn, gradient-boosted trees, extreme class imbalance, precision/recall, PR-AUC, cost-sensitive thresholds, and larger datasets.
2. Deep learning and NLP: PyTorch training loops, neural net architectures, tokenization, embeddings, sequence models, transformers, fine-tuning, transfer learning, quantization, distillation, and robustness.
3. GenAI systems: RAG architecture, chunking, embedding models, vector stores, retrieval evaluation, conversational memory, guardrails, tool calling, and Python AI services integrated into Java microservice estates.
4. MLOps: experiment tracking, model registry/versioning, model deployment CI/CD, online vs batch serving, and drift monitoring.
5. Security depth: OAuth2 flows, PKCE, client credentials, mTLS, certificate management, PKI, hashing, symmetric/asymmetric cryptography, key management, PAN tokenization, SSDLC, and threat modeling.
6. Payments domain: authorization, clearing, settlement, chargebacks, disputes, ISO 8583 concepts, and PCI DSS basics woven into implementation instead of taught as standalone theory.

## Hard Constraints

- Local development happens on a Mac with Docker available.
- OCI is the permanent, always-on home of PayGuard and must stay `$0`.
- OCI provisioning must stay inside current Always Free limits verified from official docs or CLI evidence before each provisioning step.
- Design for a small Always Free ARM host: cap JVM heaps, stage services, and use lightweight single-node infrastructure.
- Azure is not active yet. It must remain inactive until the Azure sprint entry checklist passes.
- Azure usage is limited to the available promotional credit window after signup and must be tracked in `BUDGET.md`.
- All cloud infrastructure must be scripted and paired with teardown scripts committed to the repo.
- Free GPU fallbacks, such as Colab or Kaggle, are preferred for training outside the Azure sprint.

## Phase 0: Skeleton On OCI

Goal: establish the zero-cost deployment base and the known-stack transaction spine.

Build:

- OCI Always Free infrastructure script and teardown script.
- Docker Compose for local Postgres, Redis, and Kafka or a lighter compatible broker if memory requires it.
- Java Spring Boot transaction simulator publishing realistic card-transaction events modeled loosely on ISO 8583 authorization fields.
- Basic persistence and operational health checks.
- First payments crash-course notes covering authorization, clearing, settlement, and chargeback flow between issuer, network, and acquirer.

Staff bar:

- Explain why the chosen broker/runtime shape fits a tiny always-on host.
- Explain which parts are online authorization analogs and which parts are later clearing/settlement analogs.
- Show the zero-cost evidence before any OCI resource is created.

## Phase 1: Classical ML Fraud Scoring

Goal: build a Python fraud-scoring service and learn evaluation under extreme class imbalance.

Build:

- FastAPI fraud-scoring service.
- Baseline workflow using the ULB credit-card fraud dataset.
- EDA and feature engineering workflow on the IEEE-CIS dataset.
- scikit-learn baselines, then XGBoost or LightGBM.
- Redis-backed online feature store.
- Java service synchronous call to the scorer with an explicit latency budget.
- MLflow experiment tracking from the start.

Staff bar:

- Defend threshold selection using business cost, not accuracy.
- Compare PR-AUC, recall, precision, and false-positive cost.
- Explain online feature freshness and leakage risks.

## Phase 2: Deep Learning And NLP

Goal: build sequence and text models tied to transaction and dispute flows.

Build:

- PyTorch sequence model over per-card transaction histories.
- Dispute or chargeback reason-code classifier using transformer fine-tuning.
- Free GPU training workflow with reproducible notebooks or scripts.
- Quantization and distillation experiments.
- Latency and accuracy comparison on the OCI ARM box.

Staff bar:

- Explain when deep learning beats tree models here and when it does not.
- Defend tokenization, sequence length, and evaluation choices.
- Show accuracy-vs-latency tradeoffs under constrained hardware.

## Phase 3: GenAI And RAG

Goal: build a dispute assistant that answers from public card-network and chargeback guidance corpora with measured retrieval quality.

Build:

- Corpus ingestion for public operating-rules PDFs and chargeback guidance.
- pgvector on the existing Postgres, sized for the project constraints.
- Hand-built retrieval evaluation set before tuning.
- Chunking and hybrid-retrieval experiments measured with recall@k and MRR.
- Faithfulness checks with a RAG evaluation framework.
- Conversation memory, guardrails, and tool calls into Java APIs.
- Provider abstraction around LLM calls.

Staff bar:

- No vibes-based retrieval iteration.
- Explain chunking and embedding choices.
- Demonstrate what the assistant refuses to answer and why.

## Phase 4: Self-Hosted MLOps

Goal: make model changes observable, gated, and reversible at `$0`.

Build:

- MLflow model registry with stage promotion.
- CI pipeline that retrains, evaluates against a holdout gate, and deploys only on improvement.
- Drift monitoring using Evidently or an equivalent lightweight setup.
- Prometheus and Grafana dashboards.
- Canary rollout of a new model version behind the Java service with rollback.

Staff bar:

- Explain rollback and promotion semantics.
- Show why the holdout gate blocks a bad model.
- Tie drift signals to operational response.

## Phase 5: Azure Sprint

Goal: temporarily use Azure to practice enterprise cloud security and deployment patterns, then move surviving patterns back to OCI.

Entry checklist:

- Local manifests or Helm charts are written and tested on kind or minikube.
- Spending plan is agreed and recorded in `BUDGET.md`.
- Budget alerts and spending controls are ready.
- Teardown scripts are written and tested where possible.
- Required quotas are checked before relying on them.

Build:

- Redeploy PayGuard with Helm.
- Add HPA, network policies, and secrets via Key Vault CSI where appropriate.
- Practice Key Vault certificate management, mTLS, certificate rotation, OAuth2 client credentials, PAN tokenization, and field-level encryption.
- Optionally rerun fine-tuning with a paid GPU only if the budget and quota checks justify it.
- Optionally evaluate managed search or managed LLM services only if quota and budget allow.

Exit:

- Teardown before the budget window closes.
- Move reusable manifests, security patterns, and lessons back to OCI/local.
- Update `BUDGET.md` with final spend.

## Phase 6: Staff Synthesis

Goal: turn the built system into defensible staff-level interview material.

Build:

- Full design document.
- Hostile mock architecture review covering failure modes, scale, cost, observability, and STRIDE threat modeling.
- Artifact map tying each target competency to concrete repo evidence.

Staff bar:

- Explain 10x scale pressure points.
- Explain security posture and residual risk.
- Explain what would be cut, deferred, or bought in a real company.

## Default Repo Structure

Start with this shape and refine only when implementation pressure justifies it:

```text
apps/
  transaction-simulator/   # Java Spring Boot event producer and transaction API
  fraud-scorer/            # Python FastAPI online scoring service
  dispute-assistant/       # RAG and tool-calling service
infra/
  docker/                  # local compose and service config
  oci/                     # Always Free scripts plus teardown
  azure/                   # sprint-only scripts plus teardown
ml/
  experiments/             # reproducible training and evaluation code
  notebooks/               # sanitized exploratory notebooks
docs/
  payments/                # domain notes and diagrams
  architecture/            # design docs and review prep
  security/                # threat models and crypto notes
scripts/                   # local automation
```

## Rules Of Engagement

- Teach by building.
- Every milestone includes a concise concept intro, implementation by the user, staff-level review, and a quiz on tradeoffs and failure modes.
- Do not advance just because code runs.
- Payments flavor belongs in every phase.
- `PROGRESS.md` tracks phase, milestone, decisions, open review comments, and next action.
- `BUDGET.md` tracks OCI `$0` evidence and Azure spend.
- Verify external resources, limits, and prices before depending on them.

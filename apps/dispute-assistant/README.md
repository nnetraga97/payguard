# Dispute Assistant Service

This directory will become the GenAI/RAG service for dispute and chargeback
support workflows.

Current status: contract only. The user should implement retrieval, generation,
memory, guardrails, and tool calling during Phase 3.

## Planned Responsibility

The dispute assistant is the analyst-assist analog for PayGuard. It should answer
from approved public guidance, cite retrieved evidence, refuse unsupported claims,
and call PayGuard APIs when a workflow needs live transaction context.

## Planned Capabilities

- Corpus ingestion for public dispute and chargeback guidance.
- Retrieval evaluation before tuning.
- Chunking experiments measured with recall@k and MRR.
- Provider abstraction around LLM calls.
- Guardrails for unsupported, sensitive, or out-of-scope answers.
- Tool calls into Java APIs for live transaction lookup and dispute workflows.

## Mentor Rule

Codex may help define evaluation rubrics and review implementations, but the RAG
pipeline, prompt design, tool calling, and guardrail logic should be written by
the user.

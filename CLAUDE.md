# Associative Memory Architecture

A novel memory architecture for AI agents where the memory structure IS the interpretable world model.

## Core Thesis

The memory structure IS the interpretable world model, and it replaces the role that pretrained weights currently play in forming beliefs and understanding.

## Key Principles

- **Navigation, not retrieval** — agents traverse their experiential graph, not search a database
- **LLM as engine, graph as mind** — the LLM reasons; the graph knows
- **Anti-hallucination by design** — if the path doesn't exist, the answer is "I don't know"
- **Interpretable** — you can read why the agent believes what it believes by tracing the graph
- **Associations form through co-occurrence** — neurons that fire together wire together

## Project Structure

```
vision.md          — Core thesis, philosophy, what makes this different
research/audit.md  — Comprehensive research audit (50+ systems, March 2026)
design/            — Architecture and mechanism specifications
src/               — Implementation (when ready)
```

## Status

Concept + research phase. Design docs being drafted. No code yet.

## Related

- ~/the-companion/ — The Companion project (may adopt this as its memory architecture)
- Memory file: ~/.claude/projects/-Users-wisdomhappy/memory/project_associative_memory_architecture.md

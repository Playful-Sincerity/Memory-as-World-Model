# Associative Memory Architecture

A novel memory architecture for AI agents where the memory structure IS the interpretable world model.

## Core Thesis

The memory structure IS the interpretable world model, and it replaces the role that pretrained weights currently play in forming beliefs and understanding.

## Key Principles

- **Navigation, not retrieval** — agents traverse their experiential graph, not search a database
- **LLM as engine, graph as mind** — the LLM reasons; the graph knows
- **Epistemic humility + curiosity** — when the path doesn't exist, the agent is curious, not silent
- **Interpretable** — you can read why the agent believes what it believes by tracing the graph
- **Associations form through co-occurrence** — neurons that fire together wire together

## Project Structure

```
vision.md                    — Core thesis, philosophy, what makes this different
research/audit.md            — Comprehensive research audit (50+ systems, March 2026)
research/targeted-research-round2.md — Deep answers to 5 core design questions
design/architecture.md       — Three Planes (Matrix/Trees/Mirror) + mechanism layers
design/data-model.md         — Node/edge/consciousness dataclasses + SQLite schema
design/traversal.md          — Spreading activation algorithm + Hebbian strengthening
design/pruning.md            — Distance-from-focus eviction, branch detachment, compression
design/consolidation.md      — Episodic→semantic promotion, merging, connection discovery
design/value-system.md       — Care, confidence, priority as unified motivational layer
design/open-questions.md     — Unresolved design challenges (actively explored)
design/world-integration.md  — Perception, action, and skill learning (THE next design challenge)
design/improvements-from-round4.md — Research-driven corrections and additions
research/round3-full-system-audit.md — 10-property novelty audit, 30+ systems (Three Planes era)
research/round4-synthesis.md — 12-agent deep research: foundations, neuro, philosophy, AGI, feasibility
research/round4-agents/      — Full agent reports (12 streams, 100+ sources)
journal/                     — Evolution tracking (origins, timeline, deep entries)
src/                         — Implementation (when ready)
```

## Evolution Tracking Rules

**Every session working on this project must:**
1. Update `journal/timeline.md` if a design decision was made, research changed direction, or thinking shifted
2. Write a full `journal/entries/YYYY-MM-DD-title.md` entry if an insight or pivot occurred
3. Update relevant `design/` docs when architecture changes
4. Update `design/open-questions.md` — add new questions, mark resolved ones
5. Update the memory file if the core thesis or status changes

**Why:** This project's value is as much in the thinking evolution as in the final artifact. The journey from "better retrieval" to "cognitive substrate" to "interpretable world model" is itself a contribution. Track it.

## Status

Concept + research phase. Design docs drafted. No code yet.

## Related

- ~/Playful Sincerity/PS Software/The Companion/ — The Companion project (may adopt this as its memory architecture)
- ~/claude-system/journal/ — Broader meta-system journal (cross-reference major milestones there too)
- Memory file: ~/.claude/projects/-Users-wisdomhappy/memory/project_associative_memory_architecture.md

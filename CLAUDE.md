# Memory as World Model (MWM)

A memory architecture for AI agents where the memory structure IS the interpretable world model.

MWM is a standalone project; it is also the memory subsystem of [The Synthetic Sentiences Project](https://github.com/Playful-Sincerity/SSP-Synthetic-Sentiences-Project), the broader research program it sits within.

## Core Thesis

The memory structure IS the interpretable world model, and it replaces the role that pretrained weights currently play in forming beliefs and understanding. The LLM becomes a traversal and reading engine, not a knowledge store; reasoning flows through an explicit graph rather than through opaque weights.

## Key Principles

- **Navigation, not retrieval** — agents traverse their experiential graph, not search a database
- **LLM as engine, graph as mind** — the LLM reasons at local neighborhoods; the graph carries the belief structure
- **Epistemic humility + curiosity** — when the path doesn't exist, the agent is curious, not silent
- **Interpretable by design** — you can read why the agent believes what it believes by tracing the graph
- **Anti-hallucination by design** — claims must trace back to experiential nodes
- **Action-serving** — the graph exists to support aligned action, not just retrieval

## Project Structure

```
vision.md                    — Core thesis, philosophy, what makes this different
research/audit.md            — Comprehensive research audit (50+ systems, March 2026)
research/targeted-research-round2.md — Deep answers to 5 core design questions
research/round3-full-system-audit.md — 10-property novelty audit, 30+ systems (Three Planes era)
research/round4-synthesis.md — 12-agent deep research: foundations, neuro, philosophy, AGI, feasibility
research/round4-agents/      — Full agent reports (12 streams, 100+ sources)
research/round5-synthesis.md — Further sharpening
research/round6-synthesis.md — Most recent
design/architecture.md       — Three Planes (Matrix/Trees/Mirror) + mechanism layers
design/data-model.md         — Node/edge/consciousness dataclasses + SQLite schema
design/traversal.md          — Spreading activation algorithm + Hebbian strengthening
design/pruning.md            — Distance-from-focus eviction, branch detachment, compression
design/consolidation.md      — Episodic → semantic promotion, merging, connection discovery
design/value-system.md       — Care, confidence, priority as unified motivational layer
design/open-questions.md     — Unresolved design challenges (actively explored)
design/world-integration.md  — Perception, action, and skill learning
research/local-cognition/    — Whether MWM can run on local LLMs (canonical; also shared with SSP)
research/compute-architecture/ — Future: hardware tuned to the graph substrate
journal/                     — Evolution tracking (origins, timeline, deep entries)
chronicle/                   — Semantic logging of sessions
src/                         — Implementation (when ready)
```

## Evolution Tracking Rules

**Every session working on this project must:**
1. Update `journal/timeline.md` if a design decision was made, research changed direction, or thinking shifted
2. Write a full `journal/entries/YYYY-MM-DD-title.md` entry if an insight or pivot occurred
3. Update relevant `design/` docs when architecture changes
4. Update `design/open-questions.md` — add new questions, mark resolved ones
5. Update the memory file (`~/.claude/projects/-Users-wisdomhappy/memory/project_mwm.md`) if the core thesis or status changes

**Why:** This project's value is as much in the thinking evolution as in the final artifact. The journey from "better retrieval" to "cognitive substrate" to "interpretable world model" is itself a contribution. Track it.

## Status

Concept + research phase. Design docs drafted. No code yet. Target: working implementation + paper.

## Active Research: Local Cognition

**Can the MWM graph enable a functional cognitive agent using only local LLMs (no API calls)?**

If the graph IS the intelligence, a small local model (14B) only needs to traverse — read neighborhoods, make structured decisions, write nodes/edges. Tool calls handle math and logic. See [research/local-cognition/](research/local-cognition/).

## Future Research: Compute Architecture

**What hardware and software architectures would be optimized specifically for the MWM graph?**

Two-system design: (a) a memory engine LLM optimized for reading/writing/exploring the graph with minimal pretrained bias, (b) a logic/reasoning engine for thinking and proposing, plus a pure math engine. Both systems' weights serve to read the memories, not store knowledge. See [research/compute-architecture/notes.md](research/compute-architecture/notes.md). Depends on the core architecture being more mature first.

## Relationship to The Synthetic Sentiences Project

MWM is one of nine subsystems in SSP. The others (earned conviction, value-aligned modulation, mirror architecture, imagination-first perception, epistemic prosody, sleep/dream cycles, action, trees) build on, modulate, or consume MWM's graph. MWM is the substrate; SSP shows how that substrate supports a full sentience.

The focused scope of this repo is MWM specifically — the memory subsystem — as a bounded research target. The broader Synthetic Sentiences Project is the context in which that work sits.

See [SSP's CLAUDE.md](https://github.com/Playful-Sincerity/SSP-Synthetic-Sentiences-Project/blob/main/CLAUDE.md) for the umbrella thesis and the other subsystems.

## Related

- [Synthetic Sentiences Project (sibling repo)](https://github.com/Playful-Sincerity/SSP-Synthetic-Sentiences-Project)
- `~/Playful Sincerity/PS Research/Synthetic Sentiences Project/` — local SSP path
- `~/Playful Sincerity/PS Research/Synthetic Sentiences Project/archive/companion-legacy/` — architectural ideas from the predecessor project (now archived) whose thinking seeded value-aligned modulation, mirror architecture, and earned conviction
- `~/claude-system/chronicle/` — ecosystem-level semantic log
- Memory file: `~/.claude/projects/-Users-wisdomhappy/memory/project_mwm.md` (renamed from project_associative_memory_architecture.md 2026-04-24)

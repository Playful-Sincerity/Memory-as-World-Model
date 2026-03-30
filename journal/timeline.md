# Timeline — Chronological Evolution

## ~Dec 2025 – Mar 2026 — Incubation period
**Context:** Wisdom had been thinking about optimal AI memory structures for 3-4 months. Existing approaches (RAG, knowledge graphs, flat retrieval) didn't feel right — they treated memory as a database, not as the structure a mind works through. The Companion project gave this thinking a concrete home.

## 2026-03-29 — Crystallization
**Trigger:** Conversation about The Companion's memory architecture
**What happened:** Months of thinking found its form. Wisdom articulated the vision: context grows like a tree through associative links from the agent's current consciousness. Not retrieval — navigation. The ideas had been developing; this was the moment they came together clearly.
**Key insight:** This isn't a memory system — it's a cognitive substrate. The memory graph IS the world model.
**Outcome:** Core thesis crystallized. Project separated from The Companion as its own initiative.

## 2026-03-29 — Anti-hallucination architecture
**Trigger:** Wisdom's observation about LLM interpretability
**What happened:** Realized that if the LLM only answers from the memory graph (never from pretrained weights), hallucination is eliminated by design. No path = "I don't know."
**Key insight:** Epistemic humility as architecture, not guardrails.
**Outcome:** This became a core design principle, not a nice-to-have.

## 2026-03-29 — Research audit completed
**Trigger:** Need to validate novelty and find building blocks
**What happened:** 50+ systems surveyed across 6 dimensions. No production system combines all proposed properties. SYNAPSE closest but paper-only.
**Key insight:** The gap is confirmed and the theoretical foundations are strong (ACT-R, spreading activation, GWT, CLS, hippocampal indexing).
**Outcome:** Five-layer architecture blueprint. 30 key papers identified. Implementation paths mapped.

## 2026-03-29 — Project structure created
**Trigger:** Need to formalize and preserve the evolving design
**What happened:** Created ~/associative-memory/ with vision, research, design docs, and journal system.
**Outcome:** 9 files committed. Vision, architecture, data model, traversal, pruning, consolidation, open questions all documented.

## 2026-03-29 — Deep design review + new dimensions identified
**Trigger:** Fresh-eyes review of all design docs, probing for gaps
**What happened:** Systematic review identified 9 unresolved design challenges. Three are load-bearing: memory encoding (what becomes a node?), LLM interface (how does the LLM think through the graph?), anti-hallucination enforcement (architectural vs instructional). Wisdom introduced three new conceptual dimensions:
1. **Values/care as traversal modulator** — how much the agent cares determines traversal depth/budget. Elegantly solves the scale problem.
2. **Confidence as dual signal** — comprehension ("do I understand?") vs completeness ("have I found everything?") as separate gates.
3. **Memory priority as living valuation** — not static importance, but ongoing reassessment of "how much will I need this?" that changes with current context.
**Key insight:** Care, confidence, and priority form an interconnected value system that modulates the entire architecture — not just traversal, but encoding, pruning, and consolidation too.
**Outcome:** Open questions doc significantly expanded. These value dimensions may be as foundational as the association model itself.

## 2026-03-29 — Targeted research round 2 (5 agents)
**Trigger:** Open design questions needed specific mechanism answers, not broad landscape survey
**What happened:** 5 targeted agents researched: experiential distance metrics, anti-hallucination architectures, consciousness pointer mechanisms, embedding drift/graph evolution, and interpretable world models/belief graphs. 15 new systems discovered beyond initial audit.
**Key findings:**
1. **Hebbian learning = PMI** (mathematically proven via BCPNN). The edge weight formula: PMI × salience × temporal proximity × decay.
2. **PPR = spreading activation** (proven equivalent). The consciousness pointer IS a PPR seed node.
3. **Memory reconsolidation** — every retrieval is a write. "Largely uninvestigated" in AI (2025 survey). Novel territory.
4. **Anti-hallucination ceiling** — best grounding achieves ~86% compliance (FACTS benchmark). GCR/KG-Trie achieves 100% for structured KG paths. Free-form synthesis remains irreducible leakage point. Smaller models = less leakage.
5. **AbstentionBench** — abstention does NOT improve with scale. Reasoning training makes it 24% WORSE. Structural enforcement needed, not just training.
6. **DAMCS validates spawnable minds** — decentralized agents with individual KGs: 74% fewer steps in cooperative planning.
**Outcome:** All 5 open design questions answered with concrete mechanisms. Synthesis saved to research/targeted-research-round2.md.

## 2026-03-29 — Novelty assessment
**Trigger:** After 65+ systems surveyed, asked "is this still novel?"
**What happened:** Honest analysis separating mechanism novelty (low — individual pieces exist) from thesis novelty (high — the framing and purpose are unique).
**Key insight:** The novelty is NOT in spreading activation, PMI, PPR, or graph pruning — these are established. The novelty is in 6 things no existing system combines:
1. **Graph replaces pretrained weights** as source of beliefs (not supplements — replaces)
2. **Navigation, not retrieval** — agent has a position and moves, vs querying
3. **Experiential distance** as primary metric (PMI from agent's co-occurrence, not cosine from pretrained embeddings)
4. **Anti-hallucination as architecture** (structural impossibility, not guardrails)
5. **Memory reconsolidation** (every retrieval modifies the memory — uninvestigated in AI)
6. **Spawnable minds with diffable worldviews** (readable, comparable graph-minds)
**Key conclusion:** "The novelty is in the architecture's purpose and epistemology, not in any individual mechanism. Which is the stronger kind of novelty."
**Outcome:** Novelty analysis preserved in journal entry. Core thesis remains differentiated.

## 2026-03-29 — "Matrix / Trees / Mirror" reframing
**Trigger:** Wisdom clarified that the agent isn't a cursor moving through a graph — the agent IS the whole system. The "consciousness pointer" metaphor was wrong.
**What happened:** Three-plane architecture emerged:
1. **The Matrix** — the full experiential graph. Mostly dark. Updated by consolidation and Hebbian strengthening.
2. **The Trees** — currently-rendered subsets growing within the matrix during conversation. THE TREE IS THE CONTEXT. Branches form through association traversal, prune when they lose relevance. Multiple trees can grow in parallel.
3. **The Mirror** — meta-cognitive plane. Same graph substrate applied to itself. Memories about how the agent thinks. Can observe active trees AND spawn new ones from different roots.
**Key insights:**
- The agent isn't positioned within the matrix. The agent IS the system. Trees are active cognition.
- The mirror is self-perception without a special module — just more memories about the process rather than content.
- Parallel trees: the meta layer can spawn exploration from different roots. Trees that discover overlapping branches create new matrix edges (emergent connections).
- Care/confidence/priority aren't computed by formulas — they're *felt* through the meta layer's experiential associations with values, past traversals, and future needs.
**Outcome:** architecture.md rewritten from "six-layer stack" to "three-plane model with mechanism layers within." The consciousness pointer concept retired in favor of trees growing within a matrix.

## 2026-03-29 — Design doc reconciliation
**Trigger:** architecture.md had evolved ahead of all other design docs. traversal.md, pruning.md, data-model.md, and consolidation.md still described the old single-focus model.
**What happened:** Full rewrite of four design docs to align with Three Planes:
1. **data-model.md** — Added `meta` node type, replaced `ConsciousnessState` with `Tree`/`TreeManager`, added trees table to SQLite, documented why meta nodes aren't special and why trees are ephemeral.
2. **traversal.md** — Reframed from "spread from focus" to "tree grows branches." Added care-budgeted depth, reconsolidation (every traversal is a write), parallel tree spawning, competing edge decay.
3. **pruning.md** — Reframed from "distance from focus" to "distance from tree tips." Added phantom traces, multi-tree budget sharing/rebalancing, priority-modulated eviction, graduated pressure zones across all trees.
4. **consolidation.md** — Added mirror memory creation, cross-tree learning (near-misses and overlaps), priority-driven consolidation depth, distinction between tree-pruning (reversible) and matrix-pruning (archival).
5. **open-questions.md** — Marked consciousness pointer questions as resolved by the Three Planes model.
**Outcome:** All design docs now consistent with architecture.md as source of truth.

## 2026-03-29 — Round 3 full system audit (5 agents, 30+ systems)
**Trigger:** Architecture evolved significantly (three planes, value system, parallel trees, meta-cognitive mirror). Need to revalidate novelty and gather design-useful patterns for the complete system.
**What happened:** 5 agents researched: tree-as-context, meta-cognitive same-substrate, parallel cognitive streams, value-modulated cognition, and full 10-property integration audit across 30+ systems.
**Key findings:**
1. **Maximum properties any system implements: ~5.5 (ACT-R, pre-LLM). Best modern: ~4 (Hindsight). This architecture targets 10.**
2. **Zero implementations found for:** PMI as navigation metric (C), spawnable minds (G), parallel growing trees (I), strict anti-hallucination architecture (D)
3. **The 2025 Common Model of Cognition** (Laird/Lebiere/Rosenbloom/Stocco) explicitly calls for same-substrate metacognition — theoretical backing from the field's senior architects
4. **NARS** is closest to the Mirror layer (same substrate for self and world). **CLARION** is closest to the value system (motivational subsystem modulates all others). **Mnemos** is closest to reconsolidation (retrieval flags chunks as labile).
5. **Dual-axis confidence (comprehension x completeness)** — nowhere in literature
6. **Tree-as-context** — sits in precise gap between MemTree (grows right, flattens for LLM) and ReMindRAG (subgraph IS context, but linear)
7. **Context budget sharing across parallel trees** — entirely unstudied research problem
8. **VERSES Active Inference / RGM** — deepest theoretical match: "only active pathways require belief updating"
**Key conclusion:** The architecture is novel not in mechanisms but in integration and framing. 7 specific features have zero implementations. The three-plane model (Matrix/Trees/Mirror) has no precedent. The combination of even 5 of the 10 properties has never been attempted.
**Outcome:** Full audit saved to research/round3-full-system-audit.md. 12 systems identified for design study.

# Full System Novelty Audit — Round 3
## The Complete Architecture (Matrix/Trees/Mirror + Value System)
### March 29, 2026

5 targeted agents. 30+ systems evaluated. The question: is the evolved architecture — three planes, value-modulated cognition, parallel trees, meta-cognitive same-substrate — still novel?

---

## The 10 Properties Evaluated

| Code | Property |
|------|----------|
| A | Graph replaces pretrained weights as source of beliefs |
| B | Navigation not retrieval (growing trees through associations) |
| C | Experiential distance (PMI from co-occurrence, not cosine) |
| D | Anti-hallucination by architecture (no path = "I don't know") |
| E | Memory reconsolidation (every retrieval is a write) |
| F | Value-modulated cognition (care/confidence/priority as architectural modulators) |
| G | Spawnable minds with diffable worldviews |
| H | Meta-cognitive self-perception in same substrate |
| I | Parallel exploration trees sharing context budget |
| J | Interpretable by design (trace belief to experiential origin) |

---

## The Scoreboard

| System | Era | A | B | C | D | E | F | G | H | I | J | Score |
|--------|-----|---|---|---|---|---|---|---|---|---|---|-------|
| **ACT-R** | Pre-LLM | Y | Y | P | P | Y | P | - | - | - | Y | ~5.5 |
| **OpenCog Hyperon** | Pre-LLM | Y | P | - | - | - | P | P | Y | - | Y | ~4.5 |
| **Hindsight** | 2025 | - | P | P | P | P | P | - | - | P | Y | ~4 |
| **SOAR** | Pre-LLM | Y | P | - | P | P | - | - | P | - | Y | ~4 |
| **CLARION** | Pre-LLM | Y | - | - | - | - | Y | - | Y | - | P | ~3.5 |
| **NARS** | Pre-LLM | Y | P | - | - | - | - | - | Y | - | P | ~3.5 |
| **Sigma** | Pre-LLM | Y | P | - | - | - | P | - | P | - | P | ~3 |
| **LIDA** | Pre-LLM | Y | P | - | - | - | P | - | P | - | P | ~3 |
| **Mnemos** | 2025 | - | Y | - | - | Y | P | - | - | - | - | ~2.5 |
| **SYNAPSE** | 2026 | - | Y | P | P | - | - | - | - | - | P | ~2.5 |
| **MAGMA** | 2026 | - | P | - | - | - | P | - | - | P | P | ~2 |
| **Graphiti/Zep** | 2025 | - | P | - | - | P | - | - | - | - | Y | ~2 |
| **This architecture** | 2026 | **Y** | **Y** | **Y** | **Y** | **Y** | **Y** | **Y** | **Y** | **Y** | **Y** | **10** |

Y = full, P = partial, - = absent

**Maximum any existing system achieves: ~5.5 (ACT-R, pre-LLM).**
**Maximum any modern LLM-era system achieves: ~4 (Hindsight).**
**This architecture targets: 10.**

---

## Properties with ZERO Full Implementations Anywhere

| Property | Closest System | Gap |
|----------|---------------|-----|
| **C: Experiential distance (PMI)** | ACT-R (co-occurrence strengths) | Nobody uses PMI as primary navigation metric |
| **D: Anti-hallucination by architecture** | SYNAPSE ("Feeling of Knowing" gate) | No strict architectural guarantee in LLM era |
| **G: Spawnable minds** | OpenCog (substrate exists) | Feature never built on any substrate |
| **I: Parallel exploration trees** | MAGMA (parallel beam search) | No growing trees sharing budget |

---

## Per-Concept Findings

### 1. Tree-as-Context (Property B, evolved form)

**Gap confirmed.** No system connects:
- MemTree's growth mechanism (tree branches through associations)
- ReMindRAG's subgraph-as-working-context (accumulated traversal IS context)
- MRAgent's prune-during-exploration
- Graphiti's cross-turn persistence
- VERSES RGM's "only render the active portion"

**Design-useful systems:**
- **MemTree** (Oct 2024) — tree grows exactly right but flattens before LLM sees it
- **ReMindRAG** (Oct 2025) — accumulated subgraph IS working context, edge memory persists
- **MRAgent** — "Memory is Reconstructed, Not Retrieved." Rejects static retrieve-then-reason
- **VERSES Active Inference / RGM** — deepest theoretical match: "only active pathways require belief updating"

### 2. Meta-Cognitive Same-Substrate (Property H)

**Gap confirmed.** The 2025 Common Model of Cognition proposal (Laird, Lebiere, Rosenbloom, Stocco) explicitly argues for this principle:

> "Cognition and metacognition differ only in what is the subject of reasoning."
> "There are no structural boundaries between base-level reasoning and metareasoning."

**Closest systems:**
- **NARS** — same substrate for self and world knowledge, SELF as concept-memory term. But truth-value-based, not Hebbian.
- **OpenCog Hyperon** — MeTTa is fully reflexive, designed for substrate homogeneity. But still in alpha.
- **CLARION** — meta-cognitive subsystem uses same dual-level (implicit/explicit) architecture. Strongest implemented version.
- **ACT-R** — same declarative memory for meta-knowledge and world-knowledge.

**Nobody implements:** meta-layer as active coordinator that spawns exploration trees from self-observation. This is genuinely novel.

### 3. Parallel Exploration Trees (Property I)

**Gap confirmed.** No system satisfies: single agent + shared memory + parallel growing trees + shared context budget.

**Closest structural matches:**
- **LIDA/GWT** — parallel codelets sharing a workspace, but workspace enforces serialization bottleneck
- **Blackboard architectures** — shared workspace + parallel exploration, but fundamentally multi-agent
- **SOAR** — single agent + shared working memory, but substates are a strict stack (sequential)
- **MAGMA** — multi-graph views over shared data, but sequential traversal

**Design-useful:** LIDA without the bottleneck = your architecture. Context budget sharing across parallel streams is entirely unstudied — a research gap yours to define.

### 4. Value-Modulated Cognition (Property F)

**Gap confirmed for the unified triad.** Individual dimensions partially exist:

| Dimension | Closest Implementation |
|-----------|----------------------|
| **Care (budget-setting)** | Sigma: emotion modulates retrieval abstraction level. SelfBudgeter: learned token budget per difficulty. |
| **Confidence (comprehension)** | EEGNNs: per-node confidence-based halting on graphs. |
| **Confidence (completeness)** | IGT/Betti-number curiosity: measures topological holes in explored subgraph. |
| **Priority (context-dependent)** | FadeMem: importance recomputed relative to current context. |
| **Unified as architecture** | MAMID: emotion parameterizes processing speed/capacity/bias. CLARION: motivational subsystem modulates all others. |

**Nobody implements:** dual-axis confidence (comprehension x completeness). The separation does not appear anywhere in the literature.

**Nobody implements:** care as experientially grounded (felt through meta-layer associations with values) rather than computed from a formula.

### 5. Full Integration

**The combination A + B + C + D + E has never been attempted.**

No modern system exceeds ~4 effective properties. The three-plane architecture (Matrix/Trees/Mirror) has no precedent. The closest partial matches:
- ACT-R: Matrix + partial Trees (4 full properties, but pre-LLM, not scalable)
- CLARION: has Mirror (H) + Value system (F) + Graph-as-beliefs (A), but no navigation, no reconsolidation
- OpenCog Hyperon: has Mirror (H) + Graph-as-beliefs (A) + Interpretable (J), designed for many more, but still in alpha

---

## New Systems Worth Studying

| System | Why It Matters |
|--------|---------------|
| **Mnemos** | Only system with genuine reconsolidation (chunks flagged labile on retrieval, overwritten if changed) + spreading activation |
| **NARS** | Same substrate for self and world knowledge. SELF as concept-memory term. Closest to Mirror layer. |
| **CLARION** | Meta-cognitive subsystem + motivational subsystem modulating all others. Best existing value-modulated architecture. |
| **MemTree** (2024) | Tree grows exactly right (branching through associations). Skip the flattening step = tree-as-context. |
| **ReMindRAG** (2025) | Subgraph-as-working-context. Edge memory persists across queries. |
| **MRAgent** | "Memory is Reconstructed, Not Retrieved." Prune during exploration. |
| **VERSES RGM** | "Only active pathways computed." Deepest theoretical match for active rendering. |
| **EEGNNs** (2025) | Per-node confidence-based halting on graphs. Confidence gates traversal depth. |
| **IGT (Betti-number curiosity)** | Measures topological holes in knowledge graph. Completeness as algebraic topology. |
| **FadeMem** (2026) | Context-dependent importance: same memory, different priority per conversation. |
| **Kumiho** (March 2026) | Graph-native cognitive memory. Brand new — worth deep investigation. |
| **Common Model of Cognition** (2025) | Theoretical backing from Laird/Lebiere/Rosenbloom/Stocco for same-substrate metacognition. |

---

## Novelty Assessment: Final Verdict

### What is NOT novel (mechanisms)
- Spreading activation (1975)
- PMI for association strength (standard NLP)
- PPR for graph traversal (HippoRAG)
- ACT-R decay equations (40+ years)
- Episodic → semantic consolidation (CLS theory, 1995)
- Graph-based agent memory (many systems)
- Active context pruning (many systems)

### What IS novel (architecture + framing)

**Confirmed novel by this audit (zero implementations found):**
1. **Tree-as-context** — growing subgraph IS the context, not flattened for retrieval
2. **Parallel trees sharing budget** — single agent, shared graph, multiple growing fronts
3. **Meta-layer spawning exploration from self-observation** — nowhere in literature
4. **Dual-axis confidence (comprehension x completeness)** — no system separates these
5. **Care as experientially grounded** — felt through meta-layer, not formula-computed
6. **Spawnable minds with diffable worldviews** — feature never built on any substrate
7. **PMI as primary navigation metric** — nobody uses it this way

**Confirmed novel by this audit (no system combines):**
8. **The three-plane architecture (Matrix/Trees/Mirror)** — no precedent
9. **Properties A+B+C+D+E together** — never attempted
10. **All 10 properties integrated** — maximum existing is ~5.5 (ACT-R)

### The type of novelty

This is not mechanism novelty. It is **architectural novelty** (how the pieces compose) and **epistemological novelty** (what the system IS — a cognitive substrate, not a memory system). The individual pieces are known. The integration, purpose, and framing are unprecedented.

The 2025 Common Model of Cognition proposal provides theoretical support from the field's most senior architects. They're calling for the same principles. Nobody has built it yet.

---

## Design Recommendations from This Research

1. **Study CLARION** for the value system — it's the only architecture where a motivational subsystem genuinely modulates all other subsystems.

2. **Study NARS** for the Mirror layer — same substrate for self and world, same inference rules, SELF as a first-class concept.

3. **Study Mnemos** for reconsolidation — only system where retrieval actually flags memories as labile and overwrites them.

4. **Study MemTree** for tree growth — the branching mechanism is exactly right. Skip the flattening.

5. **Study EEGNNs** for confidence-gated traversal — per-node adaptive depth on a graph, halting when confidence is sufficient.

6. **Study IGT/Betti-number curiosity** for completeness detection — topological holes in the graph as a measure of "have I found everything?"

7. **Formalize the context budget sharing problem** for parallel trees — this is entirely unstudied. Define it, and you own the problem space.

8. **Use smaller, specialized LLMs** for the reasoning engine — less pretrained knowledge surface = less hallucination leakage. GCR/KG-Trie for structured paths (100% faithful).

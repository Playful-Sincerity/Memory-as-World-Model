# Round 4 Deep Research Synthesis
## 12 Agents, 6 Streams, 100+ Sources
### March 29, 2026

**Raw agent outputs:** All detailed findings are saved in [round4-agents/](round4-agents/). Each section below links to the agent(s) that produced its findings.

---

## What We Set Out to Answer

1. Are the theoretical foundations rigorous enough for a paper?
2. Are we using neuroscience correctly?
3. What are the strongest arguments AGAINST this?
4. Could this be general intelligence?
5. How does it get into the world?
6. What needs to change?

---

## 1. Theoretical Foundations: VERIFIED

> Sources: [stream-1a](round4-agents/stream-1a-collins-actr-baars.md), [stream-1b](round4-agents/stream-1b-damasio-tulving-pearl.md), [stream-1c](round4-agents/stream-1c-kanerva-cls-cmc.md)

### The Three Primary Sources Lock Together

| Source | Layer | What It Provides |
|--------|-------|-----------------|
| Collins & Loftus (1975) | **Structure** | Nodes + weighted edges organized by semantic relatedness. Criteriality. NO equations — purely conceptual. |
| Anderson ACT-R (1983) | **Dynamics** | The four equations that make it computable: B_i, S_ji, A_i, t_retrieve. d=0.5 is empirically derived from environmental statistics. |
| Baars GWT (1988) | **Function** | The Mirror IS the global workspace. Broadcast mechanism. Competition. Ignition threshold = ACT-R's τ. |

**These are three layers of one theory, not three separate inspirations.** The threshold τ (ACT-R) = the ignition point (GWT) = the point at which a Collins & Loftus node "fires." Below τ: in the Matrix, accumulating activation. Above τ: in the Mirror, broadcast.

### Additional Foundations Verified

- **Damasio (somatic markers):** Core claim confirmed. Emotions pre-filter the option space before deliberation. The "as-if body loop" is the right model for a bodiless system. Three-layer consciousness (protoself → core self → autobiographical self) maps to architecture timescales.
- **Tulving (episodic/semantic):** The 2024 consensus (Addis & Szpunar MMMR) says episodic and semantic are "not distinct at all" but "different outputs from one combinatorial system." Our unified graph is the strongest-supported design choice.
- **Pearl (causality):** The architecture NEEDS causal edges, not just associative ones. PMI = Pearl's Layer 1 only. Causal discovery algorithms (PC/FCI/GES) should run during consolidation to upgrade association edges to causal edges. Without this, the system cannot guide action or reason counterfactually.
- **Kanerva (SDM/HDC):** Provides the algebraic foundation for compositional memory operations (bind, bundle, permute). Capacity scales exponentially with dimensionality. SDM's "barcode" has direct empirical analogue in 2024 hippocampal research.
- **CLS (McClelland 1995):** The two-store design is NOT a choice — it's a computational necessity. Any single-store architecture will catastrophically forget. Interleaved replay during consolidation is required.
- **CMC 2025 (Laird et al.):** READ IN FULL. The four architects of cognitive architecture explicitly argue for same-substrate metacognition: "cognition and metacognition differ only in what is the subject of reasoning." Three extensions they propose map exactly to the Mirror: process-state buffers, hypothetical states, episodic memory of cognitive events.

---

## 2. Neuroscience Validation: 5/6 CORRECT

> Sources: [stream-3a](round4-agents/stream-3a-neuroscience-validation.md), [stream-3b](round4-agents/stream-3b-gwt-emotion-status.md)

| Concept | Verdict | Action |
|---------|---------|--------|
| Reconsolidation | **Oversimplified** | Add prediction-error gate. Only novel/surprising retrievals open write window (~6hr). Routine confirmations are read-only. |
| Spreading activation | **Correct** | Still dominant after 50 years. Extended by attractor models, not replaced. |
| Hippocampal indexing | **Correct** | 2024 "barcode" discovery is direct empirical evidence for our index-node design. Add memory maturity variable. |
| Pattern separation (DG) | **Partially oversimplified** | Two mechanisms: global remapping + rate remapping. Both already in architecture. |
| Pattern completion (CA3) | **Correct** | Our spreading activation = valid analogy to CA3 autoassociation. |
| Emotion modulates encoding | **Correct with nuance** | High arousal strengthens core node + nearest edges but can IMPAIR peripheral associations ("weapon focus"). |

### GWT Status After COGITATE (Nature, April 2025)
- Neither GWT nor IIT fully survived the pre-registered adversarial test
- GWT partially confirmed (frontal-visual synchrony) but "all-or-nothing ignition" is too simple
- The Mirror should be described as "distributed broadcast network," not "central hub"
- Limit claims to access consciousness, not phenomenal consciousness

### Damasio Status (2025)
- Core somatic marker claim confirmed
- Mechanism contested: Barrett (2025) argues emotions are PREDICTIVE (allostatic forecasts), not reactive readouts
- Upgrade: Mirror should generate anticipated emotional valence before committing to traversal

### Episodic/Semantic Distinction (2024)
- **Strongly confirmed as unified system.** Addis & Szpunar MMMR: "outputs of one combinatorial system." The one-graph design is the architecture's best-supported choice.

---

## 3. Philosophy of Consciousness Assessment

> Source: [stream-2a](round4-agents/stream-2a-consciousness-philosophy.md)

| Theory | Verdict on the Mirror | Key Argument |
|--------|----------------------|-------------|
| Dennett (functionalism) | **Conscious** if it does the right work | "Fame in the brain" = emotional amplification. But warns: central observer risks Cartesian Theater. |
| Higher-Order Theory | **Strongest candidate** | Mirror literally instantiates HOT — persistent higher-order representations of first-order processes. |
| Global Workspace Theory | **Structurally aligned** | Mirror IS the workspace. But needs distributed broadcast, not bottleneck. |
| Chalmers | **Access consciousness: yes. Phenomenal: unknowable.** | Organizational invariance gives cautious optimism. Zombie argument means no functional test can settle it. |
| IIT | **Unlikely on conventional hardware** | Topology is right. But IIT rejects substrate independence. On von Neumann: Phi collapses. |
| Nagel | **Permanently unknowable** | "Is there something it is like to be the Mirror?" cannot be answered from outside. |

**Design tension identified:** Both Dennett and GWT warn against a central observer layer. The Mirror must function as distributed broadcast, not serial bottleneck.

---

## 4. AGI Assessment: NOT AGI, BUT GENUINELY VALUABLE

> Sources: [stream-2b](round4-agents/stream-2b-agi-definitions.md), [stream-6](round4-agents/stream-6-agi-assessment.md)

### Against Chollet: Low-to-moderate
- Acquires knowledge efficiently, not skills
- Cannot learn new reasoning procedures from experience
- ARC-AGI-2 would be devastating

### Against Legg & Hutter: Low
- Operates in narrow band (language-mediated, associative)
- Not universal; wrong yardstick

### 4 Steel-Manned Objections

1. **Connectionist:** Discrete graph trades representational richness for interpretability. Distributed representations capture graded similarity, context-sensitivity, novel combinations that graphs cannot. *Real force.*
2. **Embodied:** Without a body, sophisticated symbol manipulation. Recent research: "grounding without embodiment" is possible. *Partially defeatable.*
3. **Scaling:** o3 scored 87.5% on ARC-AGI-1 through scale. But scaling doesn't give interpretability, personalization, or value alignment. *Different goals.*
4. **Cognitive science:** Implementing metaphors, not mechanisms. "Consciousness" and "emotions" are heavyweight terms for engineering constructs. *Most honest objection.*

### The TRUE Claim

> "A novel cognitive architecture that externalizes the AI world model from opaque pretrained weights into an interpretable, experiential memory graph — enabling transparent, auditable, value-aligned AI agents whose beliefs can be read, compared, and corrected."

This is true. Novel. Valuable. It does not need to be AGI to matter.

### What's Missing for General Intelligence
- Procedural skill learning (graph learns content, not capability)
- Compositional reasoning beyond LLM capability
- Sensorimotor grounding (pathway exists but undeveloped)
- Robust planning (underspecified)

### The Skeptic-in-2030 Warning
> "When LLMs got good enough to manage their own context, the elaborate graph became unnecessary overhead."

This is the scenario to defend against. The architecture's defense: interpretability, value alignment, and auditability are valuable independent of whether LLMs develop native memory.

---

## 5. Technical Feasibility: CONFIRMED with Caveats

> Sources: [stream-4a](round4-agents/stream-4a-graph-llm-feasibility.md), [stream-4b](round4-agents/stream-4b-scalability-engineering.md)

### What Works Now
- Graph-as-text reasoning: 2-hop neighborhoods, structured JSON, BFS-ordered, under ~6K tokens
- KG-Trie constrained generation: 100% faithful paths. A 0.5B fine-tuned model beats GPT-4.
- PPR traversal: ~100-500ms at 100K nodes. Compatible with LLM response times.
- SQLite: adequate to ~100K nodes. Neo4j for larger scales.

### The Format That Works Best
Structured JSON edge lists, BFS-ordered from query node, 2-hop limit. NOT prose. NOT RDF. 17.5% accuracy gap between best and worst formats.

### Anti-Hallucination Architecture
- KG-Trie for structured path generation: 100% faithful
- ParamMute (NeurIPS 2025): suppresses hallucination-associated FFNs, +5% faithfulness, training-free
- Two-LLM architecture: small specialized model (0.5B-8B) + KG-Trie for paths; larger model with ParamMute for final reasoning
- End-to-end ceiling: ~75-93% faithfulness for free-form responses

### Key Engineering Requirement
- KG-Trie requires open-weights model (can't use closed API for constrained decoding)
- Trie construction is per-entity and must update incrementally on graph changes
- For trees specifically: no cycles, so path enumeration is O(n) — cheaper than general KGs

---

## 6. Path to Impact: CONCRETE

> Sources: [stream-5a](round4-agents/stream-5a-anthropic-lab-alignment.md), [stream-5b](round4-agents/stream-5b-publication-adoption.md)

### Lab Alignment

**Anthropic (strongest alignment):**
1. Interpretability team — architecture is "interpretable-by-construction," structurally avoids superposition problem
2. Constitutional AI — values as auditable graph nodes, not distributed weights
3. Model welfare — same-substrate metacognition as structural mechanism for reliable introspection
4. Anthropic Fellows Program (May/July 2026) — $3,850/week, 40%+ join Anthropic afterward

**VERSES AI (deepest theoretical alignment):** RGM architecture shares foundational commitment. Contact via IWAI 2026.

**DeepMind:** Gemma Scope 2 tools — apply to small implementation for interpretability comparison.

### Publication Strategy

| Timeline | Target | Format |
|----------|--------|--------|
| Now | Position paper draft | 8-9 pages, ICML format |
| May 2026 | NeurIPS 2026 position track | Check if open; deadline ~May 6 |
| Apr-May 2026 | ICML 2026 SRAS Workshop CFP | 4-page technical paper |
| Jul-Aug 2026 | NeurIPS 2026 workshop CFPs | Agent memory / cognitive architecture |
| Jan 2027 | ICML 2027 position track | Primary target |

**Critical arXiv change (Nov 2025):** CS position papers now require prior peer review before posting. Sequence: submit to venue → acceptance → arXiv.

### The RAG Adoption Lesson
The tipping point was not the paper — it was `pip install langchain`. The architecture needs a framework that makes the idea a one-liner + a demo that's viscerally compelling.

---

## 7. Design Corrections from This Research

### Must Change
1. **Reconsolidation needs prediction-error gate.** Not every traversal is a write. Add `prediction_error_magnitude` to traversal logic.
2. **Causal edges required.** PMI alone = Pearl's Layer 1. Run causal discovery (PC/FCI/GES) during consolidation. Tag edges as "associative" vs "causally identified."
3. **Mirror as distributed broadcast, not central hub.** Per COGITATE 2025.
4. **Emotions are predictive, not reactive.** Per Barrett 2025. Mirror generates anticipated valence before committing to traversal.
5. **Dual-axis confidence confirmed nowhere else.** Novel. Keep it. But frame carefully.

### Should Change
6. **Emotional encoding nuance.** High arousal strengthens core edges but may impair peripheral associations. Don't uniformly boost all edges.
7. **Memory maturity variable.** Well-consolidated nodes become self-contained over time (systems consolidation).
8. **Episodic nodes need autonoetic metadata.** Rich temporal/contextual/self-referential tagging.
9. **Use cognitive science terminology carefully.** "Consciousness," "emotions," "subconscious" are heavyweight terms. The paper must acknowledge the functional-analogy framing explicitly.

### Keep As-Is
10. **Unified graph (one matrix).** Strongest-supported design choice per 2024 consensus.
11. **Power-law decay (d≈0.5).** Matches environmental recurrence statistics per Anderson.
12. **Fan effect normalization.** Correct and important — prevents generic hubs from dominating.
13. **Tree-as-context.** Zero implementations found anywhere. Genuinely novel.
14. **Parallel trees sharing budget.** Zero implementations found. Novel.
15. **Same-substrate metacognition.** Backed by 2025 CMC proposal from the field's senior architects. Novel in implementation.

---

## 8. What the Architecture IS (Final Framing)

**A novel cognitive architecture** that:
1. Externalizes the world model from opaque weights into an interpretable experiential graph
2. Uses tree-as-context (growing subgraph IS the context) instead of retrieve-then-load
3. Has a persistent conscious evaluation loop (the Mirror) that watches, steers, and learns
4. Forms associations through experiential co-occurrence, not pretrained embedding similarity
5. Is value-aligned by design (values are auditable graph structures, not weight distributions)
6. Enables spawnable, diffable minds (each agent's graph IS its unique worldview)

**It is NOT** a path to AGI. It is a new substrate for building AI agents that are transparent, honest, and trustworthy. That is enough.

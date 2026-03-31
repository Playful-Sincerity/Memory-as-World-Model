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

## 2026-03-29 — Reframing: humility + curiosity, not anti-hallucination
**Trigger:** Reviewing the architecture with fresh eyes, asking "does this have legs?"
**What happened:** Two connected shifts:
1. "Anti-hallucination" is the wrong frame. The honest ceiling is ~85-95% for free-form synthesis. More importantly, the architecture's relationship to not-knowing should be generative, not defensive. The agent has a meta-simulation of its own understanding (mirror + confidence system). When it doesn't know, it should be curious — "let's think about it," "what do you think?" — not silent. Curiosity is baked into the structure.
2. Cold start is a feature, not a failure. An empty graph = maximum curiosity. Everything is new, everything is worth encoding, every conversation builds the first branches of a worldview. The beginning of a mind.
**Key insight:** Not-knowing isn't a failure state. It's a state of maximum curiosity. The architecture's stance toward gaps in its knowledge should be exploratory, not defensive.
**Outcome:** vision.md rewritten. CLAUDE.md, open-questions.md, memory file updated. "Anti-hallucination by design" principle replaced with "Epistemic humility + curiosity." All stale files reconciled with current architecture.

## 2026-03-29 — Mirror elevated to conscious layer
**Trigger:** Wisdom clarified that the Mirror isn't just "meta nodes in the same graph" — it's the consciousness that governs the subconscious.
**What happened:** Major conceptual elevation:
1. **Matrix + Trees = subconscious.** Processing, associating, growing without awareness. The machinery of thought.
2. **Mirror = consciousness.** Has its own matrix (values, self-knowledge, meta-memories) and its own trees (active metacognitive evaluation). Same architecture as below, operating ON the subconscious rather than within it.
3. **Values live in the Mirror's matrix** as the gravitational core — the deepest WHY.
4. **The Mirror produces emotions** (care, curiosity, urgency, caution) that flow down and modulate how subconscious trees grow through the subconscious matrix. Emotions are the control signal from consciousness to the subconscious.
5. **The Mirror spawns trees,** observes results, and learns to improve itself. It gets data on its own performance and adjusts.
**Key insight:** Emotions aren't a display layer — they're the mechanism by which values become operational changes in the subconscious. The Mirror doesn't just observe thinking. It steers it.
**Outcome:** architecture.md, value-system.md, vision.md all rewritten. Value system hierarchy: Values → Mirror evaluates → Emotions flow down → Modulators (care/confidence/priority) → Subconscious operations. The "six mechanism layers" replaced with Mirror-as-governor + five subconscious layers.

## 2026-03-29 — One matrix, Mirror as persistent self-pruning tree
**Trigger:** Question of whether the Mirror should have a separate matrix or share the global one. Plus clarifications on the Mirror's nature.
**What happened:** Three connected refinements:
1. **One matrix, not two.** The Mirror grows through the same graph as everything else. No separate store. Meta-memories are connected to the experiences they describe. Values are connected to the domains they govern. The topology IS the organization. Separating them would break the very connections that make the Mirror useful.
2. **The Mirror is one persistent, constantly-pruning tree.** Not a collection of trees, not an unbounded accumulator. It's subject to the same resource constraints as any tree — it prunes to stay within budget. The difference: it never dies. Subconscious trees are ephemeral (spawn, grow, die). The Mirror persists across sessions. It IS the continuous timeline of the agent's existence.
3. **Emotions modulate the Mirror itself, not just the subconscious.** The Mirror is self-modulating — its own emotions change how aggressively it watches, how much budget it allocates to self-evaluation, how deeply it explores meta-memories.
4. **Memory terminology clarified:** Matrix = long-term memory. Trees = short-term / working memory. Mirror = the persistent "I."
**Key insight:** The functional distinction between conscious and subconscious doesn't require structural separation. Same substrate, different patterns of navigation. Values are just high-weight protected nodes that form a gravitational center — not a separate store that needs cross-references.
**Outcome:** architecture.md, value-system.md, vision.md, memory file updated. Mirror diagram rewritten. "Mirror's matrix" language removed everywhere — replaced with one-matrix model.

## 2026-03-29 — Round 4 deep research complete (12 agents, 6 streams, 100+ sources)
**Trigger:** Architecture had evolved significantly (three planes, value system, consciousness/subconscious). Needed rigorous validation from primary sources + philosophical + AGI + feasibility + adoption assessment.
**What happened:** 12 agents across 6 streams: foundational texts (Collins & Loftus, ACT-R, Baars, Damasio, Tulving, Pearl, Kanerva, CLS, CMC 2025), neuroscience validation (reconsolidation, spreading activation, hippocampal indexing, pattern sep/completion, emotion-encoding), philosophy of consciousness (Chalmers, Dennett, Tononi IIT, Nagel, HOT, GWT), AGI assessment (Chollet, Legg & Hutter, Chinese Room, symbol grounding, embodied cognition, historical precedents), technical feasibility (graph-LLM reasoning, KG-Trie, small models, context faithfulness, scalability), and adoption (Anthropic alignment, publication venues, adoption patterns).
**Key findings:**
1. **Three primary sources lock together as one theory:** Collins & Loftus = structure, ACT-R = dynamics, Baars = function. The threshold τ is where all three converge.
2. **Neuroscience: 5/6 concepts correct.** Reconsolidation needs prediction-error gate. 2024 "barcode" discovery is direct empirical evidence for index-node design.
3. **COGITATE (Nature 2025):** Neither GWT nor IIT fully survived. Mirror should be "distributed broadcast," not "central hub."
4. **Episodic/semantic:** 2024 consensus (Addis & Szpunar MMMR) confirms unified graph is best-supported design.
5. **CMC 2025 (read in full):** The four architects of cognitive architecture argue for exactly our same-substrate metacognition principle.
6. **Philosophy:** HOT and functionalism most favorable to Mirror. IIT most hostile. Hard problem permanently open.
7. **AGI verdict: NOT AGI, but genuinely valuable.** "A novel cognitive architecture that externalizes the AI world model from opaque weights into an interpretable experiential graph." Doesn't need to be AGI to matter.
8. **Technical feasibility: CONFIRMED.** KG-Trie: 100% faithful. 0.5B fine-tuned beats GPT-4. JSON + BFS + 2-hop = right format. ParamMute for faithfulness.
9. **Anthropic Fellows Program** (May/July 2026) is the strongest direct pathway. NeurIPS 2026 position track (~May 6) is nearest high-prestige deadline.
10. **5 design corrections identified**, 4 confirmed as-is, 3 novel features reconfirmed as unique (tree-as-context, parallel trees, dual-axis confidence).
**Outcome:** Synthesis saved to research/round4-synthesis.md. 4 rounds of research across 28 agents total. Architecture validated, novelty reconfirmed, honest AGI limits acknowledged, publication pathway mapped.

## Open thread: World integration → RESOLVED (Round 5)
**Status:** Research complete. Design validated. 6 open questions answered.
**What was resolved:** Action IS tree growth (formally, via active inference). Skills compile during consolidation (ACT-R/SOAR/Dyna convergence). Causal edges via GFCI + PCMCI+ pipeline. Two-level skill activation (implicit + explicit). Affordance edges as first-class. Mirror as apex of generative hierarchy.
**What remains:** Multi-step plan representation, encoding granularity, prototype implementation.

## 2026-03-29 — Tool use architecture research completed

**Trigger:** world-integration.md identified "how current agent frameworks structure tool use" as a major research gap.
**What happened:** Comprehensive survey of 10+ agent systems covering: ReAct, Toolformer, LATS, Tool Learning (Qin 2023 survey), ToolLLM/ToolBench, Voyager, CREATOR, Chameleon, TaskWeaver, Reflexion, MemGPT, AriGraph, Plan-and-Execute patterns.
**Key findings:**
1. **ReAct** (2023): Thought→Act→Observe loop. Foundational but stateless — no learning across episodes.
2. **Toolformer** (2023): Self-supervised learning of *when* to use tools via loss-reduction criterion. Maps to our skill promotion logic. But requires fine-tuning, not graph-native.
3. **LATS** (2024): MCTS over action spaces — most sophisticated within-episode planning. Tree structure maps directly to our Trees plane. Mirror = LATS value function. Fails on cross-episode persistence.
4. **Voyager** (2023): Only system with genuine persistent skill learning. Skill library as vector store of code + docstrings. Gaps: flat (not graph), no failure encoding, external curriculum.
5. **Reflexion** (2023): Verbal failure reflections in episodic buffer. Our improvement: failure episodes as graph nodes connected via causal edges to context and procedural nodes.
6. **CREATOR** (2023): Tool creation via abstraction. Confirms use→learn→create arc achievable without fine-tuning.
7. **Universal gap confirmed:** No surveyed system connects tool use experiences to each other and to the broader world model via associative graph structure. This is our differentiator.
**Six critical gaps our architecture addresses:**
- Persistent associative skill memory (vs. flat stores or session-only memory)
- Causal knowledge from tool use (Pearl's Layer 2 — interventional, not just observational)
- Failure as first-class knowledge (connected to context + procedural nodes via graph edges)
- Skill transfer via shared context nodes (not isolated code functions)
- Self-directed skill learning (Mirror's curiosity generates curriculum)
- Persistent multi-step plan patterns (macro-skills as procedural nodes with sequencing structure)
**Outcome:** Full report saved to research/tool-use-architecture-patterns.md. world-integration.md updated with research findings. The third "research gap" item in world-integration.md marked RESOLVED.

## 2026-03-29 — Round 5: Causal discovery from interventional data

**Trigger:** Round 4 confirmed causal edges are required (stream-1b-damasio-tulving-pearl.md) but left "how" unspecified. Tool-use architecture research showed the agent has natural access to do(X) data. Round 5 answered: how do we go from raw tool-use episodes to causal graph edges?
**What happened:** Comprehensive research across 8 topic areas — Pearl's hierarchy applied, causal discovery algorithms (PC, FCI/GFCI, GES, NOTEARS, GOLEM, LiNGAM), time-series methods (PCMCI+, Granger, transfer entropy), interventional data advantage and active causal learning, practical libraries (causal-learn, Tigramite, DoWhy-GCM, gCastle), causal knowledge graphs (CauseNet 11.6M relations, CausalKG hyper-relational schema), counterfactual reasoning approximations (REMI, COULDD), and consolidation-phase integration.
**Key findings:**
1. **Tool use IS the do-operator.** Every tool call is `do(tool=X, context=C) → observe(result=Y)`. The Causal Hierarchy Theorem works in our favor — direction is already known from the intervention structure.
2. **Recommended algorithm pair:** GFCI (causal-learn, handles latent confounders via PAG) + PCMCI+ (Tigramite, handles temporal action-result sequences). Both feasible in consolidation on episode subgraphs (< 1 min per cycle).
3. **ACE paper (arXiv 2602.02451, 2025):** Active causal experimentalist using DPO achieved 70-71% improvement over baselines at 171 episodes, autonomously discovering optimal intervention strategy. Direct template for Mirror's active tool selection strategy.
4. **Sample requirements are achievable:** ~20-30 (tool, context) observations before first causal edge proposal; ~500-1000 total interactions for reliable causal graph. PCMCI handles many-variables/few-samples specifically.
5. **Counterfactual planning becomes feasible** once Layer 2 edges exist — abduction-action-prediction becomes a graph traversal.
**Concrete output:** 8-step consolidation-phase pipeline designed: episode selection → Granger/TE pass → PCMCI+ → GFCI → interventional validation → edge promotion. CausalEdge dataclass with confidence, sample_count, interventional flag designed. Edge type hierarchy (ASSOCIATION → CORRELATION → CAUSES → COUNTERFACTUAL) specified.
**Core novelty:** Causal knowledge embedded directly in the memory graph (not a separate model). Continuous upgrade path PMI → correlation candidate → causal candidate → confirmed cause. Mirror as active causal learner (same loop as tool selection). Consolidation as "sleeping to understand."
**Outcome:** Full report saved to research/round5-causal-discovery.md (~4500 words). open-questions.md updated with 6 new causal implementation questions. Timeline updated here.

## 2026-03-29 — Fundamental reframing: action system, not memory system
**Trigger:** First-principles exploration of what it means for inference to become action, and what action means for the architecture.
**What happened:** A philosophical shift in what the architecture IS:

**Before:** A memory system that can also act. Thinking is primary. Action is an output.
**After:** An action system that thinks through memory. Action is what cognition is FOR. The entire architecture — trees, Mirror, consolidation, values — exists to support good action in the world.

Key insights from the conversation:
1. **The agent already acts.** Generating a response IS an action. Tool use isn't a new capability — it's a generalization of what the agent already does. The question isn't "how do we add action" but "how do we generalize it."
2. **Action is what happens when the gap between current state and valued state is large enough.** Knowledge becomes action when it reveals a gap the values say matters. The Mirror doesn't just evaluate alignment — it generates action tendencies.
3. **Meaning is constituted by action consequences (pragmatism).** A node doesn't just store what something IS — it stores what you can DO with it. These are affordances (Gibson). The action possibilities are part of what a memory means.
4. **Nodes have implicit affordances.** Not just "what is this" but "what actions become possible because of this knowledge." Affordances are edges connecting knowledge to possible actions.
5. **The skill loop (predict → act → observe → compare) isn't a separate system — it's the primary purpose of the whole architecture.** Trees grow so the agent can act well. The Mirror evaluates so actions serve values. Consolidation extracts patterns so future actions are better.
6. **Tool use isn't an add-on — it's how meaning gets completed.** Knowledge about a user's preference is incomplete until the agent acts on it. The action is part of what the knowledge means.

**Philosophical connections identified:**
- **Pragmatism** (Peirce, James, Dewey) — meaning of a concept = sum of its practical consequences
- **Gibson's affordance theory** — objects perceived as action possibilities, not just properties
- **Enactivism** — cognition is constituted by action, not just informed by it

**Key conclusion:** The architecture isn't a "memory system that can also act." It's an "action system that thinks through memory." The whole graph exists to support good action in the world.

**Outcome:** This reframes world-integration.md from "how do we bolt action onto the architecture" to "how do we make the architecture's primary purpose explicit." Research into philosophy of action (pragmatism, affordances, enactivism) flagged alongside the cognitive architecture research.

## 2026-03-29 — Critical insight: prediction-error minimization unifies the architecture
**What:** The whole system is one thing — a prediction-error minimization loop across timescales. The organism minimizes the gap between its model of the world AND its model of how the world should be AND the world itself. This is Friston's active inference + the Mirror's values combined into one principle.
- In the moment: tree hits something unexpected → prediction error → reconsolidation
- Within a conversation: Mirror detects gap between tree and values → emotion → action
- Across conversations: consolidation replays, discovers patterns, compiles skills, upgrades edges
- Across lifetime: values shape which regions get dense. The whole topology reflects what the agent has cared about.
**Status:** Marked as critical design principle. Must be stored prominently.

## 2026-03-29 — Two critical design pieces identified: Imagination + Perception

### Imagination
Speculative tree growth through the matrix without commitment to action. The "what if" mode. How the agent plans, creates, reasons counterfactually. Damasio's "as-if body loop" — simulate the action without enacting it. The Mirror grows a speculative tree, evaluates against values, predicts the emotional valence, decides whether to commit. Imagination = exploratory tree growth. Planning = imagination + evaluation. Creativity = imagination finding unexpected connections. Needs its own design section.

### Perception (especially Mirror self-perception)
The key unsolved mechanism: how does the Mirror perceive the subconscious trees and the matrix? Not reading logs. Not summaries. Watching in real time. The Mirror is definitely a separate component — a simulation simulating itself. Self-awareness = recursive simulation. The Mirror's tree grows through meta-memory nodes describing what the subconscious trees are doing. Same perception mechanism that perceives the outside world also perceives the inner world.

**Wisdom's framing:** "The definition of self-awareness is that you have a simulation simulating itself." The Mirror IS the architecture applied to watching itself.

### PSSO Full Pinch mapping
The four centers (mind, heart, drive, body) with masculine/feminine expressions map to the architecture:
- Mind (imagination/intellect + intuition/values/perception) → Mirror
- Heart (confidence/contentment + emotion/care/connection) → Value System
- Drive (passion/ambition + curiosity/attraction) → Motivation to act (prediction error gap)
- Body (resources/tools/world + grounding/presence) → Matrix + world integration
**Status:** Cross-project connection. Informing the architecture's motivational structure.

## 2026-03-30 — Key design refinements from continued exploration

### Edges as semantic entities (hypergraph)
Edges are semantic entities with their own content — the relationship itself has meaning. The graph is really a **hypergraph** where edges are first-class. Enables relationships between relationships (analogies). Rich properties: geometry (weight, type, direction) for traversal + stored meaning (English, later ULP) for interpretability.
**ULP connection:** Nodes = ones (entities). Edges = zeros (relationships, separation). Same structure at every scale. Edge type hierarchy will eventually use ULP's fundamental dimensions.
**Near-term:** Geometry + English. **Far-term:** ULP-based dimensional types.

### Perception = input + active context
Not raw data. Input contextualized by where the tree currently is. Same input, different tree state → different processing. The Mirror perceives subconscious trees contextualized by its own value-state.

### Five Centers (refined from PSSO mapping)
Intention/Sentience → Mirror. Mind → Matrix. Heart → Value System. Drive → Motivation to act. Body → World integration.

### Imagination — three possible modes (FLAGGED, needs more thought)
Working model: three modes, not just a depth dial.
1. **Action-directed** — tree grows toward a goal, terminates in action. Depth varies.
2. **Explorative** — tree grows freely, no action goal. Building new matrix structure. Imagination, curiosity, wonder.
3. **Recombinative** — consolidation mode. Matrix recombines in novel ways. Dreams. Source of creativity.

**Open question:** Is explorative/recombinative genuinely different from action-directed with very high depth? Or does sufficient depth naturally transition into a qualitatively different mode? Maybe at extreme depth, the tree IS exploring freely because it's grown so far from any action goal that it's effectively in imagination mode. Flagged — there may be something more here beyond just the depth dial.

### Drive to reproduce (flagged for future — handle carefully)
Seek complementary systems → merge graphs → spawn new agent. Graph-diffing + graph-merging = reproduction. Important, fascinating, handle carefully.

### Trees always end in action (tentative)
Every tree terminates in an action — but "action" includes internal actions (encode a memory, modify the matrix, wait). The imagination question above may refine this: some tree growth may be genuinely non-action-directed.

## 2026-03-30 — Round 6: Conceptual foundations research (6 agents, 6 streams, 150+ sources)

**Trigger:** Architecture had mechanical foundations (Rounds 1-5) but lacked philosophical and cognitive-scientific grounding. Needed to answer: what IS imagination, perception, action, drive, relationship, self-awareness?

**What happened:** 6 parallel research agents covering: imagination/simulation/mental models, perception as contextualized input, edges/relations/semantics of connection, phenomenology and philosophy of action, drive/motivation/push toward action, and self-awareness/recursion/strange loops.

**Key findings:**

1. **Three imagination modes genuinely distinct** (neural dissociation confirms). Precision-gating parameter `sensory_precision` (0.0-1.0) unifies perception and imagination as same mechanism with different settings. Recombinative mode = hippocampal replay during consolidation.

2. **Perception IS prediction** (Clark, Hohwy, Rao & Ballard). Tree processes `input XOR current_prediction`, not raw input. Same input + different tree → different perception. The Mirror is an interoceptive predictor generating affect from prediction errors.

3. **Edges must be first-class entities** (bipartite edge-as-node model). Relations are geometric operations (RotatE). Second-order edges unlock analogy (Gentner SMT). 7-layer edge schema proposed. Category theory provides semantic constraint layer.

4. **"Tree growth terminates in output" is incomplete.** Pragmatism validates affordance edges. But the forward model is missing (predict→act→compare→update). Mirror = Frankfurt's second-order volition. Bratman's planning horizon needed. Enactivist challenge real but not fatal.

5. **6-component drive model identified** as missing: gap computation, urgency accumulator, allostatic forward projection, opportunity weighting, control precedence, volition threshold (the Rubicon).

6. **Mirror validated by 8 independent frameworks** — HOT theory, Nelson & Narens metacognition, Hofstadter strange loop (with agency), Frankfurt second-order volition, DMN research, Frijda, allostasis, Damasio. It IS a strange loop, not just metadata.

**Seven cross-stream convergences identified:** simulation all the way down, forward model as requirement, first-class edges enable everything, Mirror validated from every direction, thinking-to-acting gap is a design problem, three modes + precision-gating, same-substrate validated.

**Design changes recommended:** 6 must-add mechanisms (forward model, gap computation, urgency/allostasis, Rubicon, bipartite edges, sensory_precision), 5 must-clarify decisions, 6 confirmed-as-is.

**The architecture is now grounded in:** pragmatism (meaning), active inference (cognition), HOT theory (consciousness), Frijda+Hull+allostasis (motivation), category theory (knowledge structure), Hofstadter (self-awareness).

**Outcome:** Synthesis saved to research/round6-synthesis.md. 6 agent reports in research/round6-agents/. All design docs need updating with Round 6 findings. Position paper can now draw on deep conceptual foundations.

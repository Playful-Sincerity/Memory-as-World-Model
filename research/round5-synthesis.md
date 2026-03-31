# Round 5 Research Synthesis
## World Integration: Perception, Action, Skill Learning, and Causal Discovery
### 5 Agents, 5 Streams, 50+ Sources
### March 29, 2026

**Raw agent outputs:** All detailed findings are saved in [round5-agents/](round5-agents/). Each section below links to the agent(s) that produced its findings.

---

## What We Set Out to Answer

Round 4 identified world integration as the architecture's biggest gap — "the next major piece." This round answered:

1. How do established cognitive architectures handle procedural knowledge?
2. How does cognitive science model the action-perception loop?
3. How do modern AI agents structure tool use?
4. How do AI systems learn skills from experience?
5. How do we upgrade associative edges to causal edges through tool use?

---

## 1. Procedural Memory: The 40-Year Solutions

> Source: [stream-1-procedural-memory.md](round5-agents/stream-1-procedural-memory.md)

### What the Established Architectures Got Right

Four cognitive architectures have deeply thought about how agents learn to DO things. Each solved a different piece:

| Architecture | Key Mechanism | What It Solves | What It Misses |
|-------------|--------------|----------------|----------------|
| **ACT-R** | Utility equation: `U(i) = P(i)*G - C(i)` | Skill selection — pick the right skill based on accumulated success/cost history | Separate procedural memory — can't discover skill-knowledge connections |
| **SOAR** | Chunking + impasse-driven subgoaling | Skill compilation — compress multi-step solutions into single productions. Impasse = spawn new problem space | Fixed production system — skills don't decay or reconsolidate |
| **CLARION** | Two-level competition (implicit Q-learning vs. explicit rules) + RER extraction | Bottom-up skill emergence — implicit patterns become explicit rules. Implicit and explicit COMPETE, not just collaborate | Complex subsystem architecture — four separate interacting modules |
| **NARS** | Unified memory — no procedural/declarative distinction. SELF as first-class concept | Everything in one graph, including skills and self-model | Limited implementation maturity |

### The Critical Insight: Compilation as Consolidation

ACT-R's production compilation and SOAR's chunking converge on the same idea: **skill acquisition is the process of compiling multi-step declarative retrieval sequences into single-step automatic procedures.** The novice explicitly retrieves facts and applies general rules. The expert has compiled those facts into specialized procedures that fire automatically.

In our architecture, this maps to consolidation: repeated episodic patterns of (context → action → outcome) get promoted to procedural nodes during consolidation. The declarative retrieval hop gets eliminated — the skill node directly encodes what the agent used to have to look up.

### NARS Validates the Unified Graph

NARS has no separate procedural memory. Skills are just statements with truth values in the same concept network as world knowledge. SELF is a first-class concept. This directly validates our design choice of storing everything — knowledge, skills, values, self-model — in one matrix.

### Design Decisions from This Stream

1. **SkillNode structure** (from Options framework + ACT-R):
   - `trigger_context` — when does this skill apply? (initiation set)
   - `action_template` — what to do (policy)
   - `expected_outcome` — what should happen (dynamics)
   - `success_rate` (P) — how often has this worked
   - `cost_estimate` (C) — how expensive is this skill
   - `conditions` — when NOT to use this (learned from failures)

2. **Selection equation**: `U(i) = P(i) * care_level - C(i) + noise` — ACT-R's utility with our care level replacing G

3. **Compilation during consolidation**: Repeated (context → action → outcome) episodes → single SkillNode

4. **Two-level competition**: Implicit (graph-traversal-activated skills) compete with explicit (Mirror-deliberated choices). Not one or the other — both, probabilistically weighted.

5. **Mnemos reconsolidation pattern**: Skill retrieval → flag labile → observe outcome → update or overwrite

6. **Goal nodes and SELF region**: NARS motivates adding Goal as a node type and establishing a SELF cluster in the Matrix

---

## 2. The Action-Perception Loop: Action IS Cognition

> Source: [stream-2-action-perception-loop.md](round5-agents/stream-2-action-perception-loop.md)

### Active Inference Confirms the Design

Friston's Free Energy Principle provides the theoretical foundation: **action and perception are the same process applied in different directions.** Perception updates the model to fit the world. Action changes the world to match the model. Both minimize prediction error.

This means: **tool calls are not a bolt-on to tree growth. Tool calls ARE tree growth** — branches extending outward into the world rather than inward through the matrix. The result comes back as a new node at the tip. Active inference says this is formally correct, not just a convenient metaphor.

### VERSES RGM: Our Deepest Theoretical Match

The Renormalizing Generative Models paper (Friston et al. 2024, arXiv:2407.20292) introduced a critical principle: **"only active pathways require belief updating."** Inactive branches remain dormant. This is exactly our spreading activation — only rendered regions of the matrix are active. RGM proves this isn't a shortcut but a computational necessity derived from the renormalization group.

### Affordance Edges Should Be First-Class

Gibson's affordances — action possibilities perceived in the environment — should be explicit edges in the Matrix:

```
(context_node) --[affordance: action, expected_outcome]--> (result_node)
```

This lets the Mirror query "what can I do from here?" without full deliberation. Affordances connect knowledge to action possibilities — they're part of what a memory MEANS.

### Expected Free Energy Resolves Exploration vs. Exploitation

Action selection decomposes into:
- **Epistemic value** — uncertainty reduction (curiosity/exploration)
- **Pragmatic value** — goal alignment (exploitation)

Under uncertainty, the Mirror should spawn speculative trees to explore before committing. This is not optional — it's the Bayes-optimal policy. High uncertainty → epistemic foraging first. Low uncertainty → exploit.

### Design Decisions from This Stream

1. **Unify inward and outward tree growth**: Tool calls = branches growing beyond the matrix. Same traversal engine, same budget, same pruning.
2. **Affordance edges**: First-class typed edges `(context) --[afford: action, outcome]--> (result)` in the Matrix data model.
3. **Precision-weighted reconsolidation**: Threshold scales with edge confidence, not fixed. Well-established edges need more surprise to destabilize.
4. **Allostatic prior layer in Mirror**: Encode resource/risk costs of action paths — Barrett's predictive emotions as budget predictions.
5. **Mirror = apex of generative hierarchy**: Same structure as Matrix, operating at the slowest timescale, carrying prior preferences.

---

## 3. Tool Use in Modern AI Agents: The Universal Gap

> Source: [stream-3-tool-use-patterns.md](round5-agents/stream-3-tool-use-patterns.md)

### 13 Systems Surveyed, One Gap Found

| System | What It Does Well | What It Can't Do |
|--------|------------------|-----------------|
| **ReAct** (Yao 2023) | Thought→Act→Observe loop. The basic unit. | Stateless. No learning across episodes. |
| **Toolformer** (Schick 2023) | Self-supervised when-to-use-tools via loss-reduction | Requires fine-tuning. Not graph-native. |
| **LATS** (Zhou 2024) | MCTS over action spaces. Most sophisticated within-episode planning. | No cross-episode persistence. |
| **Voyager** (Wang 2023) | Persistent skill library. 15.3x faster. Only system that learns. | Flat vector store. No failure encoding. External curriculum. |
| **Reflexion** (Shinn 2023) | Verbal failure reflections. Best failure handling. | Linear buffer, not graph-connected. |
| **CREATOR** (Qian 2023) | Tool creation via abstraction. | No persistent learning. |
| **ToolBench** (Qin 2023) | 16K real APIs. Neural tool retriever. | Retrieves by description, not usage pattern. |
| **AriGraph** (Anokhin 2024) | KG + episodic memory. Closest to our vision. | Domain-specific (text games). Fixed ontology. |

### The Universal Gap

> **No surveyed system integrates tool use experiences into an associative graph.** Systems either forget entirely (ReAct, LATS), store in flat vector indices (Voyager), or keep linear buffers (Reflexion).

This means no system can:
- Discover that two skills share underlying context (skill transfer via shared nodes)
- Surface relevant failure memories via traversal from current context
- Build causal maps of how actions affect the world
- Generate its own learning curriculum from detected capability gaps

**This is the differentiator.** The architecture addresses all four.

### Key Patterns to Adopt

1. **LATS's tree search** → Our Trees plane already does this. Tool use as search, not chain.
2. **Toolformer's loss-reduction** → Our prediction-error signal. Keep what reduces surprise.
3. **Voyager's skill library** → Our procedural nodes, but graph-connected instead of flat.
4. **Reflexion's failure learning** → Our failure nodes connected via causal edges to context and procedural nodes.

---

## 4. Skill Learning in AI: Skills Emerge from Consolidation

> Source: [stream-4-skill-learning.md](round5-agents/stream-4-skill-learning.md)

### Dyna IS Our Architecture

Sutton's Dyna architecture (1991) maps almost perfectly:

| Dyna | Our Architecture |
|------|-----------------|
| Real experience | Live interactions (perception/action cycle) |
| World model | The Matrix (the graph IS the world model) |
| Simulated planning | Consolidation (replay and reorganize during idle) |
| Reward signal | Prediction error from Mirror |

Neuroscience validates: PNAS 2022 shows small prediction errors refine existing memories while large ones create new episodic nodes — exactly what our threshold design predicts.

### Options Framework Gives Formal SkillNode Structure

Sutton et al. (1999) formalized "options" — temporally extended actions with:
- **Initiation set**: when can this option be invoked? (our `trigger_context`)
- **Policy**: what actions to take (our `action_template`)
- **Termination condition**: when to stop (our `success_criteria`)
- **Option dynamics**: expected state after execution (our `expected_outcome`)

SkiMo (CoRL 2022) validates that **planning in skill space achieves 5x higher sample efficiency** for long-horizon tasks. The Mirror should plan at the skill level, not the action level.

### Three Genuinely Novel Things About Skills in a Graph

1. **Context-driven selection over semantic similarity.** Tree traversal activates skills through associative proximity to the current situation — not textual similarity to the task description. Transfer happens because a new situation shares associative connections with contexts where skills were previously useful.

2. **Skills embedded in episodic history.** Every other skill library separates skills from experience. Our procedural nodes are connected to the episodic instances that generated them. You can trace WHY a skill exists by following edges back to the experiences that created it.

3. **Skill acquisition without a separate learning algorithm.** RL needs a separate optimization loop. Our architecture acquires skills through the same Hebbian dynamics as all other knowledge. Skills emerge from consolidation of repeated episodic patterns — no separate trainer.

---

## 5. Causal Discovery: Ascending Pearl's Hierarchy Through Tool Use

> Source: [stream-5-causal-discovery.md](round5-agents/stream-5-causal-discovery.md)

### The Formal Necessity

The Causal Hierarchy Theorem (Bareinboim et al.) mathematically proves that PMI-only graphs cannot answer interventional queries. This is not a practical limitation — it's a theorem. Without causal edges, the architecture is forever stuck at Pearl's Layer 1.

### Tool Use IS the Do-Operator

Every tool call is `do(tool=X, context=C) → observe(result=Y)`. The agent doesn't passively observe — it intervenes. This is exactly Pearl's Layer 2. The interventional structure gives us:
- Direction (action precedes result)
- Control (agent chose the action)
- Repeatability (same tool, different contexts → natural experiment)

### Recommended Algorithm Pair: GFCI + PCMCI+

| Algorithm | Library | What It Does | Why We Need It |
|-----------|---------|-------------|----------------|
| **GFCI** | causal-learn (CMU) | Structural causal discovery with latent confounder handling | Agent can't observe everything — needs PAG output |
| **PCMCI+** | Tigramite (Runge 2019/2020) | Temporal causal discovery for sequential data | Action-result chains are temporal; handles many-variables/few-samples |

Together: PCMCI+ gives temporal direction, GFCI gives structural orientation. Complementary.

**NOTEARS caveat**: CausalLens 2021/2025 demonstrated serious failure modes — can return non-DAGs. Use only as fast skeleton finder, not primary method.

### Computational Feasibility

Causal discovery runs on the **recent episode subgraph** (20-50 variables), not the full 100K-node Matrix:
- PCMCI+ on 20 variables / 100 episodes: **under 5 seconds**
- GFCI on 30 variables / 50 episodes: **5-30 seconds**
- Full consolidation-phase pipeline: **under 1 minute**

### Sample Requirements

- ~20-30 observations per (tool, context) pair before proposing a causal edge
- ~500-1000 total interactions for a reliable core causal graph
- Interventional data halves sample requirements vs. pure observational

### Edge Type Hierarchy

Continuous upgrade path within the same graph:

```
ASSOCIATION  →  CORRELATION  →  CAUSES  →  COUNTERFACTUAL
(PMI)           (temporal +     (GFCI/     (SCM +
                 directional)    PCMCI+      abduction)
                                confirmed)
```

Each tier carries confidence scores and sample counts. The upgrade happens during consolidation.

### Active Causal Learning

The ACE paper (arXiv 2602.02451, 2025) shows an agent using DPO can learn optimal intervention strategies in 171 episodes, autonomously discovering which interventions are most informative. The Mirror should choose tool calls partly based on what would be most informative about causal structure — not just task utility, but epistemic value (connecting back to Expected Free Energy from Stream 2).

### CauseNet for Seeding

CauseNet (11.6M causal relations from web sources, 83% precision) can seed causal candidates before the agent has enough first-hand experience. The causal-learn library provides the algorithms.

---

## 6. Cross-Stream Convergences

Five independent research streams converge on the same design principles:

### Convergence 1: Action IS Cognition

- Active inference (Stream 2): action and perception are the same process
- Tool use research (Stream 3): treating tool use as search (LATS), not chain
- Skill learning (Stream 4): Dyna — the world model exists to support action
- All three say: the architecture isn't a "memory system that can also act" — it's an "action system that thinks through memory"

### Convergence 2: Prediction Error Is the Universal Learning Signal

- ACT-R (Stream 1): utility updates from success/failure
- Active inference (Stream 2): free energy minimization via prediction error
- Toolformer (Stream 3): loss-reduction criterion for tool calls
- Dyna (Stream 4): reward signal = prediction error
- Causal discovery (Stream 5): surprise triggers reconsolidation window AND provides causal evidence
- All five streams agree: **prediction error magnitude determines what gets learned and how strongly**

### Convergence 3: Consolidation = Compilation = Discovery

- ACT-R compilation (Stream 1): merge sequential steps into single procedures
- SOAR chunking (Stream 1): compress problem-solving into productions
- Dyna planning (Stream 4): replay experiences to improve the model
- Causal discovery (Stream 5): run GFCI/PCMCI+ over accumulated episodes
- All say: **consolidation (our "sleep") is when skills are compiled, patterns are extracted, and causal structure is discovered.** It's all the same process: make offline what the agent experienced online.

### Convergence 4: The Mirror's Role Is Formally Grounded

- CLARION MCS (Stream 1): metacognitive subsystem monitors and regulates
- Active inference apex (Stream 2): Mirror = highest level of generative hierarchy
- LATS value function (Stream 3): Mirror evaluates and guides tree search
- Expected Free Energy (Stream 2): Mirror balances epistemic vs. pragmatic value
- Active causal learning (Stream 5): Mirror chooses most informative interventions
- All say: **the Mirror is the unified evaluation, steering, and learning-about-learning layer**

### Convergence 5: The Unified Graph Is Validated

- NARS (Stream 1): no procedural/declarative distinction — everything in one network
- Affordances (Stream 2): action possibilities as edges connecting knowledge to actions
- Skill learning (Stream 4): skills embedded in episodic history, not separated
- Causal edges (Stream 5): continuous upgrade path within one graph structure
- All say: **one matrix, not separate stores.** Skills, knowledge, causal structure, affordances, values, self-model — all in the same graph.

---

## 7. Design Changes Recommended

### Must Add (New from Round 5)

1. **Procedural nodes (SkillNode)** — New node type with trigger_context, action_template, expected_outcome, success_rate, cost_estimate, conditions. Connected associatively to usage contexts.

2. **Affordance edges** — First-class typed edges: `(context) --[afford: action, expected_outcome]--> (result)`. Part of the Matrix data model.

3. **Causal edge pipeline** — GFCI + PCMCI+ during consolidation. Edge types: ASSOCIATION → CORRELATION → CAUSES → COUNTERFACTUAL. Continuous upgrade path with confidence scores.

4. **Goal nodes** — Explicit goal representations in the Matrix (from NARS). Connected to values and to the skills that serve them.

5. **SELF cluster** — Explicit self-model region in the Matrix (from NARS). Connected to Mirror's meta-memories. The agent's beliefs about its own capabilities.

6. **Skill selection equation** — `U(i) = P(i) * care_level - C(i) + noise` for choosing between applicable skills.

### Must Clarify (Refined by Round 5)

7. **Action as tree growth** — Tool calls are branches growing outward. Result returns as new node at tip. Same traversal engine, same budget, same pruning. Not a separate system.

8. **Consolidation does three things simultaneously** — (a) Hebbian strengthening, (b) skill compilation from repeated patterns, (c) causal discovery over accumulated episodes. One process, three outputs.

9. **Two-level skill activation** — Implicit (automatic, from graph traversal hitting a skill node) competes with explicit (deliberate, Mirror selects). Probabilistically weighted by experience.

10. **Mirror's dual evaluation** — For every potential action: epistemic value (what would I learn?) + pragmatic value (does it serve my goals?). From Expected Free Energy.

### Keep (Confirmed by Round 5)

11. **Prediction-error gate** — Confirmed by all 5 streams as the universal learning signal
12. **One matrix** — Confirmed by NARS, affordance theory, skill-in-graph design
13. **Parallel trees** — Confirmed by LATS (tree search over actions), active inference (epistemic foraging)
14. **Mirror as persistent observer** — Confirmed as apex of generative hierarchy

---

## 8. The Architecture After Round 5

The architecture is no longer just a memory system. It's a **cognitive action system** that:

1. **Perceives** — external input becomes nodes connected to active tree tips
2. **Thinks** — trees grow through the matrix, spreading activation, rendering context
3. **Acts** — trees grow outward into the world (tool calls = outward branches)
4. **Learns knowledge** — Hebbian strengthening from co-occurrence
5. **Learns skills** — consolidation compiles repeated action patterns into procedural nodes
6. **Learns causation** — GFCI + PCMCI+ during consolidation upgrade associative → causal edges
7. **Learns about itself** — Mirror encodes meta-memories, tracks its own capabilities in the SELF cluster
8. **Plans** — Mirror balances epistemic (explore) vs. pragmatic (exploit) value when selecting actions

The inner loop (think through memory) and outer loop (perceive and act in the world) are now the same loop — just growing in different directions.

---

## 9. Sources Consulted (Round 5)

### Cognitive Architectures
- Anderson, J.R. (1983/2007). ACT-R. Production compilation, utility learning.
- Taatgen, N.A. & Anderson, J.R. (2002). Production Compilation.
- Laird, J.E. (2012). The Soar Cognitive Architecture. MIT Press.
- Sun, R. (2016). Anatomy of the Mind. CLARION.
- Wang, P. NARS — Non-Axiomatic Reasoning System.
- Mnemos project documentation.

### Active Inference / Perception-Action
- Friston, K.J. (2010). The free-energy principle. Nature Reviews Neuroscience.
- Friston, K.J. et al. (2017). Active Inference: A Process Theory. Neural Computation.
- Friston, K.J. et al. (2024). From pixels to planning: scale-free active inference. arXiv:2407.20292.
- Gibson, J.J. (1979). The Ecological Approach to Visual Perception.
- Neisser, U. (1976). Cognition and Reality.
- Varela, F., Thompson, E., Rosch, E. (1991). The Embodied Mind.
- Schultz, W. (1997). Dopamine prediction error. Science.
- Barrett, L.F. (2025). Theory of Constructed Emotion.
- Rao, R. & Ballard, D. (1999). Predictive coding in the visual cortex.

### Tool Use in AI Agents
- Yao, S. et al. (2023). ReAct. ICLR.
- Schick, T. et al. (2023). Toolformer. NeurIPS.
- Zhou, A. et al. (2024). LATS. ICML.
- Wang, G. et al. (2023). Voyager.
- Shinn, N. et al. (2023). Reflexion. NeurIPS.
- Qian, C. et al. (2023). CREATOR.
- Qin, Y. et al. (2023). Tool Learning with Foundation Models.
- Anokhin, P. et al. (2024). AriGraph. IJCAI.

### Skill Learning
- Sutton, R.S. (1991). Dyna architecture.
- Sutton, R.S. et al. (1999). Options framework.
- Finn, C. et al. (2017). MAML. ICML.
- Shi, L. et al. (2022). SkiMo. CoRL.
- Wu et al. (2025). Agent Skills survey.

### Causal Discovery
- Pearl, J. (2009/2018). Causality / The Book of Why.
- Bareinboim, E. et al. Causal Hierarchy Theorem.
- Spirtes, Glymour, Scheines (2000). Causation, Prediction, and Search.
- Ogarrio, J.M. et al. (2016). GFCI.
- Runge, J. (2019/2020). PCMCI / PCMCI+.
- arXiv 2602.02451 (2025). ACE — Active Causal Experimentalist.
- CauseNet. 11.6M causal relations.
- causal-learn library (CMU). arXiv:2307.16405.

---

*This document synthesizes findings from 5 research agents. All claims trace back to the raw agent outputs in [round5-agents/](round5-agents/). This is Round 5 of the ongoing validation — see [comprehensive-audit.md](comprehensive-audit.md) for the full record.*

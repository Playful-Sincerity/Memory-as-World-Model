# Procedural Memory in Cognitive Architectures
## A Research Report for the Associative Memory Architecture Project

**Date:** 2026-03-29
**Purpose:** Understand how ACT-R, SOAR, CLARION, NARS, and Mnemos handle procedural memory, skill acquisition, and production rules — to inform the design of Skill nodes in the Associative Memory graph architecture.
**Context:** The Associative Memory architecture (Matrix/Trees/Mirror) handles knowledge well but currently lacks a procedural layer. The `world-integration.md` doc identified this gap: we need WHEN and HOW, not just WHAT.

---

## 1. ACT-R — The Production Rule Engine

### 1.1 Architecture Overview

ACT-R (Adaptive Control of Thought—Rational), developed by John R. Anderson and Christian Lebiere at Carnegie Mellon University (Anderson, 1983 — "The Architecture of Cognition"; Anderson & Lebiere, 1998 — "The Atomic Components of Thought"; Anderson et al., 2004 — "An Integrated Theory of the Mind"), is a hybrid cognitive architecture whose symbolic layer is a production system and whose subsymbolic layer is a set of parallel mathematical processes that govern the symbolic.

The central organizing principle: cognition is the interaction between **buffers** (short-term slots connecting modules to the central procedural engine) and **productions** (IF-THEN rules that read buffers and write to them). There are roughly 8 modules — visual, motor, declarative memory, imaginal, goal, and others — each exposing a single buffer. Only one production fires per ~50ms cycle. The procedural module is the only exception to the buffer rule: it has no buffer itself, and instead orchestrates all the others.

### 1.2 The Mechanism: Production Rules

A production rule has the form:

```
IF   <conditions testing the current state of multiple buffers>
THEN <actions that modify buffers and trigger module operations>
```

Concretely: "IF the goal buffer says I'm doing arithmetic AND the retrieval buffer holds the fact that 7+5=12, THEN write 12 to the answer and pop the goal." Productions are the agent's procedural knowledge — they are NOT stored as chunks in declarative memory, but in a separate procedural memory that the pattern matcher continuously scans.

At each moment, the pattern matcher searches all productions for those whose conditions match the current buffer states. If multiple match (conflict set), the **subsymbolic utility equation** selects which fires.

### 1.3 Utility Learning — The Selection Engine

The core equation (Anderson & Lebiere, 1998):

```
U(i) = P(i) * G - C(i) + noise
```

Where:
- **P(i)**: estimated probability that production i will lead to successful goal completion
- **G**: the current value of achieving the goal (stakes)
- **C(i)**: estimated cost of production i (measured in time)
- **noise**: small Gaussian noise term that prevents determinism and models individual variability

This is an expected-value calculation. The system selects the production with the highest utility. G remains constant for a given goal, so the competition is really between P*G - C across candidates.

**Learning:** After each goal completes (success or failure), P and C are updated:

- On success: P increases (closer to 1), C updates toward actual elapsed time
- On failure: P decreases
- The update is a running weighted average: new_P = old_P + α(outcome - old_P)

This is essentially a temporal difference / reinforcement learning mechanism embedded in production selection. Brasoveanu (2021, "Reinforcement Learning for Production-Based Cognitive Models," Topics in Cognitive Science) compared ACT-R's utility learning to Q-learning family algorithms and found ACT-R underperforms tabular Q-learning — suggesting the basic mechanism is sound but the update rule is not optimal by modern RL standards.

**Key insight for our architecture:** The utility mechanism solves the **selection problem** for skills. Multiple skills may be applicable; the agent picks based on accumulated success/cost history. This is how expertise develops: the right skill gets a higher P and gets selected more reliably.

### 1.4 Production Compilation — The Learning Mechanism

Production compilation (Taatgen & Anderson, 2002 — "Production Compilation: A Simple Mechanism to Model Complex Skill Acquisition") is ACT-R's primary mechanism for acquiring new procedural knowledge. The algorithm:

1. Two productions P1 and P2 fire in sequence
2. P2's actions follow P1's actions — P1 sets up conditions that P2 consumes
3. The compiler creates a new production P3 that combines the conditions of P1 (that aren't satisfied by P1 itself) with the actions of P2
4. **Critical case:** If P1 makes a request to declarative memory and P2 uses the retrieved chunk, the compiled production P3 has that chunk's content **inlined** into its condition — the declarative retrieval is eliminated entirely
5. P3 fires in one step where P1+P2 required two steps plus a retrieval delay

**Effect:** Speedup (fewer production cycles + no retrieval latency), reduced error (no risk of retrieval failure), and **specialization** (P3 is more specific than the general P1+P2 pair — it encodes the particular retrieved fact).

This mirrors the novice→expert trajectory. The novice explicitly retrieves facts from memory and applies general rules. The expert has compiled those facts into specialized productions that fire automatically. The novice uses declarative memory. The expert uses procedural memory. Compilation is the transition.

**Constraints on compilation:** Only productions that fire sequentially in the same problem-solving episode get compiled. The compiled rule does NOT fire until it has been reinforced through utility learning — new compilations start with low utility and must outcompete the originals through use.

### 1.5 Declarative-Procedural Interaction

The interaction is mediated through buffers. Productions read from the retrieval buffer and write retrieval requests to the declarative module. The declarative module retrieves chunks using activation-based selection (the ACT-R activation formula: base-level learning, spreading activation from associated chunks, partial matching). The retrieved chunk then influences which productions can fire next.

This is a strict one-way dependency: declarative memory provides the content that productions act on; productions drive the requests and the actions. Declarative chunks don't become productions — they get **inlined into** productions through compilation. The asymmetry is important: learning goes from declarative (knowing about X) to procedural (knowing how to do X), not the reverse.

### 1.6 Transfer to Graph Architecture

| ACT-R mechanism | Graph equivalent | Notes |
|---|---|---|
| Production rule | Skill node with `trigger_context`, `action_template`, `outcome_expectation` | Already sketched in world-integration.md |
| Utility U(i) = P*G - C | Edge weight from Skill node → context nodes (weighted by accumulated P, C) | P stored as edge confidence; C as cost metadata |
| Compilation | Episodic skill nodes promoted to semantic skill nodes after repeated success patterns | Consolidation does the compilation |
| Declarative retrieval elimination | Skill node directly encodes the retrieved fact, removing the graph traversal hop | High-confidence paths get "shortcut" edges |
| Noise | Probabilistic edge selection in traversal already handles this | Built into activation-based sampling |

**What needs to change:** Skill nodes need a `success_rate` and `cost_estimate` field. The traversal engine needs to weight skill node activation by P*G - C, not just structural activation. Compilation happens during consolidation when episodic patterns are promoted.

---

## 2. SOAR — Universal Subgoaling and Chunking

### 2.1 Architecture Overview

SOAR (State, Operator, And Result), developed by Allen Newell, John Laird, and Paul Rosenbloom at Carnegie Mellon and Michigan (Laird, Newell, & Rosenbloom, 1987 — "SOAR: An Architecture for General Intelligence," Artificial Intelligence; Laird, 2012 — "The Soar Cognitive Architecture," MIT Press), is built on a single organizing commitment: **all cognition is problem solving in problem spaces**.

SOAR has four long-term memories: procedural (production rules), semantic, episodic, and working memory. Unlike ACT-R's modular buffers, SOAR's working memory is an **unconstrained symbolic graph** — any structure can be in working memory, and productions can match any graph pattern.

### 2.2 The Decision Cycle

SOAR's operation follows a fixed cycle:

1. **Proposal phase:** Productions whose conditions match current working memory fire in parallel and propose operators, adding them to working memory as acceptable preferences
2. **Evaluation phase:** Other productions match the proposed operators and create comparative preferences (better-than, worse-than, indifferent, required, prohibited)
3. **Decision procedure:** The architecture analyzes all preferences and selects the highest-preference operator not explicitly prohibited; installs it as the current operator
4. **Application phase:** Productions matching the current operator fire and modify working memory (inferences, memory queries, motor commands)

Every production fires in parallel if its conditions match — there is no serial sequential firing like ACT-R's one-production-per-cycle rule. The bottleneck is at the decision procedure, not the pattern match.

### 2.3 Impasses and Universal Subgoaling

An impasse arises when the decision procedure cannot select an operator: either no operator is proposed (no-change impasse), multiple operators tie (tie impasse), or knowledge to apply an operator is missing (operator-no-change impasse). SOAR responds automatically:

1. Creates a **substate** — a new working memory context representing the problem of resolving the impasse
2. In the substate, the agent applies the same cycle recursively — now problem-solving about how to proceed rather than on the original task
3. The substate is populated with the context that caused the impasse (the superstate's partial work)
4. When the substate produces a result (a structure that links back to the superstate), the impasse resolves
5. The substate is torn down — only results persist

This is **universal subgoaling**: ANY impasse produces a subgoal, and ANY subgoal uses the same problem-solving machinery. SOAR doesn't have a separate "planning module" — planning IS subgoaling. Meta-cognition IS subgoaling. Reasoning about uncertainty IS subgoaling. The recursion bottoms out when the agent has enough innate knowledge to resolve without further subgoaling.

**Key insight for our architecture:** The Mirror's role maps closely to SOAR's impasse resolution. When the primary subconscious tree hits a gap (no path in the graph, low confidence), it IS an impasse. The Mirror noticing this and spawning a new tree is SOAR's automatic substate creation mechanism, made conscious.

### 2.4 Chunking — Compiling Substate Processing into Productions

Chunking (Laird & Rosenbloom, 1987; Rosenbloom's thesis) is SOAR's learning mechanism. When a substate produces results:

1. SOAR traces back through ALL the production firings in the substate that contributed to those results (the **behavior trace**)
2. For each contributing production, it records which working memory elements matched which conditions
3. It constructs a new production whose conditions are the **superstate-accessible elements** that were tested — not the substate-specific reasoning, just the conditions in the context that triggered the subgoaling in the first place
4. The new production's actions are the **results** that resolved the impasse
5. This production — the **chunk** — is added to procedural memory immediately

In future situations where the same superstate conditions hold, the chunk fires immediately and produces the result without re-doing the substate reasoning. This is learning by compiling experience: complex deliberate reasoning becomes fast automatic recognition.

**The anatomy of chunking (from Soar procedural learning manual):**
- Pre-learning: operator selection knowledge analysis, instantiation recording, identity assignment, constraint tracking
- During learning: collect inferences → backtracing → identity graph manipulation → 8-stage rule formation (condition/action generation, constraint enforcement, identity-based generalization, condition merging, simplification, validation, repair, Rete-ordering)

**What chunking CANNOT do:** If the operator was selected via numeric preferences (RL), random tie-breaking, or probabilistic selection, SOAR detects this and refuses to create the chunk — it can't summarize probabilistic reasoning into a deterministic rule without over-generalizing.

### 2.5 Reinforcement Learning in SOAR

Soar-RL (Nason & Laird, 2004 — "Soar-RL: Integrating Reinforcement Learning with Soar") extends SOAR with Q-value learning for operator selection.

**RL rules:** A production is an RL rule iff:
- Its LHS tests for a proposed operator (any conditions)
- Its RHS creates exactly ONE numeric-indifferent preference
- It is not a template rule

Multiple RL rules can fire for the same operator; their numeric preferences are **summed** as the operator's Q-value. This makes RL rules function as linear feature approximators: Q(s,a) = Σ wᵢφᵢ(s,a), where each RL rule is a feature φᵢ with weight wᵢ (the numeric-indifferent value).

**Update equations:**
- Sarsa (on-policy): δₜ = α[rₜ₊₁ + γQ(sₜ₊₁, aₜ₊₁) - Q(sₜ, aₜ)]
- Q-learning (off-policy): δₜ = α[rₜ₊₁ + γ max Q(sₜ₊₁, a) - Q(sₜ, aₜ)]

**Reward signal:** A `reward-link` structure in working memory carries numeric reward values. The architecture sums all reward signals at the beginning of each decision phase. Rewards must be explicitly retracted or they are collected repeatedly.

**RL + Chunking integration:** RL rules are regular productions — they CAN be learned by chunking. Initial Q-values can be seeded by substate processing, then refined by RL experience. This enables compositional skill learning: chunking provides the rule structure, RL tunes the weights.

**Critical limitation:** Chunking and RL are partially incompatible as noted above. High-performing SOAR agents typically use chunking for deliberate knowledge compilation and RL for preference tuning, but not both simultaneously on the same decision.

### 2.6 Declarative-Procedural Interaction in SOAR

SOAR's procedural memory (productions) directly queries semantic and episodic memory through working memory:

- A production fires and adds a retrieval cue to a semantic/episodic memory link structure in working memory
- The memory system responds with retrieved structures (in the same decision cycle or next)
- Productions match the retrieved structures and proceed

Semantic memory uses base-level activation (frequency + recency) and spreading activation across associated structures. Episodic memory stores temporal snapshots of working memory states and can retrieve them by cue similarity.

Unlike ACT-R, SOAR's memories are less cleanly separated — working memory IS a graph, and semantic memory structures are retrieved into it seamlessly. The working-memory-as-graph design is highly relevant to the Associative Memory architecture.

### 2.7 Transfer to Graph Architecture

| SOAR mechanism | Graph equivalent | Notes |
|---|---|---|
| Working memory as symbolic graph | Trees growing in the Matrix — already identical | This is the most architecturally similar system |
| Impasse → substate | Mirror spawns a new tree when primary tree hits a gap | The impasse/spawn mechanism maps cleanly |
| Chunking | Consolidation: repeated substate processing patterns → new Skill nodes | Consolidation does the chunking offline |
| RL rules as linear feature approximators | Edge weights as features; activation sums as Q-values | The activation sum in traversal IS a Q-value estimate |
| Operator proposal/selection | Traversal selects which skill to activate based on context match + utility | Context-dependent skill activation already in design |
| Reward signal | Surprise signal in world-integration.md (prediction_error > threshold → update) | prediction_error IS the RL reward signal |

**Most valuable SOAR insight:** Chunking compiles substate reasoning into productions that fire in the superstate. In graph terms: consolidation should create **shortcut edges** that skip the deep traversal that originally produced a result. The second time a situation arises, the shortcut fires immediately.

---

## 3. CLARION — The Implicit-Explicit Bridge

### 3.1 Architecture Overview

CLARION (Connectionist Learning with Adaptive Rule Induction On-line), developed by Ron Sun at Rensselaer Polytechnic Institute (Sun, 2002 — "Duality of the Mind"; Sun, 2016 — "Anatomy of the Mind"), is organized around a central empirical claim: human cognition operates through the interaction of implicit (subsymbolic, inaccessible) and explicit (symbolic, accessible) representations, and most skill acquisition moves **bottom-up** — from implicit to explicit, not the reverse.

CLARION has four subsystems:
1. **Action-Centered Subsystem (ACS)** — manages procedural knowledge and action selection
2. **Non-Action-Centered Subsystem (NACS)** — manages declarative knowledge
3. **Motivational Subsystem (MS)** — provides drives, goals, and motivational context
4. **Meta-Cognitive Subsystem (MCS)** — monitors and regulates the other three

Each subsystem has two levels: implicit (bottom — neural networks) and explicit (top — symbolic rules/chunks).

### 3.2 The Mechanism: Two-Level Skill Learning

**Bottom level of ACS:** A multi-layer feed-forward neural network trained with a modified Q-learning algorithm using backpropagation. State → action values (Q-values) are computed over distributed vector representations. The network learns implicit associations between situations and effective actions without symbolic interpretation.

**Top level of ACS:** Explicit action rules of the form IF (condition) THEN (action) [with confidence]. These are localist representations — human-readable symbolic rules. They can be hand-specified (top-down) or extracted from the bottom level (bottom-up).

**Action selection combines both levels:**
- The bottom level produces a Q-value distribution over actions
- The top level fires any matching explicit rules and produces their recommended actions
- The system stochastically combines these: epsilon-greedy between top-level explicit rule output and bottom-level neural output
- As explicit rules accumulate and gain confidence, the balance shifts toward explicit control
- This models the novice→expert shift: beginners rely on deliberate explicit rules, experts on fast implicit intuition, but the best performers combine both

### 3.3 The RER Algorithm — From Implicit to Explicit

The Rule-Extraction-Refinement algorithm (Sun, Zhang, & Peterson, 2001; reviewed in Sun, 2016) is how CLARION extracts explicit rules from the neural bottom level:

1. **Extraction:** After the neural network achieves some success on a situation, examine the network's internal activations. Identify which input features (microfeatures) were most strongly activated for the winning action. Generate a candidate rule: IF [activated features > threshold] THEN [winning action]
2. **Filtering:** Test the candidate rule on recent experiences. If it achieves accuracy above a threshold, promote it to the explicit top level
3. **Refinement:** When an explicit rule misfires (situation matches but wrong action), refine it: either add conditions (specialization) or split it into more specific rules
4. **Generalization:** When a rule consistently fires correctly across many situations, remove conditions (generalization)

The RER process runs continuously in the background, converting implicit success patterns into explicit articulable rules. This models the psychological phenomenon of **verbalization** — people can sometimes articulate what they're doing well (explicit rule extraction works) and sometimes can't (the knowledge stays implicit).

**Top-down learning also exists:** Explicit rules can guide what the bottom level attends to, shaping neural learning. Rules can be injected by a teacher (instructions), then internalized through practice. This models how instruction accelerates skill acquisition vs. pure trial-and-error.

### 3.4 The Motivational Subsystem

The MS operates at two levels:

**Bottom level (drives):** Primary drives including hunger, thirst, reproduction, stimulus novelty, pain avoidance. These are subsymbolic, continuous, and always present. They bias action selection by modulating Q-values in the ACS bottom level.

**Top level (goals):** Explicit goal representations — "achieve X," "avoid Y," "maintain state Z." Goals are more stable than drives (they persist until satisfied or abandoned) and are directly manipulable. The MCS sets goals in the ACS based on drive states and current context.

**Interaction:** Drives create motivational pressure (implicit); goals provide direction (explicit). Both modulate the ACS simultaneously. High drive states can override or reinforce goals. This dual-level motivational system avoids the brittleness of pure goal-directed systems (which break when goals are absent or ill-specified) and the purposelessness of pure drive systems.

**Key insight for our architecture:** The Mirror's "care" and "curiosity" emotions are this system's drives. The explicit goals spawned by the Mirror are this system's top-level goal representations. CLARION gives formal grounding to what we're already designing intuitively.

### 3.5 The Meta-Cognitive Subsystem

The MCS monitors, controls, and regulates the other subsystems:

- **Monitoring:** Observes performance metrics (success rate, error rate, resource consumption) across all subsystems
- **Goal setting:** Based on monitoring, sets or modifies goals for the ACS (e.g., "the success rate is dropping — try to be more careful")
- **Parameter adjustment:** Modifies learning rates, exploration/exploitation balance, and activation thresholds in ACS and NACS
- **Process interruption:** Can interrupt ongoing ACS processes (stop what you're doing, reassess)
- **Strategy selection:** Chooses between multiple available cognitive strategies

This is the closest analog to the Mirror in our architecture. The MCS doesn't produce object-level behavior; it produces behavioral regulation. It watches the ACS and NACS doing work and adjusts how they work.

### 3.6 Declarative-Procedural in CLARION

CLARION distinguishes procedural knowledge (ACS — what to DO) from declarative knowledge (NACS — what IS). The NACS stores explicit associative rules and implicit associative networks (same two-level structure). Importantly:

- Both ACS and NACS have implicit and explicit levels — the architecture is symmetric
- Procedural and declarative can inform each other: NACS facts can feed into ACS rule conditions; ACS successful patterns can generate declarative conclusions
- Sun (2016) argues this captures the psychological evidence that skills are not monolithic but involve both "how to" and "knowing that" aspects

**Key difference from ACT-R:** ACT-R treats the declarative→procedural pathway as compilation (chunks become embedded in productions). CLARION treats it as continuous parallel interaction at both levels. Both approaches produce similar behavioral predictions but differ in mechanism.

### 3.7 Transfer to Graph Architecture

| CLARION mechanism | Graph equivalent | Notes |
|---|---|---|
| Bottom-level Q-learning | Activation-weighted edge traversal — already the mechanism | Traversal IS implicit skill expression |
| RER: extract rule from neural | Consolidation: abstract repeated episodic patterns → Skill nodes | The consolidation process does this |
| Top-level explicit rules | Skill nodes in the Matrix — high-confidence, human-readable | Already in world-integration.md design |
| Stochastic combination of levels | Activation competition between Skill nodes and raw traversal | Skill node activation competes with pure associative traversal |
| Motivational Subsystem | Mirror's care/curiosity/urgency emotions modulating tree growth | The MS maps directly to Mirror emotions |
| MCS monitoring and adjustment | Mirror's metacognitive function watching trees, adjusting budgets | Mirror IS the MCS |
| Top-down learning | Mirror injects explicit skill templates that shape future implicit patterns | How instructed skills get internalized |

**Most valuable CLARION insight:** The two levels need to COMPETE during skill selection, not just collaborate. When both implicit graph traversal and an explicit Skill node are active for a given context, the system should probabilistically choose, weighted by confidence. Over time, the winner becomes dominant. This is how skills consolidate from effortful to automatic.

---

## 4. NARS — Unified Procedural-Declarative Inference

### 4.1 Architecture Overview

NARS (Non-Axiomatic Reasoning System), developed by Pei Wang at Temple University over 30+ years (Wang, 1995 — "Non-Axiomatic Reasoning System"; Wang, 2013 — "Non-Axiomatic Logic: A Practical Reasoning System for the Intelligent Agent"), is the most radical departure from the ACT-R/SOAR paradigm. In NARS, there is **no distinction between procedural and declarative memory** at the architectural level. Both are statements in the same language (Narsese), processed by the same inference rules, and stored in the same concept-based memory.

NARS is designed for operation under the **Assumption of Insufficient Knowledge and Resources (AIKR)**: finite memory, finite computation, real-time constraints, open-ended environment. Everything in NARS — beliefs, goals, tasks, operations — is probabilistic and revisable.

### 4.2 The Narsese Representation — Skills as Statements

In NARS, all knowledge is expressed as Narsese statements with **truth values** — (frequency, confidence) pairs representing the fraction of evidence supporting the statement and the total evidence weight.

**Declarative:** `robin --> bird` (frequency 0.9, confidence 0.95) — "robins are usually birds, with high confidence"

**Procedural:** `(×{SELF}{door_1}) --> open` — "SELF performs the 'open' operation on door_1." More generally, NAL-8 introduces the **operation** as an event type:

```
<(×{SELF}{arg1}...{argN}) --> operation_name>
```

This is NOT a production rule — it's a **judgment** like any other Narsese statement, stored as part of a concept, carrying a truth value. The operation is stored in the concept for `operation_name`, which is linked to all other relevant concepts through regular Narsese relationships.

**Goals** are also statements with truth values, but carrying a **desire value** rather than a truth value:
```
<achieve_goal_X>! (desire value: frequency 0.8, confidence 0.9)
```

Goals and beliefs inhabit the same concept-based memory, processed by the same inference engine. There is no separate goal stack or production memory.

### 4.3 SELF as a First-Class Concept

The term `SELF` is a reserved concept in NARS that refers to the system itself (Wang & Li, 2018 — "Self in NARS, an AGI System," Frontiers in Robotics and AI). SELF obeys the same representational rules as any other concept:

- **Same memory:** SELF-knowledge and world-knowledge share the same concept-based memory structure. There is no privileged self-representation.
- **Same inference:** Statements about SELF are processed by the same inference rules as statements about external entities.
- **Same learning:** The system learns about itself through the same evidence accumulation process as learning about the world.
- **Operations are self-referential:** "SELF performs X" uses SELF as the agent in an operation statement. When SELF's internal operations are used in procedural inference (NAL-9), a self-referential loop forms that enables self-awareness.
- **Imitation:** Because other agents' actions are represented as `(×{other_agent}{arg}) --> action`, and SELF's actions are `(×{SELF}{arg}) --> action`, the system can imitate by substituting SELF for the other agent.

The implication: NARS has no "system architecture code" that is separate from the knowledge — the system's own operational parameters and strategies are IN the same memory as everything else. Self-modification is inference applied to self-knowledge.

### 4.4 Procedural Inference — Goals, Operations, and Evidence

NARS's procedural reasoning operates through standard inference rules (deduction, induction, abduction) applied to procedural statements:

**Goal-directed inference:** Given a goal `<achieve_X>!` and a belief `<(×{SELF}{arg}) --> op> <==> <X>` (operation op with argument arg is equivalent to achieving X), the system infers by deduction that executing op(arg) will satisfy the goal.

**Experience-based learning:** After executing an operation and observing the result:
1. If outcome matches goal: strengthen the belief linking operation to goal with positive evidence
2. If outcome doesn't match: add negative evidence to the belief (frequency decreases)
3. Accumulate over many trials: truth value stabilizes around the operation's actual success rate

**Temporal structure:** Operations occur in time. NARS represents temporal sequences using temporal copulas: `A =/> B` (A leads to B sequentially), `A =|> B` (A and B occur simultaneously). Complex procedural knowledge is built up compositionally: atomic operations → sequential compounds → complex procedures, each level carrying an evidence-based truth value.

**The concept network as skill memory:** Each operation's concept node contains all the contexts in which it has been tried, all the outcomes observed, and all the goals it's been associated with. Retrieving the operation concept retrieves its full experiential history — not a rule, but a probability distribution over contexts and outcomes.

### 4.5 Resource Management and Skill Selection

NARS manages resources through **bags** — probabilistic priority queues where each item's selection probability is proportional to its priority. Priority reflects a combination of truth value quality, recency, and relevance to current goals.

At each cycle, NARS selects a concept, then selects a task (goal or question) in that concept, then selects a belief or desire to reason with. The selection is biased — recent, high-confidence, goal-relevant items win — but probabilistic, allowing exploration of weaker candidates.

**Skill selection mechanism:** When a goal is active, the system searches for operation-concepts that are linked to goal-achievement with high truth-value confidence. Multiple operations may qualify; the one with the best combination of expected frequency (success rate) and total evidence (confidence) wins the priority competition. This is the NARS equivalent of ACT-R's utility selection — but unified in the same representation as all other knowledge.

### 4.6 Transfer to Graph Architecture

| NARS mechanism | Graph equivalent | Notes |
|---|---|---|
| Operations as Narsese statements | Skill nodes with truth-value metadata (success_rate ≈ frequency, confidence ≈ evidence_count) | Most direct mapping to our Skill node design |
| SELF as concept in memory | Mirror as a high-weight, densely-connected region of the Matrix — already in architecture | The Matrix should include a SELF region |
| No procedural/declarative boundary | Skills live in the same Matrix as knowledge nodes — already in design | Validates our unified graph approach |
| Evidence accumulation for skills | Skill node edge weights update with each use outcome | Hebbian strengthening + prediction_error signal |
| Temporal compounds | Skill sequences encoded as chains of Skill nodes with temporal edges | Multi-step skill chains in the graph |
| Goal-operation inference | Tree traversal from a Goal node through operation edges to applicable Skill nodes | Goal nodes need to be a node type |
| Priority bag for selection | Activation-based selection already in traversal engine | Bags ≈ activation competition |

**Most valuable NARS insight:** There is no architectural reason to separate procedural and declarative memory. The Associative Memory architecture's unified graph approach is VALIDATED by NARS's 30 years of theoretical work. Skill nodes are just nodes with particular structural features (trigger context edges, action template, outcome edges), not a separate system.

Additionally: **SELF should be a concept in the Matrix**, not just the Mirror watching from outside. The Mirror IS the system's SELF-concept instantiated as a persistent tree, growing through the same Matrix that contains world-knowledge. This is already partially true in our architecture; NARS makes the theoretical case for why this is right.

---

## 5. Mnemos — Reconsolidation as Skill Updating

### 5.1 Architecture Overview

Mnemos (making-minds.ai, 2025-2026) is a local-first scoped memory system for coding agents that implements neuroscience-inspired mechanisms including biomimetic retrieval, consolidation, and reconsolidation. It is not a full cognitive architecture but a memory system for Claude Code-type agents.

Three memory scopes: project-level, workspace-level, global. These persist across sessions and survive restarts.

Modules:
- **Retrieval:** Vector similarity retrieval of memory chunks; retrieved chunks are flagged as labile
- **Reconsolidation daemon:** Async background agent evaluating whether retrieved chunks remain accurate given new context
- **Sleep daemon:** Runs during idle periods; extracts durable facts from episodic traces into long-term storage; prunes episodic records
- **Scope manager:** Maintains boundaries between project/workspace/global memory

### 5.2 The Reconsolidation Mechanism

This is Mnemos's most distinctive contribution and its direct relevance to skill updating.

**Biological basis:** Memory reconsolidation (Nader, Schafe, & LeDoux, 2000; Bhattacharya & Bhattacharya, 2017 — "An update on memory reconsolidation updating," Trends in Cognitive Sciences) is the phenomenon where retrieved memories become temporarily labile (unstable) and vulnerable to modification before restabilizing. The key property: **retrieval is a write operation**, not just a read operation.

**Mnemos implementation:**
1. When a memory chunk is retrieved, it is immediately flagged as **labile**
2. After the conversational turn completes (async), a background agent evaluates: "given the new context in this turn, is the retrieved chunk still accurate?"
3. If the chunk has changed (new information contradicts or updates it): the stored chunk is **overwritten** — not appended to — with a synthesized, updated version
4. If the chunk is still accurate: the flag is cleared, the chunk restabilizes

This prevents the progressive distortion that would occur if retrieved memories always conflicted with new information. It also prevents the rigidity that would occur if memories could never be updated. The window between retrieval and restabilization is the update window.

### 5.3 Implications for Procedural/Skill Updating

Mnemos is designed primarily for declarative/factual memory. Its docs do not explicitly address procedural skill knowledge. However, the mechanism has direct implications:

**Skill reconsolidation:** When a Skill node is retrieved (activated during task execution), it should enter a labile state. After the task completes and the outcome is observed:
- If the skill produced the expected outcome: restabilize (strengthen edges)
- If the skill produced an unexpected outcome: reconsolidation window is open — update the skill node's expected_outcome, success_rate, and conditions

This is precisely the **surprise-triggered update** mechanism already in our world-integration.md design. Mnemos provides the implementation pattern: flag on retrieval, async evaluation, overwrite on update.

**The overwrite vs. append principle:** Mnemos overwrites rather than appends. This is critical for procedural memory: skills shouldn't accumulate a history of conflicting outcomes attached as annotations — they should be the system's current best model of the skill, revised continuously. Old versions are gone; the graph has moved. (Versioning through the episodic memory of past skill applications remains available.)

**Sleep daemon → Consolidation:** Mnemos's sleep daemon maps directly to our background consolidation process. Idle periods → extract durable patterns → promote to long-term storage → prune episodic traces. For skills: repeated successful episodic patterns → promote to consolidated Skill node → prune individual episodic action records.

### 5.4 Transfer to Graph Architecture

| Mnemos mechanism | Graph equivalent | Notes |
|---|---|---|
| Retrieval → labile flag | Skill node activation → mark as labile | Flag cleared after outcome is observed |
| Async reconsolidation agent | Consolidation process evaluating outcome vs. expectation | Runs after each action completion |
| Overwrite semantics | Skill node metadata is updated in place | Not append; current-best-model wins |
| Sleep daemon | Background consolidation between interactions | Already in architecture |
| Three memory scopes | Mirror (global self-knowledge) + subconscious Matrix + per-session trees | Scope maps approximately to our planes |

---

## 6. Synthesis — Mapping to the Associative Memory Architecture

### 6.1 What We Now Understand

The five systems converge on a small set of core mechanisms. Despite their architectural differences, they all share:

1. **A selection mechanism for competing skills** — ACT-R uses utility (P*G - C), SOAR uses preference-based operator evaluation, CLARION uses stochastic combination of Q-values and explicit rules, NARS uses priority bags with truth-value weighting, Mnemos relies on activation similarity. The underlying math is different; the problem is the same.

2. **A compilation/abstraction mechanism** — ACT-R compiles two sequential productions; SOAR chunks substate reasoning into superstate rules; CLARION extracts explicit rules from implicit neural patterns via RER; NARS builds compound operations from evidence-weighted primitive operations; Mnemos promotes episodic traces to long-term consolidated chunks. All five say: repeated complex processing → simpler automated structure.

3. **A prediction-error/surprise learning signal** — ACT-R updates P based on success/failure; SOAR-RL uses Bellman TD error; CLARION's Q-learning is pure Bellman; NARS updates truth-value frequency with each outcome; Mnemos triggers reconsolidation when context changes retrieved memory. All five use some form of outcome-vs-prediction mismatch as the learning signal.

4. **Some form of meta-cognition** — ACT-R's utility noise prevents fixation; SOAR's universal subgoaling makes meta-cognition and object-level cognition the same mechanism; CLARION's MCS explicitly monitors and regulates all other subsystems; NARS applies inference to SELF-knowledge; Mnemos has no explicit meta-cognitive layer. The strongest systems (SOAR, CLARION) have the richest meta-cognition.

5. **A bridge between declarative and procedural** — ACT-R has compilation (declarative → embedded in procedural); SOAR has chunking (declarative working memory → procedural productions); CLARION has RER (implicit associations → explicit rules); NARS has no bridge because there's no distinction; Mnemos doesn't address this. Our architecture's consolidation process is this bridge.

### 6.2 Design Decisions Recommended

#### Decision 1: Skill Node Structure

Based on NARS (unified representation) + ACT-R (utility components) + SOAR (chunk conditions/actions):

```python
SkillNode:
    id: str
    trigger_pattern: str          # natural language description of when this applies
    trigger_embeddings: Vector    # for similarity matching
    action_template: dict         # what to do (tool name, parameter patterns)
    expected_outcome: str         # what should happen

    # Utility / Quality (ACT-R-inspired)
    success_rate: float           # P(i): [0.0 - 1.0], updates with experience
    avg_cost: float               # C(i): average time/tokens consumed
    evidence_count: int           # NARS-inspired: how many trials

    # Connection to context (SOAR-inspired)
    condition_edges: List[Edge]   # edges to context nodes that trigger this skill
    outcome_edges: List[Edge]     # edges to nodes this skill produces/leads to

    # Lifecycle
    is_labile: bool               # Mnemos: flagged on retrieval, cleared after update
    last_used: datetime
    origin: str                   # "compiled" | "injected" | "emergent"
```

#### Decision 2: Skill Selection During Traversal

When traversal reaches a context where multiple Skill nodes are potentially applicable, select using an ACT-R-style utility:

```
skill_activation(s) = base_activation(s)
                    + context_match_activation(s)    # spreading from context nodes
                    + success_rate(s) * goal_value   # ACT-R's P*G
                    - avg_cost(s)                    # ACT-R's C
                    + noise                          # prevents determinism
```

The skill with highest activation fires. If no skill exceeds threshold, the tree must grow deeper (find new path) or the Mirror spawns a tree to investigate (SOAR's impasse mechanism).

#### Decision 3: Skill Compilation via Consolidation

Map ACT-R's production compilation + SOAR's chunking + CLARION's RER to our consolidation process:

1. **Episodic phase:** Every action generates an episodic node: `(context, skill_applied, outcome, success)`. These are raw experience.
2. **Pattern detection:** During consolidation, scan episodic nodes for repeated `(context_pattern, action) → outcome` triplets. Frequency threshold: N successful uses with success_rate > threshold.
3. **Skill promotion:** Promote the pattern to a Skill node. Connect condition_edges to the context pattern nodes. Connect outcome_edges to the outcome nodes.
4. **Shortcut creation:** Add high-weight direct edges from context nodes → Skill node. Future traversal hits the Skill node directly without re-doing the episodic reasoning. This IS ACT-R's compilation / SOAR's chunk.
5. **Episodic pruning:** Once promoted, the individual episodic instances can be pruned from active memory (but their aggregate statistics persist in the Skill node).

#### Decision 4: Reconsolidation for Skill Updating

Implement Mnemos's reconsolidation mechanism for Skill nodes:

1. When a Skill node is activated (selected for execution), mark `is_labile = True`
2. Execute the action, observe the outcome
3. After outcome observation (async):
   - If outcome matches `expected_outcome`: strengthen condition_edges and outcome_edges; clear `is_labile`; increment `evidence_count`; update `success_rate` with Bayesian update
   - If outcome diverges significantly: update `expected_outcome`, update `success_rate` (downward), potentially split Skill node into two more specific nodes; clear `is_labile`
4. This implements overwrite semantics: the Skill node holds the system's current best model, not an append log

#### Decision 5: Two-Level Competition (CLARION pattern)

When a context activates both:
- **Explicit Skill node:** High confidence, human-readable, fast — compiled from experience
- **Raw associative traversal:** Implicit, distributional, slower — the graph finding its own path

The system should COMPETE these rather than always preferring the explicit skill. Competition mechanism: skill_activation vs. path_activation from traversal. Over time, as the skill's evidence_count grows and success_rate stays high, it dominates. Early skill nodes with low evidence should lose to raw traversal frequently — they haven't proven themselves yet.

This gives CLARION's two-level dynamics naturally, from a single activation mechanism.

#### Decision 6: Goal Nodes as First-Class Types

NARS's treatment of goals as first-class statements — not a separate system — suggests adding **Goal nodes** to the Matrix:

```python
GoalNode:
    id: str
    description: str
    desire_value: float     # NARS: how strongly this is desired
    current: bool           # whether this goal is currently active
    condition_edges: List[Edge]   # what contexts trigger pursuing this goal
    subgoal_edges: List[Edge]     # what sub-goals serve this goal
    skill_edges: List[Edge]       # what skills serve this goal
```

The Mirror maintains currently-active Goal nodes. When a tree grows, it is always rooted in either an input node or a Goal node. Connecting Skill nodes to Goal nodes through the graph creates the goal-directed skill selection that ACT-R and SOAR implement through separate mechanisms.

#### Decision 7: The SELF Region

NARS demonstrates that SELF-knowledge in the same memory as world-knowledge enables self-modification through inference. Our architecture should explicitly design a SELF region of the Matrix:

- Nodes representing the agent's own capabilities, tendencies, values
- Nodes representing the agent's history of successes and failures
- Nodes representing meta-skills: "when my confidence is low, I tend to search better than I reason"
- These are connected to regular world-knowledge through the same edges
- The Mirror grows through this region during metacognitive reflection

This region already implicitly exists (the Mirror's own matrix). NARS makes explicit that it should be **one unified region**, not a separate substrate.

### 6.3 The Skill Acquisition Pathway

Synthesizing across all five systems, here is the complete pathway from "never done this" to "expert at this" in the Associative Memory architecture:

```
PHASE 1: FIRST ENCOUNTER (no skill exists)
  Tree grows through context. No Skill node activates.
  Mirror identifies gap (impasse).
  If declarative knowledge exists: compose a tentative action from
    world-knowledge edges (NARS-style procedural inference from beliefs).
  If no knowledge: Mirror spawns exploratory tree or asks user.

PHASE 2: EPISODIC ACCUMULATION (raw experience)
  Actions create episodic nodes: (context, action, outcome).
  Causal edges form: action --caused--> outcome.
  Prediction_error signal updates edge weights.
  Surprise → reconsolidation window → context encoding improves.
  Subconscious tree finds the action faster each time via
    edge strengthening (Hebbian learning IS implicit skill development).

PHASE 3: PATTERN EMERGENCE (implicit skill)
  After N successful episodes with consistent context→action→outcome:
  Consolidation detects the pattern.
  Traversal from context reaches the action node via a now-strong
    path — this IS the implicit skill (CLARION bottom level).
  No Skill node yet; just a strong path in the graph.

PHASE 4: COMPILATION (Skill node created)
  Consolidation promotes the pattern to an explicit Skill node.
  Condition edges connect context nodes → Skill node directly.
  Outcome edges connect Skill node → expected outcome nodes.
  Success_rate initialized from historical episodic data.
  Shortcut edges bypass the detailed path.

PHASE 5: REFINEMENT (utility learning)
  Skill node competes with raw traversal on each use.
  Success → strengthen condition edges, increase success_rate.
  Failure → reconsolidation: update expected_outcome, decrease success_rate,
    possibly split into two Skill nodes with more specific conditions.
  Over time: Skill node dominates context activation.

PHASE 6: EXPERTISE (automatic skill)
  Skill node fires immediately on context match.
  Condition edges are high-weight — they win activation competition easily.
  Raw episodic traversal no longer reaches the action: the path is bypassed.
  The expert doesn't "remember how they learned" — the episodic records
    have been pruned; only the Skill node remains.
  Meta-skills in the SELF region record: "I'm good at this in this context."
```

### 6.4 What Remains Unresolved

These questions are informed by the research but not answered by it:

1. **Graph-native compilation:** ACT-R's compilation operates on production syntax; SOAR's chunking operates on working memory traces. Neither has been implemented in a graph memory architecture. The consolidation-as-compilation mapping is plausible but untested. What exactly does the "behavior trace" look like in our graph, and how do we identify which edges to include in the chunk?

2. **Condition generalization:** SOAR's chunking generalizes conditions by replacing specific identifiers with variables. Our Skill nodes need something analogous — not just "when user asks about Python list comprehensions" but "when user asks about language feature explanation." How does the system decide what level of generalization is correct?

3. **Multi-step skill composition:** NARS's temporal compound operations and SOAR's operator sequences represent multi-step procedures. Our Skill nodes handle single actions. How do we represent and compile "call tool A, then use result to call tool B, then synthesize" as a single skill? Skill chains? Macro-Skill nodes?

4. **The CLARION two-level balance over time:** CLARION has an explicit parameter controlling the balance between top-level and bottom-level. In our architecture, this balance emerges from evidence_count (more evidence → explicit Skill node wins more). But is pure activation competition sufficient, or do we need an explicit balance parameter?

5. **Negative skills:** SOAR explicitly encodes "prohibited" operator preferences. Our architecture currently has no mechanism for "don't do X in this context." Skill nodes with negative expected_outcome could serve this role, but the traversal engine would need to support repulsion (negative activation contribution) not just attraction.

---

## Citations

- Anderson, J.R. (1983). *The Architecture of Cognition*. Harvard University Press.
- Anderson, J.R., & Lebiere, C. (1998). *The Atomic Components of Thought*. Lawrence Erlbaum.
- Anderson, J.R., Bothell, D., Byrne, M.D., Douglass, S., Lebiere, C., & Qin, Y. (2004). An integrated theory of the mind. *Psychological Review*, 111(4), 1036–1060.
- Brasoveanu, A., & Dotlacil, J. (2021). Reinforcement learning for production-based cognitive models. *Topics in Cognitive Science*, 13(3), 666–689.
- Laird, J.E., Newell, A., & Rosenbloom, P.S. (1987). SOAR: An architecture for general intelligence. *Artificial Intelligence*, 33(1), 1–64.
- Laird, J.E. (2012). *The Soar Cognitive Architecture*. MIT Press.
- Laird, J.E. (2022). Introduction to the Soar Cognitive Architecture. arXiv:2205.03854.
- Nason, S., & Laird, J.E. (2004). Soar-RL: Integrating reinforcement learning with Soar. *Cognitive Systems Research*, 6(1), 51–59.
- Rosenbloom, P.S., & Laird, J.E. (1987). Chunking in Soar: The anatomy of a general learning mechanism. *Machine Learning*, 1(1), 11–46.
- Sun, R. (2002). *Duality of the Mind*. Lawrence Erlbaum.
- Sun, R. (2016). *Anatomy of the Mind: Exploring Psychological Mechanisms and Processes with the Clarion Cognitive Architecture*. Oxford University Press.
- Sun, R., Zhang, X., & Peterson, T. (2001). From implicit skills to explicit knowledge: A bottom-up model of skill learning. *Cognitive Science*, 25(2), 203–244.
- Taatgen, N.A., & Anderson, J.R. (2002). Why do children learn to say "broke"? A model of learning the past tense without feedback. *Cognition*, 86(2), 123–155.
- Taatgen, N.A., & Lee, F.J. (2003). Production compilation: A simple mechanism to model complex skill acquisition. *Human Factors*, 45(1), 61–76.
- Wang, P. (1995). Non-axiomatic reasoning system (Version 2.2). Indiana University Computer Science Department Technical Report 75.
- Wang, P. (2013). *Non-Axiomatic Logic: A Practical Reasoning System for the Intelligent Agent*. World Scientific.
- Wang, P., & Li, X. (2018). Self in NARS, an AGI system. *Frontiers in Robotics and AI*, 5, 20.
- Bhattacharya, S., & Bhattacharya, S. (2017). An update on memory reconsolidation updating. *Trends in Cognitive Sciences*, 21(8), 531–545.
- Mnemos documentation (2025). making-minds.ai.

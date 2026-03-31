# Action-Perception Loop: Research Report
**Date:** 2026-03-29
**Project:** Associative Memory Architecture
**Purpose:** Ground the Mirror → Action → Observation → Update loop in cognitive science, active inference, and predictive processing theory
**Scope:** Primary sources on active inference, affordances, enactive cognition, prediction error learning, and action selection

---

## Table of Contents

1. [Active Inference and the Free Energy Principle (Friston)](#1-active-inference-and-the-free-energy-principle)
2. [VERSES AI / Renormalizing Generative Models (RGM)](#2-verses-ai--renormalizing-generative-models)
3. [Affordances: Gibson's Ecological Approach](#3-affordances-gibsons-ecological-approach)
4. [Perception-Action Cycles in Cognitive Science](#4-perception-action-cycles-in-cognitive-science)
5. [Prediction Error and Learning](#5-prediction-error-and-learning)
6. [The Action Selection Problem](#6-the-action-selection-problem)
7. [Synthesis: Mapping to the Architecture](#7-synthesis-mapping-to-the-matrix--trees--mirror-architecture)
8. [Design Implications](#8-design-implications)
9. [Key Citations](#9-key-citations)

---

## 1. Active Inference and the Free Energy Principle

### Core Mechanism

Karl Friston's Free Energy Principle (FEP) proposes a single unifying objective for all processes in biological systems: minimize variational free energy. This is an upper bound on the negative log-probability of sensory states — in plain terms, a proxy for surprise. Systems that minimize free energy are systems that resist unexpected states, which is the statistical definition of remaining alive and coherent.

The formal expression is:

> **F ≥ -ln P(s | m)** (surprise about sensory data s, given model m)

Because surprise itself is intractable to compute directly, variational free energy provides a computable bound via an approximate posterior distribution q(θ) over hidden causes:

> **F = E_q[ln q(θ) - ln P(s, θ | m)]**

This decomposes into two terms: (1) accuracy — how well the model explains observations, and (2) complexity — how much the posterior deviates from the prior. Minimizing free energy thus trades off explanation fidelity against model parsimony.

**Source:** Friston, K.J. (2010). "The free-energy principle: a unified brain theory?" *Nature Reviews Neuroscience*, 11(2), 127–138.

### Active Inference: Action as Prediction Fulfillment

The FEP addresses perception and action symmetrically. Prediction error can be reduced in two ways:

1. **Perception route:** Update the generative model to better explain incoming data (change the prediction to fit the world).
2. **Action route:** Change the world to match the prediction (act to make the prediction true).

This reframes action in a non-standard way. In classical motor control, a command is sent and the motor system executes it. In active inference, action works differently: the agent forms a *proprioceptive prediction* (the expected sensory state of having moved to position X), and then the classical reflex arc simply acts to fulfill that prediction. There is no separate "motor command" — only a prediction that gets resolved through movement.

Friston describes this as "predictions not commands": descending signals from cortex are predictions of the sensory consequences of movement, not instructions. The motor system merely acts to reduce the proprioceptive prediction error.

**Source:** Friston, K.J. et al. (2012). "Predictions not commands: active inference in the motor system." *Brain Structure and Function*, 218(3), 611–643.

This has a critical implication: **action is hypothesis testing**. Every action is, in effect, asking "does the world behave as my model predicts?" High-surprise outcomes falsify the model and trigger learning. Low-surprise outcomes confirm and consolidate it.

### The Process Theory: Neural Implementation

The 2017 Process Theory paper (Friston et al.) demonstrates that gradient descent on variational free energy reproduces a remarkable range of known neural phenomena: repetition suppression, mismatch negativity, violation responses, place-cell phase precession, theta-gamma coupling, evidence accumulation, race-to-bound dynamics, and transfer of dopamine responses.

The paper establishes that action, perception, and learning all minimize the same quantity — variational free energy. This unification is the strongest case for the FEP as a design principle.

**Source:** Friston, K.J., FitzGerald, T., Rigoli, F., Schwartenbeck, P., & Pezzulo, G. (2017). "Active Inference: A Process Theory." *Neural Computation*, 29(1), 1–49.

### The Markov Blanket: Agent Boundaries

A Markov blanket is a statistical concept: a set of nodes that renders internal states conditionally independent of external states. In the FEP, a Markov blanket defines the *boundary* of an agent. Blanket states divide into sensory states (external → internal influence) and active states (internal → external influence).

This formalizes what it means to be a distinct agent with a boundary from the world — not a physical boundary, but an informational one. Crucially, Markov blankets can be nested: an agent can be composed of sub-agents (cells, brain regions), each with their own blanket, and can itself be nested inside larger systems.

**Source:** Kirchhoff, M., Parr, T., Pezzulo, G., Friston, K., & Kiverstein, J. (2018). "The Markov blankets of life: autonomy, active inference and the free energy principle." *Journal of The Royal Society Interface*, 15(138), 20170792.

### Architecture Mapping

| FEP Concept | Associative Memory Architecture |
|-------------|--------------------------------|
| Generative model | The entire Matrix + Trees structure (the agent's beliefs about the world) |
| Sensory prediction error | Mismatch between Mirror's prediction and the returned tool result |
| Perception route (update model) | Matrix edge weight updates, reconsolidation window |
| Action route (change world) | Tool calls, messages — acting to fulfill predicted outcomes |
| Markov blanket | The agent's boundary: sensory inputs + active outputs (tool calls) |
| Proprioceptive prediction | Mirror's prediction of what a specific action will return |

---

## 2. VERSES AI / Renormalizing Generative Models

### Core Mechanism

VERSES AI (led by Karl Friston) published "From pixels to planning: scale-free active inference" (arXiv:2407.20292, July 2024), introducing Renormalizing Generative Models (RGMs). This is the most architecturally precise extension of active inference into a scalable computational system.

The key insight is the **renormalization group**: the same functional form of belief updating is conserved across all levels of a hierarchy. Just as physical renormalization describes how the same dynamical equations hold at different scales (particle → nucleus → atom → molecule → material), RGMs have the property that the inference algorithm is identical at every level of the generative model hierarchy.

This is achieved by structuring the model as a **discrete state-space model with paths as latent variables**, generalizing partially observed Markov decision processes (POMDPs). The model learns compositionality over space and time, generating orbits (sequences of states) at increasing temporal depths.

**Source:** Friston, K.J. et al. (2024). "From pixels to planning: scale-free active inference." *Frontiers in Network Physiology* / arXiv:2407.20292.

### Sparse Belief Updating: Only Active Pathways

The renormalization group structure means that **only active pathways require belief updating**. At each level of the hierarchy, only those branches of the generative model that are actually engaged (i.e., those on the current belief trajectory) need to compute. Inactive pathways remain dormant.

This is computationally crucial: it transforms what could be an exponentially expensive Bayesian inference problem into a sparse, locally active operation. The hierarchy self-selects which sub-models to engage based on current context.

This is identified as the deepest theoretical match for spreading activation in the Associative Memory Architecture: both systems propagate activation/belief only through contextually relevant pathways.

### RGM Applications and Performance

The paper demonstrates RGMs on:
- Image classification: 99.8% accuracy on MNIST using 90% less training data than standard methods
- Movie and music compression and generation
- Atari-like game learning

All using a single, unified variational architecture — no task-specific engineering.

### Architecture Mapping

| RGM Concept | Associative Memory Architecture |
|-------------|--------------------------------|
| Hierarchical generative model with renormalized inference | Hierarchical Matrix (episodic → semantic → abstract) with shared traversal algorithm |
| Scale-free belief propagation | Spreading activation that is consistent at all node types |
| Sparse updating: only active pathways | Activation only spreads to activated nodes; dormant nodes don't update |
| Paths as latent variables | Tree branches as lived trajectories through the Matrix |
| Compositionality across temporal depths | Fast (episodic) and slow (semantic) consolidation timescales |

---

## 3. Affordances: Gibson's Ecological Approach

### Core Mechanism

James Gibson coined "affordance" in his 1979 book *The Ecological Approach to Visual Perception* to describe what the environment *offers* an animal: not objective properties of objects, nor purely subjective mental representations, but relational possibilities that emerge at the interface of organism and environment.

Gibson's definition: "The affordances of the environment are what it offers the animal, what it provides or furnishes, either for good or ill."

Key properties of affordances:
1. **Relational**: Affordances depend on both the object's properties AND the organism's action capabilities. A chair affords sitting for a human but not for a mouse.
2. **Directly perceived**: Gibson argues affordances are perceived directly, not inferred. The organism perceives "sittable" before perceiving "brown, four-legged object." Perception is for action.
3. **Invariant across perspective**: Affordances don't change when the observer moves around an object. They specify stable action possibilities.

### The Direct Perception vs. Computational Debate

Gibson's position clashes with computational/representational theories of cognition. For Gibson, there is no internal model of the world that mediates perception — the information is directly in the optic array. For Friston and the predictive processing camp, perception is fundamentally inference (the brain constructs perceptions from sensory evidence plus prior beliefs).

A synthesis position (Chemero, 2009; Rietveld & Kiverstein, 2014): affordances are not features of objects but of *field of promoted actions* — the landscape of available actions in a situation. This is compatible with predictive processing if we say the generative model encodes affordance predictions, not just object predictions.

**Source:** Gibson, J.J. (1979). *The Ecological Approach to Visual Perception*. Houghton Mifflin.
**Source:** Gibson, J.J. (1977). "The Theory of Affordances." In R. Shaw & J. Bransford (Eds.), *Perceiving, Acting, and Knowing*. Erlbaum.

### Affordances in AI and Graph-Based Representations

Recent AI research has operationalized affordances in graph form. Graph Affordance Networks (e.g., Multi-Object Graph Affordance Network, arXiv:2309.10426) represent affordances as edge types in scene graphs: nodes are objects/states, edges encode action possibilities and their expected outcomes.

An affordance in graph terms: a directed edge (context_node) --[action_type: expected_outcome]--> (result_node). This is structurally identical to the tool-use edges in the Associative Memory Architecture.

### Architecture Mapping

| Gibson Concept | Associative Memory Architecture |
|----------------|--------------------------------|
| Affordance as action possibility | Edge type: (context) --[action]--> (expected_result) |
| Relational (organism × environment) | Affordance depends on agent's current capabilities (procedural memory) AND context |
| Directly perceived | Tree branches activate affordance-edges through spreading activation — no explicit reasoning required |
| Perception is FOR action | Matrix doesn't represent the world passively; it represents it in terms of what can be DONE |
| Ecological niche of actions | The "canopy" of available tool calls reachable from the current activation focus |

---

## 4. Perception-Action Cycles in Cognitive Science

### Neisser's Perceptual Cycle (1976)

Ulric Neisser's *Cognition and Reality* (1976) introduced the perceptual cycle as a model of how cognition is fundamentally action-oriented and world-embedded:

```
        SCHEMA
       /       \
directs        modifies
     /           \
EXPLORATION → ENVIRONMENT
(action)      (samples)
```

Three components:
1. **Schema**: An anticipatory structure — a cognitive template of what to expect. It directs where to look and what to do.
2. **Exploration**: Active sampling of the environment guided by the schema. NOT passive reception — the organism acts to obtain information.
3. **Environment**: Returns information that modifies the schema.

The cycle is perpetual: the updated schema directs new exploration, which yields new environmental samples, which further update the schema.

The key insight: **cognition is not a static lookup but a continuous sensorimotor loop**. Knowledge is not stored propositions but *anticipatory structures* that guide action and are updated by its results.

**Source:** Neisser, U. (1976). *Cognition and Reality: Principles and Implications of Cognitive Psychology*. W.H. Freeman.

### Perceptual Cycle in High-Stakes Domains

The perceptual cycle has become influential in aviation safety and naturalistic decision-making research (Banks et al., 2021, *Human Factors and Ergonomics in Manufacturing*). In pilots, mismatches between schema and environment are the primary cause of "situation awareness" failures — the schema becomes frozen (locked to an outdated prediction) and new evidence fails to update it. This is directly analogous to what happens when an AI agent's internal model drifts from reality.

### Enactive Cognition: Varela, Thompson, Rosch (1991)

*The Embodied Mind: Cognitive Science and Human Experience* (MIT Press, 1991) is the founding text of enactivism. The core claim: cognition is not the processing of pre-given representations but the *enactment* of a world through embodied action.

The Santiago school (Maturana & Varela, 1980): living systems are *autopoietic* — they self-produce and maintain their own organization through structural coupling with the environment. Cognition is not something a brain "does" — it is the process of life itself. Every cognizing system is structurally coupled with its medium through sensorimotor interaction.

Enactive principle: **perception is for action, and action shapes perception**. There is no world-in-itself that cognition represents; the world perceived is the world brought forth by the organism's way of interacting with it.

**Source:** Varela, F.J., Thompson, E., & Rosch, E. (1991). *The Embodied Mind: Cognitive Science and Human Experience*. MIT Press.
**Source:** Maturana, H.R. & Varela, F.J. (1980). *Autopoiesis and Cognition: The Realization of the Living*. Reidel.

### Architecture Mapping

| Perceptual Cycle Concept | Associative Memory Architecture |
|--------------------------|--------------------------------|
| Schema (anticipatory structure) | Mirror layer: current predictive model of what to expect |
| Exploration (active sampling) | Tree growth: branching into memory to find/test paths; tool calls to sample the world |
| Environment (returns samples) | Tool results, user messages, sensor data — episodic nodes added to tips of trees |
| Schema modification | Matrix edge weight updates, consolidation of new patterns |
| Enactive coupling | The agent's matrix IS its niche — what it can perceive is shaped by what it has acted on before |

---

## 5. Prediction Error and Learning

### Predictive Coding: Rao and Ballard (1999)

The computational neuroscience foundation of predictive processing is Rao and Ballard's 1999 *Nature Neuroscience* paper on visual cortex. Their model:

- Feedback connections (higher → lower cortical areas): carry **predictions** of lower-level activity
- Feedforward connections (lower → higher): carry **prediction errors** (actual - predicted)
- Result: simple-cell-like receptive fields emerge spontaneously; extra-classical receptive-field effects (end-stopping) appear as side effects of error transmission

This means the brain never transmits raw sensory data up the hierarchy — it only transmits the *error signal* (what was unexpected). This is computationally efficient: expected signals are suppressed; only surprises propagate.

**Source:** Rao, R.P.N. & Ballard, D.H. (1999). "Predictive coding in the visual cortex: a functional interpretation of some extra-classical receptive-field effects." *Nature Neuroscience*, 2(1), 79–87.

### Precision Weighting: The Learning Rate Mechanism

Prediction errors are not treated equally. They are **precision-weighted** — scaled by the estimated reliability of the sensory channel. High-precision (reliable) prediction errors get amplified; low-precision (noisy) errors get attenuated.

Precision weighting is proposed to be the neural substrate of *attention*: attending to a channel means increasing the precision of its prediction errors. This is accomplished neurobiologically by dopaminergic modulation of prediction error units.

Critically for learning: **the learning rate is proportional to prediction error magnitude scaled by precision**. Large, precise prediction errors produce large parameter updates. Small or imprecise errors produce negligible updates. Surprise drives learning.

**Source:** Kok, P. et al. (2020). "Precision weighting of cortical unsigned prediction error signals benefits learning, is mediated by dopamine, and is impaired in psychosis." *Molecular Psychiatry*, 26, 5152–5164.

### Dopamine as Prediction Error Signal: Schultz (1997)

Wolfram Schultz's landmark 1997 Science paper ("A Neural Substrate of Prediction and Reward") provided physiological evidence that dopamine neurons in primates report reward prediction errors, not raw rewards:

- **Unexpected reward**: dopamine neurons fire (positive prediction error)
- **Expected reward occurs**: no dopamine change (prediction error = 0)
- **Expected reward omitted**: dopamine suppression (negative prediction error)

This maps directly onto temporal difference (TD) learning in reinforcement learning. The signal is: how much better (or worse) was this than predicted?

The 2016 review (Schultz, "Dopamine reward prediction error coding," *Dialogues in Clinical Neuroscience*) extends this to more complex tasks, showing prediction errors across multiple timescales and hierarchical levels.

**Source:** Schultz, W., Dayan, P., & Montague, P.R. (1997). "A Neural Substrate of Prediction and Reward." *Science*, 275(5306), 1593–1599.

### Memory Reconsolidation: The Write Window

Nader, Schafe, and LeDoux (2000) published a landmark finding in *Nature*: fear memories, when reactivated (retrieved), return to a *labile state* requiring new protein synthesis for reconsolidation. Blocking protein synthesis (with anisomycin) in the amygdala shortly after memory reactivation produces amnesia — even for memories formed weeks earlier.

This demonstrates that memory is not a fixed inscription. Every retrieval creates a **reconsolidation window** — a brief period in which the memory is plastic, updatable, and erasable. The window requires prediction error as its trigger: a memory retrieved in the absence of any new information does not reconsolidate to the same degree as one retrieved in a context that generates new prediction errors.

The reconsolidation window is the neuroscience of "learning from experience": the memory system uses the moment of retrieval + surprise to update stored representations.

**Source:** Nader, K., Schafe, G.E., & LeDoux, J.E. (2000). "Fear memories require protein synthesis in the amygdala for reconsolidation after retrieval." *Nature*, 406(6797), 722–726.

### Barrett (2025): Predictive Emotions as Allostatic Actions

Barrett et al.'s 2025 paper "The Theory of Constructed Emotion: More Than a Feeling" (*Perspectives on Psychological Science*) updates the Theory of Constructed Emotion to frame emotions as fundamentally allostatic rather than merely affective.

The key 2025 advance: The brain's efferent copies of allostatic control signals simultaneously:
1. Drive visceral motor control (regulate the body)
2. Produce interoceptive predictions (create the felt sense of the body)
3. Construct emotional experiences as "action predictions with body budget significance"

Emotions are not readouts of physiological states — they are **forward predictions about resource costs of upcoming actions**. The feeling of "anxiety before a presentation" is not a reaction to a threat; it is the brain's predictive action plan for the anticipated metabolic demands of the performance.

This grounds the Mirror layer's predictive function in allostasis: the Mirror doesn't just predict cognitive outcomes; it predicts the *energy cost* and *survival relevance* of possible actions. This is why emotional priors guide action selection.

**Source:** Barrett, L.F. et al. (2025). "The Theory of Constructed Emotion: More Than a Feeling." *Perspectives on Psychological Science*.
**Source:** Barrett, L.F. (2017). "The theory of constructed emotion: an active inference account of interoception and categorization." *Social Cognitive and Affective Neuroscience*, 12(1), 1–23.

### Architecture Mapping

| Learning Mechanism | Associative Memory Architecture |
|--------------------|--------------------------------|
| Prediction error signal | surprise = |predicted_outcome - actual_outcome| |
| Precision weighting | Confidence score on edges gates learning magnitude |
| Prediction error = 0 → reinforce | Low surprise → strengthen existing edges (confirmation) |
| Prediction error > threshold → update | High surprise → reconsolidation window opens, edges update |
| Dopamine prediction error = learning rate modulator | surprise variable directly sets edge update magnitude |
| Reconsolidation window (Nader 2000) | prediction_error > threshold triggers write window |
| Barrett's allostatic predictions | Mirror assigns emotional/resource-cost priors to action candidates |

---

## 6. The Action Selection Problem

### Expected Free Energy: The Unifying Objective

In active inference, action selection (policy selection) is governed by **expected free energy (EFE)** — the predicted free energy of a policy *before* it is executed. A policy is a sequence of actions; the agent selects the policy with the lowest expected free energy.

EFE decomposes into two terms (Friston et al., 2015, "Active inference and epistemic value"):

> **G(π) = Epistemic value + Pragmatic value**

Where:
- **Epistemic value** = expected information gain = expected reduction in uncertainty about the world's hidden states = curiosity
- **Pragmatic value** = expected alignment with prior preferences = goal satisfaction = exploitation

This gives active inference its elegant resolution of the exploration-exploitation dilemma: **epistemic foraging continues until information gain approaches zero, then exploitation dominates**. The agent is intrinsically curious in proportion to its uncertainty, and pragmatically goal-directed in proportion to its confidence.

**Source:** Friston, K.J. et al. (2015). "Active inference and epistemic value." *Cognitive Neuroscience*, 6(4), 187–214.

### Hierarchical Policy Selection

Pezzulo, Rigoli, and Friston (2018, "Hierarchical Active Inference: A Theory of Motivated Control," *Trends in Cognitive Sciences*) extend EFE to hierarchical generative models. At each level:

- Higher levels specify **prior preferences** that constrain lower-level policies
- The precision of top-down preferences is modulated by motivational context (importance, urgency)
- Lower levels unfold the abstract goal into concrete action sequences

This produces goal-directed behavior without explicit reward engineering: the agent's goals are encoded as probability distributions over preferred future states, and it selects actions that make those futures most likely.

### Temporal Depth: Planning Through Rollouts

Friston and Friston (2017, "Deep temporal models and active inference," *Neuroscience & Biobehavioral Reviews*) introduce temporal depth into the generative model. Higher hierarchical levels operate at slower timescales; each transition at a higher level "unrolls" into a sequence of transitions at the level below.

This creates a natural planning mechanism: the agent can simulate (mentally "rollout") possible futures at multiple timescales, evaluating their expected free energy before committing to action. At the highest level, abstract goals; at the lowest level, moment-to-moment actions.

The planning process is Bayes-optimal — it is simply inference about the future, using the same algorithm as inference about the present.

**Source:** Friston, K., & Friston, D. (2017). "Deep temporal models and active inference." *Neuroscience & Biobehavioral Reviews*, 90, 486–501.

### The Graphical Brain: Belief Propagation as Neural Architecture

Friston and Parr (2018, "The graphical brain: Belief propagation and active inference," *Network Neuroscience*) formalize active inference as message passing on a **factor graph**. In factor graphs:

- Variables are nodes
- Factors (constraints between variables) are square nodes connected to variables
- Inference is performed by passing messages along edges

The biological claim: neural activity IS message passing on a factor graph. Ascending signals carry prediction errors; descending signals carry predictions. The precision-weighted prediction error IS the message passed between nodes.

This is the most concrete connection between active inference and graph-based computation: the brain is, formally, a belief propagation machine running on a hierarchical factor graph.

**Source:** Friston, K.J. & Parr, T. (2018). "The graphical brain: Belief propagation and active inference." *Network Neuroscience*, 1(4), 381–414.

### Architecture Mapping

| Action Selection Concept | Associative Memory Architecture |
|--------------------------|--------------------------------|
| Expected free energy (EFE) | Mirror evaluates action candidates by (expected information gain) + (expected goal alignment) |
| Epistemic value | Mirror spawns speculative tree branches to explore before committing to action |
| Pragmatic value | Mirror's prior preferences guide which branch to pursue |
| Hierarchical policy selection | Mirror → Tree → Tool calls (abstract goal → concrete action) |
| Temporal depth / mental rollout | Mirror runs exploratory trees (speculation) before committing to a real action |
| Factor graph belief propagation | Spreading activation through the Matrix IS message passing on a semantic factor graph |

---

## 7. Synthesis: Mapping to the Matrix / Trees / Mirror Architecture

### The Complete Loop

Every theory in this report converges on the same fundamental cycle. Here is the unified loop, labeled by source:

```
┌─────────────────────────────────────────────────────────────┐
│                      MIRROR (Layer 3)                        │
│  • Holds generative model of context [Friston 2010]         │
│  • Carries predictive emotions / allostatic priors          │
│    [Barrett 2025]                                           │
│  • Evaluates action candidates by Expected Free Energy       │
│    [Friston 2015]                                           │
│  • Can run "deep" speculative trees to simulate before       │
│    acting [Friston & Friston 2017]                          │
└──────────────────┬──────────────────────────────────────────┘
                   │ Prior preferences + epistemic goal
                   │ (descending predictions)
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                      TREES (Layer 2)                         │
│  • Tree growth = exploration / action selection             │
│    [Neisser 1976: directed exploration]                     │
│  • Affordance edges = what actions are available from here  │
│    [Gibson 1979]                                            │
│  • Sparse activation: only relevant branches fire           │
│    [RGM: only active pathways update]                       │
│  • Tree tip reaching beyond matrix = tool call              │
│    (action as world-directed tree growth)                   │
└──────────────────┬──────────────────────────────────────────┘
                   │ Action executed
                   ▼
                 WORLD
                   │ Result observed
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                      PERCEPTION                              │
│  • Tool result encoded as episodic node                     │
│  • Causal edge added: action ──caused──> result             │
│  • Neisser cycle: environment modifies schema               │
└──────────────────┬──────────────────────────────────────────┘
                   │ Ascending prediction error
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                      COMPARISON                              │
│  • prediction_error = |predicted - actual|                  │
│  • Precision-weighted by confidence [Rao & Ballard 1999]    │
│  • Dopamine-analog signal: was this better or worse than    │
│    predicted? [Schultz 1997]                                │
└──────────────────┬──────────────────────────────────────────┘
                   │ Error signal
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                      UPDATE (Matrix Layer 1)                 │
│  • Low error: reinforce edges (Hebbian)                     │
│  • High error > threshold: reconsolidation window           │
│    [Nader 2000]: edges become plastic, update               │
│  • Over time: episodic patterns promoted to semantic        │
│    nodes = procedural skill emergence                       │
└─────────────────────────────────────────────────────────────┘
```

### The Two Paths of Free Energy Minimization

Friston's FEP specifies exactly the architecture's two update directions:

- **Perception route (Matrix update):** Update edge weights and node activations to better predict the world. This is what happens when prediction error flows back to update the Matrix.
- **Action route (Tree/Tool):** Change the world (or sample new information) to fulfill predictions. This is what happens when Mirror's predictions direct tree growth toward tool calls.

The architecture already has this dual-path structure. The FEP names it and provides the mathematical justification.

### Three Timescales

The literature reveals three distinct timescales operating in the architecture:

1. **Fast (milliseconds to seconds):** Spreading activation, tree traversal, immediate prediction error. Corresponds to online inference and working memory.
2. **Medium (session duration):** Episodic encoding, session-level learning, early reconsolidation. Corresponds to the hippocampal memory trace.
3. **Slow (across sessions):** Semantic consolidation, procedural node emergence, weight stabilization. Corresponds to cortical long-term memory.

This maps to the RGM's hierarchical timescales: higher levels in the hierarchy operate slower and encode more abstract, stable representations.

### What is "the Mirror" Formally?

The Mirror layer is, in formal terms:
- A **higher-level factor** in the agent's generative model
- Carrying **prior preferences** over future states (pragmatic value)
- Carrying **epistemic uncertainty estimates** (epistemic value)
- Running **mental rollouts** (deep temporal active inference) to simulate consequences before acting
- Encoding **predictive emotions** as allostatic action priors (Barrett 2025)

The Mirror is not a separate system from the Matrix — it is the apex of the generative hierarchy, the most abstract level of the same graph structure, operating at the slowest timescale.

---

## 8. Design Implications

### Implication 1: Action as Tree Growth — Confirmed

The question "is action just tree growth outward into the world?" (from `world-integration.md`) has a clear answer from the literature: **yes, and this is correct**. In active inference, action IS a form of inference — it's the same gradient descent process applied to proprioceptive states. Tree growth outward (toward tool calls) is the same process as tree growth inward (toward memory nodes). The architecture's unification of these two directions is not a simplification — it is formally correct.

### Implication 2: Affordance Edges Should Be First-Class

Based on Gibson (1979) and the AI affordance graph literature, the architecture should explicitly represent **affordance edges** as a node type: edges from context nodes to available action nodes, weighted by expected success rate. Currently tool calls are implicit in the Tree layer. Making affordance-edges explicit allows:
- The Mirror to query "what can I do from here?"
- Procedural learning to update affordance weights based on action outcomes
- Transfer: affordances activated by similar contexts via associative links

### Implication 3: The Reconsolidation Gate is Well-Founded

The design in `world-integration.md` (prediction_error > threshold → write window opens) maps exactly to Nader et al. (2000). The threshold should be calibrated to avoid both:
- **Over-plasticity**: updating edges from noise (too low a threshold)
- **Rigidity**: failing to update from genuine surprises (too high a threshold)

The precision-weighting mechanism from predictive coding (Rao & Ballard 1999) suggests the threshold is not fixed — it should be modulated by the *confidence* of the prior. High-confidence priors require larger prediction errors to trigger reconsolidation.

### Implication 4: Epistemic Foraging as Default Tree Behavior

When the Mirror has high uncertainty (low-confidence activation in the Matrix), the appropriate behavior is epistemic foraging — tree growth oriented toward information-gathering rather than goal-completion. This is already implicit in the architecture but should be made explicit:

- Low Mirror confidence → EFE strongly weighted toward epistemic value → trees expand laterally (explore)
- High Mirror confidence → EFE weighted toward pragmatic value → trees grow directionally (exploit)
- This produces the exploration-exploitation balance automatically from the EFE decomposition

### Implication 5: RGM's Sparse Updating Justifies the Architecture's Lazy Propagation

RGMs demonstrate that only active pathways need belief updating — which justifies (and names) the architecture's spreading activation approach. Inactive Matrix nodes remain unchanged during a session. Only nodes that are "lit" by spreading activation participate in inference and learning. This is not a simplification but a computational necessity — it is what makes the architecture tractable.

### Implication 6: The Mirror Needs an Allostatic Prior Layer

Barrett (2025) argues that emotions are allostatic action predictions — they assign resource costs to prospective actions before execution. The Mirror should carry not just "what outcome do I expect?" but "what is the metabolic/resource cost of this action path?" For an AI agent, "metabolic cost" translates to:
- Computational tokens consumed
- Latency of different tool paths
- Risk of error propagation (high-cost failures)
- User trust/relationship cost of wrong actions

These are the agent's "body budget" equivalents. Building these into Mirror priors gives the architecture intrinsic motivation to prefer efficient, low-risk paths — which matches observed good agent behavior.

### Implication 7: Hierarchical Goal Specification

Pezzulo et al. (2018) on hierarchical active inference suggests the Mirror should represent goals at multiple abstraction levels simultaneously:
- High-level: Abstract intent ("help the user solve this problem")
- Mid-level: Current sub-task ("gather information about X")
- Low-level: Next action ("call web_search with query Y")

Each level constrains the level below through precision-weighted prior preferences. This is already implicit in the Mirror's role but should be made explicit in the data model.

---

## 9. Key Citations

All sources cited in this report, organized by section:

### Active Inference / FEP
- Friston, K.J. (2010). "The free-energy principle: a unified brain theory?" *Nature Reviews Neuroscience*, 11(2), 127–138. PMID: 20068583.
- Friston, K.J. et al. (2012). "Predictions not commands: active inference in the motor system." *Brain Structure and Function*, 218(3), 611–643. PMID: 23129312.
- Friston, K.J., FitzGerald, T., Rigoli, F., Schwartenbeck, P., & Pezzulo, G. (2017). "Active Inference: A Process Theory." *Neural Computation*, 29(1), 1–49. PMID: 27870614.
- Friston, K.J. & Parr, T. (2018). "The graphical brain: Belief propagation and active inference." *Network Neuroscience*, 1(4), 381–414. PMID: 29417960.
- Kirchhoff, M., Parr, T., Pezzulo, G., Friston, K., & Kiverstein, J. (2018). "The Markov blankets of life." *Journal of The Royal Society Interface*, 15(138). PMID: 29343629.

### VERSES / RGM
- Friston, K.J. et al. (2024). "From pixels to planning: scale-free active inference." arXiv:2407.20292. Frontiers in Network Physiology. PMC12217590.

### Expected Free Energy / Action Selection
- Friston, K.J. et al. (2015). "Active inference and epistemic value." *Cognitive Neuroscience*, 6(4), 187–214. PMID: 25689102.
- Pezzulo, G., Rigoli, F., & Friston, K. (2018). "Hierarchical Active Inference: A Theory of Motivated Control." *Trends in Cognitive Sciences*, 22(4), 294–306. PMID: 29475638.
- Friston, K., & Friston, D. (2017). "Deep temporal models and active inference." *Neuroscience & Biobehavioral Reviews*, 90, 486–501. PMID: 28416414.

### Affordances
- Gibson, J.J. (1977). "The Theory of Affordances." In Shaw, R. & Bransford, J. (Eds.), *Perceiving, Acting, and Knowing*. Erlbaum.
- Gibson, J.J. (1979). *The Ecological Approach to Visual Perception*. Houghton Mifflin.

### Perceptual Cycle / Enactive Cognition
- Neisser, U. (1976). *Cognition and Reality*. W.H. Freeman.
- Varela, F.J., Thompson, E., & Rosch, E. (1991). *The Embodied Mind*. MIT Press.
- Maturana, H.R. & Varela, F.J. (1980). *Autopoiesis and Cognition*. Reidel.

### Predictive Coding
- Rao, R.P.N. & Ballard, D.H. (1999). "Predictive coding in the visual cortex." *Nature Neuroscience*, 2(1), 79–87. PMID: 10195184.
- Kok, P. et al. (2020). "Precision weighting of cortical unsigned prediction error signals." *Molecular Psychiatry*, 26, 5152–5164.

### Dopamine / Prediction Error
- Schultz, W., Dayan, P., & Montague, P.R. (1997). "A Neural Substrate of Prediction and Reward." *Science*, 275(5306), 1593–1599. PMID: 9054347.

### Memory Reconsolidation
- Nader, K., Schafe, G.E., & LeDoux, J.E. (2000). "Fear memories require protein synthesis in the amygdala for reconsolidation after retrieval." *Nature*, 406(6797), 722–726. PMID: 10963596.

### Barrett / Constructed Emotion
- Barrett, L.F. (2017). "The theory of constructed emotion: an active inference account of interoception and categorization." *Social Cognitive and Affective Neuroscience*, 12(1), 1–23. PMID: 27798257.
- Barrett, L.F. et al. (2025). "The Theory of Constructed Emotion: More Than a Feeling." *Perspectives on Psychological Science*. PMC12164598.

---

*Report generated by research agent for the Associative Memory Architecture project.*
*Sources: Web searches across Semantic Scholar, PubMed, arXiv, and open access repositories.*
*Cross-reference with:* `design/world-integration.md` *(the primary design doc this research was commissioned to ground)*

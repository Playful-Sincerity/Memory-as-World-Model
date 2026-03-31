# Round 5 Research: Causal Discovery from Interventional Data
**Date:** 2026-03-29
**Purpose:** Understand how to upgrade the Associative Memory Architecture from Layer 1 (PMI-based association) to Layers 2 and 3 (causal and counterfactual knowledge) through tool use and agent experience
**Scope:** Pearl's hierarchy applied, causal discovery algorithms, time-series methods, interventional learning, practical libraries, causal knowledge graphs, counterfactual reasoning, consolidation-phase integration
**Word count:** ~4500 words

---

## Framing: The Exact Problem

The architecture currently has a Matrix of nodes connected by PMI-weighted edges — pure co-occurrence statistics. Round 4 confirmed (stream-1b-damasio-tulving-pearl.md) that this is Pearl's Layer 1: the agent can ask "how often do A and B co-occur?" but cannot answer "what happens if I do X?" or "what would have happened if I had done Y instead?"

Tool use changes this. Every time the agent calls a tool, it performs a micro-experiment: it intervenes on the world and observes the result. This is exactly the structure of do-calculus: `do(X=x)` → observe `Y`. The question this research answers is: **how do we translate raw tool-use episodes into causal edges in the graph?**

---

## Topic 1: Pearl's Causal Hierarchy — Applied

### The Three Layers, Formally

Pearl's Causal Hierarchy (PCH) defines three qualitatively distinct types of inference, separated by what data and model each requires:

**Layer 1 — Association (Seeing):** `P(Y | X)`
Conditional probability from observational data. A and B co-occur — does knowing A happened give information about B? PMI edges encode exactly this. The agent can ask "how often does searching for X result in Y?" but cannot distinguish causation from confounding.

**Layer 2 — Intervention (Doing):** `P(Y | do(X))`
What happens to Y if I forcibly set X to a particular value, breaking its normal causal parents? This requires either a randomized experiment (breaking the observational distribution) or a structural causal model (SCM) with a known graph that lets you apply the do-calculus identifiability rules.

Critically: tool use IS a do-operator. When the agent calls a search tool, it does not passively observe a search happening — it forces a search to happen and then observes the result. This is `do(search=query)`, producing `P(result | do(search=query))`.

**Layer 3 — Counterfactual (Imagining):** `P(Y_{x'} | X=x)`
What would Y have been if X had been x', given that we observed X was actually x? Requires a fully specified SCM — not just the graph, but the structural equations and noise distributions. This is the hardest layer and generally not fully achievable without explicit modeling.

### The Hierarchy Theorem

The Causal Hierarchy Theorem (Bareinboim, Forney, Pearl; technical report r60 at causalai.net) proves that associations computed from Layer 1 data cannot, in general, answer Layer 2 interventional queries, and Layer 2 data cannot answer Layer 3 counterfactual queries. The layers are strictly separated. This is the formal reason why PMI-only architectures cannot reason about interventions — it is not a practical limitation but a mathematical one.

### How an Agent Ascends the Hierarchy

The path from Layer 1 to Layer 2 for our architecture:
1. Agent accumulates episodes of the form `(action, context, observed_result)`
2. Tool calls provide interventional data: the context is controlled (same query, similar state), the action is fixed (`do(tool=X)`), and the result varies
3. Consistent patterns across episodes — "whenever I call tool X in context C, result R follows" — are candidates for causal edges
4. Temporal precedence (the call always precedes the result) gives directionality
5. Absence of confounders is more achievable in tool use than in pure observation because the agent controls the intervention

The Causal Reinforcement Learning (CRL) literature (Bareinboim; crl.causalai.net) formalizes this. CRL defines nine core tasks for agents that reason causally; the most relevant for our architecture are: **Causal Model Discovery** (learning causal graphs from combined observations and experiments) and **Intervention Optimization** (identifying where to intervene to achieve goals). Both apply directly to an agent using tools.

---

## Topic 2: Causal Discovery Algorithms

### Constraint-Based: PC and FCI

**PC Algorithm** (Spirtes, Glymour, Scheines; foundational text: *Causation, Prediction, and Search*, 2000):
- Starts with a fully connected undirected graph
- Iteratively removes edges by testing conditional independence: edge X—Y is removed if there exists a set Z such that X ⊥ Y | Z
- Orients remaining edges using v-structure (collider) rules
- Produces a Partially Directed Acyclic Graph (PDAG) — a Markov Equivalence Class (MEC), not a unique DAG
- **Limitation:** Assumes causal sufficiency (no hidden common causes). Critically wrong for real agents — almost everything the agent cannot observe could be a confounder.
- **Sample sensitivity:** Conditional independence tests are unreliable with small samples. With fewer than ~30 observations per conditioning set, results are noisy.
- **Computational cost:** Exponential in the maximum degree of the graph due to conditioning set enumeration. Feasible for sparse graphs up to ~50 nodes.

**FCI (Fast Causal Inference):**
- Extends PC to handle latent confounders (causal insufficiency)
- Produces a Partial Ancestral Graph (PAG) using additional edge marks (o->) to represent uncertainty about whether a connection is direct or mediated by a latent variable
- **This is the right algorithm for our architecture.** The agent cannot observe everything — any real-world tool-use context has unobserved factors. FCI handles this correctly.
- GFCI (Ogarrio et al., 2016) combines GES's scoring for skeleton finding with FCI's orientation rules, achieving better accuracy in most simulations than vanilla FCI.
- **Limitation:** Still requires a reasonable number of observations per conditioning set.

### Score-Based: GES and GRaSP

**GES (Greedy Equivalence Search):**
- Starts with the empty graph, adds edges greedily by score improvement (forward phase), then removes edges (backward phase)
- Uses a decomposable score (typically BIC/BDeu)
- Provably consistent under causal sufficiency + faithfulness assumptions
- **Better scalability than PC/FCI** — avoids exponential conditioning sets
- **Small sample:** BIC scores are more stable than conditional independence tests with small n, making GES often preferable with sparse data
- No native latent confounder handling (like PC); use GFCI or RFCI for that

**GRaSP** (recent, ~2022-2023):
- Scalability improvements over GES, demonstrated accuracy on graphs with 100+ variables
- Better handling of non-stationary data

### Continuous Optimization: NOTEARS and GOLEM

**NOTEARS** (Zheng et al., NeurIPS 2018):
- Key innovation: transforms the discrete combinatorial problem (finding a DAG) into a continuous optimization problem using a smooth algebraic characterization of acyclicity: `h(W) = tr(e^{W ⊙ W}) - d = 0`
- Can be solved with standard gradient-based optimization
- **Scalability advantage:** handles larger variable counts than PC/FCI
- **Critical limitation:** A 2021 paper by CausalLens ("Unsuitability of NOTEARS for Causal Graph Discovery") demonstrates serious failure modes — NOTEARS can return non-DAG solutions in practice and is sensitive to initialization. Should not be used uncritically for high-stakes causal claims.
- **Use case for our architecture:** May be appropriate as a fast initial skeleton finder, with results validated by constraint-based methods

**GOLEM** (Ng, Ghassami, Zhang; NeurIPS 2020):
- Improves on NOTEARS by using Gaussian log-likelihood rather than least squares
- Two variants: GOLEM-EV (equal noise variances) and GOLEM-NV (non-equal — more realistic)
- Uses `log|det(I - W)|` as a soft acyclicity regularizer
- Better performance than NOTEARS on non-equal-variance data, which is the realistic case
- Recommendation: initialize GOLEM-NV with GOLEM-EV solution to avoid local optima

### Functional: LiNGAM

**LiNGAM** (Shimizu et al., JMLR 2006; DirectLiNGAM 2011):
- Key insight: if the data-generating process is LINEAR and the noise is NON-GAUSSIAN, the full causal DAG (not just the MEC) is IDENTIFIABLE from observational data — no need for interventions
- DirectLiNGAM uses ICA-like methods or regression-based approaches to recover the full causal ordering
- **Limitation:** Assumes no latent confounders. Fails silently if confounders are present.
- **Small sample:** "High computational complexity and unsatisfied accuracy when the data is high-dimensional or the sample size is too small" (Shimizu lab documentation)
- **Use case for our architecture:** When the agent has enough samples and can reasonably assume linear relationships (e.g., numeric sensor data, metrics), LiNGAM gives the most specific causal answer from observational data alone

### Algorithm Comparison for Our Architecture

| Algorithm | Latent Confounders | Small Samples | Incremental | Best Use Case |
|-----------|-------------------|---------------|-------------|---------------|
| PC | No | Poor (<50 obs) | No (batch) | Baseline; use FCI instead |
| FCI / GFCI | Yes | Moderate | No (batch) | **Best default for general use** |
| GES | No | Better than PC | No (batch) | When confounders unlikely + speed needed |
| NOTEARS | No | OK | Partial (warm start) | Fast skeleton finding only |
| GOLEM | No | OK | Partial | Score-based large graphs |
| LiNGAM | No | Poor | No (batch) | Linear non-Gaussian data |
| PCMCI | No (yes via LPCMCI) | Moderate | No | **Time-series agent episodes** |

**Recommendation for Round 5:** Use **GFCI** as the primary algorithm (handles latent confounders, uses GES for skeleton) over accumulated episodic data during consolidation. Use **PCMCI** for the temporal structure of action sequences. Both are available in causal-learn.

---

## Topic 3: Causal Discovery from Time-Series and Sequential Data

### PCMCI (Runge et al., Science Advances 2019)

PCMCI is specifically designed for time series where variables are highly interdependent and autocorrelated — exactly the structure of agent experience:

**How it works:**
1. **Stage 1 (PC1):** For each variable, use the PC algorithm to identify its most relevant lagged predictors, eliminating spurious autocorrelation-driven edges
2. **Stage 2 (MCI — Momentary Conditional Independence):** Test `X_{t-τ} → Y_t` by conditioning on parents of both `X` and `Y`, controlling for autocorrelation and common drivers

**Key advantages for agent architectures:**
- Handles non-linear data with appropriate conditional independence tests (GPDC, CMIknn)
- Provably correct in the limit under standard assumptions
- **Handles many variables relative to sample points** — critically important since the agent may only have 20-50 episodes for any given tool-use context
- PCMCI+ extends to contemporaneous (same-timestep) relationships
- LPCMCI extends to latent confounders

**Temporal precedence as a free gift:** Because tool calls occur before their results, the direction is often partially known before running any algorithm. `call(tool=X, t=5) → result(t=6)` — the arrow is already oriented. PCMCI formalizes this.

### Granger Causality and Transfer Entropy

**Granger Causality:** Variable Y "G-causes" X if knowing Y's past improves prediction of X's future beyond what X's own past predicts. Formally: `P(X_t | X_{t-1:1}, Y_{t-1:1}) ≠ P(X_t | X_{t-1:1})`.

**Transfer Entropy:** The information-theoretic generalization of Granger causality. For Gaussian variables, they are exactly equivalent (Barnett et al., PubMed PMID 20366183). Transfer entropy is model-free and captures non-linear dependencies.

**For our architecture:** Both methods provide weak causal signals that can be computed efficiently. They work on raw time-series without requiring a full structural model. Transfer entropy from tool call sequences to outcome sequences is a computationally cheap first pass that can identify which tool-use patterns are causally predictive of which outcomes.

**Limitation:** Both are vulnerable to indirect causation (X→Z→Y looks like X→Y) and common causes. They identify Granger-causal not structural-causal relationships. Use as evidence, not ground truth.

---

## Topic 4: Causal Discovery from Interventional Data Specifically

### The Identifiability Advantage

Interventional data breaks the observational equivalence problem. Many DAGs produce identical observational distributions (they form a Markov Equivalence Class) — no observational method can distinguish them. A single intervention can break this equivalence:

If you observe `P(Y|do(X=x)) ≠ P(Y|do(X=x'))` while `P(Y|X=x) = P(Y|X=x')`, you have confirmed that X causes Y rather than a hidden confounder C causing both.

**For tool-use data:** The agent has direct access to `P(result | do(tool_call=x))` across different calls. This is gold-standard interventional data. The challenge is accumulating enough such observations to distinguish signal from noise.

### Active Causal Discovery

The research literature on "active causal learning" or "adaptive experimental design for causal discovery" is directly relevant to how the Mirror should choose which tool calls to make:

**Adaptive Online Experimental Design** (Tirinzoni et al., arXiv 2405.11548, 2024):
- "Track-and-stop" algorithm that adaptively selects interventions using allocation matching
- Selects from a "graph separating system" — a set of interventions that collectively cut every edge at least once
- Establishes problem-dependent upper bounds on expected interventional samples
- Achieves higher accuracy with significantly fewer samples than uniform random intervention

**Active Learning for Optimal Intervention Design** (Squires et al., 2023):
- Causally-informed acquisition function that outperforms random intervention selection
- Information-theoretic bounds for linear causal models
- Demonstrated on biological perturbation data (Perturb-CITE-seq)

**Active Causal Experimentalist — ACE** (arXiv 2602.02451, 2025):
- Uses Direct Preference Optimization (DPO) to train a policy that learns which interventions to prioritize
- Reward function: `R(c,σ) = ΔL + α·w(V_i) + γ·D(V_i, H)` — information gain + node importance + exploration diversity
- Key finding: the learned policy autonomously focused 99.8% of interventions on collider parent nodes — it discovered optimal causal theory strategy from experience alone without explicit instruction
- **70-71% improvement over baselines at 171 episodes** on a 5-node benchmark (p<0.001, Cohen's d≈2)

**Architecture implication:** The Mirror, which currently decides tool call strategies, has a natural role as an active causal learner. Rather than making tool calls reactively, it can learn to choose interventions that are maximally informative about the causal structure of its task domain. This is Pearl's Layer 2 in action — the agent choosing `do(X)` to maximize information about the causal graph.

---

## Topic 5: Practical Libraries and Tools

### causal-learn (CMU CLeaR Group)

Paper: Zheng et al., JMLR 2024 (arXiv 2307.16405).
A Python translation and extension of Tetrad, developed by Kun Zhang's group at CMU.

**Implemented algorithm families:**
- Constraint-based: PC, FCI, RFCI, CDNOD (non-stationary)
- Score-based: GES, FGES, GRaSP
- FCM-based: LiNGAM family (ICA-LiNGAM, DirectLiNGAM, VARLiNGAM, RCD)
- Hidden causal representation learning
- Granger causality
- Permutation-based methods

**For our architecture:** causal-learn is the most comprehensive choice. GFCI and PCMCI (via Tigramite, the companion package) are both available. The library provides easy-to-use APIs that are well-suited to the consolidation pipeline.

### Tigramite (Runge, PIK)

Dedicated Python library for PCMCI and its variants. Supports:
- PCMCI, PCMCI+, LPCMCI (with latent confounders)
- Multiple conditional independence tests (ParCorr for linear, GPDC/CMIknn for non-linear)
- Significance testing via analytic formulas or permutation

**Best choice for temporal episodic data.** The agent's interaction history is a time series: actions at time t, results at time t+δ. Tigramite handles this structure natively.

### DoWhy (Microsoft/PyWhy)

Not a causal discovery library per se — primarily a causal inference library (estimating effect sizes once the graph is known). However:
- Has experimental support for causal discovery integration
- **DoWhy-GCM** extension handles graphical causal models, root cause analysis, and counterfactual queries
- Once causal-learn discovers the graph, DoWhy-GCM can handle the downstream reasoning
- Active PyWhy ecosystem (now independent of Microsoft, community-maintained)

**For our architecture:** Use causal-learn for discovery, DoWhy-GCM for downstream reasoning (effect estimation, root cause analysis, counterfactual queries). They interoperate naturally.

### gCastle (Huawei Noah's Ark Lab)

Python + PyTorch toolbox focused on gradient-based methods. Implements NOTEARS, GOLEM, and neural variants (GraNDAG, GAE, MCSL) that can handle non-linear relationships via neural networks.

**Advantage:** GPU acceleration makes gradient-based methods much faster on large graphs.
**Limitation:** Focuses on newer gradient-based methods; PC/FCI not included.
**For our architecture:** Useful during consolidation for large-scale structure refinement when GPU is available. Not the primary choice.

### Library Recommendation for Our Architecture

| Phase | Library | Algorithm | Rationale |
|-------|---------|-----------|-----------|
| Temporal structure (episodes) | Tigramite | PCMCI+ | Sequential action-result data |
| General causal structure | causal-learn | GFCI | Handles latent confounders |
| Effect estimation | DoWhy-GCM | Backdoor/frontdoor | Once graph known |
| Large-scale refinement | gCastle | NOTEARS/GOLEM | GPU, large graphs |

---

## Topic 6: Causal Knowledge in Knowledge Graphs

### Existing Causal Knowledge Graphs

**CauseNet** (causenet.org):
- 11.6 million causal relations across 12.2 million concepts
- Extracted from ClueWeb12, Wikipedia sentences/lists/infoboxes
- ~83% extraction precision
- Relations are "claimed causal" — linguistically extracted, not experimentally validated
- Available as a downloadable knowledge base
- **For our architecture:** CauseNet can seed initial causal edge candidates. If the agent's graph contains node pairs that CauseNet claims are causally related, those pairs become high-priority targets for causal validation via interventional data.

**CausalKG** (arXiv 2201.03647):
- Hyper-relational graph: causality as a complex relation involving more than two entities
- Supports causal weight, mediator relationships (`hasMediator`), cause/effect types
- Designed for interventional and counterfactual reasoning, not just association
- Edge types include: `causes`, `causedBy`, `causesType`, `causedByType`, `hasMediator`
- **Key architectural insight:** causality requires HYPER-RELATIONS (more than two entities, qualified by context, mediators, and modifiers), not just directed binary edges.

### Edge Typing Architecture for Our Graph

The current architecture uses a single edge type (PMI-weighted co-occurrence). Based on CausalKG and the literature on causal knowledge representation, we need at minimum:

```python
@dataclass
class EdgeType(Enum):
    ASSOCIATION    = "associates_with"   # Layer 1: PMI co-occurrence
    CORRELATION    = "correlates_with"   # Directed association (temporal order known)
    CAUSES         = "causes"           # Layer 2: validated causal direction
    ENABLES        = "enables"          # Causal with precondition semantics
    PREVENTS       = "prevents"         # Negative causal
    COUNTERFACTUAL = "required_for"     # Layer 3: X required for Y to occur
    MEDIATES       = "mediates"         # Causal mediation (X→M→Y)

@dataclass
class CausalEdge:
    source: NodeID
    target: NodeID
    edge_type: EdgeType
    confidence: float      # 0.0–1.0
    sample_count: int      # How many observations support this
    last_validated: datetime
    interventional: bool   # Was this derived from do(X) data or observational?
    context: list[NodeID]  # Conditioning context (prevents spurious causal claims)
```

### Confidence Levels on Causal Claims

A key distinction from associative edges: causal edges must carry uncertainty. A PMI edge strengthens or weakens continuously. A causal edge has an epistemological status:

- **Candidate:** Temporal precedence + consistent co-occurrence (Layer 1 → Layer 2 promotion candidate)
- **Interventional:** Direct do(X) evidence from tool use
- **Confirmed:** Interventional + tested with multiple contexts + passes conditional independence tests
- **Counterfactual:** Full SCM estimated with structural equations (rare, high cost)

This multi-tier confidence structure prevents premature promotion of associative patterns to causal claims.

---

## Topic 7: Counterfactual Reasoning (Pearl's Layer 3)

### What Layer 3 Requires

Counterfactual queries (`P(Y_{x'} | X=x)`) require:
1. A complete Structural Causal Model — not just the graph, but the functional equations `X_i = f_i(PA_i, U_i)` and the noise distributions `P(U_i)`
2. The **abduction-action-prediction** procedure:
   - **Abduction:** Given observed `X=x`, infer the noise values `U` that would produce this observation
   - **Action:** Intervene `do(X=x')` by modifying the structural equation
   - **Prediction:** Forward-run the modified model to compute `Y_{x'}`

Full SCMs are expensive to maintain and require significant data to estimate. However, limited counterfactual reasoning is possible at lower cost:

### Lightweight Counterfactual Approximations

**Counterfactual from causal graph + linear model:** If we know the graph and assume linear relationships, counterfactuals have closed-form expressions. This is feasible for the agent's tool-use domain where relationships are approximately linear (e.g., "more specific query → better result").

**COULDD** (EACL 2024): A method for adapting knowledge graph embeddings to hypothetical premises — models the original world state as a KG, hypothetical changes as edge additions, and infers plausible consequences via logical rules. This is a graph-native approximation to counterfactual reasoning that doesn't require full SCM estimation.

**REMI architecture** (arXiv 2509.06269): A causal schema memory (CSM) for a multimodal lifestyle agent that integrates:
- Personal causal knowledge graph
- Causal reasoning engine
- Schema-based planning module with counterfactual reasoning

REMI demonstrates that causal graphs with a reasoning engine can support "what-if" planning for agents. It performs "goal-directed causal traversals enriched with hypothetical (counterfactual) reasoning."

### Counterfactuals in Planning

The most practical use of Layer 3 reasoning for our architecture is **planning**: "If I had called tool X instead of tool Y, would I have gotten a better result?" This retrospective learning directly improves the Mirror's tool selection strategy.

Implementation sketch:
```python
# After a completed interaction
causal_model.abduction(observed_context)
  → noise_estimates = infer_U_from_observation(observed_X)

# Counterfactual question: what if I had used tool Y instead of tool X?
counterfactual_result = causal_model.intervention(do(tool=Y), noise_estimates)
  → predicted_Y_outcome

# If counterfactual_result > actual_result:
#   Mirror learns: in context C, tool Y is better than tool X
```

This is feasible once the architecture has Layer 2 causal edges established. Layer 3 follows naturally as a planning capability layered on top.

---

## Topic 8: Causal Discovery During Consolidation

### The Consolidation Phase as the Right Time for Causal Discovery

The architecture's consolidation phase (inspired by sleep-based memory consolidation) is precisely the right time to run causal discovery. Evidence from neuroscience:

- Sleep replay in biological systems is not random but biased toward rewarding and salient episodes (already incorporated in improvements-from-round4.md, item 9)
- Memory reactivation during rest generates new knowledge that "extends beyond direct experience" (Nature Scientific Reports 2024)
- Neural networks with sleep-like offline replay learn causal relationships between narrative events (bioRxiv 2025.09.01.673596)

**The CORAL Framework** (KDD 2023, Wang et al.) provides an engineering template: incremental disentangled causal graph learning that separates state-invariant from state-dependent causal structure, updating the graph continuously as new episodes arrive without catastrophic forgetting.

### Proposed Consolidation-Phase Causal Discovery Pipeline

```
CONSOLIDATION CYCLE (runs between interactions, ~"during sleep"):

1. EPISODE SELECTION
   recent_episodes = select_for_replay(
       surprise_weight=0.4,
       value_alignment_weight=0.3,
       reward_signal_weight=0.2,
       exploration_weight=0.1
   )  # Already designed in improvements-from-round4

2. TEMPORAL STRUCTURING
   episode_time_series = extract_action_result_sequences(recent_episodes)
   # Format: [(t, tool_call, context, result), ...]

3. GRANGER/TRANSFER ENTROPY PASS (cheap, fast)
   granger_candidates = compute_granger_causality(episode_time_series)
   te_candidates = compute_transfer_entropy(episode_time_series)
   # Output: ranked list of (node_A, node_B, direction, strength) pairs

4. PCMCI PASS (moderate cost, time-series aware)
   if len(episode_time_series) >= 30:
       pcmci_graph = tigramite.PCMCI_plus(episode_time_series)
       # Handles autocorrelation, identifies lagged causal links

5. GFCI PASS (heavier, handles latent confounders)
   if len(recent_episodes) >= 50:
       cross_episode_data = flatten_to_variable_observations(recent_episodes)
       gfci_graph = causal_learn.GFCI(cross_episode_data)
       # PAG output — partial ancestral graph with latent confounder markers

6. INTERVENTIONAL VALIDATION
   tool_use_episodes = filter(recent_episodes, has_tool_call=True)
   interventional_pairs = extract_do_X_observations(tool_use_episodes)
   # For each (do(X=x), observed_Y) pair:
   # Check if PCMCI/GFCI found X→Y edge; if so, increase confidence
   # If X→Y not in graph but consistently observed: add as causal candidate

7. EDGE PROMOTION
   for (source, target, confidence, interventional) in merged_evidence:
       if source→target in Matrix as ASSOCIATION edge:
           if confidence > PROMOTION_THRESHOLD and interventional:
               upgrade_edge(source, target,
                   from_type=ASSOCIATION,
                   to_type=CAUSES,
                   confidence=confidence,
                   sample_count=n_observations)
       else:
           add_new_causal_edge(source, target, ...)

8. MEMORY FORMATION
   # Newly promoted causal edges become indexed facts
   # High-confidence causal pairs get their own nodes: "X causes Y"
   # These can be traversed, strengthened, and retrieved like any memory
```

### Computational Cost Estimates

**For graphs of 10K-100K nodes:**
The key insight is that causal discovery does not run over the entire graph — it runs over the **recent episode subgraph**, which is much smaller:

- Typical consolidation window: 50-200 recent episodes
- Variables per episode: 10-30 (tool type, query, context tags, result quality, etc.)
- Effective variable count per PCMCI run: 10-30 variables
- **PCMCI on 20 variables, 100 time points: < 1 second** (documented in Tigramite benchmarks)
- **GFCI on 30 variables, 50 observations: 5-30 seconds** (causal-learn documentation)

This is entirely feasible during a consolidation phase that runs between interactions. The full 100K-node graph is not the input to causal discovery — only the local episodic subgraph relevant to recent activity.

**Scaling strategy for larger windows:**
- Divide-and-conquer: run PCMCI on thematic subsets of recent episodes
- Use NOTEARS/GOLEM (via gCastle with GPU) for faster structure estimation over larger variable sets
- CauScale (arXiv 2602.08629, 2025) claims neural causal discovery scaling to 1000 nodes

---

## Synthesis: Recommendations for the Associative Memory Architecture

### (a) Recommended Causal Discovery Approach

**Primary method: GFCI (from causal-learn) + PCMCI+ (from Tigramite), run together during consolidation.**

- GFCI handles the cross-episode causal structure with latent confounder support (PAG output)
- PCMCI+ handles the temporal sequential structure of action-result chains
- Their outputs are complementary: PCMCI gives temporal direction, GFCI gives structural orientation
- Both are available in mature, well-documented Python libraries

**LLM-assisted causal discovery** as a second layer: Recent work (arXiv 2402.01207, MatMcd 2412.13667) shows that LLMs can provide strong causal priors from variable names and context alone, with significantly reduced hallucination when combined with statistical algorithms. The architecture already has an LLM reasoning layer — this is a natural integration. The LLM can vote on causal directions based on semantic knowledge; the algorithm votes based on data; confidence weighted combination produces the final edge.

### (b) Pipeline for Upgrading Associative → Causal Edges

The 8-step pipeline in Topic 8 above is the concrete proposal. Key design decisions:

1. **PMI edges are not replaced — they are annotated.** A PMI edge with temporal precedence becomes a "correlation candidate." A correlation candidate with interventional evidence becomes a "causal candidate." A causal candidate with repeated validation becomes a "confirmed causal edge." The gradient from associative to causal is continuous, not a hard switch.

2. **Interventional data gates the final promotion.** No edge is promoted to `CAUSES` without at least one `do(X)` observation confirming it. This prevents pure observation-driven spurious causal claims.

3. **Confidence scores are first-class.** Every causal edge carries `(confidence: float, sample_count: int, interventional: bool)`. These decay if contradicting evidence arrives and can be boosted by new confirmations.

4. **The Mirror participates as an active causal learner.** During task execution, the Mirror uses the current causal graph to predict which tool calls are most informative (ACE-style active experimental design). After task execution, those predictions are compared to outcomes and the causal model is updated.

### (c) Data Requirements and Computational Costs

**Minimum viable causal discovery:**
- 20-30 observations of a given (tool, context) pair before any causal edge is proposed
- First causal edges should appear after ~100-200 tool use interactions total
- Reliable causal graph over core tool-use patterns: ~500-1000 interactions

**Why this is achievable:**
- PCMCI is specifically designed to handle "many variables relative to samples" — explicitly designed for regimes where p >> n would defeat NOTEARS or GES
- The interventional nature of tool-use data dramatically reduces the sample requirement vs. purely observational causal discovery (the hierarchy theorem works in our favor here — we don't need to identify which direction from observational data alone when the tool call inherently gives us the do operator)
- LLM-provided causal priors further reduce data requirements by narrowing the hypothesis space

**Computational budget per consolidation cycle:**
- Granger/Transfer Entropy pass: < 1 second
- PCMCI+ on 20 variables, 100 episodes: 1-5 seconds
- GFCI on 30 variables, 50 episodes: 5-30 seconds
- Total causal discovery per consolidation: **under 1 minute** for typical use patterns
- Feasible to run at every consolidation; can be throttled to every N cycles if needed

### (d) What is Genuinely Novel Here

**The novelty is not in any single component.** PCMCI exists. GFCI exists. Active causal learning exists. The novelty is in the integration:

1. **Causal knowledge embedded directly in the memory graph, not in a separate causal model.** In conventional causal discovery, you run an algorithm, get a DAG, and use it separately. Here, the causal edges ARE memory. The agent's causal knowledge is queryable, traversable, and updatable in the same way its associative knowledge is. A traversal that crosses a `CAUSES` edge carries fundamentally different information than one crossing an `ASSOCIATION` edge — the agent knows the difference.

2. **Continuous upgrade path from co-occurrence to causation within a single structure.** There is no hard boundary between "the associative memory" and "the causal model." They are the same graph at different confidence tiers. This mirrors how causal knowledge actually develops in humans: a hunch (association) strengthens into a belief (correlation) and ultimately into understanding (causal knowledge) through accumulated experience.

3. **Tool use as the natural do-operator, unifying tool selection and causal learning.** The Mirror's job is to decide which tools to call. The active causal learning literature says you should call the tools that are most informative about the causal structure. These are the same task. A Mirror that understands this is simultaneously improving its causal world model AND using that model to make better decisions — a single loop rather than two separate systems.

4. **Consolidation-phase causal discovery as "sleeping to understand."** The biological inspiration (sleep consolidation → causal knowledge formation from episodic replay) has a direct computational analog. The architecture already has a consolidation phase. Adding PCMCI+GFCI to that phase gives the agent a genuine analog of how biological systems upgrade experience into understanding during sleep.

5. **Counterfactual planning layered on top.** Once causal edges exist in the graph, the abduction-action-prediction procedure becomes a graph traversal operation. "What would have happened if I had called tool Y?" becomes a path query on the causal subgraph. This is not possible with PMI-only edges — and it is precisely what allows the agent to learn from mistakes without repeating them.

---

## Key Citations

| Source | What It Contributes |
|--------|-------------------|
| Pearl & Mackenzie, *The Book of Why* (2018) | Causal hierarchy, ladder of causation, seeing/doing/imagining |
| Bareinboim et al., PCH Technical Report (causalai.net/r60.pdf) | Formal separation proof between hierarchy layers |
| Bareinboim, CRL Tutorial (causalai.net/r65.pdf; crl.causalai.net) | Nine CRL tasks; causal RL framework |
| Spirtes, Glymour, Scheines, *Causation, Prediction, and Search* (2000) | PC algorithm; FCI algorithm |
| Ogarrio et al. (2016) | GFCI — hybrid GES+FCI with latent confounders |
| Zheng et al., NeurIPS 2018 | NOTEARS continuous optimization |
| Ng, Ghassami, Zhang, NeurIPS 2020 | GOLEM likelihood-based structure learning |
| Runge et al., Science Advances 2019 | PCMCI for time-series causal discovery |
| Runge, PMLR 2020 (arXiv 2003.03685) | PCMCI+ contemporaneous + lagged relations |
| Zheng et al., JMLR 2024 (arXiv 2307.16405) | causal-learn library |
| Tirinzoni et al., arXiv 2405.11548 (2024) | Adaptive online experimental design for causal discovery |
| Squires et al., 2023 (arXiv 2209.04744) | Active learning for optimal intervention design |
| ACE paper, arXiv 2602.02451 (2025) | DPO-based active causal experimentalist |
| Wang et al., KDD 2023 (arXiv 2305.10638) | CORAL incremental online causal graph learning |
| Jaimini & Sheth, arXiv 2201.03647 (2022) | CausalKG hyper-relational causal graph |
| CauseNet (causenet.org) | 11.6M causal relations knowledge base |
| COULDD, EACL 2024 | Counterfactual reasoning in KG embeddings |
| REMI, arXiv 2509.06269 | Causal schema memory for agent planning |
| MatMcd, arXiv 2412.13667 (2024) | Tool-augmented LLM + statistical causal discovery |
| CausalLens (2021/2025) | NOTEARS limitations and failure modes |

---

## Open Questions Raised by This Research

1. **What is the minimum sample count for GFCI to produce trustworthy edges?** The literature says GFCI outperforms FCI in simulations but doesn't give clear n thresholds. Empirical testing on synthetic tool-use data needed.

2. **How do we handle the "unknown intervention target" problem?** When multiple tool calls happen in close temporal proximity, which one caused the observed result? Methods for causal discovery with unknown intervention targets exist (arXiv: Efficient Causal Structure Learning from Multiple Interventional Datasets with Unknown Targets) but need evaluation.

3. **Can the Mirror's active causal learning strategy be formalized as a Bayesian update?** The ACE framework uses DPO; a Bayesian approach to intervention selection (maintaining a posterior over causal graphs) may be more principled. Bayesian causal discovery (BCCD, etc.) is an active research area.

4. **How do causal edges interact with pruning?** Current pruning is distance-based (far from focus → evict). Should causal edges have protected status? A `CAUSES` edge between two otherwise-distant nodes carries more structural importance than a weak PMI edge between close nodes.

5. **What is the right representation for a counterfactual node?** If the agent retrospectively infers "if I had done X differently, Y would have been better," that inference should be stored somewhere. Is it a node? A special edge annotation? An entry in the Mirror's value system?

---

*Companion document: this research directly extends the work in `research/round4-agents/stream-1b-damasio-tulving-pearl.md` (Pearl) and directly implements `design/improvements-from-round4.md` item 2 (Causal Edges Required) and the design sketch in item "THE BIG GAP: Tool Use + Skill Learning."*

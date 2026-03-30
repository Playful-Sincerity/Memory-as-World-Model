# Targeted Research: Answers to Open Design Questions
## Round 2 — March 29, 2026

Research from 5 targeted agents, each focused on a specific open question from the evolved architecture concept.

---

## 1. How Does the Association Model Learn Beyond Co-occurrence?

### Answer: BCPNN proves Hebbian learning = PMI

The BCPNN (Bayesian Confidence Propagation Neural Network) derives its weight rule from Bayes' theorem:

```
w_ij = log(P(i,j) / (P(i) * P(j)))
```

This IS Pointwise Mutual Information. Benchmarks as 3x better than the next-best Hebbian rule (Lansner et al., 2024). The "neurons that fire together wire together" intuition has a precise mathematical foundation.

### The Full Edge Weight Formula

```
w_ij(t) = PMI_ij(t) * salience * temporal_proximity * decay(t)

PMI_ij(t)           = log(p_ij / (p_i * p_j))          — co-occurrence strength (EMA-estimated)
salience             = max(importance(m_i), importance(m_j)) — emotional/importance weighting
temporal_proximity   = exp(-|t_i - t_j| / tau)          — contiguity bonus
decay(t)             = exp(-lambda * (t_now - t_last)^0.5)  — ACT-R power-law forgetting
```

### Beyond Simple Co-occurrence (answers open-questions.md "Association Model")

| Mechanism | How It Works | When to Use |
|-----------|-------------|-------------|
| **Co-occurrence (PMI)** | EMA-estimated joint vs marginal probability | Default — every context window |
| **Causal chains** | Temporal precedence + consistent directionality → causal edge | CausalKG framework; run PC/FCI/GES during consolidation |
| **Emotional resonance** | FadeMem: `I_i = alpha*relevance + beta*frequency + gamma*recency`. High-importance memories decay slower | Salience multiplier on edge weight |
| **LLM-judged links** | Kairos (NeurIPS 2025): validation-gated Hebbian learning. Only strengthen edges when reasoning passes quality assessment | During consolidation, not real-time |
| **Structural similarity** | Graph Attention Networks (GATv2): learned attention over neighborhoods | Training required; use for mature graphs |

### Asymmetric Associations

Yes — use directed edges. PMI is symmetric but temporal precedence and causal direction are not. Store two weights per edge pair: `w(A→B)` and `w(B→A)`. ICe cream → motorcycles might be strong (via road trip path); motorcycles → ice cream might be weak (motorcycles don't typically evoke ice cream without that specific experiential history).

### Edge Descriptions

Worth it for high-weight edges during consolidation. During real-time co-occurrence, just increment the weight. During consolidation cycles, ask the LLM to generate a brief description for edges above a strength threshold. This adds interpretability where it matters most without slowing real-time operation.

**Key refs:** BCPNN (arXiv:2401.00335), Kairos (NeurIPS 2025), CausalKG (arXiv:2201.03647), FadeMem (arXiv:2601.18642)

---

## 2. How Does the Consciousness Pointer Work?

### Answer: PPR = Spreading Activation (mathematically proven)

A 2021 IEEE paper proved that Personalized PageRank and spreading activation are equivalent diffusion processes. A 2024 paper proved PPR = Successor Representation from RL. This means:

**The consciousness pointer IS the seed node for Personalized PageRank.**

The PPR distribution defines "what is accessible from here." Teleport probability (1-alpha) models focus stability. Expected walk length = 1/alpha. With alpha=0.85, the walker explores ~6.7 hops on average before restarting.

### Single Focus + Background Monitors (answers "Single vs multi-focus")

Cognitive science is clear: primary focus is serial (ACT-R goal buffer = one chunk). But background monitoring is parallel. Design:

1. **One primary focus** (consciousness pointer) with full context loading
2. **Multiple lightweight monitors** watching for patterns without full neighborhood loading
3. When a monitor fires, it competes for primary focus via a **gating mechanism**

### Focus Momentum (answers "Momentum")

Yes. Implement a gate threshold modulated by current momentum:

```python
class ConsciousnessPointer:
    position: NodeID              # Current focus
    focus_stack: list[NodeID]     # For returning after hard jumps
    gate_threshold: float = 0.5   # Stability/flexibility balance
    momentum: float = 0.0         # Resistance to change

    def should_shift(self, interruption_salience: float) -> bool:
        return interruption_salience > self.gate_threshold + self.momentum
```

High momentum = hard to interrupt (deep in a thought). Low momentum = responsive to new input.

### Focus History / Trail (answers "History")

Yes — the focus stack provides this. SOAR's impasse-driven subgoaling model: when the agent needs info from elsewhere, push current position → jump → resolve → pop back. The trail IS the stack.

### The Entry Point Problem

**Decision tree:**
```
New input → Related to current focus? (semantic sim to neighborhood > threshold)
  YES → Walk from current position (smooth transition)
  NO  → Focus-biased search: embedding_sim × PPR_distance_from_focus
        Push current focus to stack → Hard jump to new position
```

This means the one "RAG-like step" is biased by where you currently are. "Ice cream" finds a different entry point when you're thinking about "summer" vs "dentistry."

**SA-RAG** (2024) already validates spreading activation for KG-RAG: up to 39% improvement on multi-hop benchmarks.

**Key refs:** PPR=SA equivalence (IEEE JCDL 2021), PPR=SR (arXiv:2512.24722), SA-RAG (arXiv:2512.15922), APPNP (ICLR 2019), SOAR architecture, LIDA cognitive architecture

---

## 3. Do Pruned Branches Leave Traces?

### Answer: Yes — phantom edges + graceful compression

Three mechanisms from the research:

**1. Phantom edges (low-weight traces):** When a branch prunes from active context, leave a minimal-weight edge marker. This helps re-find the branch faster if focus drifts back. Cost: negligible (one float per pruned edge).

**2. Graceful compression (AgentFold pattern):**
```
Active (verbatim) → Compressed (gist tokens) → Summary tag → Phantom edge → Gone
```
AgentFold achieves <7K tokens after 100 turns vs >91K for flat accumulation. The agent learns when and how to fold.

**3. SleepGate's supersession detection:** When a memory is superseded by newer info, mark it as stale rather than delete. Cosine similarity > 0.85 between old and new entry triggers supersession tagging.

### Practical Design

```
ACTIVE:     Full content in context. Distance < 2 hops from focus.
COMPRESSED: Gist-token summary. Distance 2-4 hops.
PHANTOM:    Edge stub only (source, target, last-weight). Distance > 4 hops.
ARCHIVED:   In cold storage. Retrievable but not in active graph.
```

---

## 4. Do Memory Embeddings Shift as New Associations Form?

### Answer: Yes — via TGN-style message passing + reconsolidation

### Automatic Shift via Dynamic GNN

**Temporal Graph Networks (TGN):** When a new edge connects ice cream to motorcycles:
1. Message function generates messages from the new interaction
2. Message aggregator combines messages for each affected node
3. Memory updater (GRU) updates both nodes' memory states
4. Embedding module recomputes embeddings from updated memories

**InkStream optimization:** Only recompute embeddings for nodes whose k-hop neighborhood was impacted. Not the whole graph.

### Reconsolidation: Every Retrieval is a Write

In neuroscience, retrieved memories become labile during recall and can be modified. This is "largely uninvestigated" in AI (2025 survey). Your architecture would be among the first to implement it:

```python
def retrieve_and_reconsolidate(node_id, query_context):
    node = graph.get(node_id)
    node.access_count += 1
    node.last_accessed = now()
    node.embedding = recompute_embedding(node, query_context)  # Context-shifted
    for edge in traversal_path:
        edge.weight *= reinforcement_factor  # Hebbian strengthening
    if similarity(query_context, node.embedding) > threshold:
        create_association_edge(query_source, node)  # New edge from co-access
```

### Contextual Embeddings (answers "ice cream from summer vs dentist")

A node can have different effective embeddings depending on access context. Two approaches:

1. **Query-conditioned:** `emb(node, query) = f(base_emb, query_emb, path_features)` — computed at access time
2. **Multi-aspect:** Store 2-3 aspect embeddings per node (clustered from edge types), select at retrieval time

P-GNN (Position-aware GNN) and CSGAT (2025) both demonstrate this works.

### Graph Topology Evolution

Real-world graphs follow predictable laws (Leskovec et al.):
- **Densification power law:** Edges grow super-linearly with nodes
- **Shrinking diameters:** Cross-domain associations create shortcuts
- **Preferential attachment:** Hub nodes accumulate more connections

The memory graph should naturally develop small-world properties through associative use. Monitor graph metrics to verify healthy evolution.

**Key refs:** TGN (arXiv:2006.10637), InkStream (arXiv:2309.11071), P-GNN (arXiv:1906.04817), CSGAT (2025), Leskovec et al. (2005)

---

## 5. Can the LLM Really Only Answer from the Graph? (Anti-Hallucination)

### Answer: Not perfectly — but close with layered defenses

### The Honest Numbers

| Strategy | Hallucination Prevention |
|----------|------------------------|
| No grounding (raw LLM) | ~57% accurate (43% hallucinate) |
| RAG (standard) | 60-80% reduction |
| Instruction grounding ("only use context") | ~86% compliance (FACTS Grounding benchmark) |
| GCR / KG-Trie (ICML 2025) | **100% faithful for structured KG paths** |
| R-Tuning (NAACL 2024) | Significant abstention improvement |
| BODHI framework (2026) | 97.3% include clarifying questions |
| All layers combined | ~85-95% for free-form, ~100% for structured |

### Critical Findings

**Context-Parametric Inversion (ICLR 2025 Oral):** Even models fine-tuned to follow context gradually learn to BYPASS it. This is a training dynamics problem, not a prompting problem.

**AbstentionBench (2025):** Abstention does NOT improve with scale. Reasoning training makes it 24% WORSE.

### The Best Available Architecture

```
Layer 5: EPISTEMIC OUTPUT — Every claim cites a graph node. NLI verification.
Layer 4: CONSTRAINED GENERATION — KG-Trie for structured paths (100% faithful)
Layer 3: REASONING ENGINE — R-Tuning trained for abstention. Small model = less leakage.
Layer 2: RETRIEVAL GATE — No graph results = no generation allowed.
Layer 1: MEMORY GRAPH — Closed-world assumption. Full provenance.
```

### Key Design Choice: Use Smaller Models

The less the engine "knows" from pretraining, the less it can leak. A small, R-Tuned model constrained by KG-Trie for structured reasoning gets close to the vision. Free-form synthesis (converting graph paths to natural language) remains the irreducible leakage point.

### GCR / KG-Trie (Most Relevant System)

Builds a trie from all valid reasoning paths in the knowledge graph. During generation, only tokens that form valid prefixes of KG paths receive nonzero probability. **100% faithful reasoning ratio** on both benchmarks. The catch: only works for structured path reasoning, not open-ended generation.

**Key refs:** GCR (arXiv:2410.13080), R-Tuning (arXiv:2311.09677), BODHI (medrxiv 2026), Context-Parametric Inversion (arXiv:2410.10796), AbstentionBench (arXiv:2506.09038)

---

## 6. Interpretable World Model: The Graph as Mind

### Pearl's Causal Hierarchy Applies

Three edge types, provably non-collapsible:

```
ASSOCIATION:     "A co-occurs with B"             (PMI-based, default)
CAUSATION:       "A causes B"                     (discovered via PC/FCI/GES during consolidation)
COUNTERFACTUAL:  "Without A, B wouldn't happen"   (deepest understanding, requires causal model)
```

Causal discovery algorithms (PC, FCI, GES) can run over accumulated experiences during consolidation to upgrade association edges to causal edges. Libraries: causal-learn, DoWhy.

### Belief Revision (AGM Framework)

Three principled operations when new evidence arrives:
- **Expansion:** Add belief without checking consistency
- **Revision:** Add belief + retract conflicting beliefs + propagate through derivation chains
- **Contraction:** Remove belief + all beliefs that depend solely on it

### Provenance: Every Belief is Traceable

```
Raw Experience (Episode #47)
  → Observation ("User said X")
    → Interpretation ("X probably means Y")
      → Belief ("Y is true because of X")
        → Derived Belief ("Since Y, then Z")
```

When Episode #47 is contradicted by Episode #92, revision propagates through the chain. Zep/Graphiti's bi-temporal model (event time + ingestion time) provides the infrastructure.

### Graph Metrics as Computable Self-Awareness

| Metric | Self-Knowledge |
|--------|---------------|
| Node degree distribution | "What do I know most about?" |
| Clustering coefficient | "How deep is my understanding of X?" |
| Betweenness centrality | "Which concepts bridge my knowledge domains?" |
| Connected components | "Do I have isolated knowledge islands?" |
| Graph diameter | "How far apart are my most distant concepts?" |
| Temporal edge distribution | "Is my knowledge of X fresh or stale?" |

### Spawnable Minds: Validated

**DAMCS (Feb 2025):** Decentralized agents with individual knowledge graphs. 74% fewer steps in cooperative planning vs single-agent. Each agent's graph IS its mind. You can read, compare, merge, transfer, and evaluate.

```
SPAWN:     Create Agent_X with empty graph
EXPLORE:   Agent_X interacts with domain, building its graph
COMPARE:   diff(G_X, G_Y) reveals worldview differences
MERGE:     merge(G_X, G_Y) with conflict resolution
DISTILL:   Extract high-centrality subgraph as "key insights"
TRANSFER:  Initialize Agent_Z with subgraph as prior knowledge
```

**AriGraph (IJCAI 2025):** Closest existing system to "KG as interpretable world model." Learns during interaction, extracts triplets.

**Key refs:** Pearl's Causality (2009), AGM (1985), DAMCS (arXiv:2502.05453), AriGraph (arXiv:2407.04363), WorldCoder (NeurIPS 2024), causal-learn, DoWhy

---

## 7. New Systems Discovered (Not in Round 1 Audit)

| System | What It Is | Why It Matters |
|--------|-----------|---------------|
| **Kairos** (NeurIPS 2025) | Validation-gated Hebbian learning on KGs | Prevents hallucination reinforcement in edge strengthening |
| **Ori-Mnemos** | ACT-R decay + spreading activation on wiki-KG + Tarjan protection | Open-source, implements exactly what we need for structural node protection |
| **FadeMem** (2026) | Importance-modulated forgetting with spacing effects | Complete decay formulation with consolidation-on-access |
| **Field-Theoretic Memory** (2026) | Memory as continuous PDE-governed field | +116% F1 on multi-session reasoning; novel theoretical frame |
| **GCR / KG-Trie** (ICML 2025) | Hard-constrained generation from KG paths | 100% faithful reasoning — key anti-hallucination mechanism |
| **R-Tuning** (NAACL 2024) | Refusal-aware instruction tuning | Teaches abstention as generalizable meta-skill |
| **BODHI** (2026) | Epistemic humility engineering framework | 97.3% clarifying questions when constrained |
| **AriGraph** (IJCAI 2025) | KG world model with episodic memory | Closest to "graph as interpretable world model" |
| **DAMCS** (Feb 2025) | Decentralized agents with individual KG memories | Validates spawnable minds concept: 74% fewer steps |
| **SA-RAG** (2024) | Spreading activation for KG-RAG | Up to 39% improvement on multi-hop benchmarks |
| **Context-Parametric Inversion** (ICLR 2025) | Models bypass context over training time | Critical limitation to account for in anti-hallucination design |
| **WorldCoder** (NeurIPS 2024) | World model as readable Python code | 10,000x sample-efficient; proves readable world models work |
| **RiverText** | Incremental Word2Vec/GloVe for streaming | Online co-occurrence learning library |
| **MemoriesDB** | Temporal-semantic-relational distance metric | Complete experiential distance formalization |
| **Temporal Context Model** | Drifting context vector for episodic memory | Gold standard for experiential distance in cognitive science |

---

## Summary: Answers to the 5 Core Open Questions

| Question | Answer | Confidence |
|----------|--------|-----------|
| **How does the association model learn?** | PMI (= Hebbian) as base + causal discovery + salience weighting + validation gating | High — mathematically grounded |
| **How does the consciousness pointer work?** | PPR seed node + gated focus shift + SOAR-style stack for subgoaling | High — PPR=SA proven equivalent |
| **Do pruned branches leave traces?** | Yes — phantom edges + graceful compression (active → compressed → phantom → archived) | High — clear implementation path |
| **Do embeddings shift?** | Yes — TGN message passing on new edges + reconsolidation on access | High — established mechanisms |
| **Can the LLM only answer from the graph?** | ~85-95% with layered defenses. KG-Trie = 100% for structured paths. Free-form synthesis = irreducible leakage point | Medium — hard ceiling exists |

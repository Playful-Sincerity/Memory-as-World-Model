# Associative Memory Architecture for AI Agents
## Comprehensive Research Audit — March 29, 2026

---

## 1. The Vision

An agent memory system where:
- **Memories are nodes** in a multi-dimensional semantic graph
- **Edges are associative relationships** — the connection topology itself is a meaningful model
- **Context-driven traversal** — from the agent's current "consciousness," it walks the graph to reach relevant memories (ice cream → summer → road trips → motorcycles)
- **Active pruning** — as context shifts, distant branches drop from the active context window
- **Dynamic growth** — the graph grows organically from where the agent "is" toward where its memories are needed
- **Not full-DB retrieval** — only contextually relevant subgraphs are ever loaded

---

## 2. The Gap Is Real

After surveying 50+ systems, papers, and repos across 6 research dimensions: **no production system implements true associative memory with dynamic graph traversal for AI agents.**

| What exists | What's missing |
|-------------|---------------|
| Flat vector retrieval (Mem0, RAG) | Associative multi-hop traversal |
| Static knowledge graphs (GraphRAG, LightRAG) | Dynamic, evolving connection topology |
| Context paging (MemGPT/Letta) | Graph-native context management |
| Recency/importance scoring (Generative Agents) | Spreading activation with learned edge weights |
| BFS graph traversal (Graphiti/Zep) | Weighted, energy-guided association propagation |
| Batch consolidation (various) | Continuous Hebbian-style edge strengthening |

The closest existing systems are:
1. **SYNAPSE** (Jan 2026, paper only) — Implements spreading activation over episodic-semantic graph
2. **HippoRAG 2** (ICML 2025) — Personalized PageRank over knowledge graph modeled on hippocampus
3. **A-MEM** (NeurIPS 2025) — Zettelkasten-inspired associative linking

None are production-ready. None combine all the properties of the proposed architecture.

---

## 3. Cognitive Science Foundations

### 3.1 Spreading Activation (Collins & Loftus, 1975)

The direct theoretical ancestor. Concepts are nodes in a weighted graph. When activated, energy propagates along edges with decay:

```
A[j] = A[j] + (A[i] * W[i,j] * D)
```

**Key parameters:** activation level, edge weight, decay factor, firing threshold, fan effect (dilution across many connections).

**Design implication:** This IS the core traversal algorithm. Tune decay for associative reach, threshold for pruning aggressiveness, and fan normalization to prevent generic hubs from dominating.

### 3.2 ACT-R Memory Model (Anderson)

The most mathematically precise framework. Total activation:

```
A(i) = B(i) + C(i) + P(i) + noise
```

- **B(i) = ln(Σ t(j)^(-0.5))** — base-level from recency/frequency (power-law decay)
- **C(i) = Σ W(j) · S(j,i)** — context-sensitive spreading activation
- **S(j,i) = S_max - ln(fan(j))** — association strength with fan effect

**Design implications:**
- Power-law decay (d≈0.5) for natural forgetting
- Fan-based normalization so common associations don't dominate
- Dynamic retrieval threshold based on task demands
- Stochastic noise for exploration in retrieval

### 3.3 Global Workspace Theory (Baars, 1988)

Consciousness as a competitive broadcast architecture. Specialized unconscious processors compete for a capacity-limited "stage." Winners get broadcast to all systems.

**Design implication:** The context window IS the global workspace. Memories compete for limited slots based on multi-factor scoring. Strict capacity limits (~3-7 active items). Behind-the-scenes "operators" (current goal, user preferences) bias selection without consuming slots.

### 3.4 Episodic vs. Semantic Memory (Tulving, 1972)

Two interacting systems:
- **Episodic:** Specific experiences, timestamped, contextually rich, faster decay
- **Semantic:** Abstracted knowledge, decontextualized, high connectivity, stable

**Design implication:** Explicitly type memory nodes. Implement a consolidation pathway where repeated episodic patterns promote to semantic nodes. Different decay rates per type.

### 3.5 Hippocampal Mechanisms

- **Indexing Theory:** The hippocampus stores pointers, not content. Graph nodes should be lightweight indices pointing to full content stored elsewhere.
- **Pattern Separation (Dentate Gyrus):** Actively differentiate similar memories at encoding to prevent interference.
- **Pattern Completion (CA3):** Partial cues reconstruct full patterns — this IS spreading activation.
- **Complementary Learning Systems:** Fast episodic write + slow semantic consolidation via offline "replay."

---

## 4. Existing Agent Memory Systems

### Landscape Summary

| System | Stars | Architecture | Associative? | Key Innovation |
|--------|-------|-------------|-------------|----------------|
| **Mem0** | 51k | Hybrid vector + graph | 1-hop entity lookup | Conflict resolution |
| **Graphiti/Zep** | 24k | Temporal KG (3-tier) | BFS n-hop | Bi-temporal model, fact invalidation |
| **MemGPT/Letta** | 22k | Tiered virtual memory | None | LLM self-manages context via paging |
| **Generative Agents** | 21k | Flat stream + reflections | Embedding similarity | 3-factor scoring (recency × importance × relevance) |
| **Cognee** | 15k | ECL → ontology-grounded KG | Graph + vector hybrid | Ontology validation |
| **Memvid** | 14k | Append-only video frames | None | Single-file portable memory |
| **Hindsight** | 7k | 4 logical networks | Entity co-occurrence | World/Bank/Opinion/Observation separation |
| **A-MEM** | 840 | Zettelkasten network | LLM-judged conceptual links | Memory evolution on insert |
| **SYNAPSE** | paper | Spreading activation graph | Yes — strongest | Lateral inhibition, temporal decay |

### What's Missing From ALL of Them

1. **Dynamic edge weighting** that strengthens with co-retrieval (Hebbian: "memories that fire together wire together")
2. **Pruning by structural importance**, not just temporal decay
3. **Multi-scale traversal** adapting depth to query complexity
4. **Associations discovered at retrieval time**, not just insertion time
5. **Compositional retrieval** assembling context from graph substructures

---

## 5. Graph-Based Retrieval

### Most Relevant Systems

**SYNAPSE (Jan 2026)** — The closest existing system to the proposed architecture:
- Episodic + semantic nodes with temporal, abstraction, and association edges
- Spreading activation: `u_i^(t+1) = (1-δ)·a_i^(t) + Σ[S·w_ji·a_j^(t)/fan(j)]`
- Lateral inhibition (winner-take-all among top-M)
- Temporal decay: `w_ji = e^(-ρ·|τ_i-τ_j|)`
- Triple hybrid score: `0.5·sim + 0.3·activation + 0.2·PageRank`
- Multi-hop F1 drops from 35.7→31.2 when activation ablated — dynamics are essential

**HippoRAG 2 (ICML 2025)** — Hippocampus-inspired:
- LLM (neocortex) → retrieval encoder (parahippocampal) → open KG (hippocampus)
- Personalized PageRank for single-step multi-hop retrieval
- 10-30x cheaper, 6-13x faster than iterative retrieval

**MAGMA (Jan 2026)** — 4 orthogonal graph structures:
- Semantic + temporal + causal + entity graphs
- Policy-guided traversal with query-adaptive selection
- 45.5% reasoning improvement over monolithic stores

**Graphiti/Zep** — Production-ready temporal KG:
- Bi-temporal tracking (event time + ingestion time)
- Incremental real-time updates, sub-second latency
- Three tiers: episodes → semantic entities → communities
- Hybrid retrieval: semantic + BM25 + BFS graph traversal + reranking

**HippoRAG GitHub:** https://github.com/OSU-NLP-Group/HippoRAG
**Graphiti GitHub:** https://github.com/getzep/graphiti
**MAGMA paper:** arXiv:2601.03236
**SYNAPSE paper:** arXiv:2601.02744

### Also Notable

- **Microsoft GraphRAG** (31.8k stars) — Leiden community detection + hierarchical summarization. Batch/static.
- **LightRAG** (EMNLP 2025) — Simpler GraphRAG with incremental updates
- **KAG (Ant Group)** — 3-layer KG with mutual indexing and logical-form reasoning
- **RAPTOR** (ICLR 2024) — GMM clustering + recursive summarization → multi-resolution tree
- **GRAG** (NAACL 2025) — GNN-based retrieval with learnable soft pruning via GAT
- **Trainable Graph Memory** (Nov 2025) — Edge weights optimized via REINFORCE

---

## 6. Semantic Embedding & Association

### Embedding Space Geometry

**Hyperbolic Embeddings (Poincaré Ball):**
- Hyperbolic space grows exponentially with radius — perfect for tree-like structures
- 5D Poincaré embedding outperforms 200D Euclidean for hierarchical data
- **HyperbolicRAG** (Nov 2025): 79% Recall@5, especially strong on multi-hop (92.1% on 2Wiki)
- Points near center = abstract concepts; near boundary = specific instances
- Natural fit for the tree-like growth pattern described in the vision

**Relational Embeddings (TransE, RotatE, ComplEx):**
- Model relationships as geometric operators (translations, rotations)
- RotatE: composition property enables multi-hop inference via embedding arithmetic
- The relation vector IS the edge — `h * r ≈ t` means the association is a geometric operation
- PyKEEN library provides production-ready implementations

**Vector Symbolic Architectures (VSA/HDC):**
- 10,000-dim binary/bipolar vectors with three operations:
  - **Bind**(A, B) = create association (the edge IS a vector)
  - **Bundle**(A, B) = group related memories (superposition)
  - **Permute** = encode temporal ordering
- All O(d), approximately invertible, content-addressable
- A single "context vector" holds multiple active associations simultaneously
- **Torchhd** (PyTorch): https://github.com/hyperdimensional-computing/torchhd

**RelBERT:**
- Embeds word PAIRS as vectors capturing the relationship itself
- Production-ready: `pip install relbert`
- Can compute: similarity("ice cream : summer", "hot chocolate : winter") directly

### Embedding Space Geometry (March 2026)

**Latent Semantic Manifold Hypothesis:** LLM hidden states lie on a smooth, low-dimensional Riemannian submanifold (1-3% of ambient space). The Fisher information metric measures "semantic distinguishability" — a principled replacement for cosine similarity.

**Modern Hopfield Networks (Feb 2025):** Continuous-time memories with energy basins as attractors. Association = shared basin or low-energy path between basins.

### Multi-Hop Reasoning

- **HopRAG** (ACL 2025): Retrieve-reason-prune pipeline for multi-hop graph traversal
- **Query2Box** (ICLR 2020): Represent queries as hyper-rectangles for set-based retrieval
- Pure embedding arithmetic degrades beyond 3-4 hops — graph structure needed for longer chains

### Dynamic Embedding Updates

- **Cache-based (practical):** Frozen model + vector DB, periodic re-embedding of stale memories
- **IncLoRA (IJCAI 2024):** LoRA-style adapters for incremental knowledge graph updates
- **AIR:** Impact-scored propagation of updates through local graph neighborhoods

---

## 7. Dynamic Context Management

### Design Principles (synthesized from 15+ systems)

**Principle 1: Multi-Level Memory Hierarchy**
- **L1 (Active Context):** Currently loaded subgraph nodes, verbatim. Size-bounded.
- **L2 (Compressed Context):** Recently visited but evicted nodes as gist tokens/summaries. Faultable.
- **L3 (Cold Storage):** Full graph indexed for retrieval.

**Principle 2: Attention-Guided Relevance Scoring**
- Heavy-hitter tokens (H2O) = keep high-attention nodes
- **BUT:** SleepGate (2026) shows cumulative-attention heuristics FAIL under proactive interference — stale superseded nodes have highest attention. Conflict-aware temporal tagging is essential.

**Principle 3: Confidence-Triggered Loading**
- FLARE: Model's own uncertainty triggers retrieval
- Self-RAG: Learned reflection tokens ([Retrieve], [ISREL], [ISSUP])
- UAR: Lightweight classifiers (<10ms) decide IF traversal needed

**Principle 4: Cooperative Eviction (Pichay, March 2026)**
- Model participates in eviction decisions via phantom tools
- Graduated pressure zones: Normal → Advisory → Involuntary → Aggressive
- 93% context reduction in production deployment

**Principle 5: Distance-Proportional Compression**
- Current focus: verbatim
- 1-hop: light compression (LLMLingua-style)
- 2-hop: heavy compression (gist tokens)
- 3+ hops: cluster-level summary nodes only

**Principle 6: Background Consolidation**
- SleepGate: Conflict-aware temporal tagging + forgetting gate + consolidation
- Merge duplicates, prune superseded nodes, strengthen co-accessed edges, compress dense subgraphs

**Principle 7: Temporal Awareness (Graphiti)**
- Bi-temporal model: event time + ingestion time
- Fact invalidation (not deletion) on contradiction

**Principle 8: Adaptive Budget Allocation**
- Simple lookup → minimal graph context
- Multi-hop reasoning → deep subgraph loading
- Creative synthesis → broad shallow loading across clusters

### Key Systems

| System | Key Innovation | Latency |
|--------|---------------|---------|
| **Pichay** (2026) | OS-style demand paging, cooperative eviction | <5ms/eviction |
| **SleepGate** (2026) | Conflict-aware forgetting, supersession detection | 10-50ms/cycle |
| **AgentFold** (2025) | Learned context folding, <7K tokens at 100 turns | 100-500ms/fold |
| **DynamicKV** (EMNLP 2025) | 1.7% KV retention, 85% performance | 1-10ms |
| **StreamingLLM** | Attention sinks + sliding window | <1ms |

### Open Gap Confirmed

"Graph-native context management barely exists. All current systems operate on flat token sequences. No system natively reasons about graph topology."

---

## 8. Neural Memory Architectures

### Architecture Components for Agent Memory

| Component | Best Source | Mechanism |
|-----------|-----------|-----------|
| **Write/Store** | Titans (2025) | Surprise-based gating: only store what's unexpected. `S_t = η·S_{t-1} - θ·∇loss` |
| **Read/Retrieve** | Modern Hopfield | Content-based associative retrieval. `ξ_new = X·softmax(β·X^T·ξ)` |
| **Addressing** | DNC | 3-mode: backward temporal + content-based + forward sequential |
| **Edge Learning** | TTT Layers (ICML 2025) | Test-time training updates edge weights during inference |
| **Scaling** | Memory Layers (Meta, ICLR 2025) | Product-key lookup: 128B parameters, sparse activation |
| **Routing** | MoSA (2025) | Content-based expert-choice routing per attention head |
| **Compression** | Mamba | Input-dependent gating controls what enters compressed state |
| **Forgetting** | Titans + DNC | Adaptive weight decay (Titans) + usage tracking + free gates (DNC) |

### Titans: Learning to Memorize at Test Time

Memory as an MLP whose weights ARE the memory. Gradient descent = write operation:
```
M_t = (1 - α_t)·M_{t-1} + S_t    (forgetting + surprise)
```
- Scales to 2M+ context windows
- Surprise metric for deciding what to remember
- Key limitation: memories are implicit in weight space (not discrete/addressable)

### Differentiable Neural Computer (DNC)

The closest existing neural architecture to a graph memory:
- Content-based addressing (cosine similarity with temperature)
- Temporal link matrix (tracks write order → enables sequential traversal)
- Usage tracking + free gates (learned pruning)
- Successfully learns graph algorithms from examples

### Modern Hopfield Networks

Every transformer attention layer IS a single Hopfield retrieval step:
```
Z = softmax(QK^T/√d)·V  =  X·softmax(β·X^T·ξ)
```
- Exponential storage: C ~ 2^(d/2)
- Temperature controls retrieval specificity (sharp vs. diffuse = spreading activation radius)
- Energy basins = memory attractors; association = shared basins

### Test-Time Training (TTT, ICML 2025 + ICLR 2026)

Hidden state IS a learnable model updated by self-supervised gradient steps at inference:
- Continues improving with context length (unlike Mamba)
- In-Place TTT (ICLR 2026): drop-in enhancement for pretrained LLMs
- Could serve as the mechanism for updating edge weights in the memory graph during inference

### Memory Layers at Scale (Meta, ICLR 2025)

Product-key lookup over 128B memory parameters:
- Memory-bandwidth bound, not compute-bound → massive scale without proportional FLOPs
- 1.3B + 128B memory ≈ Llama-2 7B performance
- Sparse activation: only retrieved entries are accessed

### Key Open Gaps

1. **No system combines neural-level memory (Titans/TTT) with graph-level organization (MAGMA/Graphiti)**
2. **Spreading activation in neural memory graphs** remains underexplored
3. **Learned pruning policies** (not just decay) optimizing for downstream performance
4. **Scalable differentiable graph operations** beyond O(N) DNC addressing

---

## 9. Synthesis: Proposed Architecture Blueprint

### The Core Idea

Combine:
- **ACT-R's activation equations** for scoring
- **Spreading activation** for traversal
- **Hippocampal indexing** for storage (lightweight graph + external content)
- **Global Workspace Theory** for context competition
- **Complementary Learning Systems** for dual-store + consolidation
- **Hyperbolic embeddings** for the geometric space
- **TTT-style adaptation** for live edge weight updates
- **Pichay-style demand paging** for context management

### Five-Layer Architecture

```
┌─────────────────────────────────────────────────┐
│  Layer 5: CONTEXT MANAGER                        │
│  Competitive context selection (GWT)             │
│  Demand paging (Pichay-style)                    │
│  Distance-proportional compression               │
│  Confidence-triggered loading (FLARE/Self-RAG)   │
├─────────────────────────────────────────────────┤
│  Layer 4: TRAVERSAL ENGINE                       │
│  Spreading activation (Collins & Loftus)         │
│  ACT-R activation scoring (B + C + P + noise)   │
│  Lateral inhibition (SYNAPSE)                    │
│  Policy-guided multi-graph routing (MAGMA)       │
├─────────────────────────────────────────────────┤
│  Layer 3: ASSOCIATION MODEL                      │
│  Typed edges (RotatE relational embeddings)      │
│  Cross-domain linking (RelBERT pair embeddings)  │
│  Hyperbolic geometry for hierarchy               │
│  VSA binding/bundling for compositional links    │
├─────────────────────────────────────────────────┤
│  Layer 2: MEMORY NODES                           │
│  Episodic nodes (timestamped, contextual)        │
│  Semantic nodes (abstracted, high-connectivity)  │
│  Lightweight indices (hippocampal indexing)       │
│  Multi-representation (base + contextual embeds) │
├─────────────────────────────────────────────────┤
│  Layer 1: STORAGE & MAINTENANCE                  │
│  Graph DB (Neo4j/FalkorDB) + Vector DB           │
│  Bi-temporal tracking (Graphiti)                 │
│  Background consolidation (SleepGate-style)      │
│  Episodic→semantic promotion (CLS replay)        │
│  Conflict detection + fact invalidation          │
└─────────────────────────────────────────────────┘
```

### Critical Design Parameters

| Parameter | Source | Suggested Range | Controls |
|-----------|--------|----------------|----------|
| Decay rate (d) | ACT-R | ~0.5 | Forgetting speed |
| Spreading decay (D) | Collins & Loftus | 0.3-0.8 | Associative reach |
| Firing threshold (τ) | ACT-R | Dynamic | Pruning aggressiveness |
| Context capacity | GWT | 3-7 items | Active memory limit |
| Fan normalization | ACT-R | S_max - ln(fan) | Hub suppression |
| Consolidation frequency | CLS | Configurable | Episodic→semantic rate |
| Temperature (β) | Hopfield | Variable | Retrieval specificity |
| Interference threshold (δ) | SleepGate | ~0.85 cosine | Supersession detection |

---

## 10. Key Papers (by relevance)

### Must-Read (directly relevant to the architecture)

1. **SYNAPSE** — arXiv:2601.02744 (Jan 2026) — Spreading activation over episodic-semantic graph
2. **HippoRAG 2** — arXiv:2502.14802 (ICML 2025) — Non-parametric continual learning via hippocampal indexing
3. **MAGMA** — arXiv:2601.03236 (Jan 2026) — Multi-graph agentic memory with policy-guided traversal
4. **A-MEM** — arXiv:2502.12110 (NeurIPS 2025) — Zettelkasten-inspired agentic memory
5. **Memory for Autonomous LLM Agents** — arXiv:2603.07670 (March 2026) — Comprehensive survey
6. **Titans** — arXiv:2501.00663 (Jan 2025) — Surprise-based memorization at test time
7. **SleepGate** — arXiv:2603.14517 (2026) — Conflict-aware memory consolidation
8. **Pichay** — arXiv:2603.09023 (March 2026) — OS-style demand paging for LLM context

### Foundational

9. Collins & Loftus (1975) — Spreading Activation Theory
10. Anderson (ACT-R tutorials) — http://act-r.psy.cmu.edu/
11. Baars (1988) — Global Workspace Theory
12. Teyler & DiScenna (1986) — Hippocampal Indexing Theory
13. McClelland, McNaughton & O'Reilly (1995) — Complementary Learning Systems
14. Ramsauer et al. — arXiv:2008.02217 — Modern Hopfield Networks
15. Nickel & Kiela (2017) — arXiv:1705.08039 — Poincaré Embeddings

### Systems to Build On

16. **Graphiti/Zep** — GitHub: getzep/graphiti (24k stars) — Best production temporal KG
17. **Mem0** — GitHub: mem0ai/mem0 (51k stars) — Most adopted memory layer
18. **MemOS** — GitHub: MemTensor/MemOS — Memory as managed resource
19. **Cognee** — GitHub: topoteretes/cognee (15k stars) — Ontology-grounded KG pipeline

### Embedding & Retrieval

20. **HyperbolicRAG** — arXiv:2511.18808 — Poincaré + graph RAG
21. **HopRAG** — arXiv:2502.12442 (ACL 2025) — Multi-hop graph traversal
22. **RelBERT** — GitHub: asahi417/relbert — Relationship pair embeddings
23. **Query2Box** — arXiv:2002.05969 — Set-based multi-hop reasoning

### Context Management

24. **AgentFold** — arXiv:2510.24699 — Learned proactive context folding
25. **StreamingLLM** — arXiv:2309.17453 — Attention sinks discovery
26. **DynamicKV** — arXiv:2412.14838 — Adaptive per-layer KV retention

### Neural Architecture

27. **TTT Layers** — arXiv:2407.04620 (ICML 2025) — Test-time training
28. **Memory Layers at Scale** — arXiv:2412.09764 (ICLR 2025) — 128B parametric memory
29. **DNC** — Nature 2016 — Differentiable graph-like neural memory
30. **Mamba-2** — arXiv:2405.21060 — State space duality with attention

---

## 11. Key GitHub Repos

| Repo | Stars | Relevance |
|------|-------|-----------|
| [getzep/graphiti](https://github.com/getzep/graphiti) | 24k | Production temporal KG engine |
| [mem0ai/mem0](https://github.com/mem0ai/mem0) | 51k | Hybrid vector+graph memory layer |
| [OSU-NLP-Group/HippoRAG](https://github.com/OSU-NLP-Group/HippoRAG) | — | Hippocampal indexing for RAG |
| [microsoft/graphrag](https://github.com/microsoft/graphrag) | 32k | Community-based graph RAG |
| [topoteretes/cognee](https://github.com/topoteretes/cognee) | 15k | Ontology-grounded KG pipeline |
| [WujiangXu/A-mem](https://github.com/WujiangXu/A-mem) | 840 | Zettelkasten agent memory |
| [MemTensor/MemOS](https://github.com/MemTensor/MemOS) | — | Memory OS with MemCubes |
| [ml-jku/hopfield-layers](https://github.com/ml-jku/hopfield-layers) | — | Modern Hopfield for PyTorch |
| [hyperdimensional-computing/torchhd](https://github.com/hyperdimensional-computing/torchhd) | — | VSA/HDC in PyTorch |
| [asahi417/relbert](https://github.com/asahi417/relbert) | — | Relationship pair embeddings |
| [LIU-Hao-2002/HopRAG](https://github.com/LIU-Hao-2002/HopRAG) | — | Multi-hop graph RAG |
| [microsoft/LLMLingua](https://github.com/microsoft/LLMLingua) | — | Context compression |
| [state-spaces/mamba](https://github.com/state-spaces/mamba) | — | State space models |
| [lucidrains/titans-pytorch](https://github.com/lucidrains/titans-pytorch) | — | Titans implementation |
| [test-time-training/ttt-lm-pytorch](https://github.com/test-time-training/ttt-lm-pytorch) | — | TTT layers |
| [facebookresearch/memory](https://github.com/facebookresearch/memory) | — | Memory Layers at Scale |
| [DEEP-PolyU/Awesome-GraphMemory](https://github.com/DEEP-PolyU/Awesome-GraphMemory) | — | Survey of graph memory approaches |
| [Shichun-Liu/Agent-Memory-Paper-List](https://github.com/Shichun-Liu/Agent-Memory-Paper-List) | — | Curated paper list |
| [vectorize-io/hindsight](https://github.com/vectorize-io/hindsight) | 7k | 4-network agent memory |

---

## 12. Upcoming Events & Community

- **ICLR 2026 MemAgents Workshop** — April 2026, Rio de Janeiro. Formal crystallization of the agent memory field. Brings together generative AI, RL, cognitive psychology, and neuroscience researchers.
- **ICLR 2025 Workshop: New Frontiers in Associative Memories** — Specifically on associative memory architectures.
- **Awesome-GraphMemory** — Active survey repo tracking the field.

---

## 13. What Makes This Architecture Novel

Based on this comprehensive audit, the proposed architecture would be **the first system to combine**:

1. ✅ **Spreading activation traversal** (only SYNAPSE does this, paper-only, no production impl)
2. ✅ **Dynamic edge weighting** that strengthens via co-retrieval (Hebbian learning — no system does this)
3. ✅ **Graph-native context management** with topology-aware pruning (identified as an open gap)
4. ✅ **Hyperbolic embedding geometry** for natural tree-like growth (HyperbolicRAG exists but not for agent memory)
5. ✅ **Multi-scale traversal** adapting depth to query complexity (no system does this adaptively)
6. ✅ **Continuous consolidation** with pattern separation/completion (inspired by CLS but not implemented in agents)
7. ✅ **Associations discovered at retrieval time** via energy-guided traversal (A-MEM only links at insert time)

This is genuinely novel territory with strong theoretical foundations and clear implementation paths.

---

*Research conducted March 29, 2026. 6 parallel research agents surveyed 50+ systems, papers, and repositories across cognitive science, agent systems, graph retrieval, embeddings, context management, and neural architectures.*

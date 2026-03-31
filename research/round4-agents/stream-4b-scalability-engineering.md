I now have enough data across all six topics to write the comprehensive feasibility report. Let me compile everything.

---

# Engineering Feasibility Report: Associative Memory Architecture
**Research date:** 2026-03-29
**Sources:** arXiv preprints, VLDB/KDD/ICDE proceedings, Semantic Scholar, GitHub benchmarks, community profiling data

---

## Topic 1: Real-Time Personalized PageRank (PPR) at Scale

### What the algorithms are

There are three relevant algorithm families:

**APPNP / Power Iteration** (the ICLR 2019 "Predict then Propagate" approach): uses K steps of sparse matrix-vector multiplication to approximate PPR. Linear complexity, no pre-indexing needed. K=1-3 iterations usually sufficient for accuracy. The catch: APPNP runs out of memory on even moderately large graphs (233K nodes / Reddit dataset) when doing on-the-fly propagation during inference. PPRGo (KDD 2020) avoids this by *precomputing* a sparse PPR matrix offline, then using O(k) forward passes at query time where k is the number of top-PPR neighbors retained per node (k≈32 typical). PPRGo ran end-to-end in under 2 minutes on MAG-Scholar (12.4M nodes, 173M edges) on a single machine.

**Approximate Push-Based PPR (FORA, SpeedPPR, FAST-PPR)**: These are the systems papers for real-time single-source query workloads. FORA combines a forward push (fast, imprecise) with Monte Carlo random walks (slow, accurate). On a billion-edge Twitter graph, FORA answers a top-500 approximate single-source PPR query within 1 second on a single commodity server. FAST-PPR achieves O(√d/δ) per query versus the naive O(1/δ), and on Twitter-2010 completes single-source PPR in under 3 seconds on average (vs. 6+ minutes for naive random walks). kPAR on GPU answers top-1000 PPR in 42.4ms on a billion-edge graph. A 2025 ICDE paper explicitly targets sub-100ms PPR on internet-scale graphs.

**Precomputed PPR index + incremental updates** (arXiv:2212.10288, "Personalized PageRank on Evolving Graphs with an Incremental Index-Update Scheme", SIGMOD 2023): Maintains an incremental index that is updated when edges are added/removed, achieving "orders of magnitude speed-up on update performance" vs. full reindex. This is the most relevant approach for a memory graph that evolves continuously.

### Latency at scale

| Graph scale | Algorithm | Latency (CPU, single source) | Notes |
|---|---|---|---|
| ~20K nodes | APPNP, K=2-3 | ~1-5ms (estimated from PPRGo 20s on 233K Reddit) | Feasible, fits in RAM |
| 233K nodes (Reddit) | PPRGo (precomputed) | <20s total pipeline; inference only much faster | APPNP OOMs here |
| ~1M nodes | FORA/SpeedPPR | 100-500ms | Single-source, 1 commodity server |
| 1.5B edges (Twitter) | kPAR (GPU) | 42.4ms for top-1000 | GPU required for this scale |
| Billion-edge graph | FORA | <1 second | CPU, single server |

**For the associative memory use case (10K-100K nodes)**: PPR is well within reach at sub-10ms latency on CPU, using either precomputed sparse PPR matrices (PPRGo style) or fast push-based algorithms. On a local M2 MacBook Air with 10K-50K nodes, expect 1-20ms per query with a well-implemented push-based or precomputed approach.

### Compatibility with LLM response times (100-500ms window)
**Yes, clearly feasible.** Even at 100K nodes, CPU-based PPR with modern approximate algorithms lands well under 100ms. The precomputed PPR matrix approach is the strongest path: precompute and cache the sparse PPR scores offline; at query time, just do a sparse lookup + 1-3 matrix-vector multiply steps. The incremental index update scheme (arXiv:2212.10288) handles graph evolution without full recompute. This is not a bottleneck for the architecture.

### Key ceiling
APPNP-style on-the-fly propagation breaks at ~100K nodes (OOM). Always precompute PPR offline, update incrementally. The real bottleneck shifts to the LLM, not PPR.

---

## Topic 2: Incremental Embedding Updates

### InkStream (arXiv:2309.11071) — the key result

InkStream targets real-time GNN inference on streaming graphs where model weights are static but graph structure evolves. Its two key insights:
1. When edges are modified, only a subset of nodes in the k-hop neighborhood are actually affected (especially with min/max aggregation)
2. Node embeddings can be incrementally updated by propagating only through the affected subgraph

**Performance:** 2.5-427x speedup on CPU clusters, 2.4-343x on GPU clusters vs. full recompute, with *identical outputs*. The range is large because speedup depends on how localized the graph change is (a leaf node addition is nearly free; a hub node update propagates widely).

The updated IEEE version (IPDPS 2025, "Instantaneous GNN Inference on Dynamic Graphs via Incremental Update") presumably refines these numbers further, but the PDF wasn't parseable directly.

### Ripple (arXiv:2505.12112, May 2025)

A newer framework explicitly targeting near-realtime incremental GNN updates:
- Single-machine throughput: ~28,000 updates/sec on sparse graphs (ArXiv citation graph), ~1,200 updates/sec on dense graphs (Amazon Products)
- Latency range: **0.1ms to 1s** for near-realtime applications
- Distributed version achieves 30x better throughput via 70x lower communication costs

**For the associative memory use case**: At 28K sparse-graph updates per second, adding a new memory node + edges and getting updated embeddings takes ~0.04ms. Even in the dense-graph case, 1,200 updates/sec = ~0.83ms per update. This is comfortably within budget.

### Incremental SVD / LoRA approaches

For non-GNN embedding updates (e.g., when you store embeddings as static vectors from a sentence-transformer):
- A production framework (Dec 2025 VLDB paper) demonstrated **CPU-only incremental embedding updates at millisecond latency** using Incremental Locally Linear Embedding (ILLE) — a lightweight CPU algorithm that updates only the local neighborhood of a new node
- Continual KG embedding with incremental LoRA (arXiv:2407.05705, AAAI 2024) adds new knowledge without catastrophic forgetting

### Practical latency estimate for the prototype

For the likely architecture (sentence-transformer embeddings, stored as float32 vectors, updated when new nodes are added):
- New node embedding via nomic-embed-text (137M params, 768-dim): ~50-200ms per sentence on M2 CPU
- Updating graph structure + PPR index incrementally: ~1-10ms
- Propagating updated embeddings to k-hop neighbors (InkStream-style): depends on hop depth and graph density, but sub-10ms for a 10K node graph with sparse connectivity

**The bottleneck here is the embedding model inference**, not the graph update. Using a pre-quantized ONNX or CoreML embedding model on M2 could bring this to 10-30ms per sentence.

---

## Topic 3: EEGNNs — Confidence-Based Halting (arXiv:2505.18088)

### What the paper delivers

Early-Exit Graph Neural Networks (EEGNNs) attach confidence-aware exit heads (using Gumbel-Softmax, differentiable) to each layer of a Symmetric-Anti-Symmetric GNN (SAS-GNN). Nodes exit when the exit head's output is sufficiently one-hot (confident). No explicit threshold — it's learned end-to-end via task loss only.

### Accuracy numbers

| Dataset | Task | EEGNN | Best Competitor | Notes |
|---|---|---|---|---|
| Questions | Node classification | 78.90 ± 1.15% | Co-GNN: similar | Heterophilic graph |
| Amazon Ratings | Node classification | 51.54 ± 0.50% | SAS-GNN: 51.47% | Comparable |
| Tolokers | Node classification | 85.26 ± 0.65% | SAS-GNN: 85.80% | Tiny gap |
| SSSP (ECHO) | Long-range | MAE 0.065 | Best overall | Beats specialized models |
| Peptides-func | Molecular | Competitive | — | Exits after ~2 layers typically |

EEGNN matches or slightly underperforms full-depth models, which is expected — the tradeoff is efficiency.

### Efficiency numbers

On the Questions dataset (1,500 passes averaged), 20 layers:
- EEGNN: **0.0257s** inference
- Co-GNN (20 layers): **0.0598s** — EEGNN is 2.3x faster
- GCN (10 layers): 0.0168s (simpler architecture, fewer params)

Parameter counts remain **constant regardless of depth** (12,562 parameters) because the same weight matrices are reused — elegant for memory-constrained hardware.

**Critical finding:** Applying early exit to *standard* MPNNs (without the SAS-GNN backbone) produces unstable recovery at depth 20. The SAS-GNN's symmetry-based inductive biases are essential for stable intermediate representations that enable safe early exits.

### Applicability to tree growth halting

**High applicability.** The per-node adaptive depth mechanism maps cleanly onto "stop growing a branch when the confidence in that memory cluster is sufficient." The Peptides-func exit distribution (predominantly exits after 2 layers) is encouraging — it shows the model genuinely learns to exit early on easy inputs. For the associative memory use case, this could be implemented as: traverse PPR neighbors, and at each hop, evaluate a lightweight confidence head — if confidence is high (the memory cluster is coherent), stop expanding. This would be a novel application of EEGNN-style halting to graph traversal rather than GNN layer depth, but the mechanism is analogous.

### What needs future work
The paper is from May 2025 and hasn't been validated in production graph RAG systems. The SAS-GNN backbone requirement means you can't bolt early exit onto any arbitrary GNN.

---

## Topic 4: TTT Layers for Edge Weight Updates (arXiv:2407.04620)

### What the paper actually is

arXiv:2407.04620 ("Learning to (Learn at Test Time): RNNs with Expressive Hidden States") introduces TTT layers as a *sequence modeling* mechanism — the hidden state is itself a small ML model (linear or MLP) updated via self-supervised learning on the current token sequence during inference. TTT-Linear uses a linear model as hidden state; TTT-MLP uses a 2-layer MLP. Scale tested: 125M–1.3B parameters.

This is **not** about graph edge weights. It's about replacing RNN hidden states with mini-models that update themselves during inference on sequential data.

### Performance and overhead

The original paper is honest about efficiency challenges:
- TTT layers have below 5% peak FLOPS utilization on modern GPUs due to small mini-batch sizes (updating fast weights every 16-64 tokens)
- The dual form (for GPU/TPU efficiency) trains more than **5x faster on TPUs** than the naive implementation
- "TTT-MLP still faces challenges in memory I/O"

The follow-up LaCT paper (arXiv:2505.23884, "Test-Time Training Done Right") directly addresses this:
- Achieves up to **70% GPU FLOP utilization** on A100s (vs. 5% for naive TTT)
- Language modeling throughput: 4.1K tok/s (Transformer baseline) vs. 5.0K tok/s (LaCT) on A100-40GB
- Prefill: 1.4s for LaCT vs. 16.1s for full attention (on a novel view synthesis task)
- LaCT nearly matches Transformer accuracy while matching RNN efficiency
- State size overhead: 0.75d² to 6d² per block (d = model dimension)

### Can TTT be applied to graph edge weight updates?

**Conceptually yes, practically it needs significant re-engineering.** The TTT mechanism (update a small model via gradient descent during inference) could be reframed as: for each traversed node during graph query time, take a gradient step that updates the edge weight predictor using local graph context as self-supervised signal. This would allow edge weights to adapt during a memory retrieval query based on what's being asked.

However:
- TTT as currently implemented is for sequence modeling, not graph topology
- The efficiency story (LaCT) requires modern GPU hardware and careful batching — poorly suited to M2 8GB CPU-dominant inference
- Latency: on CPU, TTT gradient updates at inference time would likely add 50-200ms per traversal step, making it impractical for real-time use on the target hardware
- Memory state per TTT layer: up to 6d² parameters (at d=768 embedding dim, that's ~3.6M floats = ~14MB per layer, non-trivial)

**Assessment for prototype:** TTT-style edge weight updates are a compelling *research direction* but not practical for v1 on M2 8GB. The more tractable path: update edge weights via simple EWMAs or attention-weighted scores computed at query time (no gradient required), reserving TTT for a future offline fine-tuning step.

---

## Topic 5: SQLite as Graph Database at Scale

### Performance characteristics

SQLite supports recursive CTEs, which enable multi-hop graph traversal. Performance characteristics:

**What works:**
- For a local agent/RAG system with a few hundred to a few thousand nodes, SQLite with a well-indexed edge table (indexed on both `source_id` and `target_id`) performs adequately
- Shallow traversals (2-3 hops) have negligible performance difference vs. dedicated graph engines for typical workloads
- SQLite achieves 100K+ point-query SELECTs/second with proper tuning (WAL mode, mmap, normal sync)

**Where it breaks:**
- SQLite uses B-Tree lookups per edge traversal. Dedicated graph DBs use "index-free adjacency" (pointer stored with the record — O(1) hop vs. O(log n) B-Tree lookup). This gap widens sharply with depth and density
- Deep traversals (6+ hops): dedicated engines win decisively
- Recursive CTEs visit nodes multiple times (no built-in cycle detection without extra logic)
- Above ~100K nodes with complex traversals, users report "abysmal performance" — concrete pain point reported at "several million nodes" requiring Neo4j migration
- One benchmark: recursive CTE took 7.7s vs. 3.9s for a manual join approach on a tree structure

**The specific weakness for PPR**: PPR requires multiple iterations of sparse matrix-vector multiply. SQLite has no native sparse matrix operations. You would implement PPR in Python, loading the adjacency structure from SQLite into NetworkX or a sparse matrix in memory — at which point SQLite is just persistence, not the query engine.

### Alternatives compared

| System | Latency (p50) | Latency (p99) | Memory | Best for |
|---|---|---|---|---|
| SQLite + recursive CTE | Seconds for complex multi-hop | Unpredictable | ~1KB/node overhead | 1K-50K nodes, simple queries |
| SQLite + Python NetworkX | Fast after load | Fast after load | ~2.4KB/node in-memory | Medium graphs, flexibility |
| NetworkX (pure in-memory) | Sub-millisecond | Sub-millisecond | ~100 bytes/node+edge base | Up to ~1M nodes in 8GB |
| FalkorDB | 55ms p50 | 136ms p99 | Compact | GraphRAG, production |
| Neo4j | 577ms p50 | 46,923ms p99 (!) | 5.2GB JVM pre-allocated | Enterprise, large graphs |
| Memgraph | ~400ms for 100K node creation | Low | 415MB for full dataset | In-memory, real-time |

**FalkorDB** is the most compelling alternative for this architecture: sub-140ms p99, 6.7x the QPS of Neo4j, runs as an embedded library (no separate server), supports up to 9-hop traversals with 100% success at 0.33s average (Securin case study). It runs on Linux/macOS and has a Python client.

### Recommendation for prototype

**Phase 1 (10K-50K nodes):** SQLite for persistence + NetworkX loaded in memory for PPR computation. Total memory for 50K nodes in NetworkX: ~120-600MB depending on edge count (at ~2.4KB/node for a moderately dense graph). SQLite stores the canonical graph; NetworkX is the working index, rebuilt on startup (~1-5s load time for 50K nodes).

**Phase 2 (100K+ nodes):** Migrate to FalkorDB. It's embedded, fast, and designed for exactly this use case (GraphRAG). No JVM overhead like Neo4j. FalkorDB is the pragmatic upgrade path.

**DuckDB note:** DuckDB is 10-100x faster than SQLite for *analytical aggregations*, but its columnar architecture gives no advantage for recursive graph traversal (still row-by-row hops). Not the right tool here.

---

## Topic 6: Memory Footprint on M2 MacBook Air 8GB

### Component-by-component breakdown

**1. Local LLM (Q4_K_M quantized, llama.cpp)**

| Model | Size | RAM at load | Tokens/sec (M2 8GB) |
|---|---|---|---|
| Qwen2.5 1.5B Q4 | ~0.9GB | ~1.2GB | ~40-60 tok/s |
| Qwen2.5 3B Q4_K_M | ~1.7GB | ~2.2GB | ~25-40 tok/s |
| Phi-3-mini 3.8B Q4 | ~2.2GB | ~2.8GB | ~20-35 tok/s |
| Llama 3.2 3B Q4 | ~1.9GB | ~2.5GB | ~25-40 tok/s |
| Qwen2.5 7B Q4_K_S | ~4.0GB | ~5.0GB | ~15-22 tok/s |

*Qwen2.5 7B fills 8GB entirely with almost no headroom. Phi-3-mini or Qwen2.5 3B are the practical choices on 8GB.*

**2. Embedding model (nomic-embed-text v1, 137M params, 768-dim)**
- Model weights: ~280MB at F16 (float16)
- Inference: ~50-150ms per sentence on M2 CPU
- Can be run in same process, or ONNX-quantized to ~140MB with faster inference
- **Cannot run GPU-accelerated alongside LLM on 8GB** — Metal GPU memory is shared with system RAM. With a 3B LLM loaded, the embedding model should run CPU-only, which is still fast enough for ~200ms latency per embedding.

**3. Graph storage (10K-50K nodes)**

| Component | 10K nodes | 50K nodes | 100K nodes |
|---|---|---|---|
| Float32 embeddings (768-dim) | 30.7 MB | 153 MB | 307 MB |
| Float16 embeddings | 15.4 MB | 76.8 MB | 153 MB |
| NetworkX in-memory graph (sparse) | ~24 MB | ~120 MB | ~240 MB |
| PPR sparse matrix (top-32 neighbors) | ~1.2 MB | ~6 MB | ~12 MB |
| SQLite file on disk | ~50 MB | ~250 MB | ~500 MB |

*Float32 embeddings for 10K nodes: 30.7MB. This is negligible.*

**4. PPR computation overhead**

PPR computation itself is memory-light for small graphs:
- Forward push / local push algorithm: only visits a local neighborhood, memory proportional to the frontier, not the full graph
- For a 10K node graph with average degree 10: the push algorithm touches at most a few hundred nodes per query, using kilobytes of working memory
- Precomputed sparse PPR matrix (top-32 neighbors per node) for 10K nodes: 10K × 32 × 8 bytes ≈ 2.56MB — trivial

**5. Full stack budget on 8GB**

| Component | RAM estimate |
|---|---|
| macOS system processes | ~1.5-2GB |
| Qwen2.5 3B Q4_K_M (llama.cpp) | ~2.2GB |
| Embedding model (nomic-embed-text F16 CPU) | ~0.3GB |
| Python + application runtime | ~0.3GB |
| NetworkX graph (50K nodes, sparse) | ~0.15GB |
| Float16 embeddings (50K × 768) | ~0.08GB |
| PPR index + working memory | ~0.05GB |
| **Total** | **~4.6GB** |
| **Headroom** | **~3.4GB** |

A 50K-node graph with a 3B LLM fits comfortably on 8GB with ~3GB to spare. Even at 100K nodes (adding ~0.4GB for embeddings + graph), you still have headroom with a 3B model.

The wall: upgrading to a 7B model (~5GB) leaves only ~0.5-1GB headroom after macOS, which is tight. Stick with 3B-class models for the 8GB prototype.

---

## Summary: Feasibility Assessment

### What is practical NOW (v1 prototype, 8GB M2)

| Mechanism | Verdict | Latency | Notes |
|---|---|---|---|
| PPR traversal at 10K-50K nodes | **Green — implement** | 1-20ms | Precomputed sparse PPR + 1-3 power iterations |
| Incremental embedding updates (new nodes) | **Green — implement** | 1-10ms graph update, 50-200ms embed | Bottleneck is embedding inference, not graph |
| InkStream-style selective recomputation | **Green — use as design pattern** | 2.5-427x speedup over full recompute | k-hop localization is the key insight |
| EEGNN confidence halting | **Yellow — adapt the concept** | 0.025s for 20-layer GNN | Adapt per-node halting to traversal depth decisions |
| SQLite for graph persistence | **Green — use with NetworkX overlay** | Fine for <50K nodes | NetworkX for PPR, SQLite for durability |
| 3B LLM + graph + embeddings on 8GB | **Green — fits** | 25-40 tok/s LLM | Use Qwen2.5 3B or Phi-3-mini Q4 |

### What needs future work

| Mechanism | Issue | Path forward |
|---|---|---|
| TTT edge weight updates at inference time | CPU gradient descent is too slow for real-time; LaCT requires A100-class GPU | Use EWMA/attention scoring for v1; TTT as offline fine-tuning later |
| APPNP on-the-fly propagation at 100K+ nodes | OOM — must precompute | Already addressed by PPRGo/FORA precomputed approach |
| SQLite at 100K+ nodes | Multi-hop traversal degrades | Migrate to FalkorDB at this scale |
| EEGNN in production graph RAG | May 2025 paper, untested in production | Validate on a real memory graph prototype |
| 7B LLM on 8GB | Only 0.5-1GB headroom — risky | 16GB M2 is the right target for 7B models |

### Minimum viable scale for a compelling prototype

**10K nodes is the sweet spot for v1.** At this scale:
- PPR completes in ~1-5ms
- Full embedding matrix fits in 30MB (float32) or 15MB (float16)
- NetworkX graph loads in <1s from SQLite
- Incremental updates via InkStream-style localization take <10ms
- The whole stack (3B LLM + embeddings + graph) uses ~4GB of 8GB RAM
- You get a real, demonstrable associative memory with meaningful semantic connections

10K nodes is also large enough to demonstrate non-trivial recall and associative traversal, small enough that all algorithms are trivially fast, and a natural scaling unit (one new memory per conversation turn means you have headroom for ~5-10 years of daily journaling before hitting 10K).

---

Sources:
- [Real-Time Single-Source PPR over Evolving Social Networks, ICDE 2025](https://www.computer.org/csdl/proceedings-article/icde/2025/360300d765/26FZC2eBNEk)
- [FAST-PPR: Scaling Personalized PageRank, arXiv:1404.3181](https://arxiv.org/abs/1404.3181)
- [Efficient Algorithms for PPR: A Survey, arXiv:2403.05198](https://arxiv.org/abs/2403.05198)
- [PPRGo: Scaling GNNs with Approximate PageRank, arXiv:2007.01570](https://ar5iv.labs.arxiv.org/html/2007.01570)
- [InkStream: Real-time GNN Inference on Streaming Graphs, arXiv:2309.11071](https://arxiv.org/abs/2309.11071)
- [Ripple: Scalable Incremental GNN Inferencing, arXiv:2505.12112](https://arxiv.org/abs/2505.12112)
- [Early-Exit Graph Neural Networks, arXiv:2505.18088](https://arxiv.org/html/2505.18088)
- [Learning to (Learn at Test Time): TTT RNNs, arXiv:2407.04620](https://arxiv.org/abs/2407.04620)
- [Test-Time Training Done Right (LaCT), arXiv:2505.23884](https://arxiv.org/html/2505.23884v1)
- [PPR on Evolving Graphs, Incremental Index Update, arXiv:2212.10288](https://arxiv.org/abs/2212.10288)
- [FalkorDB vs Neo4j Performance Benchmarks](https://www.falkordb.com/blog/graph-database-performance-benchmarks-falkordb-vs-neo4j/)
- [kPAR: Realtime top-k PPR over Large Graphs on GPUs, VLDB](https://dl.acm.org/doi/10.14778/3357377.3357379)
- [FORA: Simple and Effective Approximate SSPPR, arXiv:1908.10583](https://arxiv.org/abs/1908.10583)
- [Memgraph vs Neo4j performance](https://memgraph.com/blog/memgraph-vs-neo4j-performance-benchmark-comparison)
- [Practical NLP with Local LLMs on M2 MacBook Air 8GB](https://mwzero.medium.com/practical-nlp-with-local-llms-on-a-macbook-air-m2-8-gb-bc1e66992eb0)
- [Best LLMs for MacBook (8GB–192GB)](https://modelfit.io/guides/best-llm-for-macbook/)
- [Nomic Embed: Local OpenAI-Quality Embeddings](https://www.nomic.ai/blog/posts/local-nomic-embed)
- [Embedding storage requirements, Milvus](https://milvus.io/ai-quick-reference/what-are-the-storage-requirements-for-embeddings)
- [SQLite as a Graph Database (simple-graph)](https://lobste.rs/s/x0fk0a/simple_graph_graph_database_sqlite)
- [IncDE: Continual Knowledge Graph Embedding, AAAI 2024](https://github.com/seukgcode/IncDE)
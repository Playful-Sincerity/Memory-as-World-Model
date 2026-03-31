Now I have enough data to compile the comprehensive technical feasibility report. Let me synthesize all findings.

---

# Technical Feasibility Report: Associative Memory Architecture
**Research Date:** 2026-03-29
**Sources searched:** arXiv, Semantic Scholar, ACL Anthology, ICLR/ICML/NeurIPS proceedings, Google Research blog
**Papers reviewed in depth:** 15+ across six topic areas

---

## Executive Summary

The Associative Memory Architecture (AMA) — which treats a memory graph as an interpretable world model, uses an LLM as reasoning engine over graph-as-text context, and relies on smaller models to suppress pretrained knowledge leakage — is **technically feasible but faces specific, well-characterized failure modes**. Each of the three core mechanisms has partial support in the 2024–2025 literature, but all three need careful engineering to hold together simultaneously.

---

## Topic 1: Can LLMs Reason Over Graph Structures Rendered as Text?

### What the Evidence Shows

**Yes, with sharp caveats about scale and format.**

The foundational systematic study is "Talk like a Graph" (Fatemi et al., ICLR 2024, Google Research), which established that encoding choice alone can shift LLM graph task performance by up to **60 percentage points**. The best-performing format they found was the "incident" notation (edge-list format), not adjacency matrices, natural-language prose, or JSON objects.

The April 2025 **KG-LLM-Bench** (arXiv 2504.07087) is the most directly relevant new benchmark. Across five KG reasoning tasks on 200-edge subgraphs, the best-to-worst textualization format gap was **17.5% absolute on overall performance, and larger on specific tasks**. Key ranking: Structured JSON ≈ 0.42 average accuracy, YAML slightly below, List-of-Edges in the middle, RDF Turtle ≈ 0.35, JSON-LD ≈ 0.34. For aggregation queries, JSON/YAML win because they naturally cluster related edges.

**GraCoRe** (COLING 2025, Harbin Institute of Technology, arXiv 2407.02936) benchmarks 4 closed-source and 8 open-source LLMs across 5,140 graphs spanning 10 capability areas and 19 tasks. Core finding: *general comprehension outstrips complex reasoning*. Node ordering significantly affects success rates. OpenAI o1's reasoning model substantially outperforms non-reasoning models — a strong signal that chain-of-thought over graph context requires deliberate multi-step processing. Crucially: *"the ability to process longer texts does not necessarily improve graph comprehension or reasoning."*

**GraphArena** (NeurIPS 2024 Datasets & Benchmarks) provides the clearest degradation curve: on polynomial-time tasks, Llama 3-70B vs Llama 3-8B is **61.2% vs 28.6% on small graphs** but collapses to **31.6% vs 9.4% on large graphs**. Scaling the graph breaks even large models badly.

### Scale Breakdown Point

The token-count problem is concrete. A graph with even a few hundred nodes rendered as edge triples rapidly reaches 6,000+ tokens. LLMs can count triangle memberships node-by-node in ~10-node graphs but fail on large graphs where this must be done systematically. Llama 3.1-405B's RAG performance starts degrading after 32k tokens; GPT-4-0125 after 64k tokens. For the AMA use case — where you render a *subgraph* retrieved around a query — this is manageable if retrieval is tight, but is a hard constraint on how much of the memory graph you can render at once.

### Linearization Strategy

The 2024 paper "Graph Linearization Methods for Reasoning on Graphs with LLMs" (arXiv 2410.19494) showed that centrality-based and degeneracy-based ordering (degree centrality, PageRank, k-core peeling) outperforms random ordering, because they maximize *local dependency* (neighboring tokens reflect graph neighborhoods) and *global alignment* (globally important anchor nodes appear first). For a tree structure specifically — which has natural topological order — this is encouraging: a parent-before-children BFS ordering directly satisfies both properties.

### Format Recommendation for AMA

Based on the evidence: **structured JSON or YAML edge lists, BFS-ordered from the query node, limited to 2-hop neighborhoods**. Unordered linearized triples outperform fluent narrative text for knowledge-intensive tasks (ScienceDirect 2025 study). Narrative prose loses relational structure.

---

## Topic 2: GCR / KG-Trie — Full Paper Analysis

**Paper:** "Graph-constrained Reasoning: Faithful Reasoning on Knowledge Graphs with Large Language Models" (arXiv 2410.13080, ICML 2025)
**Authors:** Luo et al. (same group as RoG/ICLR 2024)

### How KG-Trie Actually Works

GCR has three components:

1. **KG-Trie Construction (offline):** Given a topic entity, all valid KG reasoning paths up to L hops are enumerated and stored in a trie data structure. Each trie node is a path prefix (entity → relation → entity → ...). This is pre-built and cached.

2. **Graph-Constrained Decoding (inference):** During LLM generation, the KG-Trie acts as a hard constraint on the token vocabulary at each step. At each position, only tokens matching a valid trie prefix are permitted. This means the LLM *cannot generate a relation or entity that doesn't exist as a continuation* in the KG. Beam search with width K generates K diverse paths simultaneously in one forward pass.

3. **Graph Inductive Reasoning:** The K paths and their hypothesis answers are fed to a larger general-purpose LLM which reasons over the multi-path evidence to derive a final answer.

### Performance Numbers

- WebQSP Hit@1: **92.6%** (outperforms second-best by 2.1%)
- CWQ Hit@1: **75.8%** (outperforms second-best by 9.1%)
- **100% faithful reasoning ratio** on both benchmarks when the correct answer is generated (no hallucinated paths)
- A fine-tuned **0.5B model outperforms a 70B model** for the graph-constrained decoding component, confirming that the trie does the heavy structural lifting

### Real Limitations

**Trie construction is per-entity and must be pre-built.** For a fixed, well-structured KG like Freebase, this is fine. For a dynamic personal memory graph where nodes are continuously added and modified, the trie for every entity must be rebuilt or invalidated on every update. This is the single largest adaptation challenge for AMA.

**Storage scales with hop count:** ~0.5–7.5 MB per entity for 1–4 hops. Two hops is the practical sweet spot (>90% Hit rate, manageable storage). At 4 hops on a dense personal graph with thousands of nodes, trie size could become expensive if every entity requires its own trie.

**Scalability to Freebase/Wikidata scale is flagged as future work** by the authors themselves. The paper tested on standard KGQA benchmarks (WebQSP, CWQ) using subgraph retrieval first — the trie covers the retrieved subgraph, not the full KG.

**Beam width tradeoff:** Wider beam → more diverse candidate paths → better final answer quality, but more compute. The paper uses K=5 in main experiments.

**KG-Trie requires tokenizer-level integration.** This is not a prompting technique — it requires modifying the LLM's decoding loop to enforce trie-constrained vocabulary. This means you cannot use a closed-source API model (GPT-4, Claude) as the graph-constrained component. You need an open-weights model with accessible logits.

### Adaptation for AMA

The core idea is directly applicable to a tree-as-context model: instead of a KG trie over (entity, relation, entity) paths, you build a **tree-path trie** over (node\_id, edge\_label, child\_node\_id) paths. Since your structure is a tree (not a general graph), path enumeration is strictly cheaper — trees have no cycles, so path enumeration is O(n) rather than potentially exponential. The update problem is also lighter: adding a leaf node only invalidates/extends the tries of its ancestors, not the whole graph.

---

## Topic 3: Small Models for Graph-Grounded Reasoning

### Key Finding: Fine-Tuned Small Models Beat Large Generalist Models

The GCR paper provides the strongest evidence for this: a **fine-tuned Qwen2-0.5B outperforms GPT-4 (70B+)** for the graph-constrained decoding task after specialized training. This is the most important empirical result for AMA's anti-hallucination strategy.

**Why small models work here:** The KG-Trie mechanically eliminates hallucination at the path level — the model doesn't need to recall facts from pretraining, it only needs to *rank* valid paths. A small model fine-tuned to score path validity does this well. The pretrained knowledge problem is sidestepped structurally, not behaviorally.

### Model Landscape (1B–7B)

- **Phi-3 (3.8B, Microsoft):** Best-in-class for RAG-style tasks in the sub-4B range. GPT-3.5 class performance from textbook-quality training data. Strong at reasoning over retrieved context, notably fast (40–45 tokens/sec locally). Weakness: struggles with niche factual queries without retrieval, and drops instructions on 30k+ token dense contexts.
- **Llama 3.1-8B:** Used as the base for GCR's KG-specialized LLM in main experiments. Good baseline. Fine-tunes well.
- **Qwen2-0.5B / 1.5B / 7B:** Explicitly tested in GCR. The 0.5B is shockingly capable for constrained decoding after fine-tuning.
- **Mistral 7B:** Strong multilingual and RAG performance; prone to hallucination in unconstrained settings.

### THINKSLM (EMNLP 2025)

"THINKSLM: Towards Reasoning in Small Language Models" demonstrates that reasoning capability can be bootstrapped into small models, suggesting that the gap between small and large models for structured reasoning tasks is closable with targeted training data — not just parameter count.

### Context Window Limitations

Pushing 30k+ dense tokens into Phi-3 class models causes dropped instructions and hallucinated summaries due to insufficient attention head capacity. For AMA, this enforces tight subgraph retrieval — you cannot dump the entire memory graph into context even if the model has a large window.

---

## Topic 4: Context-Faithfulness — The Core Risk

### The Context-Parametric Inversion Problem (ICLR 2025)

**Paper:** arXiv 2410.10796, published at ICLR 2025 (two versions: "Why Instruction Finetuning Can Worsen Context Reliance" and "Why Instruction Finetuning May Not Actually Improve Context Reliance")

**The core finding is alarming for AMA:** During instruction fine-tuning, context reliance initially increases as expected, then *decreases as training continues* — even as standard benchmark performance keeps rising. This occurs across TULU, Alpaca, Ultrachat datasets and across Llama, Mistral, and Pythia model families.

**Root cause:** Instruction tuning data contains both context-critical examples (where the right answer requires reading the provided context) and non-context-critical examples (where the model can answer from parametric memory). The non-context-critical examples teach the model to bypass context. As IFT progresses, the model learns to use parametric shortcuts more reliably, which hurts context reliance even as benchmark scores improve.

**Mitigation strategies explored:** Data curation (removing non-context-critical examples), data augmentation (adding counterfactual context), and regularization. All work *partially* but have fundamental tradeoffs — pure context-critical training data degrades general capability.

### Recent Solutions (2025–2026)

**ParamMute** (arXiv 2502.15543, NeurIPS 2025): A mechanistic intervention — identifies "Unfaithfulness-Associated FFNs" (UA-FFNs) in mid-to-deep layers that are disproportionately activated in hallucination cases, then suppresses their activation at inference time with an adaptation module that promotes reliance on external knowledge. Achieves **+5% average context reliability improvement** over vanilla RAG, **+4% reduction in parametric memory reliance**, outperforming SFT, KAFT, DPO, and DDR fine-tuning approaches on ConFiQA and FaithEval. This is training-free at inference: you identify the FFNs once and suppress them permanently. The ParamMute-8B-SFT model is on HuggingFace.

**FaithEval** (ICLR 2025, Salesforce): Benchmark with 4.9K problems across unanswerable, inconsistent, and counterfactual contexts. The CLEAR system achieves 74.4% F1 / 64.4% EM, outperforming CANOE by ~3% F1 and ~8% EM.

**Teaching Context Faithfulness via RL** (arXiv 2505.16483, 2025): Uses synthetic tasks + reinforcement learning to train models to maintain contextual faithfulness — treats context-following as a learnable behavioral objective, not just a data curation problem.

**Resisting Contextual Interference via Parametric-Knowledge Reinforcement** (arXiv 2506.05154, ICLR 2026): Addresses the opposite direction — preventing models from *over-relying* on (potentially noisy) context. Relevant for the AMA case where memory graph entries may be outdated or conflicting.

### The Fundamental Tension for AMA

The literature reveals a genuine architectural tension: models trained to follow context perfectly become vulnerable to noisy, conflicting, or injected context. Models with strong parametric knowledge are more robust to context errors but harder to ground. AMA's bet — that smaller models have less parametric knowledge to fight — is partially validated: smaller models are *less* opinionated about world facts and therefore easier to ground. But the inversion problem shows that even small models, once instruction-tuned, develop parametric shortcuts.

**Key gap:** No current method achieves >~75% faithfulness on adversarial/counterfactual contexts. For AMA, this means graph entries that contradict the model's training data will still sometimes lose to parametric memory.

---

## Topic 5: Graph-to-Text Serialization for LLMs

### What Format Actually Works Best

The evidence is now fairly settled. From KG-LLM-Bench (April 2025) across seven models and five textualization strategies:

| Format | Avg. Accuracy | Best For |
|---|---|---|
| Structured JSON | 0.42 | Aggregation queries |
| Structured YAML | ~0.40 | Aggregation queries |
| List-of-Edges | ~0.38 | Traversal tasks |
| RDF Turtle | 0.35 | — |
| JSON-LD | 0.34 | — |

**Unordered triples beat prose.** A ScienceDirect 2025 study found linearized triples consistently outperform fluent natural-language text for knowledge-intensive questions, and combining both formats does not improve over triples alone.

**Node ordering matters significantly.** GraCoRe (COLING 2025) explicitly flags this. The graph linearization paper (arXiv 2410.19494) shows centrality-based and degeneracy-based orderings (PageRank, k-core) beat random ordering by placing high-connectivity anchor nodes early in the sequence, where attention is strongest.

**Graph size is the dominant variable.** Once graphs exceed ~6,000 tokens of rendered triples, performance degrades steeply. For a personal memory tree, a 2-hop neighborhood centered on the query concept is likely manageable; a full render is not.

**"Let Your Graph Do the Talking"** (arXiv 2402.05862) introduces GraphToken, a parameter-efficient method that *learns* an encoding function extending prompts with explicit structural information — showing improvements up to 73 percentage points on node, edge, and graph-level tasks. This approach (learned graph encodings rather than text serialization) is a more powerful but harder-to-deploy alternative.

### Implication for AMA Tree Rendering

For a tree-structured memory: render as **JSON with node IDs as keys, parent references explicit, relation labels as string values, BFS ordering from the query node, limited to 2 hops**. Include relation type on each edge. Do not flatten to prose. Do not use RDF-style namespaced notation (RDF Turtle performs worst).

---

## Topic 6: FiDeLiS — Full Analysis

**Paper:** "FiDeLiS: Faithful Reasoning in Large Language Models for Knowledge Graph Question Answering" (arXiv 2405.13873, ACL 2025 Findings, also ICLR 2025 workshop)

### Architecture

**Path-RAG:** Extracts key terms from the question → generates dense embeddings → retrieves candidate entities/relations from a pre-embedded KG combining semantic similarity + graph connectivity → produces candidate reasoning steps.

**DVBS (Deductive-Verification Beam Search):** Beam search over candidate paths, with an LLM scoring each step via *deductive reasoning* rather than logit-based scoring. The LLM is asked "given what we know so far, does this next step logically follow?" At each beam expansion, steps are scored by whether they make the question deducible. Search halts once deducibility is achieved — this is important: it stops reasoning when enough evidence is found, rather than exhausting a fixed path length.

### Performance Numbers (Ablation Study)

- Removing beam search → **-18.97% Hit@1 on WebQSP, -13.34% on CWQ** (beam search is the largest single component)
- Removing Path-RAG → **-6.97% on WebQSP, -6.01% on CWQ**
- Removing deductive verifier → smaller but notable contribution
- **Training-free framework** — works with any LLM at inference

The beam search contribution being the largest component is telling: iterative exploration of multiple candidate paths is more valuable than the specific verification mechanism.

### Applicability to AMA

FiDeLiS is more directly applicable to AMA than GCR because it is **training-free and works through prompting**. You don't need to modify the decoding loop. The Path-RAG component maps naturally to AMA's subgraph retrieval step. The DVBS component maps to incremental reasoning over the memory tree — each beam step is "traverse one edge of the memory tree and verify whether the accumulated path so far answers the query."

The "halt when deducible" property is particularly relevant for AMA: it prevents the model from over-generating and potentially introducing hallucinated content after the relevant graph context has already been found.

**Key limitation:** FiDeLiS still relies on the LLM's ability to perform deductive verification, which itself can fail. The verification LLM call at each beam step multiplies inference cost by ~beam_width × path_length.

---

## Synthesis: Feasibility Assessment for the Associative Memory Architecture

### What Is Confirmed Feasible

1. **Graph-as-text reasoning works for bounded subgraphs.** 2-hop neighborhoods rendered as structured JSON/YAML, BFS-ordered from the query node, under ~6k tokens: current LLMs (including 7B-class models) reason over this adequately. The "incident" / edge-list format and the KG-LLM-Bench JSON format are the empirically strongest choices.

2. **Constrained generation over graph paths is implementable and effective.** GCR/KG-Trie achieves 100% faithful path generation, 92.6% Hit@1 on WebQSP, and demonstrates that a fine-tuned 0.5B model can outperform GPT-4 on the structural task. For a tree structure (simpler than general KGs, no cycles), trie construction is cheaper and updates are localized.

3. **Small fine-tuned models are the right choice for the structural component.** The GCR result — 0.5B beats 70B after fine-tuning — validates AMA's anti-hallucination strategy structurally. The trie constraint does the faithfulness work; the model does path ranking. Less pretrained knowledge = less to fight.

4. **FiDeLiS-style deductive beam search is usable training-free.** Path-RAG + DVBS as a prompting strategy over the memory tree requires no decoding modifications and works with any model.

### What Needs Careful Engineering

5. **KG-Trie requires offline construction and incremental update logic.** For a static graph this is easy. For a live memory graph with continuous updates, you need a delta-update protocol: adding a node only requires extending ancestor tries, not rebuilding everything. This is tractable for trees but must be explicitly designed.

6. **Context-parametric inversion is real and partially unsolved.** Even after context-faithful fine-tuning, models degrade on adversarial/counterfactual contexts (~25% failure rate on FaithEval). ParamMute (NeurIPS 2025) offers the most promising mitigation: identify and suppress the specific FFNs responsible, with +5% faithfulness and training-free deployment. Integrating ParamMute into the KG-constrained model is a direct next step.

7. **Serialization format is not trivial.** The 17.5% performance gap between best and worst textualization formats is large enough to determine whether AMA works or fails in practice. JSON with explicit parent/child structure, BFS-ordered, is the recommended format based on the literature.

### The Core Feasibility Gap

The architecture requires all three mechanisms to work **simultaneously**: (a) faithful path generation via constrained decoding, (b) correct context utilization by the reasoning LLM, and (c) a small model that is both graph-specialized and context-faithful. The literature demonstrates each component separately but not in combination. The integration challenge is:

- The KG-constrained LLM (small, fine-tuned) generates faithful paths — this is solved.
- The inductive reasoning LLM (general-purpose, larger) reasons over those paths — this is where context-parametric inversion bites. Even GPT-4 class models can bypass provided context ~25% of the time on adversarial inputs.
- The two-LLM architecture of GCR (small specialized + large general) is the state of practice, but the large general LLM is the weak link for faithful final-answer generation.

**The gap is not whether the components exist — they do. The gap is whether a production system can maintain >90% faithful end-to-end reasoning across diverse queries, including ones where the memory graph content contradicts the model's parametric beliefs.** Current best results suggest ~75–93% faithfulness depending on task type, with the hardest failures occurring at the final answer generation step, not the path retrieval step.

---

## Recommended Architecture Decisions (Based on Evidence)

| Decision | Recommendation | Evidence |
|---|---|---|
| **Graph text format** | Structured JSON, BFS-ordered, 2-hop limit | KG-LLM-Bench (2025), Talk like a Graph |
| **Constrained decoding** | KG-Trie over tree paths (GCR-style) | arXiv 2410.13080, ICML 2025 |
| **Path generation model** | Fine-tuned Qwen2-0.5B or Llama-3.1-8B | GCR ablations |
| **Final reasoning model** | GPT-4o class or o1 for complex queries | GraCoRe results (o1 substantially better) |
| **Context faithfulness intervention** | ParamMute on the reasoning LLM | arXiv 2502.15543, NeurIPS 2025 |
| **Beam search** | Use it; width K=5 is practical | FiDeLiS ablation (-19% without it) |
| **Update protocol** | Delta-update on tree path tries on node insert/modify | Inferred from GCR storage analysis |
| **Faithfulness test** | FaithEval + ConFiQA as evaluation harness | Salesforce FaithEval (ICLR 2025) |

---

## Key Papers for Follow-Up

- [Graph-constrained Reasoning (GCR/KG-Trie), arXiv 2410.13080, ICML 2025](https://arxiv.org/abs/2410.13080)
- [FiDeLiS, arXiv 2405.13873, ACL 2025](https://arxiv.org/abs/2405.13873)
- [Context-Parametric Inversion, arXiv 2410.10796, ICLR 2025](https://arxiv.org/abs/2410.10796)
- [ParamMute, arXiv 2502.15543, NeurIPS 2025](https://arxiv.org/abs/2502.15543)
- [KG-LLM-Bench, arXiv 2504.07087, NAACL 2025](https://arxiv.org/abs/2504.07087)
- [Graph Linearization Methods, arXiv 2410.19494](https://arxiv.org/abs/2410.19494)
- [GraCoRe Benchmark, arXiv 2407.02936, COLING 2025](https://arxiv.org/abs/2407.02936)
- [Talk like a Graph (GraphQA), arXiv 2310.04560, ICLR 2024](https://arxiv.org/abs/2310.04560)
- [Reasoning on Graphs (RoG), arXiv 2310.01061, ICLR 2024](https://arxiv.org/abs/2310.01061)
- [GraphRAFT, arXiv 2504.05478](https://arxiv.org/abs/2504.05478)
- [FaithEval, arXiv 2410.03727, ICLR 2025](https://arxiv.org/abs/2410.03727)
- [FACTS Grounding Leaderboard, arXiv 2501.03200](https://arxiv.org/abs/2501.03200)
- [Google Research: Talk Like a Graph blog](https://research.google/blog/talk-like-a-graph-encoding-graphs-for-large-language-models/)
# Architecture

## Five-Layer Design

```
┌─────────────────────────────────────────────────┐
│  Layer 5: CONTEXT MANAGER                        │
│  Competitive context selection (GWT)             │
│  Active pruning by distance-from-focus           │
│  Distance-proportional compression               │
│  Confidence-triggered loading                    │
├─────────────────────────────────────────────────┤
│  Layer 4: TRAVERSAL ENGINE                       │
│  Spreading activation (Collins & Loftus)         │
│  ACT-R activation scoring (B + C + P + noise)   │
│  Path growth from consciousness → target         │
│  Multi-scale depth (adapts to query complexity)  │
├─────────────────────────────────────────────────┤
│  Layer 3: ASSOCIATION MODEL                      │
│  Hebbian co-occurrence (fire together → wire)    │
│  Experiential distance (not just semantic)       │
│  Hyperbolic geometry for natural tree growth     │
│  Edge decay for untraversed associations         │
├─────────────────────────────────────────────────┤
│  Layer 2: MEMORY NODES                           │
│  Episodic (timestamped, contextual, decays)      │
│  Semantic (abstracted, stable, high-connectivity)│
│  Multimodal (text, image, sound, sensor)         │
│  Lightweight indices pointing to full content    │
├─────────────────────────────────────────────────┤
│  Layer 1: STORAGE & MAINTENANCE                  │
│  Graph DB + Vector DB                            │
│  Background consolidation                        │
│  Episodic → semantic promotion via replay        │
│  Conflict detection + fact invalidation          │
└─────────────────────────────────────────────────┘
```

## How a Thought Happens

```
1. LOCATE     Input arrives ("ice cream")
              Embed it. Find nearest node in the graph.
              (The one RAG-like step — finding the entry point)

2. TRAVERSE   From current focus, find path → target node
              Spreading activation propagates outward
              Strongest edges activate first
              Path discovered through the graph topology

3. LOAD       Load nodes along the path into context
              Current focus: verbatim
              1-hop: light compression
              2-hop: heavy compression
              3+ hops: summary only

4. PRUNE      Context has a budget
              Score each loaded node by distance from focus
              Evict the most distant when budget exceeded
              Evicted nodes remain in graph, leave context

5. STRENGTHEN Every edge traversed gets weight bumped
              Co-occurrence in context creates new edges
              This IS the learning — the graph evolves

6. SHIFT      Update consciousness pointer to new position
              The agent is now "at" the target
              Everything reachable from here is available
```

## Critical Parameters

| Parameter | Source | Range | Controls |
|-----------|--------|-------|----------|
| Decay rate (d) | ACT-R | ~0.5 | Forgetting speed |
| Spreading decay (D) | Collins & Loftus | 0.3-0.8 | Associative reach per hop |
| Firing threshold (τ) | ACT-R | Dynamic | Minimum activation to enter context |
| Context capacity | GWT | Budget-limited | How many nodes fit in active context |
| Fan normalization | ACT-R | S_max - ln(fan) | Prevents generic hubs from dominating |
| Strengthening rate | Hebbian | TBD | How fast edges grow from co-occurrence |
| Edge decay rate | — | TBD | How fast unused edges weaken |

## Relationship to Existing Systems

| System | What We Take | Where We Go Further |
|--------|-------------|-------------------|
| SYNAPSE | Spreading activation, lateral inhibition | Hebbian edge learning, graph-native context |
| HippoRAG 2 | Hippocampal indexing, PageRank | Experiential (not just entity) associations |
| Graphiti/Zep | Bi-temporal tracking, production patterns | Graph-native traversal instead of BFS |
| ACT-R | Activation equations, decay, fan effect | Applied to agent context management |
| Voltropy LCM | DAG structure, compaction, expand/grep | Typed/weighted edges, curiosity, emotion |
| GWT | Competitive context selection | Graph-topology-aware competition |

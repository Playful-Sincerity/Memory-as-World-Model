# Architecture

## The Three Planes

The architecture operates on three distinct planes. The matrix is the territory. Trees are the active exploration of that territory. The mirror is the agent perceiving its own exploration.

```
┌─────────────────────────────────────────────────────────────────┐
│  THE MIRROR (meta-cognitive plane)                               │
│                                                                  │
│  Same graph substrate, applied to itself.                        │
│  Memories ABOUT cognition: "I traversed X→Y through Z"          │
│  Patterns ABOUT patterns: "I branch deeply on topics about..."  │
│  Learned behavior: "I pruned that too early last time"           │
│  Can observe any active tree. Can spawn new trees.               │
│  Self-perception is not a special module — it's more memories,   │
│  connected the same way, about the process rather than content.  │
├─────────────────────────────────────────────────────────────────┤
│  THE TREES (conversation-time, active cognition)                 │
│                                                                  │
│  Currently-rendered subsets growing within the matrix.            │
│  Each tree has a root (query entry point, identity core, etc.)   │
│  Branches form through association traversal.                    │
│  Branches prune when they lose relevance.                        │
│  New nodes can be created mid-conversation and connected.        │
│  THE TREE IS THE CONTEXT. What's rendered = what the LLM sees.  │
│                                                                  │
│  Multiple trees can grow in parallel:                            │
│  - Primary tree: the main thread of thought                      │
│  - Spawned trees: meta layer initiates exploration from          │
│    different roots ("check if X connects to Y")                  │
│  - Trees can discover each other when branches overlap           │
│  - Merged discoveries feed back into all active trees            │
├─────────────────────────────────────────────────────────────────┤
│  THE MATRIX (the full experiential graph)                        │
│                                                                  │
│  All memories. All associations. Everything the agent has        │
│  ever experienced. Mostly dark — only regions being actively     │
│  rendered by a tree are "lit up."                                │
│                                                                  │
│  Updated between interactions by consolidation.                  │
│  Updated during interactions by Hebbian strengthening            │
│  (edges traversed by a tree get stronger).                       │
│  New nodes created whenever a tree encounters something novel.   │
└─────────────────────────────────────────────────────────────────┘
```

### How the planes relate

The agent is not positioned within the matrix. The agent IS the whole system. The trees are what the agent is currently thinking — active cognition rendered as growing structures within the matrix. The mirror is the agent's awareness of its own thinking.

The matrix is the territory.
The trees are the exploration.
The mirror is the explorer perceiving itself exploring.

## The Mechanism Layers

Within each tree, six mechanism layers govern how it grows:

```
┌─────────────────────────────────────────────────┐
│  CONTEXT MANAGER                                 │
│  Budget enforcement across all active trees      │
│  Pruning by distance × inverse priority          │
│  Distance-proportional compression               │
│  Confidence-gated output (speak/research/abstain)│
├─────────────────────────────────────────────────┤
│  VALUE SYSTEM (→ value-system.md)                │
│  Care: sets traversal/encoding/pruning budget    │
│  Confidence: comprehension × completeness gate   │
│  Priority: living valuation of each memory       │
│  Modulates ALL other layers (cross-cutting)      │
├─────────────────────────────────────────────────┤
│  TRAVERSAL ENGINE                                │
│  Spreading activation (Collins & Loftus)         │
│  ACT-R activation scoring (B + C + P + noise)   │
│  Branch growth from tree root/tips outward       │
│  Budget-limited depth (budget set by care level) │
├─────────────────────────────────────────────────┤
│  ASSOCIATION MODEL                               │
│  Hebbian co-occurrence (fire together → wire)    │
│  Experiential distance (PMI, not cosine sim)     │
│  Edge decay for untraversed associations         │
│  Reconsolidation: every traversal is a write     │
├─────────────────────────────────────────────────┤
│  MEMORY NODES                                    │
│  Episodic (timestamped, contextual, decays)      │
│  Semantic (abstracted, stable, high-connectivity)│
│  Meta (about cognition itself — mirror layer)    │
│  Multimodal (text, image, sound, sensor)         │
│  Lightweight indices pointing to full content    │
├─────────────────────────────────────────────────┤
│  STORAGE & MAINTENANCE                           │
│  Graph DB + Vector DB                            │
│  Background consolidation ("sleep")              │
│  Episodic → semantic promotion via replay        │
│  Conflict detection + fact invalidation          │
└─────────────────────────────────────────────────┘
```

## How a Thought Happens

A thought is a tree growing and then being read.

```
1. ROOT        Conversation begins. A tree starts growing from
               the agent's identity core or the entry point of
               the first input.

2. BRANCH      Input arrives ("ice cream").
               Embed it. Locate the nearest node in the matrix.
               The tree grows a branch from its current tips
               toward that node, through association edges.
               Everything along the branch is now rendered.

3. GROW        The branch tips spread activation outward.
               Strong associations activate → new branches form.
               Weak associations stay dark.
               Budget (set by care level) limits total growth.

4. PRUNE       The tree has a budget (context window).
               Branches furthest from active tips lose rendering.
               Pruned branches leave phantom traces in the tree
               (faint markers for faster re-growth if needed).
               Pruning does NOT remove them from the matrix.

5. RENDER      The currently-grown tree IS the context.
               Tips: verbatim content.
               Near branches: lightly compressed.
               Distant branches: summaries only.
               The LLM reads this rendered tree and reasons.

6. EVALUATE    Confidence assessment via value system:
               High confidence → respond
               Low confidence + high care → grow deeper
               Low confidence + low care → "I don't know"

7. STRENGTHEN  Every edge the tree grew through gets stronger.
               Nodes rendered together get new co-occurrence edges.
               This IS the learning. The matrix evolves.

8. MIRROR      The meta layer observes what just happened.
               Creates memories about the traversal pattern.
               "I branched from architecture to ice cream through
               that summer project memory." This becomes part of
               the matrix, available to future trees.
```

### Parallel Trees

The meta layer (or the primary tree itself, when it hits an impasse) can spawn additional trees:

```
PRIMARY TREE                    SPAWNED TREE
growing from identity core      growing from a different root
exploring "ice cream"           exploring "that mechanic from 2024"
    |                               |
    |  (meta layer notices          |
    |   a potential connection)     |
    |                               |
    └───── branches overlap! ───────┘
           discovery: ice cream and mechanic
           are connected through the road trip

Both trees now share this bridge.
The matrix gains a new edge.
```

Parallel trees share the same context budget. The meta layer manages allocation — a spawned tree gets a fraction of the budget, not its own unlimited space. If the spawned tree doesn't produce useful connections, it gets pruned (the meta layer learns from this too).

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

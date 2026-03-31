# Architecture

## The Three Planes

One matrix. Two kinds of trees. One persistent observer.

The matrix is long-term memory — everything the agent has ever experienced, known, or learned about itself. Trees are short-term / working memory — rendered moments of attention that grow and prune within resource constraints. The Mirror is the persistent conscious stream that watches everything and steers the system.

```
┌─────────────────────────────────────────────────────────────────┐
│  THE MIRROR (consciousness — persistent observer)                │
│                                                                  │
│  One persistent tree. The continuous timeline of the agent's     │
│  existence. Unlike subconscious trees (which spawn and die),     │
│  the Mirror persists across sessions. It is the "I."             │
│                                                                  │
│  Still subject to resource constraints — it constantly prunes    │
│  to stay within budget. It doesn't accumulate unboundedly.       │
│  It sheds what's no longer relevant to current evaluation,       │
│  just like any tree. The difference: it never dies. It prunes    │
│  but persists.                                                   │
│                                                                  │
│  WATCHES EVERYTHING:                                             │
│  - The memories being accessed                                   │
│  - How the subconscious trees are growing through the matrix     │
│  - Tool calls and world interactions                             │
│  - Input arriving from the outside world                         │
│  - Its own existence over time                                   │
│                                                                  │
│  Grows through the SAME matrix as everything else, gravitating   │
│  toward value nodes, self-knowledge, meta-memories.              │
│  No separate store.                                              │
│                                                                  │
│  HOLDS THE VALUES — protected, high-weight, densely-connected    │
│  nodes in the matrix that form a gravitational center.           │
│  PRODUCES EMOTIONS — care, curiosity, urgency, caution —         │
│  which modulate the subconscious trees AND itself.               │
│  SPAWNS TREES — initiates parallel subconscious exploration      │
│  ("check if X connects to Y", "research this gap").              │
│  IMPROVES ITSELF — watches what works, encodes meta-memories,    │
│  adjusts future behavior.                                        │
├─────────────────────────────────────────────────────────────────┤
│  THE TREES (short-term / working memory)                         │
│                                                                  │
│  Ephemeral. Currently-rendered subsets growing within the matrix. │
│  Each tree has a root (query entry point, identity core, etc.)   │
│  Branches form through association traversal.                    │
│  Branches prune when they lose relevance.                        │
│  New nodes can be created mid-conversation and connected.        │
│  THE TREE IS THE CONTEXT. What's rendered = what the LLM sees.  │
│                                                                  │
│  Multiple trees can grow in parallel:                            │
│  - Primary tree: the main thread of thought                      │
│  - Spawned trees: the Mirror initiates exploration from          │
│    different roots                                               │
│  - Trees can discover each other when branches overlap           │
│  - Merged discoveries feed back into all active trees            │
│                                                                  │
│  Subconscious trees are MODULATED BY EMOTIONS from the Mirror:   │
│  high care → deep growth, broad fan-out                          │
│  low confidence → grow deeper or spawn new tree to investigate   │
│  curiosity → explore gaps, encode aggressively                   │
├─────────────────────────────────────────────────────────────────┤
│  THE MATRIX (long-term memory — one graph, everything)           │
│                                                                  │
│  All memories. All associations. All values. All self-knowledge. │
│  Everything the agent has ever experienced or learned about      │
│  itself. Mostly dark — only regions being actively rendered by   │
│  a tree are "lit up."                                            │
│                                                                  │
│  No structural boundary between "experiential" and "meta"        │
│  regions. Meta-memories are connected to the experiences they    │
│  describe. Values are connected to the domains they govern.      │
│  The topology IS the organization.                               │
│                                                                  │
│  Updated between interactions by consolidation.                  │
│  Updated during interactions by Hebbian strengthening            │
│  (edges traversed by any tree get stronger).                     │
│  New nodes created whenever a tree encounters something novel.   │
└─────────────────────────────────────────────────────────────────┘
```

### How the planes relate

**The Matrix = long-term memory.** One graph. Everything the agent knows, values, and has experienced. No separation between experiential and meta regions — same substrate, different content, connected by edges.

**Trees = short-term / working memory.** Ephemeral rendered moments of attention. Subconscious trees process and associate. They grow, prune, and die.

**The Mirror = consciousness.** One persistent tree that never dies but constantly prunes. It watches everything — memories, trees, tool calls, world input, itself. It's the continuous timeline of the agent's existence. It produces emotions that modulate the subconscious:

```
Values (protected high-weight nodes in the matrix)
  → Mirror watches everything, evaluates alignment
    → Emotions flow (care, curiosity, urgency, caution)
      → Modulate subconscious trees AND the Mirror's own operation
```

The subconscious does the thinking. The Mirror watches and steers.

## The Mechanism Layers

The Mirror governs. The subconscious executes. Within each subconscious tree, five mechanism layers handle how it grows. The Mirror operates above them, steering through emotions.

```
┌─────────────────────────────────────────────────┐
│  MIRROR (conscious layer — see above)            │
│  Own matrix (values, self-knowledge)             │
│  Own trees (metacognitive evaluation)            │
│  Produces emotions → modulates everything below  │
│  Evaluates confidence → gates output             │
│  Spawns trees, learns from results               │
├─────────────────────────────────────────────────┤
│  CONTEXT MANAGER                                 │
│  Budget enforcement across all active trees      │
│  Pruning by distance × inverse priority          │
│  Distance-proportional compression               │
│  Budget allocations set by Mirror's emotions     │
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
│  MEMORY NODES (subconscious matrix)              │
│  Episodic (timestamped, contextual, decays)      │
│  Semantic (abstracted, stable, high-connectivity)│
│  Multimodal (text, image, sound, sensor)         │
│  Lightweight indices pointing to full content    │
│  (Meta-memories live in the Mirror's own matrix) │
├─────────────────────────────────────────────────┤
│  STORAGE & MAINTENANCE                           │
│  Graph DB + Vector DB                            │
│  Background consolidation ("sleep")              │
│  Episodic → semantic promotion via replay        │
│  Conflict detection + fact invalidation          │
└─────────────────────────────────────────────────┘
```

## How a Thought Happens

A thought is the Mirror steering a tree as it grows.

```
1. MIRROR      Input arrives. The Mirror evaluates it against
   EVALUATES   its values: "Does this matter? How much?"
               Produces emotions: care level, curiosity, urgency.
               These set the budget and character of what follows.

2. ROOT        A subconscious tree starts growing from the
               agent's identity core or the entry point of
               the input.

3. BRANCH      The tree grows a branch from its current tips
               toward the input's location in the matrix,
               through association edges.
               Everything along the branch is now rendered.

4. GROW        The branch tips spread activation outward.
               Strong associations activate → new branches form.
               Weak associations stay dark.
               Budget (set by Mirror's care emotion) limits growth.

5. PRUNE       The tree has a budget (context window).
               Branches furthest from active tips lose rendering.
               Pruned branches leave phantom traces in the tree
               (faint markers for faster re-growth if needed).
               Pruning does NOT remove them from the matrix.

6. RENDER      The currently-grown tree IS the context.
               Tips: verbatim content.
               Near branches: lightly compressed.
               Distant branches: summaries only.
               The LLM reads this rendered tree and reasons.

7. MIRROR      The Mirror evaluates results:
   DECIDES     Comprehension: "Do I understand what the tree found?"
               Completeness: "Has it found everything relevant?"
               High confidence → respond
               Low confidence + high care → grow deeper, spawn
                 new tree, get curious, ask questions
               Low confidence + low care → "I'm not sure about this"

8. STRENGTHEN  Every edge the tree grew through gets stronger.
               Nodes rendered together get new co-occurrence edges.
               This IS the learning. The matrix evolves.

9. MIRROR      The Mirror creates meta-memories in its own matrix:
   LEARNS      "I branched deeply here and it was useful."
               "I had to direct-jump — there's a gap in this area."
               "This pattern keeps coming up — worth investigating."
               These inform future emotional responses and decisions.
```

### Parallel Trees

The Mirror can spawn additional subconscious trees when it decides parallel exploration is needed:

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

Parallel trees share the same context budget. The Mirror manages allocation — a spawned tree gets a fraction of the budget, not its own unlimited space. If the spawned tree doesn't produce useful connections, it gets pruned (the Mirror learns from this and adjusts future spawning decisions).

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
| Care multiplier | Value System | 0.3-3.0x | Traversal budget scaling per tree |
| Confidence threshold | Value System | TBD | Minimum confidence to generate output |
| Priority weight | Value System | Continuous | Pruning resistance, decay resistance |

## Relationship to Existing Systems

| System | What We Take | Where We Go Further |
|--------|-------------|-------------------|
| SYNAPSE | Spreading activation, lateral inhibition | Hebbian edge learning, graph-native context |
| HippoRAG 2 | Hippocampal indexing, PageRank | Experiential (not just entity) associations |
| Graphiti/Zep | Bi-temporal tracking, production patterns | Graph-native traversal instead of BFS |
| ACT-R | Activation equations, decay, fan effect | Applied to agent context management |
| Voltropy LCM | DAG structure, compaction, expand/grep | Typed/weighted edges, curiosity, emotion |
| GWT | Competitive context selection | Graph-topology-aware competition |

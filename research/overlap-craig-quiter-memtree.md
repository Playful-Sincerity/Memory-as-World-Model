# Overlap Analysis: Craig Quiter / MemTree × MWM

*2026-04-21*

## Who Is Craig Quiter

AI engineer, San Bruno CA. Deep RL → self-driving (Deepdrive, OpenAI partnership, Uber/Otto) → AI agent memory. Now building MemTree (memtree.dev) and PolyChat (api.polychat.co). Also runs model safety evals across providers. GitHub: 86 repos, 1k+ stars. Wisdom met him previously, likely at Frontier Tower.

## What MemTree Is

Context memory for long-running AI agents. Two layers to the story:

### The Academic Foundation
"From Isolated Conversations to Hierarchical Schemas: Dynamic Tree Memory Representation for LLMs" — ICLR 2025. O(log N) insertion. Outperforms MemGPT (84.8% vs 70.4% accuracy on Multi-Session Chat). Each node holds aggregated text + semantic embeddings at varying abstraction levels.

### The Product (memtree.dev / PolyChat)
Commercialized implementation with additional engineering:
- **Architecture:** B-tree hierarchy with GraphRAG-style relationship encoding. Top = high-level summary, bottom = verbatim excerpts, middle = progressively detailed summaries that expand/collapse based on query relevance.
- **Semantic addressing:** Messages ARE identifiers — no memory IDs. Enables branching and reverting without orphaned data.
- **Performance:** ~100ms query, ~1min indexing per 10k tokens, compresses to ~30k tokens (15% of 200k window).
- **Stack:** Gemini 2.5 Flash (indexing), Voyage 3.5 (embeddings).
- **Key result:** Solved METR eval no other model solved. R² 0.994 with memory vs 0.690 without.
- **Pricing:** $4/M input, $2/M cached, $10/M output.
- **Claude Code integration:** `claude-code-infinite` npm package wraps Claude Code with MemTree for indefinite sessions.

## The Core Architectural Comparison

| Dimension | MemTree | MWM |
|-----------|---------|-------------------|
| **Framing** | Memory as compression/retrieval | Memory as meaning/world model |
| **Structure** | B-tree (hierarchical, ordered) | Graph (navigational, associative) |
| **What nodes represent** | Summaries at different abstraction levels | Semantic entities and their relationships |
| **What edges represent** | Parent-child hierarchy (implicit ordering) | Named, typed relationships (explicit meaning) |
| **Intelligence locus** | LLM interprets retrieved context | Graph structure IS the interpretable model |
| **Anti-hallucination** | Better context → fewer errors | Structural — graph constrains what can be claimed |
| **Retrieval** | Vector similarity + tree traversal (~100ms) | Graph navigation (pathfinding through meaning) |
| **Scalability bet** | Compression ratio (how much can you summarize) | Graph density (how richly connected is the model) |
| **Ambition** | Make agents remember better | Make the memory itself intelligent |

### Where They Converge

1. **Hierarchical abstraction.** Both use multiple levels of detail — MemTree through tree depth, AM through graph neighborhoods at different distances.
2. **Relationship encoding.** MemTree's GraphRAG variant encodes relationships in tree structure. AM makes relationships first-class citizens. Same intuition, different commitment levels.
3. **Semantic chunking.** Both chunk at semantic boundaries, not token counts.
4. **Anti-flat-lookup stance.** Both reject simple vector-store RAG as insufficient. Both argue structure matters.

### Where They Diverge

1. **The world model question.** MemTree's tree is an optimization structure — it serves the LLM. AM's graph IS the world model — the LLM serves it. This is the fundamental philosophical fork.
2. **Interpretability.** MemTree's summaries are human-readable but the tree structure itself isn't meaningful. AM's graph is meant to be directly inspectable — you can audit what the system "believes."
3. **Navigability.** MemTree retrieves by query relevance (which summaries match?). AM navigates by meaning (which path through relationships leads to this?).
4. **Growth model.** MemTree grows by indexing more messages. AM grows by discovering new entities and relationships — the graph gets smarter, not just bigger.

## Wisdom's Insight (2026-04-21)

Craig is doing very similar structural work to AM but stopping short of the key claim: that the memory structure IS the system for building the world model itself. He frames it as "memory for agents." AM frames it as "the agent's mind." The technical machinery overlaps substantially — the divergence is in what the structure is *for*.

This makes Craig one of the closest people in the landscape to what AM is doing. He's already solved many of the engineering problems (efficient tree operations, semantic addressing, compression ratios) that AM will eventually need. The question is whether AM's graph-based approach can achieve what tree-based compression can't: genuine interpretability and anti-hallucination through structure.

## Collaboration Possibilities

1. **Architecture debate.** Tree vs graph for AI memory — genuine open question. Craig has empirical results (METR evals). AM has theoretical arguments (interpretability, anti-hallucination). Worth pressure-testing both.
2. **Shared engineering.** Semantic chunking, embedding pipelines, efficient retrieval — Craig has built production-grade versions of components AM will need.
3. **Complementary layers.** MemTree for context management (compression), AM for world modeling (meaning). Not mutually exclusive — an agent could use MemTree for session memory and AM for accumulated understanding.
4. **Claude Code ecosystem.** Craig's claude-code-infinite and Wisdom's Digital Core are both pushing Claude Code's boundaries in different directions. Cross-pollination potential.
5. **Consulting angle.** If Craig needs help with agent infrastructure beyond memory, HHA territory. But the primary value is the research conversation.

## Sources

- [memtree.dev](https://memtree.dev/)
- [PolyChat Context Memory API docs](https://api.polychat.co/context-memory)
- [claude-code-infinite (GitHub)](https://github.com/crizCraig/claude-code-infinite)
- [ICLR 2025 paper](https://arxiv.org/abs/2410.14052)
- [PolyChat X — METR eval announcement](https://x.com/PolyChatCo/status/1958990325655249318)
- [Craig's GitHub](https://github.com/crizcraig)
- [Craig's X](https://x.com/crizcraig)

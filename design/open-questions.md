# Open Design Questions

## Association Model

- **Beyond co-occurrence:** Co-occurrence is the simplest Hebbian mechanism. Should associations also form through:
  - Causal chains? (A led to B → directed edge)
  - Emotional resonance? (A and B both felt important)
  - Structural similarity? (A and B have similar graph neighborhoods)
  - LLM-judged conceptual links? (Ask the LLM "how are these related?" during consolidation)

- **Edge descriptions:** Should edges carry a linguistic description of WHY two nodes are connected? This adds interpretability but costs storage and compute. When does the system generate these?

- **Asymmetric associations:** Ice cream → motorcycles might be stronger than motorcycles → ice cream. How asymmetric should edges be? Two separate weights per direction?

## Consciousness Pointer

- **Single focus vs. multi-focus:** Is the agent "at" one node, or at a small set of nodes (like holding multiple things in working memory)?

- **Momentum:** Should the focus have inertia? If you've been in one area of the graph for a while, it should take more activation energy to shift focus to a distant area. Prevents context thrashing.

- **History:** Should the consciousness pointer remember where it's been recently? A "trail" that influences which branches feel more natural to return to?

## Pruning

- **Traces:** When a branch prunes, does the agent retain any trace that it existed? Like a fading sense of "there was something relevant over there." This could be a low-weight "phantom edge" that helps re-find the branch faster.

- **Graceful vs. hard pruning:** Should eviction be gradual (compression → summary → tags → gone) or binary (in context / not in context)?

## Embeddings

- **Static vs. dynamic:** Does a memory's embedding stay fixed, or does it shift as new associations form? A memory of ice cream might "move" in embedding space as it becomes more connected to summer road trips.

- **Which model:** Small local model (all-MiniLM-L6-v2, ~80MB) vs API-based (text-embedding-3-small) vs something novel (SONAR for multimodal)?

- **Hyperbolic vs. Euclidean:** Hyperbolic space naturally represents trees (exponential volume growth). This matches the tree-like growth pattern. But tooling is less mature. Worth the complexity?

## Scale

- **Growth limits:** How big can the graph get before traversal becomes slow? At what point does SQLite need to be replaced?

- **Cold start:** When the agent has few memories, the graph is sparse. How does traversal work with a nearly empty graph? Heavy reliance on direct jumps initially?

- **Sharding:** If spawning many agents, does each get its own graph DB? Can graphs share structure (common knowledge subgraph)?

## LLM Integration

- **When does the LLM reason vs. when does the graph provide?** The vision says the LLM should only answer from the graph. But some questions need inference (combining facts). Where's the boundary?

- **Graph-as-prompt:** How exactly is the loaded subgraph formatted for the LLM? Markdown list? Structured JSON? Narrative text? This affects how well the LLM can reason through it.

- **Model independence:** If the graph IS the mind, can you swap the LLM and preserve the agent's personality/knowledge? This is the promise — how do we validate it?

## Multimodal

- **Non-text nodes:** How are images, audio, etc. stored as nodes? Do they get a text description (for LLM readability) plus a modality-specific embedding?

- **Cross-modal associations:** How does a visual memory connect to a textual one? Through shared text descriptions? Through a unified multimodal embedding space (SONAR)?

## Consolidation

- **Timing:** When does consolidation run? Idle periods? Scheduled? After every N interactions? Budget-dependent?

- **Who consolidates?** The same LLM doing the reasoning? A cheaper model? A non-LLM process for structural operations (decay, merge)?

- **What if consolidation is wrong?** If the system incorrectly merges two memories or promotes a false pattern to semantic knowledge, how is this caught and corrected?

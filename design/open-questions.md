# Open Design Questions

## Association Model

- **Beyond co-occurrence:** Co-occurrence is the simplest Hebbian mechanism. Should associations also form through:
  - Causal chains? (A led to B → directed edge)
  - Emotional resonance? (A and B both felt important)
  - Structural similarity? (A and B have similar graph neighborhoods)
  - LLM-judged conceptual links? (Ask the LLM "how are these related?" during consolidation)

- **Edge descriptions:** Should edges carry a linguistic description of WHY two nodes are connected? This adds interpretability but costs storage and compute. When does the system generate these?

- **Asymmetric associations:** Ice cream → motorcycles might be stronger than motorcycles → ice cream. How asymmetric should edges be? Two separate weights per direction?

## Memory Encoding — What Becomes a Node? (Critical)

The intake valve of the entire system. Currently unspecified.

- **Current thinking:** Similar to how Claude Code builds markdown memory files — the human says something significant, or the agent itself decides to encode something.
- **Granularity:** Every message? Every topic shift? Every "significant" moment?
- **Who decides?** The LLM? A heuristic? Surprise-gating (Titans: only store what's unexpected)?
- **Does encoding improve over time?** As the graph grows, more context for deciding what's new/important.

## Anti-Hallucination Enforcement (Critical)

The vision says the LLM ONLY answers from the graph. But LLMs always have pretrained knowledge. Prompt constraints aren't truly architectural.

- **Possible approaches:**
  - Minimal system prompt + only graph context (starve it of general knowledge)
  - Verification layer: can the response be traced back to graph paths?
  - Confidence gating: sparse graph coverage → "I don't know"
  - Maybe a new kind of model needs to be trained — designed for graph-native reasoning rather than weight-based knowledge
  - Maybe full enforcement isn't desirable — some pretrained reasoning IS appropriate (logic, math, language understanding)
- **Key question:** Is this a spectrum rather than a binary? Where is pretrained knowledge appropriate vs. dangerous?

## Confidence Threshold (Important)

Two distinct dimensions:
- **Comprehension:** "How well do I actually grasp this concept?" (depth of understanding)
- **Completeness:** "Have I found everything in my memories relevant to this?" (coverage)

Both should gate willingness to answer. Low on either → "I'm not sure" / "Let me look deeper."

- How is confidence computed? Graph density in region? Path strength? Supporting node count?
- Does confidence decay over time? (Knowledge you haven't revisited feels less certain)
- "I know I don't know" vs. "I don't know what I don't know" — can the agent distinguish these?

## Values / Care as Traversal Modulator (Important)

How much the agent CARES determines traversal depth and computational budget.
- High care → deep traversal, thorough search, research if needed
- Low care → quickest path, surface answer, move on

This is how biological attention works. Also elegantly solves the scale problem — budget is proportional to care, so you never fan out to millions of paths unless you deeply care.

- Where do values come from? Trained? Configured? Emergent from the graph itself?
- How does care interact with confidence? (Care a lot + low confidence → research. Don't care + low confidence → "I don't know" and move on.)
- Is care about the topic, the person asking, the task, or all three?
- Connection to The Companion's emotion modulator system (Damasio somatic markers)

## Memory Priority — Ongoing Valuation (Important)

Not static importance scoring. A living reassessment: "How much will I need this?"
A memory's value changes depending on what the agent is doing NOW. Different kinds of memories have different priority levels.

- Is priority computed at access time or maintained as a background process?
- Does priority influence decay rate? (High-priority memories resist decay?)
- How does this interact with the `protected` flag in the current data model?

## Contradiction Handling

What happens when the agent has contradictory memories, both reachable from focus?

- **Possible approaches:**
  - Temporal precedence (newer overrides older)
  - Activation strength (stronger memory wins)
  - Surface the contradiction explicitly ("I have conflicting information...")
  - Fact invalidation (Graphiti-style: mark old as superseded, don't delete)
- Can contradictions be productive? (Holding tension → deeper understanding)
- Should consolidation resolve contradictions, or preserve them?

## Consciousness Pointer

- **Single focus vs. multi-focus:** Is the agent "at" one node, or at a small set of nodes (like holding multiple things in working memory)?

- **Momentum:** Should the focus have inertia? If you've been in one area of the graph for a while, it should take more activation energy to shift focus to a distant area. Prevents context thrashing.

- **History:** Should the consciousness pointer remember where it's been recently? A "trail" that influences which branches feel more natural to return to?

- **Movement logic:** Is focus always the last target node? What about meandering conversations with no clear target?

- **During consolidation:** Does focus move through the graph during "sleep"? (Replay)

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

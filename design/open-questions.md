# Open Design Questions

## Causal Edges (NEW — Round 5)

Round 5 research resolved the *what* and *how* at the design level. These are the remaining open implementation questions:

- **Minimum sample threshold:** What n is needed for GFCI to produce trustworthy PAG output? Literature is not prescriptive. Need empirical testing on synthetic tool-use data.

- **Unknown intervention targets:** When multiple tool calls happen in close temporal proximity, which one caused the observed result? Need a method for causal discovery with unknown intervention targets (Wang et al. 2023 has partial answers).

- **Bayesian vs. frequentist causal discovery:** Should the Mirror maintain a posterior distribution over causal graphs (Bayesian causal discovery), or use point-estimate algorithms (GFCI)? Bayesian approach is more principled but far more expensive.

- **Causal edge interaction with pruning:** Should `CAUSES` edges have protected status against distance-based eviction? A causal edge between temporally distant nodes carries more structural importance than a weak PMI edge between nearby nodes.

- **Counterfactual node representation:** When the agent infers "if I had done X differently, Y would have been better," where does that inference live? A dedicated counterfactual node? An edge annotation? Mirror meta-memory?

- **LLM causal prior integration:** The LLM can vote on causal directions from variable names and semantics. How do we weight LLM-priors vs. statistical evidence? What prevents LLM hallucination from corrupting the causal graph?

See `research/round5-causal-discovery.md` for the full pipeline design and library recommendations.

---

## Association Model

- **Beyond co-occurrence:** Co-occurrence is the simplest Hebbian mechanism. Should associations also form through:
  - Causal chains? (A led to B → directed edge) → **PARTIALLY RESOLVED by Round 5** — yes, via causal discovery during consolidation
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

## Epistemic Humility + Curiosity (Critical)

Reframed from "anti-hallucination enforcement." The goal isn't silence when the graph is sparse — it's curiosity. The agent has a meta-simulation of its own understanding (via the mirror layer and confidence system) and uses it to be honest AND generative about what it doesn't know.

- **The spectrum:** Pure graph-only answers for factual claims. Pretrained reasoning allowed for logic/math/language understanding. Monitored synthesis for combining graph facts into novel responses.
- **Curiosity at cold start:** Empty graph = maximum curiosity, not maximum silence. "I haven't encountered this before — let's think about it." "What do you think?" Encode aggressively early, consolidation cleans up later.
- **Structural mechanisms:** Confidence gating (comprehension × completeness), KG-Trie for structured paths (100% faithful), verification layers for synthesis, smaller models = less leakage.
- **Honest ceiling:** ~85-95% for free-form synthesis even with all defenses. Frame as humility, not as a solved problem.
- **Open:** Can a model be trained specifically for graph-native reasoning? Where exactly is pretrained knowledge appropriate vs. dangerous?

## Value System — Care, Confidence, Priority (→ design/value-system.md)

Promoted to full design doc. See [value-system.md](value-system.md) for the unified motivational layer design.

**Remaining open questions (from value-system.md):**
- Can the agent learn what to care about from experience, or must values be configured?
- Care conflicts: what when the agent cares about two contradictory things?
- Confidence calibration: avoiding overconfidence AND underconfidence
- Priority horizon: how far ahead does predicted_future_utility look?
- Value drift: should values evolve over time, or should some be immutable? (Alignment implications)

## Contradiction Handling

What happens when the agent has contradictory memories, both reachable from focus?

- **Possible approaches:**
  - Temporal precedence (newer overrides older)
  - Activation strength (stronger memory wins)
  - Surface the contradiction explicitly ("I have conflicting information...")
  - Fact invalidation (Graphiti-style: mark old as superseded, don't delete)
- Can contradictions be productive? (Holding tension → deeper understanding)
- Should consolidation resolve contradictions, or preserve them?

## Consciousness Pointer → RESOLVED: Trees

The "consciousness pointer" concept was retired in favor of the Three Planes model.
The agent isn't a cursor in the graph — it IS the whole system. Active cognition = trees growing within the matrix.

- Single vs multi-focus → **resolved:** Multiple parallel trees. Primary tree + spawned trees.
- Momentum → **resolved:** Trees have inertia through their root and rendered structure. Shifting requires growing a new branch or spawning a new tree — that IS the cost.
- History → **resolved:** Phantom traces. Pruned branches leave markers. The mirror layer remembers traversal patterns as meta-memories.
- Movement logic → **resolved:** Tips of the tree are the active front. Trees grow toward inputs, not "move to" them.
- During consolidation → **resolved:** Consolidation runs when no trees are active (between interactions). A consolidation tree can be spawned for replay.

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

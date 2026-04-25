---
source: Eric Jennings (Zoox lead dev, PS advisor) via LLM-assisted technical review
captured_at: 2026-04-25
session: Eric ran the MWM repo (README + vision) through an LLM and asked for a technical assessment along three axes (compute, storage, conceptual coherence) with Big-O analysis. Sent to Wisdom via WhatsApp.
context: First substantive external technical critique of the MWM paper. Eric flagged in advance: "If your proposal hits even the tiniest bit of actual code review you are going to have to explain in terms of Big-O." This was the fly-by version of that.
note: Preserved verbatim per raw-data-preservation rule. The author of the analysis is the LLM Eric fed it to, but Eric's own framing/advice is in the chat trailer at the end.
---

# Assessment: Memory as World Model (MWM)

*Repository:* [Playful-Sincerity/MWM-Memory-as-World-Model](https://github.com/Playful-Sincerity/MWM-Memory-as-World-Model)
*Status of subject:* Research / design phase. No implementation. Targeting a 4-month research project (Anthropic Fellows 2026).
*Scope of this assessment:* What the proposal is trying to fix, and how inefficient it is along three axes — compute/runtime, storage/memory, and conceptual/design coherence — including a Big-O treatment of the core claims.
*Sources used:* `README.md` and `vision.md`. The `design/` and `research/` folders were not directly accessible during this assessment (GitHub directory listings blocked); the critique below addresses the proposal as described in the README and vision. Any conclusions about specific design decisions documented only in those folders should be revisited when they can be read directly.

---

## Executive Summary

MWM proposes to fix the interpretability problem in current LLMs by replacing the role pretrained weights play in forming beliefs with an explicit, readable graph. The LLM becomes a traversal and rendering engine; the graph holds beliefs as explicit nodes with confidence, evidence, and timestamps; a separate symbolic tool handles logic. The pitch is "interpretable by design" — to ask why the agent believes X, you trace a path in the graph rather than reverse-engineer weights.

The conceptual frame is genuinely interesting. The execution, as specified, is computationally extravagant on every axis except the one axis it claims to optimize, and even on that axis the win is partial.

*Headline findings:*

- *Compute:* per-inference time is approximately $\Theta\big(p \cdot (T \bar{d} + k \cdot c^2)\big)$ versus a baseline LLM's $\Theta(c^2)$ — a multiplicative factor of $k$ on the LLM cost plus an additive graph-traversal term that grows with the agent's lifetime. Expect 1–3 orders of magnitude worse latency.
- *Storage:* $\Theta(A \cdot N \bar{d})$ per-agent storage with no amortization across agents, against the LLM baseline of $\Theta(P)$ shared. Realistic numbers put a "graph as mind" agent in the terabyte range, multiplied by the agent count.
- *Interpretability:* the win is real but partial. Tracing retrieval is cheap and readable. Tracing the rendering step — what the LLM does once it reads the subgraph — remains a forward pass through an opaque transformer. The proposal moves the interpretability frontier; it doesn't shrink it.
- *The "graph replaces weights" claim is Big-O-incoherent.* Weights compress facts plus their compositional closure into a fixed budget that supports implicit generalization at inference. Graphs without a learned function on top do not generalize. The proposal cannot have it both ways: either the LLM's priors are doing real work (and the dichotomy collapses), or the graph carries no generalization (and the agent only "knows" what was explicitly stored).

The proposal is defensible as a research agenda where partial interpretability is intrinsically valuable enough to pay these costs. It is not defensible as written when it claims the LLM becomes "almost interchangeable" — that claim contradicts the asymptotics of the design.

---

## 1. What the Proposal Is Trying to Fix

Per the README and vision, the target is the interpretability problem in current LLMs. The framing:

Today's LLMs entangle three things in one weight space — language, knowledge, and reasoning. Interpretability in that substrate is therefore "forensic": reverse-engineering features and circuits in a system that was never designed to be read.

MWM proposes to factor those apart:

- *The LLM* — a traversal and rendering engine. How to think: navigation, language, inference at local neighborhoods of the graph.
- *The memory graph* — the world model. What it knows: beliefs as explicit nodes (with confidence, evidence chains, timestamps); associations as linguistic edges formed through Hebbian co-occurrence.
- *A separate reasoning tool* — symbolic logic and math.

The architecture operates on three planes:

- *Matrix* — the full experiential graph (long-term memory).
- *Trees* — the active working context, growing and pruning through spreading activation.
- *Mirror* — a persistent self-observation tree holding values and self-model.

The question "why does this agent believe X?" is meant to be answered by tracing a path in the graph rather than training a probe against weights.

Secondary claims layered on:

- *Anti-hallucination by design* — claims must trace back to experiential nodes.
- *Epistemic humility* — when no path exists, the agent is "curious" rather than silent.
- *Reconsolidation* — every retrieval modifies the memory; traversed paths strengthen, competing paths decay.
- *Unified multimodal substrate* — every node's canonical layer is natural-language description; modality-specific data hangs off the readable layer.
- *Spawning vision* — multiple agents each build their own experiential topology; their worldviews are diffable by comparing graphs.

---

## 2. Notation for the Big-O Treatment

| Symbol | Meaning |
|---|---|
| $N$ | total nodes in the matrix (experiential graph) |
| $E$ | total edges; $E = \Theta(N \cdot \bar{d})$ |
| $\bar{d}$ | average node degree — *grows over time*, not constant |
| $T$ | nodes in the active tree (working context) |
| $b$ | branching factor at the growth frontier |
| $h$ | traversal depth before tree stabilizes |
| $L$ | LLM forward-pass cost at context size $c$, $\Theta(c^2)$ for standard attention |
| $k$ | number of LLM invocations per "thought" (rendering at local neighborhoods) |
| $p$ | number of parallel growing trees sharing the context budget |
| $M$ | number of modalities |
| $A$ | number of agents (spawning/multi-agent setup) |
| $P$ | LLM parameter count, $\sim 10^{10}$–$10^{11}$ today |

---

## 3. Compute / Runtime Cost

This is where the proposal is most expensive, and the README and vision do not engage with it.

### 3.1 Baseline LLM, for comparison

One forward pass: tokens in, tokens out, fixed FLOPs, GPU-friendly dense matmul.

$$\text{LLM per inference} = \Theta(L) = \Theta(c^2)$$

Single-shot, with $c$ bounded by the context window.

### 3.2 MWM per-inference, decomposed

*(a) Tree growth via spreading activation.* The vision explicitly rejects RAG ("query → top-K"). Instead, trees grow through associative edges from a root, with branches pruning and re-attaching as the tree's center of mass shifts. Spreading activation on a graph of millions of nodes is irregular, pointer-chasing, cache-hostile work — the exact opposite of what GPUs are good at. It is CPU-bound and memory-latency-bound.

Worst-case frontier exploration with branching $b$ and depth $h$ visits $\Theta(b^h)$ nodes; $\Theta(T)$ if pruning is aggressive. Each visit requires an edge-weight evaluation — $\Theta(\log E)$ if edges are sorted, $\Theta(\bar{d})$ if not. The vision's "branches prune when they lose relevance, re-attach when growth turns back" implies repeated re-evaluation, which can push this toward $\Theta(T^2)$ in adversarial cases (oscillating relevance).

$$\text{Tree growth} = \Theta(T \cdot \bar{d}) \text{ to } \Theta(T^2)$$

*(b) LLM rendering at local neighborhoods.* The vision says "the LLM reasons at local neighborhoods" — plural — implying the model is invoked repeatedly as the tree grows, not once. Each invocation is a full forward pass over the locally-rendered subgraph.

$$\text{Rendering} = \Theta(k \cdot T_{\text{local}}^2)$$

The vision does not bound $k$. It is at minimum $\Theta(h)$ or $\Theta(\text{number of branches})$, not $1$. *This is the multiplicative factor on the LLM cost* — and it is the dominant new cost at typical context sizes.

*(c) Reconsolidation (write-on-read).* "Every traversal is a write." The path the tree grew through gets strengthened; competing paths decay. That is a write-amplification problem: every read mutates state. In a database it is an antipattern — kills caching, creates contention, complicates concurrency. The vision flags this is "largely uninvestigated in AI systems"; that is true, and there is a reason. It also means the graph cannot be easily shared across users or sessions, because reads are not idempotent.

$$\text{Reconsolidation} = \Theta(T \cdot \bar{d}) \text{ writes per inference}$$

*(d) The Mirror as a persistent always-on tree.* A tree that "never dies but constantly prunes to stay within resource constraints" is continuous background compute. Forever. This is not per-inference cost but it is per-wall-clock-second cost.

*(e) Tree growth needs a non-off-the-shelf embedding/association model.* The vision is explicit: pretrained embeddings give "semantic distance" but the architecture wants "experiential distance" learned from this agent's history. That means training and continually retraining a per-agent association model — extra compute per agent, no amortization across agents.

*(f) Parallel trees sharing a context budget.* The vision explicitly mentions this. If $p$ trees grow concurrently, multiply everything by $p$ and add coordination cost — at minimum $\Theta(p)$, in practice $\Theta(p \log p)$ for any priority-queue scheduling.

### 3.3 Total per-inference time

$$\text{MWM per inference} = \Theta\big(p \cdot (T \cdot \bar{d} + k \cdot T_{\text{local}}^2)\big)$$

The LLM baseline is $\Theta(c^2)$. MWM is $\Theta(c^2)$ *times $k$* plus a graph-traversal term that scales with the agent's lifetime.

*Realistic verdict:* 1–3 orders of magnitude slower per response than a current LLM at comparable knowledge access, with the gap widening as the graph grows. Latency would be the dominant complaint of any user.

---

## 4. Storage / Memory Overhead

The vision implies that compressed weights are an inefficient substrate compared to an explicit graph. The math does not support that.

### 4.1 Baseline LLM

$$\text{LLM storage} = \Theta(P), \text{ shared across all users/sessions}$$

A 70B parameter model in 4-bit quantization is approximately 35 GB and encodes a meaningful fraction of human written knowledge. That is a compression ratio nothing graph-based gets near.

### 4.2 MWM, per agent

*Per node:* natural-language description ($\Theta(s)$ bytes, $s \sim 10^2$–$10^3$), confidence and metadata ($\Theta(1)$), modality-specific payload pointers ($\Theta(M)$). Per-node total $\Theta(s + M)$.

*Per edge:* weight, traversal count, decay state — $\Theta(1)$ in count, but typically 16–64 bytes.

*Edge count is the load-bearing term.* Hebbian co-occurrence creates an edge every time two nodes are in context together. Without aggressive decay this trends to $\Theta(N^2)$ in the limit (every pair has co-occurred at some point). With decay it stabilizes at $\Theta(N \cdot \bar{d})$ — but $\bar{d}$ is not constant in real associative graphs. Preferential-attachment dynamics typically yield $\bar{d}$ growing with $\log N$ or as a small power of $N$.

$$\text{Per-agent storage} = \Theta\big(N \cdot (s + M) + N \cdot \bar{d}\big)$$

With $N = 10^9$ for a "graph as mind" agent, $s = 10^3$, this lands at $10^{12}$–$10^{13}$ bytes per agent. *Terabytes, not gigabytes.*

### 4.3 Across multiple agents

The spawning vision pitches agents that each "build their own experiential topology." This means *no amortization across agents*, unlike pretrained weights:

$$\text{Total storage for } A \text{ agents} = \Theta(A \cdot N \cdot \bar{d})$$

This is the killer at scale. The LLM substrate is shared $\Theta(P)$; the graph substrate is per-agent.

### 4.4 The lost generalization

A trained model can answer questions about combinations it never explicitly saw, because gradient descent found compositional structure in the weight space. A graph only "knows" what an explicit traversal can reach. If the path does not exist, the agent is "curious" — which is the rebrand of "doesn't know."

You pay the storage cost *and* lose the implicit-generalization property of weights. This is addressed in §6.

---

## 5. Interpretability, in Complexity Terms

This is the part of the assessment that warrants the most pointed framing, because the interpretability claim is the proposal's central justification, and the way it is described overstates what the architecture delivers.

The pitch: "trace a path from belief A to belief B." Reading the graph is $\Theta(\text{path length})$ — small, readable, defensible.

But *"why did the agent produce this output?" is not "what path was traced?"* It is "given the path, why did the LLM render this sentence rather than another?" That step is a forward pass through an opaque transformer — the same $\Theta(c^2)$ of inscrutable computation as a baseline LLM, just over a smaller context.

So:

| Question | Cost in MWM | Cost in baseline LLM |
|---|---|---|
| What was retrieved? | $\Theta(\text{path length})$ — readable | $\Theta(L)$ forensic |
| Why was this output produced? | $\Theta(L)$ forensic | $\Theta(L)$ forensic |

*The proposal moves the interpretability frontier; it does not shrink it.* Some of the most interesting beliefs — the ones formed during rendering, not stored as nodes — remain on the wrong side of that frontier. The framing "interpretable by design" should more accurately read as *"interpretable retrieval, opaque rendering."* The original problem ("why did the model produce this output") is still partly forensic because the LLM is still in the loop.

This is not a small caveat. It is the difference between solving the interpretability problem and relocating it.

---

## 6. The "Graph Replaces Weights" Claim, in Complexity Terms

The vision states: "the model becomes almost interchangeable — what matters is the graph." This claim is *Big-O-incoherent with the design.*

To genuinely replace what weights do, the graph must support implicit generalization — answering queries whose exact path does not exist. Pretrained weights do this in $\Theta(L)$ via learned compositionality. A graph does it via what, exactly?

There are only two options:

 1. *Explicit traversal only.* Zero generalization beyond what is stored. Cost to "know" $K$ facts is $\Theta(K)$ storage, hard cap. The agent only knows what was explicitly traversed and recorded.
 2. *The LLM fills in gaps using its priors.* Then the LLM's weights are still the locus of belief for everything not in the graph. The dichotomy "weights for HOW, graph for WHAT" collapses.

There is no third option in the proposal as written.

In Big-O terms, weights compress $K$ facts plus their compositional closure into $\Theta(P)$ space with $P \ll K \cdot (\text{closure factor})$. Graphs achieve $\Theta(K)$ storage with no closure. To match weight-equivalent capability, the graph would need storage proportional to the closure — which is super-linear in $K$ and possibly exponential in compositional domains. *This is the storage version of the same wall symbolic AI hit in the 1980s.*

The vision needs to confront one of two outcomes:

- The LLM keeps its priors and is doing real cognitive work, in which case "almost interchangeable" is wrong and the graph is a memory layer on top of an LLM, not a replacement substrate.
- The LLM is genuinely interchangeable, in which case the graph must store everything explicitly, which is asymptotically infeasible.

---

## 7. Conceptual / Design Coherence

Several load-bearing claims in the proposal are in tension with each other or with established results.

*The "interpretable by design" claim is weaker than advertised.* Covered in §5. The graph is interpretable; the rendering step is not. The proposal moves opacity rather than eliminating it.

*The "no weights carrying beliefs" claim is hard to honor.* Covered in §6. The LLM has to read the graph and produce coherent language, which requires it to know what the words mean, what the relations imply, and how to compose them. That is belief-laden pretrained knowledge doing real work. Language understanding is priors.

*Hebbian co-occurrence as the primary association mechanism is brittle.* "Two memories in context together get an edge" is the same mechanism that makes humans superstitious. It conflates statistical association with causal/semantic relevance — exactly the failure mode that pretrained representations spent a decade learning past with attention and contrastive learning. PMI-based association graphs (LSA, HAL, etc.) have been studied since the early 2000s and hit a ceiling well below modern LM performance. Combined with the rejection of off-the-shelf embeddings ("experiential distance, not semantic distance"), the agent loses access to most of the field's progress on representing meaning.

*The novelty claims need scrutiny.* The vision lists seven items as "no system implements." Several are contestable:

- "Memory graph as primary world model" is essentially what classical symbolic AI / knowledge graphs / Cyc / SOAR / ACT-R have proposed for 40+ years. The modern resurgence in agentic memory (MemGPT, A-MEM, Letta, Zep, GraphRAG, Cognee, HippoRAG) is doing meaningfully similar work.
- "Tree-as-context" is closely related to spreading activation in ACT-R, which the docs cite.
- "Reconsolidation as primitive" appears in some neuroscience-inspired memory work.

The framing "65 systems audited and none do this" likely reflects a strict definition of "this" rather than genuine novelty across the design space. The contribution is real but more incremental than the framing suggests.

*The unified multimodal substrate via natural language is a strong claim presented lightly.* Forcing every node's canonical layer to be natural language collapses information-theoretically rich modalities (images, audio, sensor streams) onto a lossy serialization. This is the entire reason multimodal models train joint embedding spaces — text descriptions throw away too much. The proposal acknowledges modality-specific data "hangs off" the text layer, but if the text layer is what the LLM reads and what the graph topology is built on, the agent's worldview is shaped by what survives the text bottleneck. That is a much bigger commitment than the README treats it as.

*"Action-serving" is asserted, not designed.* The vision says "trees grow so the agent can act well" and the Mirror "produces emotions that modulate the subconscious." But there is no model of how value evaluation actually selects actions, only the claim that it does. The values/emotions/Mirror layer reads as evocative rather than mechanical; it is where the proposal shifts from architecture to vibes. *This needs to be either formalized or removed before the proposal is taken seriously as engineering.*

*The whole stack is designed for a problem that may already be eroding.* The motivation rests on "LLMs entangle knowledge and reasoning." Recent work — chain-of-thought interpretability, mechanistic circuits, sparse autoencoders, retrieval augmentation — is steadily disentangling pieces of this without abandoning weights. If that trend holds, MWM is solving a problem from a position that is becoming more tractable through other means, at the cost of throwing away dense-weight efficiency.

---

## 8. Summary Table

| Axis | Baseline LLM | MWM (as proposed) |
|---|---|---|
| Per-inference time | $\Theta(c^2)$ | $\Theta\big(p \cdot (T \bar{d} + k \cdot c^2)\big)$ |
| Storage | $\Theta(P)$, shared across all users | $\Theta(A \cdot N \bar{d})$, per-agent, no amortization |
| Interpretability cost | $\Theta(L)$ forensic for everything | $\Theta(\text{path})$ for retrieval + $\Theta(L)$ forensic for rendering |
| Generalization | Implicit, free at inference | Either none, or reduces to baseline |
| GPU efficiency | High (dense matmul) | Low (pointer-chasing graph traversal) |
| Multi-agent amortization | Full | None |

Every axis is worse, sometimes by a constant, sometimes by a multiplicative factor of $k$ or $A$. The one axis that is supposed to be better (interpretability) is only better for part of the computation, not the whole.

---

## 9. Verdict

*The proposal is conceptually ambitious and computationally extravagant.* Its strongest claim — that an explicit graph is more interpretable than weights — is true at the storage layer but partially defeated by keeping an LLM in the rendering loop. The inefficiency is real and large: 1–3 orders of magnitude worse latency, terabytes of per-agent storage, the loss of weight-based generalization, in exchange for a graph you can read.

Whether that trade is worth it depends entirely on how much you value that specific kind of interpretability. For an alignment-focused research agenda where being able to point at "this node, with this evidence, supports this belief" is intrinsically valuable, the cost might be defensible at small scales. For anything competing on capability or deployment cost, it is a non-starter as described.

The repo is upfront that this is a research/design exercise targeting a 4-month project, which is more honest framing than the rhetorical confidence of the docs would suggest. The right read is: interesting epistemological frame, useful set of design questions, but *the efficiency story has to be confronted before any of the claims about replacing pretrained weights become meaningful.* The current docs assert those claims without grappling with the asymptotics, and that gap is the single most important thing for the author to address.

---

## 10. Questions for the Author

These are the questions a reviewer would want answered before treating MWM as a serious engineering proposal rather than a vision document.

*On compute:*

 1. What is the expected number of LLM invocations $k$ per "thought"? The latency story turns on this. If $k = 1$, what is the rendering loop actually doing? If $k > 1$, what is the upper bound and how is it controlled?
 2. How is spreading activation implemented at scale? Pointer-chasing on a graph with $N \geq 10^7$ nodes is not GPU-friendly. What is the target hardware profile?
 3. Reconsolidation makes reads non-idempotent. How does this interact with concurrent agents, caching, and any kind of replay or debugging?
 4. The Mirror is a persistent always-on tree. What is its steady-state compute footprint, and how is that compared to the inference cost it modulates?

*On storage:*

 5. What is the expected $\bar{d}$ (average degree) at saturation? Is decay alone enough to bound it, or does the architecture need explicit topology constraints?
 6. The spawning vision implies per-agent graphs. Is there any cross-agent amortization mechanism, or does every agent pay the full $\Theta(N \bar{d})$ storage cost independently?
 7. The multimodal substrate routes everything through a natural-language canonical layer. What is the expected information loss for image/audio/sensor modalities, and how is it measured?

*On the "graph replaces weights" claim:*

 8. When the graph has no path supporting an answer, what happens? If "the agent is curious," that is "doesn't know" — does the LLM ever fill in from priors? If yes, the dichotomy collapses; if no, capability is hard-capped at what was explicitly stored. Which one is it?
 9. The vision says "the model becomes almost interchangeable." What experiment would distinguish a system where the graph is doing the work from one where the LLM's priors are doing the work? Without such a test, the claim is unfalsifiable.

*On interpretability:*

10. Tracing the retrieval path is cheap. Tracing the rendering step is not. How does MWM address the rendering-side opacity, or is "interpretable retrieval" the actual scope of the claim?
11. The graph is interpretable to a human reading it. But at $N = 10^7$ or $10^9$ nodes, no human reads the graph — they query it, which is itself an interpretive act. What tooling makes graph interpretability tractable at scale?

*On novelty:*

12. The "no system implements this" framing rests on a strict definition of "this." How does MWM concretely differ from A-MEM, Zep, Cognee, HippoRAG, GraphRAG, and the ACT-R lineage on the dimensions that matter — not in vocabulary but in mechanism?

*On the soft layer:*

13. The Mirror, values, and emotions are described as control signals from consciousness to subconscious. What is the formal specification — input, output, update rule — of an emotion in this system? Without that, this layer is not engineerable.

*On the underlying motivation:*

14. Mechanistic interpretability, sparse autoencoders, and chain-of-thought work are making weight-based systems progressively more readable without abandoning the substrate. What is the threshold of progress in those directions that would make MWM unnecessary, and how close are we to it?

---

## Chat trailer (Eric ↔ Wisdom, 2026-04-25)

> **Wisdom Happy** [13:49]: Haha, computational extravagant is hilarious
>
> **Wisdom Happy** [13:49]: Thank you for this, I'll look over that
>
> **Eric Jennings** [13:49]: If your proposal hits even the tiniest bit of actual code review you are going to have to explain in terms of Big-O as I tried to mention before
>
> **Eric Jennings** [13:51]: This was a quick fly by so don't get too hung up on it
>
> **Wisdom Happy** [13:51]: Right, ok, yeah, I remember, I'm taking that as a critical piece here for sure. Haha, no worries
>
> **Eric Jennings** [13:52]: Computationally extravagant sounds great until you get the compute bill
>
> **Wisdom Happy** [13:52]: Hahahah
>
> **Wisdom Happy** [13:52]: Yeah, we're gonna need a bigger boat
>
> **Wisdom Happy** [13:53]: I think
>
> **Eric Jennings** [14:00]: Don't shrug off the potential 1000 fold worse latency shark, if folks are paying attention you will get asked about how to survive it. Then again maybe you got a a big boat?
>
> **Wisdom Happy** [14:02]: yeah for sure, thats gonna be a lot of work to figure. it would be incredible if we didn't have to sacrifice performance for interpretability. Curious to see whether or not that's even possible. If it's anti-hallucination, maybe that could make up for some speed, but it's probably mathematically impossible for it to be faster than the models today, right? I don't see how it couldn't be
>
> **Wisdom Happy** [14:04]: Computationally extravagant would be a good t-shirt haha
>
> **Wisdom Happy** [14:05]: Even with all of this, would you be willing to be an honest reference for me for the fellowship? Haha you can say I'm crazy if you'd like hahaha
>
> **Wisdom Happy** [14:06]: I'll update the paper tonight with some of these considerations too
>
> **Eric Jennings** [14:11]: I can be a reference but if I get asked about the validity of this I'm going to have to express my concerns over the performance, it would make me look like I didn't know what I was talking about, uh an idiot, if I didn't. I think it's creative though. Just you you know: Computationally Extravagant was the term generated after I asked the agent to be nice.
>
> **Eric Jennings** [14:12]: These are real issues though if you want to develop your plan
>
> **Wisdom Happy** [14:15]: Totally totally, of course, wouldn't ever ask for anything else. Hahahaha. Yeah, thank you, I really appreciate that, I had a feeling it would be bigger but I didn't really realize just how much more it might be. optimization needs to be a completely critical and core component of the research. And if it turns out it just won't work, I'll have to be good to pivot to something more manageable. Ok, what email would want them to reach to you with?
>
> **Eric Jennings** [14:18]: ejnoiz@gmail.com — This is also the e-mail for my LinkedIn, Eric Jennings
>
> **Wisdom Happy** [14:22]: Thank you my friend haha thanks for the good laughs
>
> **Eric Jennings** [14:23]: I hope you get the fellowship! Computer world needs some out of the box thinking!
>
> **Eric Jennings** [14:39]: See you at Frontier later

Eric's tonal frame — "this was a quick fly-by, don't get too hung up on it" / "computationally extravagant was the term generated after I asked the agent to be nice" — pairs with his substantive ask: if MWM goes to a real review, the Big-O story has to land. He's not trying to kill the proposal; he's flagging that the load-bearing claims aren't yet defensible at the level real reviewers will press on. The "I asked the agent to be nice" reveal is important calibration: the critique above is the *softened* version. The underlying assessment was sharper.

**Reference status:** Eric agreed to be a fellowship reference for Wisdom, with the explicit caveat that if asked about the validity of MWM he will voice his performance concerns honestly — *"it would make me look like I didn't know what I was talking about, uh an idiot, if I didn't."* This is the standard to meet. The reference will say what he actually thinks; the paper revision needs to land or the reference becomes a real problem rather than an asset.

**Reference contact:** ejnoiz@gmail.com (also LinkedIn under Eric Jennings).

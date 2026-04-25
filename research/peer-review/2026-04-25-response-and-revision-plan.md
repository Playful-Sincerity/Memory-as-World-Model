# Response and Revision Plan: Eric Jennings' MWM Critique (2026-04-25)

*Companion to the raw critique at [knowledge/sources/peer-review/2026-04-25-eric-jennings-mwm-critique.md](../../knowledge/sources/peer-review/2026-04-25-eric-jennings-mwm-critique.md). This document is the derived analysis: which critiques to accept fully, partially, or push back on, and what concretely needs to change in the paper.*

## TL;DR

Eric's critique is the first substantive external technical pressure-test on MWM, and most of it is right. Three of his critiques are sharp enough that responding to them strengthens the paper, not weakens it. Two are fair but partially-applicable. Two need a careful pushback. The right move is a paper revision pass — three sections need real changes (not sentence tweaks), and the architecture itself is defensible.

The critique should be treated as gift, not threat. Eric (Zoox lead dev, PS advisor) is being honest in the way a senior engineer is honest with someone whose work he wants to see succeed.

## Critiques to Accept Fully

### 1. "Almost interchangeable" is Big-O-incoherent — CUT IT

**Eric's point (§6):** Either the LLM's priors are doing real cognitive work (and "weights for HOW, graph for WHAT" collapses), or the agent only knows what was explicitly stored (and capability is hard-capped). The paper waves between both.

**Verdict:** He's right. The paper has a redistribution claim ("language stays in the LLM, knowledge moves to the graph, reasoning to a tool") which is defensible, AND a substitution claim ("the model becomes almost interchangeable") which is not. They are in tension and the substitution claim has to go.

**Paper change:**
- Vision.md: the "Eventually the model is almost interchangeable — what matters is the graph" passage in §"Epistemic Humility and Curiosity" needs to be cut or significantly reframed. The honest version: the LLM's role *compresses* but it is not interchangeable. Language understanding, local inference, and surface generation are still load-bearing.
- Paper §2.2 ("MWM's configuration"): keep the redistribution language. Tighten "the LLM keeps what it is best at" so no later section contradicts it.
- Paper §7.4 ("The LLM's future role"): the "swap the LLM and the agent's beliefs and values are preserved" language is okay because it's about persistence across model swaps, not about the LLM becoming irrelevant. But re-read carefully — the line "what matters is the graph" should not appear unqualified.

### 2. "Interpretable by design" → interpretable retrieval, opaque rendering

**Eric's point (§5):** Reading the graph is cheap and readable. The forward pass that turns the rendered subgraph into a sentence is still a transformer doing transformer things. The proposal moves the interpretability frontier; it doesn't shrink it.

**Verdict:** He's right, and saying so explicitly makes the paper stronger. "Interpretable by design" is currently doing rhetorical work the architecture doesn't fully cash out. Reframing as "interpretable retrieval; rendering opacity is reduced but not eliminated" is honest AND a more defensible claim.

The case for the reframed version is actually stronger than it might seem at first: SAE/probe/circuit work on transformers has *much* more traction over a small, semantically-clean context (the rendered Tree) than over arbitrary natural language. The rendering-opacity remaining is over a smaller, more structured input. That's a real interpretability win, just not the total one currently claimed.

**Paper change:**
- Paper §1 (Thesis), §2.2, §7.1 (Implications): replace "interpretability-by-design" framing with something like "interpretability moves to the retrieval layer; the rendering layer's opacity is reduced (smaller, more structured input) but not eliminated." Use the smaller-context-makes-rendering-interp-tractable argument as the second-order win.
- Paper §5 (Predictions): tighten the "Structural interpretability" prediction to specifically cover what graph-only audits *can* answer (retrieval, evidence chains, value-set, recent updates) versus what they *can't* (why the LLM phrased the response as it did). Make the falsification criterion address the right claim.

### 3. The compute story isn't confronted — add a Computational Tradeoffs section

**Eric's point (§3, §8):** Per-thought latency with `k > 1` LLM invocations plus graph traversal is multiplicatively worse than a single forward pass. The paper has a Predictions section that gestures at scaling but doesn't engage with this.

**Verdict:** He's right that this gap is the single most important thing for a serious reviewer to press on. Adding a section that frankly states the costs and articulates *why we think the trade is worth it for the use cases MWM targets* is a much stronger posture than letting the reader land on the cost question themselves.

**Paper change:**
- New §6 (or new subsection in Implications): "Computational Tradeoffs." Frank statement of:
  - Per-token throughput will be lower than a single LLM forward pass. This is unavoidable for a system that does retrieval + rendering + reconsolidation. The honest comparison isn't per-token throughput; it's *end-to-end task cost including downstream verification*.
  - For tasks where current LLMs require heavy verification (fact-checking, hallucination correction, source-tracing, agent loops with retries), MWM's traceability could dominate the system-level cost equation. This is a system-level argument, not a per-token one.
  - Per-agent storage scales with experiential graph size. At $N \sim 10^7$ nodes (a realistic working scale for years of an agent's life), this is gigabytes-not-terabytes territory; the worst-case $N \sim 10^9$ projection is far past the working regime.
  - Hardware mismatch (graph traversal is pointer-chasing; GPUs prefer dense matmul) is real and is one of the reasons MWM has a separate research direction on graph-tuned compute substrate (see `research/compute-architecture/`).
  - The cost story is part of the bet — MWM accepts a worse cost frontier in exchange for traceable provenance. We are not claiming this is universally cheaper; we are claiming it is universally more readable.

## Critiques to Accept Partially

### 4. Hebbian co-occurrence has hit known ceilings

**Eric's point (§7):** "Two memories in context together get an edge" is the same mechanism that makes humans superstitious. PMI/LSA/HAL hit ceilings well below modern LM performance. Combined with rejecting off-the-shelf embeddings, the agent loses access to most of the field's progress on representing meaning.

**Verdict:** Partially right. Pure co-occurrence IS brittle. But:
- MWM doesn't claim co-occurrence is the only association mechanism — Round 5 research introduced causal edges (interventional, Pearl Layer 2). Round 6 surfaced affordance edges and analogical (second-order) edges. The paper underplays this; co-occurrence is the substrate but it's not the only edge type.
- The "experiential vs. semantic distance" rejection isn't a rejection of pretrained embeddings entirely — embeddings are still useful for novel-edge formation and modality-internal neighborhood lookup. They just don't carry the canonical belief structure. The paper should clarify this.
- The superstition-failure-mode is a real concern that better matches with reconsolidation as a *correction* mechanism: superstitious associations decay if they're never reinforced through use; high-priority reconsolidation is what protects load-bearing beliefs.

**Paper change:**
- Paper §4.1 (Navigation, not retrieval) and §3.1 (Matrix → edges as first-class): expand the edge-type discussion. Co-occurrence is the substrate; causal edges, affordance edges, and second-order/analogical edges are first-class and load-bearing for higher-order reasoning.
- Paper §1 (Thesis): briefly acknowledge that pretrained embeddings still play a role in novel-edge formation and modality-internal lookup — they're not *rejected*, they're *demoted* from carrying belief structure to supporting graph construction.

### 5. Novelty claims overstate the gap

**Eric's point (§7):** "65 systems audited, none do this" likely reflects a strict definition of "this" rather than genuine novelty across the design space. ACT-R, MemGPT, A-MEM, Letta, Zep, GraphRAG, Cognee, HippoRAG do meaningfully similar work.

**Verdict:** Fair. The paper actually does this responsibly in §6 (Relationship to Prior Work) — it acknowledges the lineage. But the vision document and parts of the paper still gesture at "no system does this" as if the contribution is total. The contribution is real but it's the *integration* (Mirror + reconsolidation + causal edges + earned conviction in a unified substrate), not any single mechanism.

**Paper change:**
- Vision.md "What Makes This Novel" section (the seven-item list): rewrite to frame as "the integration is novel — particularly [X+Y+Z]," and concede individual mechanisms have lineage. Match the more careful tone of paper §6.
- Paper §1 / §2.2: any phrasing that suggests the architecture is wholly new should be sharpened to "the *integration* is novel," with the prior art acknowledged.

## Critiques to Push Back On

### 6. The terabyte / $N=10^9$ extrapolation is worst-case

**Eric's point (§4):** Per-agent storage at $N = 10^9$ nodes lands at terabytes. Multiplied by agent count, this is the killer at scale.

**Pushback:** Practical agents likely sit at $N \sim 10^5$–$10^7$ for years of operation, not $10^9$. Human episodic memory has roughly $10^{11}$ neurons but vastly fewer "memorable events" — episodic memory works in the $10^5$ range, semantic memory adds another order or two. An agent at $10^7$ nodes with $\bar{d} \sim 50$ is in the gigabyte range, comparable to today's local LLMs and entirely tractable.

The $10^9$-node extrapolation is a real upper-bound concern but it's not the working regime. Eric's framing slightly inflates the storage problem by assuming the worst-case scale.

**Paper change:** In the Computational Tradeoffs section above, explicitly state expected working-regime scales ($10^5$–$10^7$ nodes for the foreseeable future) versus the asymptotic worst case. Acknowledge the ceiling; reject the framing that the ceiling is the working regime.

### 7. "Mech interp is making weights readable, so MWM might be unnecessary"

**Eric's point (§7):** Recent work — chain-of-thought interpretability, mechanistic circuits, sparse autoencoders, retrieval augmentation — is steadily disentangling pieces of this without abandoning weights. If that trend holds, MWM is solving a problem from a position that is becoming more tractable through other means, at the cost of throwing away dense-weight efficiency.

**Pushback:** This is a genuinely uncertain bet on both sides.
- Mech interp on frontier models is heroic engineering; whether it scales to GPT-N or beyond is open. The Anthropic interp work itself describes this as a research program, not a solved problem.
- MWM is hedging on the "frontier interp won't scale to the level we need for high-stakes applications" side. That's a research bet, not a confused one.
- Even if frontier interp scales, MWM's interpretability profile is different in kind (structural-by-design vs forensic-after-the-fact). Both could coexist; one isn't strictly better than the other.

**Paper change:** §7 (Implications) already addresses this in the "interpretability-by-design vs forensic interpretability" discussion. Tighten the language to explicitly acknowledge the bet: "MWM is a hedge against the case where frontier-model interpretability does not scale to the level needed for high-stakes applications. Both research directions are valuable; the bet is that having a structural-by-design alternative is worth the cost." Make the bet explicit, not implicit.

## Things the Critique Missed (Strengths)

The critique was based on README + vision only — `design/` and `research/` weren't accessible. This means the critique missed several pieces of work that DO address some of its concerns:

- **`research/round5-synthesis.md`**: Causal discovery pipeline (GFCI, intervention-based learning) addresses the "co-occurrence is brittle" concern partially.
- **`research/round6-synthesis.md`**: Six streams (imagination, perception, edges-relations, action philosophy, drive-motivation, self-awareness) provide the philosophical and cognitive-scientific grounding the "values/emotions reads as evocative not mechanical" concern asks for. The Mirror as interoceptive predictor (Stream 2) and the action-readiness model (Stream 5) are concrete enough to engineer; we need to surface this in the paper.
- **`research/local-cognition/`**: Addresses the "GPU-hostile" concern by sketching the local-LLM + graph + tools agent that doesn't need GPU-scale dense matmul.
- **`research/compute-architecture/notes.md`**: Sketches the compute-substrate research direction — a real engineering response to the GPU-mismatch concern.
- **`design/multimodal-unified-substrate.md`**: Addresses the "natural-language bottleneck loses information" concern more carefully than the README does.

**Paper change:** Reference these design/research artifacts more prominently in the paper. Some of the questions Eric asks (what's $k$? what's $\bar{d}$ at saturation? what hardware?) are partially answered in research/ already; the paper should cite forward to them.

## On Wisdom's Question — Mathematical Impossibility of Being Faster

> "it would be incredible if we didn't have to sacrifice performance for interpretability. Curious to see whether or not that's even possible. If it's anti-hallucination, maybe that could make up for some speed, but it's probably mathematically impossible for it to be faster than the models today, right?"

Honest answer: At per-token throughput, MWM is strictly slower than a single LLM forward pass. The graph traversal stage and the multiple LLM invocations are work the baseline doesn't do. That's mathematically true.

But the right comparison isn't per-token throughput — it's **end-to-end task cost** including verification, hallucination correction, source-tracing, retries, and agentic loops that current LLMs require to be useful at high stakes. For a question whose answer needs to be auditable, the current frontier-LLM pipeline involves: model emits answer → human or system verifies → if wrong, retry / correct / source-check → finally trust. MWM moves that verification cost INTO the architecture. Per-token slower; per-trustworthy-task possibly comparable.

This is the strongest version of the latency argument and it should be the paper's framing in the Computational Tradeoffs section.

## Concrete Revision Plan

The paper revision pass that incorporates Eric's critique:

1. **Cut the "almost interchangeable" claim** wherever it appears. (vision.md, possibly paper). 30 minutes of work.
2. **Reframe "interpretability by design" → "structural retrieval interpretability + reduced rendering opacity over structured context."** Update §1 thesis, §2.2, §5 prediction 4, §7.1 implications. 1-2 hours of work.
3. **Add new §6 "Computational Tradeoffs."** Frank statement of costs, working-regime scales, system-level cost framing, hardware mismatch acknowledgment, explicit bet on interpretability-worth-the-cost. 2-3 hours of work.
4. **Sharpen edge-type treatment** — co-occurrence is substrate, causal/affordance/second-order edges are first-class. Update §3.1, §4.1. 30-60 minutes.
5. **Tighten novelty framing** — emphasize integration, concede individual-mechanism lineage. Update vision.md "What Makes This Novel" and any paper §1 / §2.2 phrasing. 30-60 minutes.
6. **Forward-reference research/ artifacts** more prominently — answer Eric's questions 2, 5, 7 by pointing at where work has been done. Update paper §8 (open questions) to explicitly say which questions have research-artifact answers vs. which are genuinely open. 1-2 hours.

Total revision: probably one focused 4-6 hour session, ideally in a fresh conversation specifically for this work, with Eric's critique as the explicit guidance document. Rebuild PDF, push.

## Recommendation

**Do the revision.** Eric's pressure is the kind of external test that should leave the paper materially stronger. The architecture is defensible; three claims need to be fixed; one major section needs to be added. None of this requires architectural changes — only honest framing.

Start a fresh conversation specifically for this revision. The current chat has done its work and is heavy with context that doesn't serve the focused revision pass. New conversation with this document + the raw critique as the seed.

Also: send Eric a thank-you when the revision lands. He gave the paper the kind of pressure-test it needs and did it as a friend, not as a competitor. That's worth acknowledging.

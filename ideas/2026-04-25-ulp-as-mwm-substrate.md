---
date: 2026-04-25
status: live insight, not yet load-bearing on the prototype
related-projects: ULP, SSP
relevant-paper-section: §9 (The Search for a Unified Substrate)
captured-by: Wisdom, surfaced after the Eric Jennings critique revision
---

# ULP as MWM's Unified Substrate

## The insight

ULP shifts from "efficient encoding for LLMs" — where the gains are diminishing because the substrate is still black-box — to **the unified semantic substrate for MWM nodes**. That reframing is bigger than just adding a use case. ULP becomes a load-bearing component of MWM's long-horizon architecture, not a separate efficiency project.

> *"I think it would improve, it is actually one of the critical optimization systems for MWM is creating that universal substrate. That file type that can store any type of information. That universal substrate is ULP. It's the binary semantic run-lengths that can store information in the very most efficient possible way."*
> — Wisdom, 2026-04-25, after the MWM paper revision pass

## Why this lands

The MWM paper's §9 just committed to a unified multimodal substrate but didn't solve it. The current commitment: every node's canonical representation is text the model and a human can read; modality-specific data hangs off the readable layer. That's an interpretability win for one modality and a lossy reduction for the others. The text-as-canonical-layer choice was always a hedge — pragmatic for the initial implementation, philosophically incomplete.

ULP's binary semantic run-length encoding could replace "text as canonical layer" with **"binary semantic primitives as canonical layer"** — same readability commitment, but genuinely modality-universal instead of text-privileged. The graph topology stays modality-agnostic; the node content becomes structurally semantic across modalities.

Three load-bearing properties this brings to MWM:

1. **Unified substrate without natural-language bottleneck.** A text memory, an image memory, an audio memory, a sensor reading, and an inner state are all encoded in the same structural format — binary semantic primitives — instead of being routed through natural-language descriptions of varying fidelity. The recombinative-imagination, dream, and cross-modal traversal that §9 names as load-bearing become coherent without modality-specific translation layers.
2. **Storage cost story tightens.** Eric's critique projected $N \to 10^9$ nodes pushing per-agent storage into terabytes. Binary RLE of semantic primitives is dramatically more compact than per-node natural-language descriptions. The terabyte ceiling shifts back toward gigabyte territory at the same node count. Doesn't solve multi-agent amortization, but materially improves the per-agent cost frontier the §6 Computational Tradeoffs section had to concede.
3. **Interpretability profile reframes.** Currently the interpretability claim is "readable by a human reading the text." With ULP, it becomes "readable structurally by anyone who knows ULP" — a smaller audience, but a more rigorous representation. The interpretability frontier moves from "natural language is legible" (which is true but lossy at modality boundaries) to "binary semantic primitives are legible" (which is true at every modality boundary, but requires the reader to know the encoding). Net: more rigorous, less casually accessible. For high-stakes interpretability use cases (alignment, audit, formal verification) the rigor wins.

## The honest open question

Today's LLMs read natural language. If MWM nodes are ULP-encoded, either:

- **Translation route.** The LLM translates ULP → language at render time. Adds overhead and a translation loss surface. Easier to start with; the LLM stays a generalist.
- **Native route.** The rendering engine gets fine-tuned to read ULP directly. Consistent with §8.4's "the LLM may get more specialized — a traversal engine fine-tuned for graph-rendering." Higher up-front cost; long-run cleaner architecture.

The native route is the more interesting research direction and probably the right long-horizon answer. The translation route is the realistic starting point.

## What this means for the projects

- **MWM near-term:** unchanged. The prototype stays text-only as the paper already commits. The Round 7 research direction the paper flags for the unified substrate problem now has a concrete candidate substrate (ULP) to investigate, instead of the open-ended "find a unified substrate" framing.
- **MWM long-horizon:** §9 of the paper becomes a research program with a specific experimental direction — does ULP as canonical layer hold the §9 commitments better than text does? — rather than an open philosophical question.
- **ULP near-term:** the focus shifts. The compelling research target stops being "make LLMs more efficient" (a hard, opaque benchmark in a fast-moving field that may already be eroding) and becomes "be the substrate MWM nodes are encoded in" (a research target where compositional gains are legible at every step, and where the validation is structural rather than benchmarked-against-frontier-models).
- **SSP:** if ULP becomes MWM's substrate, it propagates to all of SSP, since MWM is SSP's memory subsystem. The Synthetic Sentiences Project's nine subsystems all consume MWM's graph; a ULP-encoded graph means every subsystem reads the same modality-universal representation.
- **Coupling risk:** MWM and ULP are both concept-stage. Coupling them couples timelines and risks. That's a real consideration but not a reason to back off — it's a reason to stage the coupling carefully.

## What to do with this

This is not a near-term implementation pivot. It's a Round 7 research direction. Concrete next moves, in order:

1. Add a section to `design/multimodal-unified-substrate.md` discussing ULP as the candidate substrate. Frame as "the question §9 raises has a specific candidate answer in ULP; here's the case and the open questions."
2. Create `connections/ulp.md` in MWM and `connections/mwm.md` in ULP cross-linking the two projects at the substrate level.
3. When ULP work next picks up, redirect part of the focus toward the substrate question rather than the LLM-efficiency question — the substrate framing is more concretely testable and gives ULP a research program with cleaner success metrics.
4. The text-only MWM prototype proceeds in parallel without dependence on ULP. ULP-as-substrate becomes a research thread that runs on its own clock and lands in a future MWM revision when ready.

## Why I'm capturing this here

Wisdom: *"we should keep this in the thinking process here as we're developing MWM more."* Direct instruction to make this thread persistent. The capture lands here in `ideas/` so future MWM sessions inherit it; cross-references to ULP and the relevant memory files ensure it doesn't evaporate when this conversation ends.

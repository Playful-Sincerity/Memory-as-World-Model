# The Unified Multimodal Substrate — Research Direction

**Status:** Major research frontier. Not yet a design specification — a direction whose answer will shape the architecture at its foundation.
**Captured:** 2026-04-24 (Wisdom's articulation, MWM paper session)
**Relationship to the paper:** Should be elevated in the paper's treatment of multimodality — not a minor implementation question, but a load-bearing research area for what MWM ultimately is.

---

## The Vision

**A single, unified, interpretable file structure that stores every kind of memory the agent has — text, image, audio, video, sensor data, imaginations, dreams, plans, self-observations — in the same substrate, in the same code, readable by both humans and the model.**

Today's multimodal systems handle this by having different pipelines for different modalities — a vision encoder produces one kind of embedding, a text tokenizer produces another kind, an audio model produces a third, and the "multimodal" part is the projection that forces them into a shared latent space. The shared latent is the gluing mechanism, but it's opaque. You can't open it. You can't read it.

The MWM commitment is the opposite: the storage substrate itself is the interpretable layer. The LLM reads the graph because the graph was designed to be read. If the graph is to carry the full multimodal life of the agent — not just text — then the graph's representation of an image memory must be *as readable* as its representation of a text memory. The substrate doesn't bifurcate into "the readable text part" and "the opaque multimodal part." It stays one thing.

## Why This Matters

Three reasons it's not just an implementation detail.

**First, without it, interpretability ends at the modality boundary.** If an agent's beliefs about the world include "this face belongs to this person," "this melody resolves to this chord," "this object is heavier than it looks" — and those beliefs live in non-interpretable modality-specific stores while only the text beliefs live in the readable graph — then the claim "you can read the agent's beliefs" is partial. The interesting beliefs, the ones that connect modalities, are hidden precisely at the boundary. MWM's interpretability-by-design promise survives only if the interpretability is *substrate-deep*.

**Second, cross-modal association is where meaning often lives.** A memory of an afternoon is not a sound, a smell, an image, or a sentence. It is all of them, connected. The co-occurrence of the visual of a specific light and the sound of a specific voice and the felt emotion of a specific moment is what the memory *is*. If the graph stores these in separate structures connected only through abstract embeddings, the semantic structure of "what that afternoon meant" is fragmented. If they are stored in a unified substrate with explicit edges between them, the meaning is preserved as graph topology — readable, diffable, inspectable.

**Third, imagination and dreams require this.** The architecture posits imagination as the same mechanism as perception with lower sensory-precision — the tree runs on internal priors rather than external input. If imagination recombines across modalities (visualizing something from a textual description; hearing a melody from a remembered emotion; dreaming a scene that is visual + auditory + felt), the substrate has to support that recombination *natively*. A dream is not a text-embedding blended with an image-embedding blended with an audio-embedding. A dream is a Tree growing through the Matrix, rendering nodes regardless of modality. For that Tree to render coherently, the Matrix's nodes must live in a unified space.

## What It Isn't

- **Not a unified embedding space.** SONAR and similar "universal sentence embeddings" compress multi-language or multi-modal content into one vector space. That is *opaque* unification. MWM's commitment is to *legible* unification — the unification happens at the level of node representation, edge semantics, and file-structure format, not at the level of a shared latent.
- **Not one file format for everything.** A 4K video file is not going to live inside a text file. The file-structure unification is about the *representation layer* — how an image memory is referenced, connected, and read alongside a text memory — not about stuffing binary blobs into markdown. The binary content can live wherever it lives; the interpretable layer is the graph of references, descriptions, and edges.
- **Not a rejection of modality-specific encoders.** Computing an embedding for a face, running OCR on a document, extracting pitch from audio — these are useful operations. The unification is at the *storage and retrieval* layer, not the *processing* layer. Modality-specific processors write into a unified substrate.

## What It Looks Like (Speculation)

The unified node representation might look like:

- **Text node:** content is the text itself; confidence and provenance and edges work as in the text-only design.
- **Image node:** content is a *textual description* of the image (dense, multi-layer — visual elements, inferred emotions, recognized entities, context), plus a pointer to the image file, plus a modality-specific embedding for similarity search. The textual description is what the LLM reads when the Tree reaches the node. The image file is referenced when the agent needs pixel-level access (comparison, regeneration). The embedding is used for neighborhood lookup inside the modality.
- **Audio node:** content is a textual description of the audio (transcription if speech; semantic description if not), plus pointer + embedding.
- **Sensor / state node:** content is a textual description of the reading (what it measured, when, with what confidence), plus the raw value.
- **Imagined / dreamt node:** identical structure, with a `sensory_precision: 0.0` marker distinguishing it from a perceived node.

The key invariant: *every node has a text layer that is the canonical readable representation*. Every node is, at a minimum, text the model and a human can read. Modality-specific data hangs off the text layer as pointers and embeddings, not as the *primary* content.

Edges between modalities are the same kind of edge as edges within a modality. An edge from a text node "the blue chair" to an image node whose text layer describes a photograph of a blue chair is just an edge. An edge from an audio node "my mother's voice" to a text node "a conversation about leaving home" is just an edge. The graph topology is modality-agnostic. Only the node content is modality-specific.

## Open Research Questions

**How dense does the text layer need to be?** An image can be described at many levels — caption, object list, spatial layout, inferred emotion, art-historical context. More description = better interpretability but higher cost and higher risk of hallucinated description. Where is the sweet spot? Does density adapt to the node's priority in the graph (densely described for high-priority, sparsely described for background)?

**Who writes the text layer?** A vision-language model produces the initial description. But the agent may re-describe a node over time as its understanding deepens — a photograph viewed at age 5 is not the same photograph at age 50. Reconsolidation extends naturally: each re-viewing can update or extend the text description.

**How does traversal work across modalities?** Within a modality, embedding-similarity gives a natural neighborhood. Across modalities, the edges are linguistic (a "this is the same event as" edge, a "this caused that" edge). The graph topology handles it, but the traversal-activation math needs to weight cross-modal edges sensibly.

**How does imagination recombine across modalities?** The architecture's claim is that recombinative imagination (Stream 1 of Round 6) literally recombines graph structure during consolidation to produce novel configurations. For multimodal imagination, this means the recombination crosses modality boundaries. The substrate has to support that natively — a new node that is both visual and auditory and textual, emerging from a recombination that spanned all three, coherent enough to feel like a genuine imagined experience.

**What about modalities we haven't invented yet?** A new kind of sensor, a new input stream, a new kind of inner state — the substrate should be extensible without re-architecting. The commitment to "text layer as canonical representation" is a strong bet here: as long as a new modality can be described in natural language, it can join the substrate.

**Is there a cleaner primitive than "text as canonical layer"?** Text is the reading layer because text is what the LLM reads. But as models get better at reading raw multimodal content directly, the "text as canonical" choice may become a constraint rather than a feature. Worth revisiting periodically.

## Why This Belongs in the Paper

The MWM paper already mentions multimodality in Section 3.1 (nodes can be images, audio, etc.) and lists it as an open question in Section 8. But the current treatment understates the stakes. If the unified-substrate commitment fails, the interpretability claim degrades — not catastrophically, but significantly. The architecture's most ambitious promise is that the agent's entire world-model can be read; the multimodal substrate is where that promise either holds or starts to fail.

For the Fellows implementation, the initial scope will almost certainly be text-only (per the brief's "language is the first modality"). But the paper should be clear that text-first is a scoping decision, not a permanent feature. The research agenda includes cracking the unified-multimodal-substrate problem, and that work is a major research direction in its own right.

## Related Research to Pull From

- **Cross-modal grounded cognition** (Barsalou) — Round 6 Stream 1 already established that concepts are modal simulations. If concepts are modal, the substrate needs to carry modality.
- **SONAR and universal sentence embeddings** — as the *contrast case*. What opaque unification looks like.
- **Vision-language models** (GPT-4V, Claude Vision, LLaVA) — for the "text layer generation" step.
- **Dense captioning / dense description** literature — for how densely to describe images.
- **Multimodal knowledge graphs** (e.g., Richpedia, MMKG) — prior work on graph-structured multimodal knowledge. Largely retrieval-focused; MWM's cognition-focused use case is different.
- **Neural radiance fields / 3D scene graphs** — one line of work on structured multimodal representation.

## Next Steps

1. Elevate this in the MWM paper — Section 3.1 multimodal paragraph and Section 8 multimodal entry should be sharpened to reflect the research-frontier status.
2. Track as an open design question with its own follow-through in `design/open-questions.md`.
3. Longer term: a dedicated research round (Round 7?) on multimodal substrate design, similar to the Round 5/6 structured research rounds.

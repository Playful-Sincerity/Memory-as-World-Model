# Connection — ULP (Universal Language Project)

*Date opened:* 2026-04-25
*Surfaced after:* the MWM paper revision pass against Eric Jennings' critique
*Status:* live insight; introduced as §9.4 in the MWM paper as a "candidate substrate under active investigation"; not yet load-bearing on the prototype

## The connection

ULP is a candidate **unified semantic substrate** for the nodes of MWM's experiential graph — the answer §9.1–9.3 of the MWM paper is implicitly asking. Originally framed as an efficiency layer for language models, ULP's more load-bearing role is here: as the canonical readable layer of MWM nodes, replacing the current "text as canonical layer" hedge with binary semantic primitives that are modality-universal by construction.

The text-as-canonical commitment is a hedge that works for text and degrades at modality boundaries. ULP is a candidate that holds at every boundary because the encoding is structurally semantic regardless of source modality.

## Where this lives in the paper

- **§9.4 "A candidate substrate: ULP"** — the substantive treatment. Names ULP as the candidate, articulates the three properties (modality universality without latent opacity; storage compactness; interpretability-profile shift), names the open question (translation vs. native-read), names the coupling-risk and stages the coupling.
- **§10 Open Questions, Multimodal substrate details entry** — light forward-reference to §9.4.

## Why this is important across both projects

- **For MWM:** the §9 substrate question gets a specific candidate answer to investigate, rather than an open-ended "find a substrate." Storage cost story tightens against Eric's terabyte projection.
- **For ULP:** the research target shifts from "make LLMs more efficient" (a hard, opaque benchmark in a fast-moving field) to "be the substrate MWM nodes are encoded in" (a research target where compositional gains are legible at every step, validation is structural rather than benchmarked-against-frontier).
- **For SSP:** as MWM's parent, SSP inherits this coupling at the substrate level. All nine SSP subsystems consume MWM's graph; a ULP-encoded graph propagates substrate-level interpretability throughout the whole architecture.

## Coupling risk

Both projects are concept-stage. Coupling timelines and risks. Worth doing carefully:
- Near-term MWM prototype stays text-only as the paper commits.
- ULP-as-substrate is the specific Round 7 research direction.
- The coupling lands in a future MWM revision when both projects are ready — not now.

## Cross-references

- ULP-side connection: `~/Playful Sincerity/PS Research/ULP/connections/mwm.md`
- MWM idea capture: `~/Playful Sincerity/PS Research/MWM/ideas/2026-04-25-ulp-as-mwm-substrate.md`
- MWM paper §9.4: the published treatment in `paper/MWM-proposal.md`
- Design note where the ULP-as-substrate hypothesis should be developed: `~/Playful Sincerity/PS Research/MWM/design/multimodal-unified-substrate.md`

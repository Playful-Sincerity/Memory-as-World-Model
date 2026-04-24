# Session Brief — MWM Paper + Polish Pass

*Drop this into a fresh Claude Code conversation at the `~/Playful Sincerity/PS Research/MWM/` working directory.*

## Purpose

Build the MWM concept paper (the main artifact we'll be showing reviewers, collaborators, and Anthropic contacts), and polish the public repo so it reads coherently. Close out the Associative Memory → Memory as World Model rename throughout the codebase, reframe the vision doc, and remove material that's not useful right now.

## Project Context

**MWM — Memory as World Model** is an interpretable memory architecture where the memory structure IS the world model, replacing the role that pretrained weights currently play in forming beliefs.

- **Local path:** `~/Playful Sincerity/PS Research/MWM/`
- **Public repo:** [github.com/Playful-Sincerity/MWM](https://github.com/Playful-Sincerity/MWM) (public, as of 2026-04-24)
- **Fellows status:** The 4-month Anthropic Fellows 2026 research target. Application due April 26, 2026.
- **Sibling project:** [The Synthetic Sentiences Project](https://github.com/Playful-Sincerity/Synthetic-Sentiences-Project) — MWM is its memory subsystem; SSP is the broader research program.

Start by reading:
1. `CLAUDE.md` — current project-internal index
2. `README.md` — current public-facing entry point
3. `vision.md` — current thesis (needs reframing, see below)
4. `research/round4-synthesis.md` and `round5-synthesis.md` — most recent research grounding
5. `~/Playful Sincerity/PS Research/Synthetic Sentiences Project/memory/CLAUDE.md` — how MWM fits into the broader program
6. `~/.claude/projects/-Users-wisdomhappy/memory/project_mwm.md` — memory-level summary

## Tasks (priority order)

### 1. Build the paper (primary deliverable)

Create `paper/` directory at the project root. Inside, write `MWM-proposal.md` — a concept paper in the style of ULP's and GCM's concept papers. Target length: ~8–15 pages of markdown. This is primarily a proposal; verification/experimental results come later. Mostly the idea, well-structured.

Suggested structure:
- **Title + abstract** (1–2 paragraphs)
- **Thesis** (the central claim: memory structure IS the interpretable world model; LLM as traversal engine; graph as mind)
- **The architectural inversion** (what today's LLMs do vs what MWM proposes — separating language/knowledge/reasoning into three components)
- **The Three Planes** (Matrix / Trees / Mirror) — architecture overview
- **Key mechanisms** — navigation-not-retrieval, causal edges, reconsolidation, epistemic humility, earned conviction
- **Predictions and measurements** — belief-traceability vs flat-memory baselines like AriGraph; designed-emotion variants measured against Jack Lindsey's April 2026 emotion work; anti-hallucination as emergent property
- **Relationship to prior work** — MemGPT, Letta, MIRA (Feb 2026), AriGraph, cognitive architectures (ACT-R / Soar), neurosymbolic memory
- **Implications** — interpretability-by-design vs forensic interpretability; welfare research connection; alignment story
- **Open questions** (pull from `design/open-questions.md`)
- **References** (15–25 papers with one-line annotations where citing is load-bearing)

Keep Wisdom's voice (warm, honest, non-preachy). Use the "action system that thinks through memory" framing — he confirmed 2026-04-24 that he likes that framing and wants to keep it.

### 2. AM → MWM rename sweep

The folder was renamed, CLAUDE.md and README.md were rewritten, but many internal files still say "Associative Memory." Grep and update in judgment-preserving ways:

- `grep -r "Associative Memory"` — review each hit
- Update running-text references to the current project name (MWM / Memory as World Model)
- Leave historical references intact where they're actually historical (e.g., `rename-session-seed.md`, `chronicle/` entries pre-rename, `journal/` entries documenting the evolution, `archive-highlights.md`)
- `design/` docs and `research/` synthesis files that describe the current thinking should be updated
- Commit with a message like "sweep: AM → MWM internal references"

### 3. Reframe `vision.md`

The vision doc is the single most important internal document. Reframe it to:
- Open with MWM naming (not "Associative Memory")
- Keep the "action system that thinks through memory" framing — it's the right frame
- Sharpen the thesis: memory structure IS the world model; architectural inversion away from weight-based knowledge
- Update references to sister projects (Companion → archived/absorbed into SSP; Phantom → GRP)
- ~1500–3000 words, dense but readable

### 4. Cleanup pass

Decide what in the repo is not useful-right-now and hide or remove:

- **`chronicle/`** — "barely has anything in it" (Wisdom, 2026-04-24). Either populate with a proper log of the rename + recent thinking, or move to `.git`-tracked-but-gitignored state, or delete. Judgment.
- **`journal/`** — doesn't need to be public. Move to a private location or add to `.gitignore` and remove from tracking. This was for internal evolution tracking; public readers don't need it.
- **Organic AM diagram** — Wisdom mentioned "a diagram that was showing associated memory like more organically a little bit" and thought it might be useful. Search `diagrams/` and `archive/` for it; if found, surface it in the paper or in a `diagrams/README.md`.
- Anything else that feels like working-files-not-artifacts — move to `_working/` or gitignore.

After cleanup, commit with a message summarizing what moved/was hidden and why.

### 5. Push

After each task, commit with a clear message. Push to `origin main`. Public repo so the Fellows reviewer can browse mid-application.

## What NOT to do

- Don't re-architect the project — the Three Planes framing and the current subsystem-of-SSP relationship are settled
- Don't touch SSP's files — that's a separate project with its own session brief
- Don't add new subsystems or major new claims without explicit Wisdom sign-off
- Don't replace the existing design docs with paper drafts — the paper is a new artifact, not a replacement
- Don't chase citations that aren't load-bearing — Wisdom wants substance, not citation density for its own sake

## Success criteria

End of session:
- `paper/MWM-proposal.md` exists and reads as a coherent, scrutinizable research proposal
- `vision.md` reframed, names the project correctly, holds the action-system-thinks-through-memory framing
- Internal AM references swept (historical references preserved)
- Cleanup done: repo doesn't have noise
- All changes committed and pushed
- `CLAUDE.md` updated to reference the paper

# Seed Document — Renaming "Associative Memory"

*For a fresh Claude Code session focused specifically on naming this project. Drop this into the opening message (or read it as the first file) to pick up with full context.*

---

## The goal of this session

Pick a new name for the project currently called **Associative Memory**. Produce a locked decision plus an execution checklist. If bandwidth allows, execute the rename (directory move, symlink updates, CLAUDE.md references, memory file updates, MEMORY.md index).

## Why rename

Three layers of drift pulling the current name off-target:

1. **"Memory"** reads as a memory-system name. The [vision.md](vision.md) now describes the graph as *"the interpretable world model, replacing the role that pretrained weights currently play in forming beliefs and understanding."* That is a cognition claim, not a memory claim.
2. **"Associative"** describes one mechanism (Hebbian co-occurrence edges) rather than the thesis. The thesis is *navigable*, *interpretable-by-design*, and *action-serving* — not primarily *associative*.
3. **Urgent external driver:** Wisdom is submitting an Anthropic Fellows Program 2026 application by April 26, and this project is the centerpiece of the research proposal. The project name will appear in Q16 (research interests). Shipping the application under a name that no longer describes the project is a leak in the positioning.

## What's been rejected and why

- **"Associative Memory" (current name)** — rejected for the drift reasons above.
- **"Lucid"** — first pick in this session, rejected because [TensorFlow Lucid](https://github.com/tensorflow/lucid) is an existing neural-network interpretability toolkit, and Chris Olah (Anthropic's interp lead) was in that lineage at Google Brain. Using "Lucid" for an interpretability-focused memory architecture in an Anthropic application = collision + legacy confusion with exactly the reviewer's reference frame.

## Current shortlist (honoring Wisdom's preference for "short code word + scientific subtitle")

1. **Legible** — *"Legible: Memory as Interpretable World Model."* Direct, utilitarian. Names the core commitment.
2. **Reach** — *"Reach: A Graph-Traversal Architecture for Agent Cognition."* Active, captures the tree-traversal mechanism.
3. **Lumen** — *"Lumen: Memory as Interpretable World Model."* Latin for light; same register as Lucid, less cute. (Needs an availability check before committing.)
4. **Parse** — *"Parse: Agent Memory as Traversable World Model."* The verb is what the architecture *does*.
5. **Witness** — *"Witness: Persistent Self-Watching as Cognitive Substrate."* Mirror-forward framing; strongest if the project's centerpiece is consciousness/self-observation rather than memory.

Fresh proposals from the new session are welcome — these are not exhaustive. See [`~/Wisdom Personal/Anthropic Fellows Application/positioning/rename-proposal.md`](../../../../Wisdom%20Personal/Anthropic%20Fellows%20Application/positioning/rename-proposal.md) for the full candidate menu with tradeoffs and criteria.

## Criteria for a good name

- **Names the thesis** (world-model / interpretability-by-design), not just a mechanism
- **Short, legible, memorable** — single word preferred
- **Unambiguous standalone** — works when spoken without preamble
- **Playful Sincerity fit** — warm, clean, not corporate
- **Available** — not saturated in AI/ML research or adjacent tooling (required: web check before locking)
- **Works for paper titles** and will appear in citations
- **Scales** — parent name that holds Matrix / Trees / Mirror as subsystems

## Reading list (in order)

1. [vision.md](vision.md) — current thesis + Three Planes architecture
2. [CLAUDE.md](CLAUDE.md) — project structure + evolution-tracking rules
3. [`~/Wisdom Personal/Anthropic Fellows Application/positioning/rename-proposal.md`](../../../../Wisdom%20Personal/Anthropic%20Fellows%20Application/positioning/rename-proposal.md) — full candidate analysis
4. [`~/Wisdom Personal/Anthropic Fellows Application/positioning/spine.md`](../../../../Wisdom%20Personal/Anthropic%20Fellows%20Application/positioning/spine.md) — how the name interacts with the application thesis
5. [knowledge/sources/wisdom-speech/2026-04-20-anthropic-fellows-kickoff.md](knowledge/sources/wisdom-speech/2026-04-20-anthropic-fellows-kickoff.md) and [2026-04-21-thesis-sharpening.md](knowledge/sources/wisdom-speech/2026-04-21-thesis-sharpening.md) — Wisdom's own framing of what the project is

## Execution checklist (when the name is locked)

1. Availability: web search for the chosen name in AI/ML context; check arXiv, GitHub, HuggingFace, first 3 pages of Google for "X memory" / "X architecture" / "X agent"
2. Directory: `mv ~/Playful Sincerity/PS Research/Associative Memory ~/Playful Sincerity/PS Research/<NAME>`
3. Symlink update: `ln -sfn ~/Playful\ Sincerity/PS\ Research/<NAME> ~/Wisdom\ Personal/Anthropic\ Fellows\ Application/linked-assets/<NAME>` (remove old `associative-memory` symlink)
4. Global replace `Associative Memory` → `<NAME>` in:
   - `~/.claude/CLAUDE.md` (ecosystem map)
   - `~/Playful Sincerity/ECOSYSTEM.md`
   - `~/Playful Sincerity/CLAUDE.md`
   - The project's own `CLAUDE.md`, `vision.md`, and design docs (carefully — some uses of "associative" are mechanism-specific and should stay)
5. Memory file: rename `~/.claude/projects/-Users-wisdomhappy/memory/project_associative_memory_architecture.md` → `project_<name>_architecture.md`, update content, update [MEMORY.md](../../../../.claude/projects/-Users-wisdomhappy/memory/MEMORY.md) index
6. Fellows application: update `~/Wisdom Personal/Anthropic Fellows Application/application/drafts/q15-motivation.md`, `q16-research-interests.md`, `q17-background.md`, `cv-content.md` — replace `[NAME]` placeholder with the chosen name
7. Tombstone: leave a short note file at the old directory location (if possible via a README pointing to the new location) so stale references don't silently break
8. Chronicle entry: log the rename in the project's chronicle and in `~/claude-system/chronicle/` (ecosystem-level)

## What success looks like at end of session

Either:
- A name is locked + the execution checklist is fully worked through + the Fellows application drafts have the name replacing `[NAME]`, OR
- A name is locked + the execution is scheduled + Wisdom knows exactly what happens next and when

Not:
- A menu of good options presented without a decision
- Execution started but partially complete, leaving broken references

## Notes on the meta-pattern

Wisdom already did this rename-at-a-crossroads once when the AM project moved from "better retrieval" to "cognitive substrate" to "interpretable world model" — the thinking outgrew the name each time. This is the third such moment and the first where the name actually gets updated. The rename itself is an evolution-tracking event worth chronicling.

Stay focused on the decision. Don't drift into re-designing the project — vision.md already captures where the project is. This session exists to name it.

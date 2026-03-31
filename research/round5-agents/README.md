# Round 5 Research Agents — World Integration
## Perception, Action, Skill Learning, and Causal Discovery

**Date:** 2026-03-29
**Purpose:** Research the architecture's biggest identified gap — how the agent perceives, acts, learns skills, and builds causal knowledge from interaction with the world.
**Triggered by:** `design/world-integration.md` research gaps + Round 4 priorities #1 (tool use + world integration)

## Agent Index

| File | Stream | Agent Topic | Key Sources |
|------|--------|-------------|-------------|
| `stream-1-procedural-memory.md` | 1 | Procedural memory in cognitive architectures | ACT-R (Anderson 1983/2007), SOAR (Laird 2012), CLARION (Sun 2016), NARS (Wang), Mnemos |
| `stream-2-action-perception-loop.md` | 2 | Action-perception loop in cognitive science | Friston (2010, 2017, 2024), Gibson (1979), Neisser (1976), Varela et al. (1991), Schultz (1997), Barrett (2025), VERSES RGM |
| `stream-3-tool-use-patterns.md` | 3 | Tool use in modern AI agents | ReAct (Yao 2023), Toolformer (Schick 2023), LATS (Zhou 2024), Voyager (Wang 2023), Reflexion (Shinn 2023), CREATOR, ToolBench, AriGraph |
| `stream-4-skill-learning.md` | 4 | Skill learning and procedural knowledge in AI | Dyna (Sutton 1991), MAML (Finn 2017), Options (Sutton 1999), Voyager, JARVIS-1, SkiMo, PolySkill, GraphICL |
| `stream-5-causal-discovery.md` | 5 | Causal discovery from interventional data | Pearl (2009/2018), GFCI, PCMCI+ (Runge 2019), NOTEARS, ACE (2025), CauseNet, CausalKG, CORAL, causal-learn, DoWhy |

## Key Findings Per Stream

### Stream 1: Procedural Memory
- ACT-R utility equation `U(i) = P(i)*G - C(i)` for skill selection
- SOAR chunking = consolidation-as-compilation; impasses = Mirror spawning trees
- CLARION two-level competition (implicit vs explicit) with RER extraction algorithm
- NARS: no procedural/declarative distinction — validates unified graph
- Mnemos: reconsolidation pattern for skill updating (retrieve → labile → evaluate → overwrite)
- 6-phase skill acquisition pathway and SkillNode data structure proposed

### Stream 2: Action-Perception Loop
- Active inference confirms action as tree growth outward (same process as perception)
- VERSES RGM: "only active pathways require belief updating" = our spreading activation
- Affordance edges should be first-class in the Matrix
- Expected Free Energy automatically resolves exploration vs. exploitation
- Reconsolidation threshold should be precision-weighted, not fixed
- Mirror = apex of generative hierarchy at slowest timescale

### Stream 3: Tool Use Patterns
- 13 systems surveyed; universal gap: no system integrates tool experience into associative graph
- LATS tree search = direct analog of Trees plane
- Voyager = only persistent skill learning system; gaps are exactly what our architecture fills
- Toolformer loss-reduction criterion maps to our prediction-error signal
- Reflexion = best failure handling but linear buffer vs. our graph connections

### Stream 4: Skill Learning
- Dyna architecture maps to our consolidation (matrix = world model, replay = consolidation)
- Options framework gives formal SkillNode structure: initiation, policy, termination, dynamics
- Three novel things: context-driven selection, skills embedded in episodic history, Hebbian acquisition
- GraphICL validates graph-structured prompts outperform flat retrieval
- No separate learning algorithm needed — skills emerge from consolidation

### Stream 5: Causal Discovery
- Causal Hierarchy Theorem mathematically proves PMI-only graphs cannot answer interventional queries
- Recommended: GFCI + PCMCI+ (complementary: structural + temporal)
- NOTEARS has serious failure modes — use only as skeleton finder
- Active causal learning (ACE 2025): Mirror chooses most informative tool calls
- Computational cost: under 1 minute for consolidation-phase pipeline
- ~20-30 observations per (tool, context) pair for causal edges; ~500-1000 total interactions for core graph
- CauseNet can seed causal candidates before sufficient tool-use data

## Cross-References

- `design/world-integration.md` — the design doc this research grounds
- `design/improvements-from-round4.md` — corrections #2 (causal edges) and the big gap (tool use + skill learning)
- `research/comprehensive-audit.md` — living validation record (to be updated with Round 5)
- `research/round4-synthesis.md` — Round 4 findings that motivated this research

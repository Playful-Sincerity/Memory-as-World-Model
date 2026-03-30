# Value System — Care, Confidence, and Priority

## The Insight

Care, confidence, and priority are not separate features to be added to the architecture. They form an interconnected **motivational layer** that modulates every operation — encoding, traversal, pruning, consolidation, and output. This is the agent's affective system: the thing that determines not just *what* it knows, but *how much effort it puts into knowing it*.

This connects directly to Damasio's somatic marker hypothesis (already in The Companion plan): emotions are goal-alignment signals that modulate attention, budget, and behavior. The value system IS the emotion system, expressed as architectural parameters.

## The Three Dimensions

### 1. Care — "How much does this matter to me?"

Care determines computational budget. It answers: how deep should I traverse, how thoroughly should I search, how much effort should I spend?

| Care Level | Traversal Depth | Encoding Thoroughness | Pruning Resistance | Consolidation Priority |
|-----------|----------------|----------------------|-------------------|----------------------|
| High | Deep (5+ hops), broad fan-out | Create detailed nodes, rich edges | Resist eviction, compress slowly | Replay frequently, promote to semantic |
| Medium | Standard (2-3 hops) | Normal encoding | Standard eviction rules | Normal consolidation |
| Low | Shallow (1 hop), narrow | Minimal encoding or skip entirely | Evict readily | Decay faster, consolidate rarely |

**Where does care come from?**
- **Configured values:** The agent has explicit values/goals (e.g., "I care deeply about my human's wellbeing")
- **Graph-emergent:** Regions with high density, high connectivity, and frequent access signal care — the agent has invested attention there before
- **Contextual:** Who is asking? What's the task? What are the stakes?
- **Relational:** Care about the *person* can elevate care about a topic ("I don't usually care about sports, but my human is excited about this game")

**How care modulates traversal (solves the scale problem):**
```
traversal_budget = base_budget * care_multiplier

care_multiplier:
  high care   → 3.0x (deep exploration, broad fan-out, research if needed)
  medium care → 1.0x (standard traversal)
  low care    → 0.3x (quick surface answer, minimal fan-out)
```

This elegantly prevents the combinatorial explosion of spreading activation at scale. You don't fan out to millions of paths because the budget caps you — and the cap is set by how much you care.

### 2. Confidence — "How sure am I?"

Confidence gates output. It answers: should I speak, stay quiet, or go look deeper?

Two independent dimensions:

**Comprehension** — "Do I understand this concept?"
- Measured by: path strength to the relevant region, density of interconnections between loaded nodes, consistency of the loaded subgraph
- High comprehension: strong edges, dense neighborhood, no contradictions
- Low comprehension: weak edges, sparse region, isolated nodes

**Completeness** — "Have I found everything relevant in my memories?"
- Measured by: ratio of activated nodes to known nodes in the region, presence of unexplored high-weight edges, phantom edges suggesting pruned branches
- High completeness: most reachable nodes loaded, no dangling high-weight edges
- Low completeness: many untraversed strong edges, phantom edges pointing to unloded regions

**The confidence matrix:**

| | High Completeness | Low Completeness |
|---|---|---|
| **High Comprehension** | Speak confidently | "I understand this, but I may be missing context — let me look deeper" |
| **Low Comprehension** | "I've seen a lot about this but I'm not sure I understand it well" | "I don't have a strong grasp on this" → care level decides: research or say "I don't know" |

**Confidence decays:**
- Knowledge you haven't revisited feels less certain over time
- This mirrors real cognition — you were sure about something last month, but now you'd want to re-check before asserting it
- Implemented as: confidence = f(path_strength, recency_of_access, graph_density_in_region)

**Distinguishing types of not-knowing:**
- "I know I don't know" — graph has dangling edges, metamemory entries, explicit gaps. The agent knows the territory exists but hasn't explored it. (Structural curiosity from The Companion plan — topology generates awareness of gaps.)
- "I don't know what I don't know" — no graph structure in this area at all. The agent can't even assess what it's missing. This is the honest "I have no experience with this" state.

### 3. Priority — "How much will I need this?"

Priority is living valuation. Not the static `importance` field set at encoding time — a dynamic reassessment of each memory's value given what the agent is doing *right now*.

The same memory could be:
- High priority during a conversation about architecture (it's a load-bearing reference)
- Zero priority during a conversation about dinner (irrelevant)
- Medium priority during consolidation (contributes to a pattern being synthesized)

**Priority modulates:**
- **Decay resistance:** High-priority memories decay slower. This isn't the `protected` flag (which is binary and permanent) — it's a continuous, contextual resistance to forgetting.
- **Pruning order:** When context is full, low-priority nodes evict first, regardless of distance from focus. A distant but high-priority memory stays; a close but low-priority one can go.
- **Consolidation attention:** High-priority clusters get more consolidation time (deeper analysis, more cross-linking, better semantic promotion).
- **Re-encoding:** When a memory is accessed and found to be high-priority, it may be re-encoded with richer detail (content_ref gets promoted to full content, edges get descriptions).

**Priority computation:**
```
priority(node, current_context) =
    relevance_to_current_task     — how directly useful is this right now?
  × predicted_future_utility      — will I need this soon? (prospective memory)
  × emotional_weight              — does this connect to something I care about?
  × access_trend                  — have I been needing this more often lately?
```

## How They Interact

The three dimensions form a decision system:

```
Input arrives → Locate in graph

1. CARE assessment
   "How much does this matter?"
   → Sets the budget for everything that follows

2. TRAVERSAL (budget = f(care))
   Spread activation within budget
   Load nodes along paths

3. CONFIDENCE assessment
   "Do I understand? Have I found everything?"
   Comprehension × Completeness → confidence score

4. DECISION GATE
   ┌─────────────────────────────────────────────────┐
   │ High confidence + any care    → Respond          │
   │ Low confidence + high care    → Go deeper        │
   │                                 (more traversal, │
   │                                  research,       │
   │                                  ask questions)  │
   │ Low confidence + low care     → "I don't know"   │
   │                                 (and that's fine) │
   └─────────────────────────────────────────────────┘

5. PRIORITY assessment (post-interaction)
   For each memory that was in context:
   "How much will I need this going forward?"
   → Adjust decay rates, encoding richness, consolidation priority
```

## Architectural Integration

This value system touches every layer:

| Layer | Without Value System | With Value System |
|-------|---------------------|-------------------|
| **Encoding** (what becomes a node) | Encode everything / heuristic filter | Care + surprise: encode deeply what matters, skip what doesn't |
| **Traversal** (how deep to go) | Fixed depth or budget | Budget scales with care level |
| **Pruning** (what to evict) | Distance from focus only | Distance × inverse priority — important things stay even if distant |
| **Consolidation** (what to strengthen) | Uniform processing | High-care regions get more replay, deeper analysis |
| **Output** (what to say) | Generate if you have context | Confidence gates: speak, research, or abstain |
| **Anti-hallucination** | Structural constraints only | Confidence threshold: don't generate below threshold |

## Connection to The Companion's Emotion System

The Companion plan has an emotion layer modeled on Damasio's somatic markers: a continuous background evaluator asking "Am I aligned with my goals?"

The value system IS this, made concrete:
- **Care** = the emotional weight assigned to a domain/task/person
- **Confidence** = the felt sense of knowing (metamemory)
- **Priority** = the prospective assessment ("will I need this?")

These aren't separate from emotions — they are what emotions DO in a cognitive system. They modulate attention, effort, and behavior. The value system is the emotion system expressed as architectural parameters.

## Open Questions

- **Learning care:** Can the agent learn what to care about from experience, or must values be configured? Probably both — some values are given (like caring about the human), others emerge from the graph (you care about what you've invested in).
- **Care conflicts:** What happens when the agent cares about two contradictory things? (The human wants X, but the agent's experience says X is harmful.)
- **Confidence calibration:** How do you calibrate confidence so the agent isn't overconfident (speaks when it shouldn't) or underconfident (says "I don't know" when it has good information)?
- **Priority horizon:** How far ahead does predicted_future_utility look? Next turn? Next conversation? Next month?
- **Value drift:** Should the agent's values evolve over time, or should some be immutable? (Connection to alignment — values that drift could drift in bad directions.)

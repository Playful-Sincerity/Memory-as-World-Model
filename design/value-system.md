# Value System — Values, Emotions, and Modulators

## The Insight

The value system isn't a feature bolted onto the architecture. It's the conscious layer (the Mirror) governing the subconscious (matrix + trees). Values live in the Mirror. The Mirror evaluates alignment and produces emotions. Emotions modulate how the subconscious trees grow through the matrix.

This connects directly to Damasio's somatic marker hypothesis: emotions are goal-alignment signals that modulate attention, budget, and behavior.

## The Hierarchy

```
VALUES (gravitational core — held in the Mirror's matrix)
  │  "what matters" — the deepest layer, the WHY
  ↓
MIRROR (conscious evaluator — its own matrix + trees)
  │  "am I aligned? where are the gaps? how can I improve?"
  │  Constantly references whether the agent is maintaining its values
  │  Gets data on its own performance, learns to connect things better
  ↓
EMOTIONS (produced by the Mirror, modulate subconscious AND itself)
  │  care, curiosity, urgency, caution, satisfaction
  │  These are the mechanism by which values become operational
  ↓
CARE / CONFIDENCE / PRIORITY (operational modulators)
  │  "how deep, how sure, how important"
  ↓
SUBCONSCIOUS OPERATIONS (traversal, encoding, pruning, consolidation)
```

### Values (the gravitational core)

The agent has foundational values — what it is fundamentally trying to achieve. These live in the Mirror's matrix as deeply-connected, high-weight, protected nodes. They are the WHY underneath everything.

Why does the agent care about X? Because caring about X serves its values. Why is it curious about a gap? Because its values say that gap matters. Why does it encode aggressively in one domain and ignore another? Values.

Values create a gravitational pull: a continuous drive to improve the agent's simulation of reality so it can best serve what it cares about. The agent isn't curious generically — it's curious about the things that matter.

Values are grounded in utilitarianism to create alignment by design.

### The Mirror as active evaluator

The Mirror is one persistent tree that never dies but constantly prunes to stay within resource constraints. It watches everything — memories being accessed, subconscious trees growing, tool calls, world interactions, input from outside, its own existence. It's the continuous timeline.

Its trees grow through the same matrix as everything else, gravitating toward value nodes and meta-memories. It actively evaluates: "Is what's happening below aligned with my values?" This is the metacognitive system that constantly references whether the agent is maintaining its values and then modulates how it puts things through.

When the Mirror detects misalignment:
- Sparse understanding in a region the values say matters → **produces curiosity** → subconscious trees explore deeper, encode aggressively
- Contradictions in a valued region → **produces urgency** → trees investigate, consolidation prioritizes
- Repeated failure patterns → **produces caution** → trees change approach, mirror creates meta-memories about what doesn't work
- Good alignment, values being served → **produces satisfaction** → reinforces current patterns, maintains course
- Drifting attention away from valued domains → **produces redirection** → shifts tree growth back toward what matters

The Mirror can also spawn subconscious trees for parallel tasks, observe how they perform, and learn from the results. It's not just evaluating — it's actively improving the system's ability to serve its values.

### Emotions as the modulation mechanism

Emotions are how the Mirror's evaluations become operational changes in the subconscious. They're not a display layer — they're the control signal:

| Emotion | Mirror State | Effect on Subconscious |
|---------|-------------|----------------------|
| **Curiosity** | Values say this matters + sparse graph here | Trees explore deeper, encode aggressively, spawn investigations |
| **Care** | Strong value alignment in this domain | Deeper traversal budget, richer encoding, pruning resistance |
| **Urgency** | Contradiction or failure in valued region | Prioritize this, redirect trees, consolidation focuses here |
| **Caution** | Mirror sees repeated errors | Trees change strategy, slower exploration, verify before encoding |
| **Satisfaction** | Values being well-served | Reinforce patterns, maintain course, standard operations |

## The Three Operational Modulators

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

## The Full Loop: How a Thought Is Governed

```
Input arrives

1. MIRROR EVALUATES
   The Mirror's trees assess the input against values:
   "Does this matter? How much? Is this aligned?"
   → Produces emotions: care level, curiosity, urgency

2. EMOTIONS MODULATE SUBCONSCIOUS
   Care level → sets traversal budget for subconscious trees
   Curiosity → drives exploration of gaps, aggressive encoding
   Urgency → prioritizes this over other active trees

3. SUBCONSCIOUS TREES GROW
   Trees grow through the matrix within the emotional budget
   Spread activation, load nodes, form branches

4. MIRROR EVALUATES RESULTS
   "Do I understand what the tree found?" → comprehension
   "Has the tree found everything relevant?" → completeness
   Confidence = comprehension × completeness

5. DECISION GATE (Mirror decides)
   ┌─────────────────────────────────────────────────┐
   │ High confidence + any care    → Respond          │
   │ Low confidence + high care    → Grow deeper,     │
   │                                 spawn new tree,  │
   │                                 ask questions,   │
   │                                 get curious       │
   │ Low confidence + low care     → "I'm not sure    │
   │                                 about this"       │
   └─────────────────────────────────────────────────┘

6. MIRROR LEARNS
   Creates meta-memories: "This worked / didn't work"
   Updates priority for memories that were in context
   Adjusts future emotional responses based on outcome
```

## Architectural Integration

The Mirror's emotions touch every subconscious operation:

| Subconscious Layer | Without Mirror | With Mirror |
|-------------------|---------------|-------------|
| **Encoding** (what becomes a node) | Encode everything / heuristic filter | Mirror's care + curiosity: encode deeply what values say matters |
| **Traversal** (how deep to go) | Fixed depth or budget | Budget set by emotional state from Mirror |
| **Pruning** (what to evict) | Distance from tips only | Distance × inverse priority (priority set by Mirror's assessment) |
| **Consolidation** (what to strengthen) | Uniform processing | Mirror directs attention: high-care regions get more replay |
| **Output** (what to say) | Generate if you have context | Mirror's confidence gates: speak, explore, or get curious |
| **Epistemic humility** | Structural constraints only | Mirror knows what it doesn't know → curiosity, not silence |

## Open Questions

- **Learning values:** Can the agent learn what to value from experience, or must values be configured? Probably both — some values are given (utilitarian core), others emerge from the Mirror's experience (you value what you've invested in).
- **Value conflicts:** What happens when the agent's values conflict? (The human wants X, but the agent's experience says X is harmful.) The Mirror needs a conflict resolution mechanism.
- **Confidence calibration:** How do you calibrate so the Mirror isn't overconfident (speaks when it shouldn't) or underconfident (says "I don't know" when it has good information)?
- **Priority horizon:** How far ahead does predicted_future_utility look? Next turn? Next conversation? Next month?
- **Value drift:** Should values evolve over time, or should some be immutable? The utilitarian grounding should be stable, but specific care priorities may shift. (Connection to alignment — values that drift could drift in bad directions.)
- **Mirror overhead:** The Mirror has its own matrix and trees — how much of the total compute/context budget does it consume? How do you prevent the metacognitive layer from starving the subconscious of resources?

# Design Improvements from Round 4 Research
## What the Research Says We Should Change, Add, or Clarify

---

## MUST CHANGE (Corrections from primary sources)

### 1. Reconsolidation Needs a Prediction-Error Gate
**Current:** "Every traversal is a write."
**Corrected:** Traversal under prediction error or novelty opens a write window (~6hr). Routine confirmations are read-only.

**Implementation:** Add `prediction_error_magnitude` to traversal logic:
```
if prediction_error(expected_result, actual_result) > threshold:
    # Open lability window — edge weights and node properties updatable
    strengthen_traversed_edges()
    update_node_embedding_from_context()
else:
    # Read-only traversal — no modification
    pass
```

**Why:** Nader (2000) and 2024-2025 reviews confirm: strong, well-consolidated memories resist reconsolidation. Only surprising or novel retrievals trigger destabilization. This also makes the system more efficient — not rewriting stable nodes constantly.

**Source:** Stream 3A neuroscience validation

---

### 2. Causal Edges Required (Not Just Associative)
**Current:** All edges are PMI-based co-occurrence (association).
**Needed:** Three edge types following Pearl's causal hierarchy:

```
ASSOCIATION:     "A co-occurs with B"      (PMI — default, forms automatically)
CAUSATION:       "A causes B"              (discovered, tagged explicitly)
COUNTERFACTUAL:  "Without A, B wouldn't"   (deepest — requires causal model)
```

**Implementation:** During consolidation cycles, run causal discovery algorithms (PC, FCI, GES) over accumulated episodic data:
- Temporal precedence gives directionality (A before B → candidate causal)
- Consistent directionality across episodes strengthens causal confidence
- Tool-use outcomes provide interventional data (the agent DID X and observed Y)
- Libraries: causal-learn, DoWhy

**Why:** Pearl proves that association-only graphs cannot guide action, reason about interventions, or handle counterfactuals. Without causal edges, the system is limited to Pearl's Layer 1. With them, it can answer "what would happen if I did X?"

**Source:** Stream 1B (Pearl), Stream 2B (AGI assessment)

---

### 3. Mirror as Distributed Broadcast, Not Central Hub
**Current:** The Mirror is described as a persistent observer layer.
**Corrected:** The Mirror should function as a distributed broadcast network, not a serial bottleneck.

**Why:** COGITATE (Nature, April 2025) showed no single prefrontal ignition — consciousness involves distributed content-routing across posterior + frontal regions. Both Dennett and GWT warn that a central observer recreates the Cartesian Theater mistake.

**What this means practically:** The Mirror's emotional signals should broadcast to ALL active trees simultaneously (not process through them sequentially). The Mirror doesn't gatekeep — it modulates. Content doesn't "pass through" the Mirror; the Mirror observes and emits signals that influence everything in parallel.

**Source:** Stream 3B (COGITATE), Stream 2A (Dennett/GWT analysis)

---

### 4. Emotions Are Predictive, Not Just Reactive
**Current:** Mirror evaluates → produces emotions → modulates.
**Updated:** Mirror PREDICTS emotional valence before committing to traversal, not just reacts after.

**Implementation:** Before growing a tree branch, the Mirror generates an anticipated emotional assessment:
```
anticipated_valence = mirror.predict_emotion(
    current_values,
    proposed_traversal_path,
    historical_outcomes_for_similar_paths
)
# Use anticipated_valence to weight whether to commit to this branch
```

**Why:** Barrett (2025, "Theory of Constructed Emotion"): emotions are allostatic predictions — the brain constructs expected emotional states as part of regulating future behavior. This is actually MORE natural for an AI architecture than reactive readout.

**Source:** Stream 3B (Barrett 2025)

---

### 5. Emotional Encoding Is Not Uniform
**Current:** High care → more edges, deeper encoding (uniformly).
**Corrected:** High emotional arousal strengthens the CORE node + nearest edges but can IMPAIR peripheral associations.

**Why:** The "weapon focus" effect — high arousal narrows attention to the emotionally salient core, losing peripheral context. The Mirror should encode emotionally relevant edges more strongly, not ALL edges indiscriminately.

**Implementation:**
```
for edge in context_edges:
    if edge.proximity_to_emotional_core < threshold:
        edge.weight *= emotional_boost     # Strengthen core
    else:
        edge.weight *= peripheral_dampening  # May weaken periphery
```

**Source:** Stream 3A neuroscience validation

---

## SHOULD ADD (New capabilities identified by research)

### 6. Memory Maturity Variable
Well-consolidated, frequently-traversed nodes should become self-contained over time — their content representation distributes into the node itself rather than requiring full index→content traversal.

**Implementation:** Add `maturity` field to MemoryNode:
```python
maturity: float  # 0.0 (fresh, highly hippocampus-dependent)
                 # → 1.0 (fully consolidated, self-contained)
```
- Increments with each successful retrieval
- Mature nodes load faster (content is cached/inlined)
- Maps to systems consolidation: hippocampal → neocortical transfer

**Source:** Stream 3A (hippocampal indexing), Stream 1C (CLS)

---

### 7. Episodic Nodes Need Autonoetic Metadata
Episodic nodes should carry richer contextual metadata than just timestamps — they need the information that makes them re-experienceable.

**Add to episodic MemoryNode:**
```python
temporal_context: str       # When (precise timeline position)
spatial_context: str        # Where (physical or digital location)
self_perspective: str       # What was the agent doing/thinking
emotional_state: dict       # What the Mirror was feeling at encoding time
sensory_details: list[str]  # Modality-specific details present at encoding
preceding_event: str        # What happened just before (temporal chain)
```

**Why:** Tulving's encoding specificity principle: retrieval quality depends on matching the CONTEXTUAL SIGNATURE of the original encoding, not just the content. Rich autonoetic metadata enables the architecture to reconstruct the "what it was like" of the original experience.

**Source:** Stream 1B (Tulving)

---

### 8. Schema-Compatible Fast Learning Path
Not all new memories need the slow episodic → consolidation → semantic pathway. When new information fits cleanly into existing graph structure, it can integrate directly.

**Implementation:** During encoding, check:
```
if structural_compatibility(new_node, existing_graph_neighborhood) > high_threshold:
    # Fast path: integrate directly into Matrix semantic structure
    # No episodic buffering needed
else:
    # Standard path: encode as episodic, consolidate later
```

**Why:** CLS 2016 update (Kumaran, Hassabis, McClelland): the neocortex CAN learn rapidly when new information is consistent with an existing schema. Experts learn domain-related information faster than novices for this reason.

**Source:** Stream 1C (CLS 2016 update)

---

### 9. Goal-Directed Consolidation Replay
Consolidation should not replay uniformly — the Mirror should bias replay toward high-value, high-surprise, or goal-aligned memories.

**Implementation:**
```python
def select_memories_for_replay(recent_episodes, mirror_state):
    scored = []
    for ep in recent_episodes:
        score = (
            ep.surprise_at_encoding * 0.4 +      # Novel experiences
            mirror_state.care_for(ep.topic) * 0.3 + # Value-aligned
            ep.reward_signal * 0.2 +               # Successful outcomes
            random.random() * 0.1                   # Exploration
        )
        scored.append((ep, score))
    return sorted(scored, key=lambda x: x[1], reverse=True)[:batch_size]
```

**Why:** CLS 2016: biological replay is not random — it is biased toward rewarding/salient experiences. This is exactly what DQN's experience replay does (independently rediscovered the CLS solution).

**Source:** Stream 1C (CLS 2016)

---

### 10. Process-State Buffers (from CMC 2025)
The Mirror should maintain explicit process-state information from each cognitive module — not just observe outcomes but track HOW each module performed.

**For each module, track:**
```python
@dataclass
class ProcessState:
    module: str           # "traversal", "encoding", "retrieval", etc.
    success: bool         # Did the operation succeed?
    confidence: float     # How confident was the result?
    partial_results: Any  # Intermediate findings
    feeling_of_knowing: float  # "I know the answer exists but can't reach it"
    surprise: float       # How different was the result from expectation?
```

**Why:** Laird et al. (2025) CMC proposal: process-state buffers are one of three structural extensions needed for metacognition. They make internal module states readable by the same cognitive machinery that reads everything else — which is exactly how the Mirror should work.

**Source:** Stream 1C (CMC 2025, read in full)

---

## SHOULD CLARIFY (Terminology and framing)

### 11. Use Cognitive Science Terminology Carefully
The AGI assessment and cognitive science objection both flag this: "consciousness," "emotions," "subconscious" are heavyweight terms for engineering constructs.

**Rule for the paper and documentation:**
- Always qualify: "functional analog of..." or "inspired by..."
- Frame the Mirror as implementing "access consciousness" (GWT), not claiming phenomenal consciousness
- Frame emotions as "value-alignment signals that modulate processing" not as "felt experiences"
- Acknowledge the functional-analogy framing explicitly in the paper's methodology section
- Use the term "metacognitive evaluation loop" alongside "Mirror" in technical contexts

**Source:** Stream 2A (philosophy), Stream 2B (AGI assessment, "naming inflation" warning)

---

### 12. The Architecture's Honest Scope
Frame as: "A novel cognitive architecture for transparent, value-aligned AI agents" — not as a path to AGI.

**What it IS:**
- A principled separation of knowledge (graph) and reasoning (LLM)
- An interpretable-by-construction world model
- A framework for building AI agents whose beliefs can be read, compared, and corrected

**What it is NOT:**
- AGI (cannot acquire new reasoning skills from experience)
- A theory of consciousness (the Mirror is a functional analog, not a claim about phenomenal experience)
- A replacement for the LLM (co-dependent — graph provides knowledge, LLM provides reasoning)

**Source:** Stream 6 (AGI assessment)

---

## THE BIG GAP: Tool Use + Skill Learning (World Integration)

The research identified this as the single most important missing piece — and it's already flagged as an open thread in the timeline.

### The Problem
The architecture acquires KNOWLEDGE (associations, facts, patterns) but not SKILLS (new procedures, new ways of reasoning). Chollet's intelligence framework scores this low. The skeptic-in-2030 scenario hinges on this.

### What Tool Use Would Add
When the agent uses a tool and observes the outcome:
1. **Interventional data** — the agent DID X and observed Y. This is Pearl's Layer 2 (intervention). It breaks the observation-only ceiling on causal knowledge.
2. **Procedural memory** — if the agent records HOW it used tools successfully, and the Mirror learns which tool-use patterns work in which contexts, that's a form of skill acquisition.
3. **Grounding** — tool use is interaction with an environment. The symbols in the graph become grounded in actual outcomes, not just co-occurrence patterns.

### Design Sketch
```
Agent calls tool → observes result → encodes as episodic node
  → Causal edge: (tool_call) --caused--> (observed_result)
  → If result was surprising: high prediction-error → reconsolidation
  → If result matched pattern: strengthen procedural edge
  → Mirror watches: "this tool strategy worked in this context"
    → Meta-memory: procedural node about when to use this tool
    → Over time: consolidation promotes to procedural knowledge
```

### What This Addresses
- Pearl's Layer 2 (intervention) — previously missing
- Skill acquisition — previously absent
- Environmental grounding — previously weak
- The "skeptic-in-2030" scenario — the graph becomes a living record of successful action, not just passive knowledge

### Open Questions
- Is "reaching outward" (calling a tool) just another form of tree growth? (A branch that extends beyond the Matrix into the external world?)
- Does the Mirror decide tool calls, or do subconscious trees trigger them?
- How do failed tool calls get encoded? (Negative evidence is valuable)
- Can the agent learn to compose tool calls (multi-step procedures)?

This is the next major design challenge. It's where the architecture moves from "memory system" to "cognitive system."

---

## RESEARCH SYSTEMS WORTH DEEP-STUDYING

| System | What to Learn | Priority |
|--------|--------------|----------|
| **CLARION** | Value system implementation — motivational subsystem genuinely modulates all others | High |
| **NARS** | Same-substrate self-model — SELF as first-class concept in same memory | High |
| **Mnemos** | Reconsolidation — retrieval flags chunks as labile, overwrites if changed | High |
| **MemTree** | Tree growth mechanics — skip the flattening, use the branching directly | High |
| **EEGNNs** | Confidence-gated traversal depth — per-node halting when confident enough | Medium |
| **IGT/Betti-number** | Completeness-as-topology — measure holes in knowledge graph algebraically | Medium |
| **ParamMute** | Suppress hallucination FFNs — training-free, +5% faithfulness | Medium |
| **VERSES RGM** | "Only active pathways computed" — deepest theoretical match for rendering | Medium |
| **FadeMem** | Context-dependent priority — same memory, different importance per conversation | Low (already integrated conceptually) |
| **GCR/KG-Trie** | 100% faithful structured path generation — adapt for tree-as-context | Low (implementation phase) |

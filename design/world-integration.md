# World Integration — Perception, Action, and Skill Learning

## The Foundational Reframing

**The architecture is not a memory system that can also act. It is an action system that thinks through memory.**

Action is what cognition is FOR. The entire architecture — trees, Mirror, consolidation, values — exists to support good action in the world. Trees grow so the agent can act well. The Mirror evaluates so actions serve values. Consolidation extracts patterns so future actions are better.

The agent already acts — generating a response IS an action in the world. Tool use isn't a new capability to bolt on. It's a generalization of what the agent already does. The question isn't "how do we add action" but "how do we make the architecture's action-oriented purpose explicit."

### Knowledge becomes action when it reveals a gap the values say matters

Action is what happens when the distance between "how things are" (what the tree shows) and "how things should be" (what the values say) is large enough to overcome inertia. The Mirror doesn't just evaluate alignment — it generates action tendencies. Care doesn't just set traversal budget — it produces a pull toward specific actions.

### Meaning is constituted by action consequences

A node doesn't just store what something IS — it stores what you can DO with it (affordances). "This is fragile" MEANS "if you drop it, it will break." The action possibilities are part of the meaning. Knowledge about a user's preference is incomplete until the agent acts on it. Tool use isn't an add-on — it's how meaning gets completed.

**Philosophical foundations:** Pragmatism (Peirce/James/Dewey — meaning = practical consequences), Gibson (affordance theory — objects perceived as action possibilities), Enactivism (cognition constituted by action, not just informed by it).

---

## The Problem (First Principles)

The architecture has an inner world (matrix + trees + mirror) and an outer world (users, tools, APIs, files, sensors, the internet). The inner world is well-designed. The interface to the outer world needs to make the architecture's action-oriented purpose concrete.

Three directions:
1. **Perception** — outer world → inner world. Information comes in. Becomes nodes in the matrix.
2. **Action** — inner world → outer world. The agent does something. Changes the outer world.
3. **Learning from action** — the agent acts, observes the result, updates its understanding. This is where SKILLS come from. Not "I know about hammers" but "I know when and how to use a hammer."

Without the skill loop, the architecture acquires knowledge but not skills. It knows but doesn't grow in capability.

## What "Action" Actually Means

At first principles, an action is: the agent manipulates something in the outer world and observes what happens. But action isn't just output — it's how meaning gets completed. Knowledge has action implications (affordances), and those affordances are part of what the knowledge means.

Examples:
- Calling a tool (web search, file read, API call, code execution)
- Sending a message to a user
- Creating or modifying a file
- Querying a database
- Triggering a physical actuator (future, robotics)
- Asking a question ("I don't know — what do you think?")

Every action has:
- An **intention** — what the agent was trying to achieve (the Mirror's goal)
- A **method** — how it chose to act (which tool, what parameters)
- An **outcome** — what happened (the result)
- A **surprise** — how different the outcome was from what the Mirror predicted

The surprise is the learning signal. Low surprise = confirmation. High surprise = reconsolidation window opens, edges update, new associations form.

## What "Skill" Actually Means

A skill is: knowing WHEN and HOW to do something, not just THAT something exists.

In the current architecture:
- "Ice cream relates to motorcycles through the road trip" = knowledge (associative)
- "When the user asks about X, searching the web is more effective than searching memory" = skill (procedural)
- "API calls to service Y tend to fail on weekends" = knowledge from action (causal)
- "When my confidence is low on a technical topic, I should read the docs before responding" = meta-skill (the Mirror learning about its own best strategies)

Skills are represented differently from knowledge:
- Knowledge = associations between things (what relates to what)
- Skills = associations between SITUATIONS and ACTIONS with OUTCOMES (when I'm in context X, action Y tends to produce result Z)

## The Three Layers of World Integration

### Layer 1: Perception (outer → inner)

How does external input become part of the matrix?

- User message arrives → encoded as episodic node, connected to active tree tips
- Tool result returns → encoded as episodic node, connected to the action that requested it (causal edge)
- Sensor data arrives → encoded as node (possibly non-text modality)
- Time passes → temporal markers, context shifts

**Key question:** What determines encoding granularity? (This is the "what becomes a node?" question, specifically for external input.)

### Layer 2: Action (inner → outer)

How does thinking lead to doing?

- A subconscious tree is growing and hits a gap (no path exists, low confidence)
- OR the Mirror evaluates and decides more information is needed
- OR the tree has grown enough that the agent is ready to respond/act
- The agent selects and executes an action (tool call, message, etc.)

**Key questions:**
- Who decides to act — the Mirror or the subconscious tree?
- Is action selection its own kind of tree growth? (Branching outward into the world instead of inward through the matrix?)
- How does the agent choose WHICH action? (From procedural memory? From the LLM's general knowledge? Both?)

### Layer 3: Learning from Action (the skill loop)

This is the critical piece. After acting and observing:

```
1. PREDICT    Mirror predicts outcome before action
              (Barrett's predictive emotions)

2. ACT        Execute the action (tool call, message, etc.)

3. OBSERVE    Result arrives. Encode as episodic node.
              Connect to the action with a causal edge:
              (action) --caused--> (result)

4. COMPARE    Mirror compares predicted vs actual outcome.
              prediction_error = |predicted - actual|

5. UPDATE     If prediction_error > threshold:
                Reconsolidation window opens
                Edges update, new associations form
                Mirror encodes meta-memory about what happened
              If prediction_error ≈ 0:
                Strengthen existing edges (confirmation)
                Skill becomes more consolidated

6. ABSTRACT   Over time, consolidation promotes repeated
              situation→action→outcome patterns into
              procedural knowledge:
              "When [context], doing [action] tends to [result]"
              These are SKILL nodes — a new node type.
```

## What's Different About Procedural Nodes

Current node types: episodic, semantic. (Meta-memories in the Mirror.)

A skill/procedural node would need:
- **Trigger context** — when does this skill apply? (situation description)
- **Action template** — what to do (tool name, parameter patterns)
- **Expected outcome** — what should happen if the skill works
- **Success rate** — how often has this worked historically
- **Conditions** — when NOT to use this (learned from failures)

This is similar to what SOAR calls "production rules" and ACT-R calls "procedural memory" — but stored in the graph, connected associatively to the contexts where they apply, rather than as a separate rule system.

## Causal Edges (Pearl's Layer 2)

Tool use is what creates causal knowledge. Without it, the graph only has associations (co-occurrence). With tool use:

```
ASSOCIATION:     "search results and correct answers co-occur"
                 (PMI — observational only)

CAUSATION:       "searching CAUSED me to find the answer"
                 (I did the search, I observed the result)
                 (interventional — Pearl's Layer 2)

COUNTERFACTUAL:  "if I hadn't searched, I wouldn't have found it"
                 (requires causal model — Pearl's Layer 3)
                 (discoverable through consolidation over many episodes)
```

## Open Design Questions (Updated After Round 5 Research)

1. **Is action just tree growth?** → **RESOLVED: Yes.** Active inference (Friston 2010, 2017) confirms action and perception are the same process applied in different directions. Tool calls are branches growing outward; results return as new nodes at the tip. Same traversal engine, same budget, same pruning. See [round5-synthesis.md](../research/round5-synthesis.md) §2.

2. **Who decides to act?** → **RESOLVED: Both, competing probabilistically.** CLARION's two-level competition (Sun 2016) provides the model: implicit (automatic skill activation from graph traversal) competes with explicit (Mirror deliberation). Consolidated skills fire automatically; novel situations require Mirror deliberation. Weighted by experience. See [round5-synthesis.md](../research/round5-synthesis.md) §1.

3. **How do failed actions get encoded?** → **RESOLVED: As first-class graph nodes with causal edges.** Failure episodes become episodic nodes connected via causal edges to (a) the action that failed, (b) the context where it failed, and (c) the procedural node it implicates. Traversal from similar contexts naturally surfaces relevant failures. Reflexion (Shinn 2023) does verbal failure reflection; our improvement is graph-connected failures. See [round5-synthesis.md](../research/round5-synthesis.md) §3.

4. **How does the agent compose multi-step actions?** → **PARTIALLY RESOLVED.** LATS (Zhou 2024) applies MCTS to action sequences — trees exploring different tool chains. The Mirror manages high-level planning at skill level (SkiMo shows 5x efficiency), while trees handle execution. SOAR's subgoaling provides the formal model: hit an impasse → spawn subtree → resolve → return. Remaining open: how are multi-step plans represented as graph structure?

5. **Skill decay and refinement.** → **RESOLVED: Skills follow the same decay as everything else, but consolidation resists it.** ACT-R's utility learning provides the model: success_rate (P) and cost_estimate (C) update with each use. Unused skills decay. Well-consolidated skills have high maturity and resist decay. Mnemos reconsolidation: skills are flagged labile on activation and updated based on outcome.

6. **Transfer.** → **RESOLVED: Through associative links between contexts.** Skills transfer because a new situation shares associative connections with contexts where the skill previously succeeded. This is context-driven selection (not semantic similarity). GraphICL (2025) validates that graph-structured context outperforms flat retrieval for in-context learning. See [round5-synthesis.md](../research/round5-synthesis.md) §4.

## Research Gaps — ALL RESOLVED (Round 5, 2026-03-29)

All three gaps identified in the original design have been addressed by Round 5 research (5 agents, 50+ sources).

### 1. SOAR / ACT-R procedural memory → RESOLVED
Deep-dived ACT-R production compilation, SOAR chunking, CLARION two-level competition, NARS unified memory, and Mnemos reconsolidation. Result: 6-phase skill acquisition pathway, SkillNode data structure, and selection equation. See [stream-1-procedural-memory.md](../research/round5-agents/stream-1-procedural-memory.md).

### 2. Action-perception loop in cognitive science → RESOLVED
Grounded in active inference (Friston), VERSES RGM, Gibson affordances, Neisser's perceptual cycle, enactivism, predictive coding, and Expected Free Energy. Result: action IS tree growth (formally, not metaphorically), affordance edges as first-class, Mirror as apex of generative hierarchy. See [stream-2-action-perception-loop.md](../research/round5-agents/stream-2-action-perception-loop.md).

### 3. How current agent frameworks structure tool use → RESOLVED
Surveyed 13 systems (ReAct, Toolformer, LATS, Voyager, Reflexion, CREATOR, ToolBench, AriGraph, etc.). Universal gap confirmed: no system integrates tool experience into an associative graph. See [stream-3-tool-use-patterns.md](../research/round5-agents/stream-3-tool-use-patterns.md).

### Additional: Causal discovery + Skill learning
Two further streams researched skill learning in AI (Dyna, Options, MAML, Voyager, GraphICL) and causal discovery from interventional data (GFCI + PCMCI+ pipeline, CauseNet seeding, ACE active learning). See [stream-4-skill-learning.md](../research/round5-agents/stream-4-skill-learning.md) and [stream-5-causal-discovery.md](../research/round5-agents/stream-5-causal-discovery.md).

**Full synthesis:** [research/round5-synthesis.md](../research/round5-synthesis.md)

## Remaining Open Questions

- How are multi-step plans represented as graph structure? (Partially resolved by LATS + SOAR subgoaling, but representation format TBD)
- What determines encoding granularity for external input? (The "what becomes a node?" question, specifically for perception)
- How does the agent's Markov blanket (Friston) map to the actual tool-use API boundary?

## Status

Research complete. Design validated by 50+ sources across 5 streams. Ready for design doc update and prototype specification.

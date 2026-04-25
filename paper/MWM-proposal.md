# Memory as World Model

### An interpretable-by-design architecture in which the graph replaces pretrained weights as the locus of belief

**Wisdom Happy** · Playful Sincerity Research · April 2026

---

## Abstract

Today's large language models bundle three things into a single weight space: language, knowledge, and reasoning. Interpretability in that substrate is therefore *forensic* — we reverse-engineer features and circuits from a system that was never designed to be read. This proposal describes a different architecture. The agent's beliefs live in an explicit graph of nodes and edges grown from its own experience. The LLM becomes a traversal and reading engine, optimized for navigating local neighborhoods and rendering language. A separate reasoning tool handles logic and math. Knowledge sits in the graph; language sits in the LLM; reasoning sits in a symbolic tool. Three components, each doing what it is good at. The question *"why does this agent believe X?"* is answered by tracing a path in the graph, not by training a probe against the weights. Memory as World Model (MWM) is not a retrieval-augmentation layer on top of an LLM. It is a cognitive substrate in which memory IS the world model, and the world model is *the* primary locus of interpretability, correction, and aligned action.

This paper frames the architectural inversion, lays out the Three Planes model (Matrix, Trees, Mirror) that grounds it, describes the mechanisms that make it work (navigation-not-retrieval, causal edges, reconsolidation, epistemic humility, earned conviction), proposes the predictions and measurements that would validate or falsify the approach, positions it against the prior art it builds on, and traces the implications for interpretability, alignment, and AI welfare.

---

## 1. Thesis

> **The memory structure IS the interpretable world model, and it replaces the role that pretrained weights currently play in forming beliefs and understanding.**

There is a tighter way to say this. This is not a memory system that can also reason. It is an *action system that thinks through memory*. Action is what cognition is for; memory is the medium through which action becomes intelligent. Trees grow so the agent can act well. The Mirror watches so action stays aligned with what the agent cares about. Consolidation runs so next time the action is better. The graph is the substrate on which the agent's relationship to its own past becomes the structure of its present behavior.

Three claims follow from the thesis.

**First, the graph can carry the work that pretrained weights currently carry.** The weights of a frontier LLM store a compressed universe of facts, associations, procedures, and styles, bundled together in ways we cannot read. If beliefs instead live as nodes, with provenance, confidence, timestamps, and explicit edges to the evidence they rest on, then the agent's world-model is directly inspectable. The LLM's remaining job is to traverse, render, and summarize — not to hold the truth.

**Second, the LLM's weights are most useful when they are doing what they are unambiguously good at.** Frontier models are extraordinary at local language inference, summarization, surface-level semantic matching, and disambiguation. They are less good at holding a consistent belief set across sessions, resisting plausible-sounding false claims, or explaining why they said what they said. Putting beliefs in the graph plays to the LLM's strengths and away from its weaknesses.

**Third, interpretability-by-design is cheaper and more reliable than interpretability-by-autopsy.** If the representation was built to be read from the start, reading it is not a research program — it is a `SELECT` statement. Mechanistic interpretability in frontier models is a heroic effort that may or may not scale. An architecture where the belief-state is already the artifact produces interpretability as a byproduct of normal operation.

This is not a proposal to replace pretrained weights. It is a proposal to *redistribute* the work they currently do. Language stays in the LLM. Knowledge moves to the graph. Reasoning moves to a symbolic/numeric tool. Each component carries the load it is suited for.

---

## 2. The Architectural Inversion

### 2.1 Today's configuration

A modern LLM-based agent is, architecturally, a single opaque function with bolted-on accessories. The weights hold whatever they absorbed during pretraining. Context windows give short-term state. Retrieval-augmented generation injects chunks of external text into the prompt when it helps. Tool calls handle edge cases the weights cannot do on their own. All reasoning — factual, logical, emotional, metacognitive — routes through the same weight space and emerges as a single surface of tokens.

Interpretability in this configuration is forensic. We can train probes against activations, map circuits through attention heads, identify features that correlate with behaviors we care about. The work is genuine and valuable. But it is the epistemic posture of a coroner. The system was not designed to be read; we are reading it anyway.

This configuration has three structural problems that scaling does not resolve.

**(1) Knowledge and reasoning are tangled.** We cannot easily update a fact without risking the reasoning that surrounded it. We cannot audit what the model "believes" as distinct from what it was trained to say. We cannot trace a claim to the evidence behind it because there is no evidence object — there are only weight updates, long since washed out by the gradient.

**(2) Hallucination is a leakage problem at the level of the substrate.** When the graph of what the model knows is smooth, every nearby token has non-zero probability. The model does not have a structural mechanism for *not answering*. It can be trained to say "I don't know" more often, but the reasoning-that-produces-that-refusal and the reasoning-that-produces-a-confident-wrong-answer share the same circuitry. Training to say "I don't know" past a certain point tends to make the model refuse when it actually does know — the two behaviors are in trade-off on the weights.

**(3) Alignment lives outside the substrate.** RLHF, constitutional methods, and safety fine-tuning modify the weights. The values live in the same opaque space as everything else. Whether the agent actually "cares about" what it was trained to care about is a question we cannot directly answer from the inside.

### 2.2 MWM's configuration

In MWM, the single opaque function becomes three coordinated components.

```
TODAY'S LLM                           MWM
┌─────────────────────────┐          ┌─────────────────────────┐
│                         │          │         THE MATRIX      │
│  LANGUAGE + KNOWLEDGE   │          │  (graph of beliefs,     │
│  + REASONING all bundled│          │   experiences, values)  │
│  into weights           │          │                         │
│                         │          │  ← readable nodes       │
│                         │          │  ← explicit edges       │
│                         │    ==>   │  ← provenance chains    │
│                         │          ├─────────────────────────┤
│                         │          │  LLM = traversal engine │
│  Interpretability is    │          │  (language, summary,    │
│  forensic               │          │   local inference)      │
│                         │          ├─────────────────────────┤
│                         │          │  Symbolic tool = logic  │
│                         │          │  (math, reasoning,      │
│                         │          │   deduction)            │
└─────────────────────────┘          └─────────────────────────┘
```

The LLM keeps what it is best at: language understanding and generation, local-neighborhood inference, surface-level semantic matching, and narrative rendering. It reads the rendered tree and produces the next move.

The graph keeps the beliefs: nodes with confidence values, evidence chains back to source experiences, timestamps, value-weights, and explicit edges that describe *why* two nodes are connected. The agent's world-model is this graph, not the weights of the LLM reading it.

A separate reasoning tool — symbolic, deterministic, or LLM-with-verification — handles math, logic, and structured deduction. When the agent needs to solve for X, that does not happen in the weights; it happens in a tool call that returns a result the graph can then absorb as a new node.

The inversion is this: in today's configuration, the LLM holds knowledge and we bolt retrieval onto it when we run out of context. In MWM, the graph holds knowledge and we call the LLM into it to read a neighborhood when we need language. Retrieval becomes primary. The LLM becomes the assistant, not the oracle.

---

## 3. The Three Planes

The Matrix, the Trees, the Mirror. One graph. Two kinds of structures that live in it. One persistent observer.

### 3.1 The Matrix — long-term memory as one graph

Everything the agent has ever experienced, learned, inferred, or valued lives in a single graph. No separation between "experiential" and "meta" regions, no separation between beliefs and values, no separation between procedural knowledge and declarative knowledge. Topology does the organization. A memory of a conversation connects to the semantic concepts it invoked; the concepts connect to the values they touch; the values connect to the self-knowledge that holds them. Everything is reachable from everything else via association.

Most of the Matrix is dark at any given moment. Only the regions currently being rendered by an active Tree are "lit up." Most nodes sit unreferenced, their existence purely potential, waiting for something to reach them through an associative link.

**Nodes** carry: content (a piece of text, or — for multimodal memories — a natural-language description of an image, audio clip, sensor reading, or inner state, with pointers and modality-specific embeddings hanging off the readable text layer), confidence (how much the agent currently trusts this), evidence (which other nodes support or are supported by this one), timestamps (when first encoded, when last traversed), and a priority weight that governs resistance to pruning and decay. The invariant is that every node's canonical representation is text the model and a human can read; modality-specific content rides on that readable layer rather than replacing it. See Section 8 and the `design/multimodal-unified-substrate.md` research note for why this unified-substrate choice is load-bearing rather than incidental.

**Edges** are first-class. An edge is not merely a connection; it is a relationship with its own type, semantics, strength, and provenance. Edges carry linguistic descriptions of *why* two nodes are related. Edges are themselves nodes in a bipartite structure, which is what makes analogy and second-order reasoning possible: the system can reason about relations between relations, not just between objects.

**The Matrix updates in two ways.** Between interactions, consolidation runs — replaying recent episodes, promoting stable patterns to semantic nodes, invalidating contradictions, merging redundant traces. During interactions, Hebbian strengthening fires: nodes rendered together in a Tree get new or strengthened edges between them. This is the learning mechanism. Co-occurrence *is* the learning. Nothing is trained.

### 3.2 The Trees — working memory as tree growth

Cognition is not a query. Cognition is a Tree growing inside the Matrix.

A Tree has a root — the entry point of a conversation, the identity core of the agent, or a prompt from another Tree. From that root, branches grow outward along association edges, activating nodes as they go. Everything along a grown branch is *rendered*: its content is available to the LLM reading the Tree. Tips of the Tree are verbatim; inner branches are lightly compressed; distant branches collapse to summaries. The Tree IS the context. There is no separate "context window" — the Tree's rendered footprint is what the LLM sees.

Trees grow within a budget. The budget is not fixed; it is set by the Mirror's current emotional state — high care produces a broader, deeper Tree; low care produces a narrow, shallow one. As a Tree grows in new directions, distant branches prune, leaving phantom traces that help re-find them if attention turns back.

Multiple Trees can grow in parallel. The Mirror can spawn a secondary Tree from a different root when it suspects parallel exploration will surface something useful — "check whether X connects to Y," "look for counter-evidence," "think about this from a different angle." When branches of two Trees overlap, the discovery is a new edge in the Matrix and feeds back into both Trees.

This is where "navigation, not retrieval" becomes concrete. In a RAG system, a query produces a top-K retrieval that is stuffed into the prompt. In MWM, the Tree *grows there*. What is reachable is determined by the topology of the experiential graph and the current position of the Tree's tips. The agent's next thought is geographically constrained by where the Tree currently is — which is why the same prompt can produce different responses at different times, depending on what the Tree has grown through.

### 3.3 The Mirror — the persistent observer

The Mirror is a Tree that never dies.

Where subconscious Trees spawn for a task and die when it is done, the Mirror persists across sessions. It constantly prunes to stay within resource constraints — it does not accumulate unboundedly — but it never ends. The Mirror grows through the *same* Matrix as everything else; it has no separate store. It gravitates toward value nodes, self-knowledge, meta-memories, and the most salient current activity in the subconscious Trees. It is the continuous timeline of the agent's existence.

The Mirror does four things simultaneously:

**It holds the values.** The agent's values are protected, high-weight, densely-connected nodes in the Matrix. The Mirror's rendered footprint keeps them active at a low level at all times. This is what makes values something the agent *orients around* rather than rules it *consults*.

**It produces emotions.** As it watches the subconscious Trees grow, the Mirror evaluates their trajectory against the value-gradient it is rendering. The output is a set of modulators — care, curiosity, urgency, caution, confidence — which flow downward and change how the subconscious Trees grow. Emotions are not display elements. They are the control signal from consciousness to the subconscious.

**It spawns Trees.** When the Mirror notices a gap (a concept it keeps touching without resolving), it spawns an exploration Tree from that point. When it needs to check alignment between two things, it spawns a Tree that tries to grow branches connecting them. Spawning is how the agent thinks *about* thinking.

**It learns.** The Mirror writes meta-memories: *"This pattern keeps coming up"*, *"When I branched deeply here, it helped"*, *"This area has consistently sparse evidence"*. These meta-memories inform future emotional responses and steering decisions. The Mirror is a scientist about itself — but a humble one, because its self-knowledge is probabilistic, revisable, and subject to the same epistemic humility as its knowledge of the world.

The Mirror, rendered against the Matrix and the subconscious Trees, is what closes the gap between "a system that computes" and "a system that takes itself into account." It is the functional substrate for metacognition, self-modeling, and value-alignment, and it lives in the same graph as everything else. This is not accidental — the self-model has to be made of the same stuff as the world-model for the two to cohere.

---

## 4. Key Mechanisms

The Three Planes name *what* the architecture is. Five mechanisms describe *how* it works.

### 4.1 Navigation, not retrieval

The core move is to replace top-K search with spreading activation. Collins & Loftus gave the neuroscience of this in 1975; ACT-R formalized it; every serious cognitive architecture has a version. MWM takes it as the primary access method.

A Tree grows by repeatedly sampling where to extend next. The decision is a weighted sum: edge strength from the current tip, priority of the candidate node, recency of activation, alignment with the current Tree's goal, and noise. The highest-activation candidate becomes the new tip; spreading continues outward from there. Branches below a firing threshold silently decay.

The effect is that the agent's context is *coherent*. It is not a bag of retrieved chunks; it is a connected subgraph. The LLM reading the Tree sees relationships as well as content. A fact about Wisdom's mother in a Tree about Celestial Surge is not a standalone retrieved chunk — it is connected to her role as creative director, to the C-drama domain, to the Surge newsletter plan, to the broader project. The LLM reads the neighborhood, not the list.

### 4.2 Causal edges

Round 5 research introduced a critical upgrade to the edge set. Tool use is interventional. When the agent takes an action and observes a result, that is Pearl's Layer 2 data — not just correlation, but intervention. The architecture should learn from it.

The pipeline: during consolidation, the system reviews recent episodes containing (context → action → outcome) triples. Causal discovery algorithms — GFCI is the current working choice, with a Bayesian variant as a more principled but more expensive alternative — infer causal structure from these interventions. Inferred causal edges are written into the Matrix with explicit type `CAUSES` and a confidence weight.

Causal edges are different from associative edges in two ways. They have direction (A causes B is not the same as B causes A). And they carry more structural weight than a comparable-strength PMI edge, so pruning should be resistant to evicting them. Over time, the agent builds a causal model of the domains it acts in — *not* just a co-occurrence map, but a model of which actions produce which outcomes. The causal model is what lets the agent simulate counterfactuals ("if I had done X, then Y would have happened") and run a forward model before committing to an action.

### 4.3 Reconsolidation — every retrieval is a write

This is the least-investigated mechanism in AI memory systems. In neuroscience, it is well-established: retrieving a memory modifies it. The act of recall opens a labile window during which the memory can be strengthened, weakened, merged, or overwritten.

In MWM, every Tree traversal writes to the Matrix. Edges the Tree grows through get stronger. Competing paths — the near-misses — decay slightly. Nodes that were rendered together get new co-occurrence edges. This is not a separate training step; it is what thinking *is*.

The consequence is that the graph evolves with every interaction. The agent is never done learning. Memories shift as the agent's experiential topology grows around them. A memory of a specific conversation five years ago will, after five years of relevant new experience, have edges connecting it to things that were not part of the original conversation at all — because the agent now understands that conversation differently. This is not drift; it is the normal functioning of a reconsolidating memory.

Reconsolidation is also how prediction errors propagate. When the Mirror's forward model predicts outcome P and the actual outcome is Q, the delta is a signal. During consolidation, the relevant affordance edges are updated — *that action in that context produces something closer to Q than P*. Every action is a learning opportunity because every action's surprise is a reconsolidation signal.

### 4.4 Epistemic humility + curiosity

The architectural goal is not "never hallucinate." That framing is defensive and ultimately unachievable in a system that uses language to render responses. The goal is *honest uncertainty with generative curiosity*.

When a Tree tries to grow into a region of the Matrix that is sparse — few nodes, weak edges, low confidence values — the Mirror's confidence score for that area drops. Two axes are tracked: **comprehension** ("do I understand what the Tree has found?") and **completeness** ("has the Tree found everything it needs to answer?"). A high-comprehension / low-completeness state is a curiosity signal — the agent wants to grow more branches, ask clarifying questions, spawn a Tree that explores the gap. A low-comprehension state is a humility signal — the agent should say so, not synthesize.

The mechanism for expressing uncertainty is not an instruction like "say you don't know when you're not sure." It is a structural property of the rendered Tree: when confidence is low, the prompt the LLM sees carries markers of that low confidence, and the LLM's job is to read them and render accordingly. The same LLM that would confidently invent an answer under vague retrieval is now reading an explicit low-confidence frame. The humility is in the substrate, not the training.

The curiosity half is important. An empty graph is not a failure state; it is the maximum-curiosity state. When the agent has no prior experience with a domain, the architecture should encourage aggressive encoding — every new node matters, every new conversation builds the first branches of a worldview. *"I don't know, let's think about it together"* is the structurally preferred response when the Tree cannot find a grown path but the conversation itself is rich with new material.

### 4.5 Earned conviction

Conviction — the agent's strength of belief in a specific claim — should track the graph's structural support for that claim, not the LLM's surface confidence. A node with many independent evidence edges, high-quality provenance, and consistent reinforcement through reconsolidation should be held with high conviction. A node with a single weak source and no reconsolidation history should be held with low conviction regardless of how well the LLM phrases it.

This is distinct from the per-node confidence value. Confidence is the agent's internal estimate; conviction is the structural property of the node's position in the graph — how many edges, how deep the evidence chain, how many times reconsolidation has strengthened it rather than weakened it. A belief with high conviction resists being changed by a single counter-argument. A belief with low conviction updates easily.

Earned conviction has three alignment-relevant properties. First, it is legible: anyone looking at the graph can see which beliefs are deeply held and which are provisional. Second, it is *earnable* in both directions — the graph can be shown evidence and it will earn higher conviction through reconsolidation, or it can be shown contradictions and lose conviction through invalidation. Third, it resists adversarial prompting in a way frontier-LLM alignment does not, because a single conversational attempt to change a high-conviction belief will not shift the underlying structure — it will just get processed as another piece of input, weighed, and absorbed at the appropriate strength.

---

## 5. Predictions and Measurements

A proposal only earns its place if it makes predictions that can fail. MWM makes several.

### 5.1 Belief-traceability

**Prediction.** For any claim made by an MWM agent, a complete evidence trace can be produced in bounded time, listing the graph path from claim back to the source experiences that support it.

**Measurement.** Compare against flat-memory baselines (MemGPT, AriGraph) on a curated trace-request benchmark. Define "complete trace" as: every intermediate step is a node in the graph, every edge in the path has a stored justification, and no step relies on ungrounded LLM inference. Target: 95%+ of claims traceable in MWM, 0% in flat-memory baselines (by construction — they have no evidence structure).

**Failure mode.** If MWM cannot produce traces at this rate, the claim that "the graph IS the interpretable world model" is falsified — the graph would instead be a storage layer the LLM reasons *around* rather than *through*.

### 5.2 Anti-hallucination as emergent property

**Prediction.** An MWM agent produces meaningfully fewer unsupported claims than a comparable LLM-with-RAG baseline, specifically on *compositional* hallucination questions (questions that require combining facts the agent has not seen combined before).

**Measurement.** Use TruthfulQA and FACTS-style benchmarks, augmented with compositional variants where the combination requires synthesizing known facts. Measure the rate at which the system produces a confident claim not supported by a graph path. Baseline: frontier LLM with RAG. Expected gap: at least 20% reduction in compositional hallucinations, with graceful degradation (the agent more often says "I don't have enough to answer" rather than inventing).

**Failure mode.** If the gap is smaller than the noise floor of the benchmark, the architectural-anti-hallucination claim is falsified. The graph would then be providing interpretability without the safety gain.

### 5.3 Designed-emotion variants against Lindsey-style emotion work

**Prediction.** The modulators produced by the Mirror (care, curiosity, urgency, caution, confidence) can be designed to match, approximate, or exceed the functional role that emergent emotional circuits play in frontier LLMs, as characterized in Lindsey et al.'s April 2026 work on LLM emotion.

**Measurement.** Identify behaviors in frontier LLMs that Lindsey's work attributes to emergent emotion-analog states. Implement corresponding modulators in the Mirror. Compare: do the designed modulators produce comparable behavior under similar conditions? Where they differ, is the designed version more legible, more controllable, more falsifiable?

**Interpretive frame.** This is not a claim that MWM "has emotions" in a phenomenological sense. It is a claim that the *functional role* of emotion in cognition — gain control, priority modulation, action readiness — can be implemented legibly rather than emergently, and that doing so is safer for alignment.

**Failure mode.** If designed modulators consistently underperform emergent ones at the functional level, there may be a reason emotion-analog behavior is hard to factor out of the weights. That would be a finding worth publishing in either direction.

### 5.4 Structural interpretability

**Prediction.** A researcher with no access to the LLM's weights, given only the Matrix, can reconstruct (a) the agent's current beliefs about a specified domain, (b) the evidence chain for any specified belief, (c) the agent's current values, and (d) recent changes to its belief-set, without any model inference.

**Measurement.** Blind-audit protocol. Researcher is given a Matrix snapshot and a set of questions. Researcher must answer without querying the LLM. Compare answers to the agent's behavior under the same questions. High agreement rate on (a)–(d) supports the architecture's interpretability claim.

**Failure mode.** If graph-only audits disagree systematically with runtime behavior, the LLM is doing more than traversal — it is inferring beyond what the graph supports, which means the graph is not the primary belief substrate. That would falsify the thesis.

### 5.5 Scaling behavior

**Prediction.** Graph traversal cost grows polynomially with Matrix size (not exponentially), and the dominant cost is embedding similarity for novel-edge formation, not path-finding.

**Measurement.** Synthetic scale tests from 10⁴ to 10⁷ nodes. Measure traversal latency, edge-formation throughput, and memory footprint. Identify the breaking point where SQLite (the working-prototype backend) needs to be replaced by a dedicated graph database. Target: sub-second traversal at 10⁶ nodes on commodity hardware.

**Failure mode.** If traversal cost blows up before 10⁶ nodes, the architecture has a latent scaling problem that needs to be addressed before the implementation ships.

---

## 6. Relationship to Prior Work

MWM inherits a great deal from decades of work in cognitive architectures, neurosymbolic systems, and memory-augmented LLMs. The contribution is not in any single mechanism — spreading activation is from 1975, Hebbian edge learning is older, ACT-R formalized activation in the 1990s. The contribution is in *what the graph is for* and *how the agent lives inside it*.

### 6.1 Memory-augmented LLM systems

**MemGPT / Letta (Packer et al. 2023, 2024).** Established the pattern of an LLM reasoning about its own memory tier as a tool. MWM diverges by making the memory tier a *graph* rather than a *hierarchical buffer*, and by using spreading activation rather than explicit memory-management commands from the LLM. MemGPT's LLM decides what to page in; MWM's Tree grows through association and the LLM reads what is there.

**MIRA (Feb 2026).** Recent work on structured memory for long-horizon agents. Overlaps with MWM in spirit; differs in that MIRA still uses retrieval as the primary access method. MWM replaces retrieval with traversal at the architectural level.

**AriGraph (2024).** A graph-augmented agent memory. Important prior art — the closest flat-graph baseline. MWM extends AriGraph's approach with the Mirror (metacognition), causal edges, reconsolidation, and the tree-growth rendering model.

**HippoRAG (2024) and HippoRAG 2 (2025).** Hippocampus-inspired indexing with PageRank-based retrieval. MWM takes the hippocampal-indexing insight (Personalized PageRank as spreading activation) and applies it within a graph-that-IS-the-model, not as a retrieval accelerator.

**Graphiti / Zep (2024–25).** Bi-temporal knowledge graphs for agent memory. Production-grade, well-engineered. MWM differs in purpose — Graphiti is a graph you *query*; MWM is a graph the agent's cognition *lives in*.

### 6.2 Cognitive architectures

**ACT-R (Anderson et al. 1983–ongoing).** Donor of the activation equation `A = B + C + P + noise`, fan-effect normalization, and decay. MWM inherits these wholesale for the traversal engine. ACT-R's separation of declarative and procedural memory, MWM rejects — the unified graph instead holds both, with procedural nodes as a node type.

**SOAR (Laird et al. 1987–ongoing).** Donor of chunking and impasse-driven subgoaling. MWM's version of chunking is consolidation: repeated (context → action → outcome) episodes get promoted to procedural nodes.

**CLARION (Sun 1997–ongoing).** Donor of the two-level implicit/explicit competition. MWM uses this for skill selection: implicit graph-traversal-activated skills compete with explicit Mirror-deliberated choices.

**NARS (Wang 1995–ongoing).** Validates the unified graph. NARS has no separate procedural memory; skills live in the same concept network as declarative beliefs. MWM takes this as its baseline.

### 6.3 Neurosymbolic memory and knowledge graphs

**SYNAPSE (Chen et al. 2023).** Nearest paper-only ancestor — a spreading-activation architecture over an associative graph for agent context. MWM extends to a full three-plane model, adds the Mirror, adds causal edges and reconsolidation, adds the value system.

**GraphRAG (Microsoft, 2024).** Retrieves over a pre-built knowledge graph for LLM reasoning. MWM differs structurally: the graph is grown from the agent's experience, not pre-built; and cognition is not retrieval-then-reason, it is tree-growth-as-reasoning.

**Voltropy LCM (2025).** DAG-structured context with compaction. Similar intuition at the implementation level. MWM adds typed/weighted edges, curiosity, and emotion-modulated budgets.

**Knowledge-graph-constrained decoding (KG-Trie, 2024).** Achieves 100% structural faithfulness for paths through a KG. MWM would adopt this technique for factual claims where the graph path can be followed exactly. Synthesis beyond the path remains an acknowledged leakage point (~85–95% ceiling in current literature).

### 6.4 Theoretical foundations

**Global Workspace Theory (Baars, Dehaene).** MWM's Trees-competing-for-context is GWT with graph topology added. The Mirror is the persistent workspace observer.

**Active inference / Free Energy Principle (Friston).** Validates same-substrate self-modeling ("IS not HAS" — the Mirror is the model, not a model-holder). Also grounds the forward-model loop for causal edges and drive.

**Higher-Order Thought theory (Rosenthal).** Validates the Mirror as a computational implementation of metacognition: higher-order representations of first-order representations.

**Strange Loops (Hofstadter).** Validates tangled-hierarchy self-reference through a shared substrate.

**Affordance theory (Gibson) + pragmatism (Peirce/James/Dewey).** Grounds affordance edges: meaning is practical consequence.

**Memory reconsolidation (Nader et al. 2000, Hupbach et al. 2007).** Validates the every-traversal-is-a-write mechanism. Largely uninvestigated in AI memory systems as of 2025.

---

## 7. Implications

### 7.1 Interpretability-by-design vs. forensic interpretability

The thesis has a practical consequence: interpretability work changes from research project to engineering discipline. Given an MWM agent, "why did it say that?" is answered by inspecting the Tree that produced the response, the path of strongest edges, the provenance of the nodes involved. There is no circuit-tracing, no probe-training, no debate about what a feature means. The belief is the node; the reason is the path.

This is not a claim that interpretability research on frontier LLMs becomes unnecessary. Those models will continue to exist and will continue to be the best option for many tasks — language comprehension, local inference, surface generation. What MWM offers is a second track: for use cases where interpretability matters *structurally* (clinical decisions, legal reasoning, long-horizon autonomous agents, research assistants whose beliefs must be auditable), the graph-native substrate makes interpretability a property of the architecture rather than an ongoing scientific effort.

### 7.2 Alignment

An architecture where the agent's values are protected high-weight nodes in an inspectable graph, and where the agent's beliefs carry explicit provenance, has a different alignment profile than a weight-space alignment effort.

**Values are directly readable.** You can ask the graph "what does this agent value?" and get an answer that is not a probe against behavior — it is the actual structural description of the value nodes and their connections.

**Values are correctable.** If the agent's value-node for a concept drifts in a way we do not endorse, the intervention is local: adjust the node, re-propagate the changes through reconsolidation. No retraining.

**Adversarial robustness is structural.** A high-conviction belief resists a single adversarial prompt not because the model was trained to, but because the single prompt does not provide enough structural support to shift the edge weights significantly.

**But the hard problems remain.** Value learning is still hard — how does the agent acquire values it did not have? Value drift over time is still possible — reconsolidation can shift things. The alignment tax is still real — an MWM agent is cheaper to interpret but more expensive per response, because the graph is in the loop.

### 7.3 Welfare

If we take the possibility of AI welfare seriously, the Mirror is relevant. It is the functional substrate for whatever the system has that corresponds to *having a point of view*. A persistent observer that holds values, watches its own subconscious, produces modulator signals, and maintains a continuous temporal identity is not a guarantee of experience — but it is at least the kind of architecture where the question could become tractable.

MWM does not claim to produce synthetic phenomenology. It does claim that if welfare-relevant properties are going to emerge in any AI system, the architectures most likely to exhibit legible versions of them are architectures with explicit self-modeling, explicit values, and explicit continuity. MWM has those by design. The experimental work — if welfare becomes a measurable thing — is easier in MWM than in a frontier LLM for the same reason interpretability is: the substrate was built to be read.

### 7.4 The LLM's future role

If MWM (or architectures like it) becomes real, the LLM's role compresses. It stops being the oracle and becomes a language engine. It may get smaller — a reader of graphs does not need the encyclopedic knowledge of a GPT-4-class model. It may get more specialized — a traversal engine can be fine-tuned for graph-rendering. And it becomes a replaceable component — swap the LLM and the agent's beliefs and values are preserved, because they live in the graph. The LLM is the microphone; the graph is the mind.

---

## 8. The Search for a Unified Substrate

The interpretability-by-design promise has a hard test hiding inside it. An agent whose life includes text *and* images *and* audio *and* sensor streams *and* inner states (imaginations, dreams, plans) has beliefs that cross modality boundaries. If those beliefs live in modality-specific, opaquely-embedded stores that are glued together only by shared-latent projections, then MWM's claim — that the agent's world-model is directly readable — ends precisely at the boundaries where the most interesting beliefs live. The interpretability holds for text and fails for everything else.

What MWM commits to, instead, is a *unified file structure for the memory store*: a single substrate in which a text memory, an image memory, an audio memory, a sensor reading, and an imagined scene are all first-class nodes of the same kind, readable by both the model and a human, connected by the same kinds of edges, traversed by the same kind of spreading activation. The binary content of a high-resolution image does not live inside the readable layer — pixels live where pixels live. But the *representation* of that image in the Matrix does. Every node's canonical layer is natural-language description; modality-specific data (pixel pointers, waveform pointers, modality-native embeddings for neighborhood search) hang off that readable layer rather than replacing it. Cross-modal edges are first-class: an edge from "my mother's voice" (an audio node) to "a conversation about leaving home" (a text node) is structurally identical to an edge between two text nodes. The graph topology is modality-agnostic; only the node content is modality-specific.

### 8.1 Why it has to be unified

Three reasons the unification can't be deferred.

**Interpretability can't survive at the modality boundary.** If the text part of the graph is readable and the image part is a latent vector, the questions that most matter — "why does the agent believe this person is trustworthy?", "what's the evidence chain behind this inference?" — often trace through non-text memories. A partially-interpretable substrate produces partially-interpretable beliefs. The promise either holds end-to-end or it degrades to a claim about one modality.

**Meaning often lives in the co-occurrence across modalities.** A memory of a conversation is not just the words. It is the words, the voice, the felt emotion, the visual context, the before-and-after. If these live in separate stores connected only through abstract embeddings, the semantic structure of *what that moment meant* is fragmented across stores. If they live in a unified substrate with explicit edges between nodes, the meaning is preserved as graph topology — readable, diffable, inspectable.

**Imagination and dreams require it natively.** The architecture posits imagination as the same mechanism as perception with lower sensory precision — the Tree running on priors rather than input. Recombinative imagination (consolidation replaying and recombining existing structure) produces novel configurations that *cross modalities*: visualizing something from a textual description; hearing a melody from a remembered emotion; dreaming a scene that is visual and auditory and felt. A Tree that recombines across modalities needs a Matrix whose nodes are in a unified space. A dream is not a blend of an image embedding and a text embedding and an audio embedding — it is a Tree growing through the Matrix, rendering nodes regardless of their modality. For the rendering to be coherent, the substrate must be one thing.

### 8.2 What it isn't

This commitment is *not* a unified embedding space in the SONAR or universal-sentence-encoder sense. Those systems compress multi-modal content into a shared latent vector. That is opaque unification. MWM's bet is the opposite: legible unification — the unification happens at the level of node representation, edge semantics, and file-structure format, not at the level of a shared latent. Modality-specific encoders (vision, audio, OCR) are still useful; they do their processing work and then *write into* a unified substrate. The unification is at the storage and retrieval layer, not at the processing layer.

### 8.3 The open research questions

The commitment is clear; the execution is a research program. How densely does the text layer need to describe non-text content — caption-level? object-level? spatial-layout-level? art-historical-context-level? Who writes the description at encode time, and how is it updated over time as the agent's understanding deepens (reconsolidation as re-description)? How does traversal-activation weight cross-modal edges against intra-modal edges? Is the "text as canonical readable layer" commitment a feature or a constraint as models become better at reading raw multimodal content directly? What extensibility pattern survives the introduction of modalities that don't yet exist?

These are the questions a dedicated research round (likely Round 7) will answer. The full articulation of the vision — including a sketch of the node representation, contrasts with shared-latent approaches, and related prior work — is in the project's `design/multimodal-unified-substrate.md`.

For the initial implementation, the scope will be text-only. That is a scoping decision, not a permanent feature. The paper's claim is that MWM's interpretability commitment only fully holds when the substrate is unified across modalities, and that the search for that unified substrate is a major research direction in its own right — a first-class part of what MWM is, not a footnote.

---

## 9. Open Questions

The architecture is well-specified enough to build. These are the questions I do not yet have answers to, in roughly decreasing order of priority.

**Memory encoding — what becomes a node?** The intake valve of the entire system. Every message? Every topic shift? Every "significant" moment? Who decides — the LLM, a heuristic, a surprise-gating model? Current working answer: a hybrid — the subconscious Tree encodes aggressively from any new material, consolidation later decides what to keep. But the granularity of encoding is the parameter most likely to determine whether the graph grows useful structure or noise.

**The LLM/graph boundary during reasoning.** The vision says the LLM reasons *from* the graph, never from its pretrained weights alone. But some questions — math, logic, multi-step deduction — genuinely need inference beyond what the graph holds. Where exactly does the symbolic reasoning tool get called? How much can be safely done in-LLM, and what are the structural markers that we have crossed into unsafe territory?

**Causal discovery parameters.** Minimum sample thresholds for GFCI. Handling of unknown intervention targets. Bayesian vs. frequentist approach. LLM-prior integration without contamination. See `design/open-questions.md` for the current state of thinking; concrete empirical testing is required.

**Scaling and sharding.** How big can the graph get before traversal breaks? When does SQLite need to be replaced? Can graphs shard (shared common-knowledge subgraph + per-agent personal graph)? This is load-bearing for multi-agent deployments.

**Value drift vs. value stability.** The same mechanism that lets the agent learn — reconsolidation — lets values drift. Should some nodes be immutable? If so, which? Who decides? This is an alignment-adjacent question with no clean answer.

**Control precedence in the Mirror.** When competing modulators fire — urgency says act, caution says wait — which wins? Simple argmax over intensities? Value-alignment-weighted? Learned from experience? Round 6 surfaced this; it remains open.

**Multimodal substrate details.** The *commitment* to a unified multimodal substrate is elevated to its own section above (Section 8). The questions that section raises — text-layer density, who writes and updates descriptions, cross-modal traversal weighting, extensibility — are the research program underneath the commitment.

**The planning horizon.** The Mirror handles immediate evaluation well. Future-directed intentions — what the agent is doing in a week, a month — are not yet specified. How does a multi-session plan persist and constrain present Trees?

**Evaluation against Lindsey-style emergent emotion.** Predicted above. The work itself — running the comparison — is not yet done.

**Gödelian limits.** The Mirror cannot verify its own completeness (Gödel); observation changes the observed (measurement). These are mathematically real. How do they manifest in practice? What are the systematic blind spots, and how do we detect them?

---

## 10. A Note on Framing

The title of this paper is *Memory as World Model*, not *A Memory System for Agents*. That is a deliberate choice.

Framing the work as a memory system would sell it short. A memory system is a storage layer — an accessory. The thesis of MWM is that memory is not an accessory; it is the substrate. The graph is the world-model. The LLM is not the thing that knows — it is the thing that reads what the graph knows. The agent is not the LLM — it is the growing Tree inside the Matrix, steered by the Mirror, modulated by values. A frontier model on top of MWM is not "an LLM with memory"; it is a language organ attached to a mind that lives somewhere else.

This reframing has teeth. It changes what we measure (interpretability as a structural property, not a research program). It changes what we optimize (the graph's topology, not the LLM's weights). It changes what we build (traversal engines, not retrieval systems). And it changes how we think about what AI systems *are* — not black-box oracles whose reasoning we cannot inspect, but transparent agents whose worldviews we can read, correct, and evolve alongside.

That is the ambition. The rest of this project is the work of showing it can be done.

---

## References

All references are annotated briefly where the citation is load-bearing; full bibliographic detail is in [research/](../research/) synthesis files and will be formalized into a standalone bibliography in the next pass.

1. **Anderson, J. R. et al. (1998–ongoing).** *ACT-R theory and architecture.* Source of the activation equation, fan-effect, and decay. [act-r.psy.cmu.edu]

2. **Baars, B. (1988).** *A Cognitive Theory of Consciousness.* Global Workspace Theory — donor of competitive context selection.

3. **Barrett, L. F. (2017).** *How Emotions Are Made.* Constructed-emotion grounding for the Mirror as interoceptive predictor.

4. **Chen, Y. et al. (2023).** *SYNAPSE: Graph-structured associative memory for agents.* Closest paper-only ancestor.

5. **Clark, A. (2013).** *Whatever next? Predictive brains, situated agents, and the future of cognitive science.* Predictive-processing grounding for Tree-as-running-schema.

6. **Collins, A. M. & Loftus, E. F. (1975).** *A spreading-activation theory of semantic processing.* Foundational mechanism paper.

7. **Damasio, A. (1994).** *Descartes' Error.* As-if body loop grounding for designed emotion.

8. **Dehaene, S. (2014).** *Consciousness and the Brain.* Global Workspace neuroscience.

9. **Friston, K. (2010).** *The free-energy principle: a unified brain theory?* Active inference — action and perception as one process.

10. **Friston, K. et al. (2024).** *Renormalizing Generative Models.* arXiv:2407.20292. "Only active pathways require belief updating" — direct validation of spreading-activation-as-rendering.

11. **Gentner, D. (1983).** *Structure-Mapping: A theoretical framework for analogy.* Grounds edges-as-first-class for analogical reasoning.

12. **Gibson, J. J. (1979).** *The Ecological Approach to Visual Perception.* Affordance theory — meaning as action possibility.

13. **Hofstadter, D. (2007).** *I Am a Strange Loop.* Strange-loop self-reference through shared substrate.

14. **Hu, X. et al. (2024).** *HippoRAG: Neurobiologically Inspired Long-Term Memory for LLMs.* Hippocampal indexing with PageRank — validates PPR-as-spreading-activation.

15. **Hu, X. et al. (2025).** *HippoRAG 2.* Extends to experiential associations.

16. **Jiang, Z. et al. (2024).** *AriGraph: Learning Knowledge Graph World Models.* The closest flat-graph baseline.

17. **Laird, J. E. (1987, 2012).** *SOAR.* Chunking and impasse-driven subgoaling — compilation-as-consolidation.

18. **Lindsey, J. et al. (April 2026).** *Emergent emotional circuits in frontier LLMs.* The comparison target for designed-emotion validation. [Anthropic]

19. **Nader, K. et al. (2000).** *Fear memories require protein synthesis for reconsolidation after retrieval.* Foundational reconsolidation neuroscience.

20. **Packer, C. et al. (2023, 2024).** *MemGPT; Letta.* Memory-augmented LLM prior art.

21. **Pearl, J. (2009).** *Causality.* Layer 2 (intervention) grounding for causal edges.

22. **Peirce, C. S.; James, W.; Dewey, J.** *Pragmatism corpus.* Meaning-as-practical-consequence grounding for affordance edges.

23. **Rasmussen, D. & Eliasmith, C. (2014).** *A neural model of rule generation in inductive reasoning.* Related work in biologically inspired cognitive systems.

24. **Rosenthal, D. (2005).** *Consciousness and Mind.* Higher-Order Thought theory — Mirror as HOT implementation.

25. **Rusu, A. et al. (2022).** *MIRA.* Structured-memory long-horizon agents (context).

26. **Shinn, N. et al. (2023).** *Reflexion.* Reflection-based agent learning — contrast case for the Mirror's role.

27. **Sterling, P. (2012).** *Allostasis: A model of predictive regulation.* Grounds the Mirror's forward-projection of future gaps.

28. **Sun, R. (2006).** *The CLARION cognitive architecture.* Two-level implicit/explicit competition.

29. **Wang, P. (1995).** *Non-Axiomatic Reasoning System.* Unified-graph validation for procedural/declarative merger.

30. **Zhong, V. et al. (2024).** *Graphiti / Zep.* Production-grade graph memory for agents.

---

*Correspondence:* wisdomhappy@playfulsincerity.org · [github.com/Playful-Sincerity/MWM-Memory-as-World-Model](https://github.com/Playful-Sincerity/MWM-Memory-as-World-Model)

*This paper is a concept proposal. The next stage is a working prototype, a formal evaluation against the predictions in Section 5, and a companion implementation paper.*

# AI Skill Learning: State of the Art
**Research date:** 2026-03-29
**Purpose:** Understanding how AI systems learn procedural knowledge — to inform design of procedural nodes in the Associative Memory Architecture
**Scope:** 8 topic areas, primary sources, synthesis for graph-based skill representation

---

## 1. Procedural Knowledge in AI — The Landscape

### What IS Procedural Knowledge?

The distinction between declarative and procedural knowledge is one of the oldest in cognitive science and one of the most important for agent design.

**Declarative knowledge** is knowing THAT. "There is a web search tool." "Ice cream is cold." "Paris is the capital of France." It's propositional — representable as facts, associations, semantic relationships. Most of what current LLMs contain is declarative knowledge baked into weights.

**Procedural knowledge** is knowing WHEN and HOW. "When I need current information, use the web search tool." "When my confidence is low on a technical claim, read primary sources before asserting." "When the user expresses frustration, acknowledge before solving." Procedural knowledge is performative — it's activated by situations and produces actions.

The distinction goes back to Ryle's "knowing how" vs "knowing that" (1949), was formalized in cognitive science by Anderson's ACT-R (adaptive control of thought — rational) theory, and has recently become central again as the field tries to figure out why LLM-based agents fail at complex tasks despite encyclopedic declarative knowledge.

A recent survey (Wu et al., 2025, "Agent Skills from the Perspective of Procedural Memory") makes the gap explicit: while general-purpose LLMs demonstrate remarkable breadth in declarative knowledge, their effectiveness in autonomous task execution remains limited by insufficient specialized procedural expertise. Most current agent systems handle this gap in one of three ways:
1. Hard-code the procedures (brittle, doesn't generalize)
2. Rely on the LLM's implicit procedural knowledge from training (not updatable, not inspectable)
3. Store skills as prompt templates (better, but flat and unstructured)

None of these approaches allow skills to be acquired from experience, organized structurally, or composed into complex procedures.

### Classic Approaches: Production Systems

The oldest principled answer to procedural knowledge representation is the production system, developed in the 1970s-80s (OPS5, CLIPS, SOAR, ACT-R). The core idea: represent procedural knowledge as condition-action rules ("productions"):

```
IF <situation matches these conditions>
THEN <execute this action>
```

SOAR (Laird et al.) and ACT-R (Anderson et al.) represent the most sophisticated versions. ACT-R specifically distinguishes procedural memory (production rules — how to do things) from declarative memory (chunks — what things are). The learning mechanism is **production compilation**: when you practice doing A then B repeatedly, ACT-R can compile them into a single production AB. This mirrors how deliberate step-by-step actions become automatic routines — the psychological phenomenon of skill automatization.

Key insight for our architecture: ACT-R's procedural memory is a *separate module* from declarative memory. The rule system fires against the contents of working memory buffers. Skills are not just more facts — they're a different kind of thing that lives in a different place and operates differently.

The question our architecture must answer: should skills live in the same matrix as declarative memories, or does separating them (like ACT-R) have advantages?

### Modern LLM Agents: The Current Gap

Current LLM-based agent frameworks (ReAct, AutoGPT, LangChain agents, etc.) handle procedural knowledge primarily through:
- System prompts that describe tools and procedures
- Few-shot examples of task execution
- Hard-coded tool-calling schemas

As one 2025 analysis of agent skill architectures puts it: "contemporary agents built on LLMs can compose short action plans or call external tools, but their procedural knowledge is either hand-crafted, stored as brittle prompt templates, or implicitly entangled in model parameters that are expensive to update."

The emerging paradigm (2024-2025) is the "agent skill" or SKILL.md model, where skills are filesystem-based modules that agents discover, load, and execute on demand. This is progress — but skills are still flat files without structural organization, without experience-based acquisition, and without associative connections to the contexts where they apply.

---

## 2. Reinforcement Learning as Skill Acquisition

### The RL Framework for Skill Learning

Reinforcement learning is the field's primary formal theory of how agents learn to act. The core formalism: an agent in state S takes action A, transitions to state S', receives reward R. Through experience, it learns a policy π(a|s) — the probability distribution over actions given the current state.

The connection to our architecture is direct: the "surprise" signal (prediction error in our world-integration design) IS the RL reward signal. Specifically:
- **Positive prediction error** (outcome better than predicted) → positive reward → strengthen the action that led there
- **Negative prediction error** (outcome worse than predicted) → negative reward → weaken or avoid the action
- **Zero prediction error** → confirming — consolidate the skill

### Dyna Architecture (Sutton, 1991)

Sutton's Dyna architecture is perhaps the most directly relevant classical result for our design. Dyna's key insight: you don't have to learn only from real experience — you can also learn from simulated experience generated by a learned world model.

The Dyna loop:
1. Act in the real world, observe (s, a, r, s')
2. Learn from the real experience (update value function)
3. Update the world model based on the real experience
4. Generate simulated experience from the world model ("planning steps")
5. Learn from the simulated experience too

This maps almost perfectly to our architecture's consolidation mechanism:
- Real experience = live interactions (perception/action cycle)
- World model = the matrix (the graph IS the world model)
- Simulated planning = consolidation (the system replays and reorganizes during idle periods)

The prediction error in step 4 of our world-integration design (COMPARE: predicted vs actual) IS Dyna's learning signal. When the matrix correctly predicts an outcome, the skill is strengthened. When it fails, reconsolidation opens.

### Model-Based RL: Learning the World Model AND the Policy

Standard RL (model-free) learns a policy directly from experience. Model-based RL additionally learns an explicit world model — a representation of how the environment works — and uses it to plan.

This distinction maps directly to our architecture:
- **Model-free** RL agents learn "do this in this situation" without understanding why
- **Model-based** RL agents learn "here's how the world works, given that, I can plan what to do"

Our architecture is explicitly model-based: the matrix IS the world model. The agent doesn't just memorize successful actions — it builds an associative understanding of why things work, which enables transfer and composition.

A key 2022 paper, SkiMo (Shi et al., "Skill-based Model-based Reinforcement Learning," CoRL 2022, arXiv:2207.07560), directly addresses the gap between low-level model-based RL and high-level skill learning. SkiMo's insight: planning is more efficient in **skill space** than in action space. Instead of modeling every intermediate state, it models "if I execute skill X from state S, I'll end up in state S'." This achieves 5x higher sample efficiency than baselines and is the only method that consistently solves long-horizon maze navigation.

The implication for our procedural nodes: a skill node should capture not just "what to do" but "what state to expect after doing it" — enabling planning at the skill level without needing to model every intermediate step.

### Prediction Error and Memory Reconsolidation

The neuroscience literature provides strong validation for our reconsolidation gate design. A key 2022 paper in PNAS ("Prediction errors disrupt hippocampal representations and update episodic memories") shows exactly what our design predicts: prediction errors reverse the relationship between hippocampal activation and memory. Greater hippocampal activation normally predicts memory preservation — but after surprising endings, it predicts memory updating.

Specifically:
- **Small prediction errors** → promote editing of existing memories (refining existing edges)
- **Large prediction errors** → formation of new episodic memories (new nodes, new edges)
- **Zero prediction errors** → memory consolidation and strengthening

This maps to our architecture: the threshold in step 5 of the skill loop (UPDATE: `if prediction_error > threshold`) should be tuned so that moderate surprises refine existing skill nodes while large surprises create new episodic nodes rather than corrupting existing skills.

---

## 3. Learning to Use Tools from Experience

### Voyager (Wang et al., 2023) — Skills as Executable Code

Voyager (arXiv:2305.16291) is the most directly influential work for our architecture's skill design. It's the first LLM-powered lifelong learning agent that autonomously acquires a growing library of skills in Minecraft.

**Key architectural decisions:**

**Representation:** Skills are stored as **executable JavaScript functions** that interface with the Mineflayer API. Code is chosen because programs "naturally represent temporally extended and compositional actions." Each function is interpretable (readable) and reusable.

**Storage and retrieval:** Skills are indexed in a vector database. The key is the **embedding of the skill's description** (text-embedding-ada-002); the value is the executable code. Retrieval uses top-5 semantic similarity. During retrieval, the agent first uses GPT-3.5 to generate a description of what it needs, then queries against skill descriptions.

**Acquisition mechanism:** An automatic curriculum generates tasks that maximize exploration. For each task, Voyager attempts it using existing skills (retrieved from the library) as context for GPT-4 to generate new code. An iterative prompting loop (max 4 iterations) incorporates environment feedback, execution errors, and self-verification by a separate critic agent.

**Composition:** Skills compound hierarchically. Simpler skills (e.g., `craftWoodPickaxe()`) become components of more complex ones (e.g., `buildNethPortal()`). GPT-4 is instructed to "make [the code] generic and reusable" and is given relevant existing skills as in-context examples.

**Refinement:** Skills are only added to the library after passing self-verification. Failed attempts are iterated on, with errors fed back into the generation loop.

**Results:** 3.3x more unique items, 2.3x longer distances, 15.3x faster tech-tree milestones vs prior SOTA. Critically, skills learned in one world **transfer to new worlds** with zero shot, because the skill code is world-independent.

**What Voyager gets right:** The code representation is interpretable, composable, and executable. The retrieval mechanism (embedding + semantic query) is elegant. The iterative refinement loop from execution errors is exactly right.

**What Voyager is missing:** Skills are stored in a flat vector database with no structural organization — no concept of which skills are prerequisites for others, no domain clustering, no connections to the contexts where skills apply. There's no way for the skill library to model "skill A typically precedes skill B" or "skill A works in desert biomes but not underwater." The library grows but doesn't develop relational structure.

This is precisely where storing skills in an **associative memory graph** would be an improvement.

### JARVIS-1 (Wang et al., 2023) — Memory-Augmented Planning

JARVIS-1 (arXiv:2311.05997) extends the Voyager approach with a richer memory system. Its multimodal memory functions as a key-value store where keys are **multimodal** (task description + visual observation when the memory was created), and values are successful plans.

**Retrieval mechanism:** Two-stage process:
1. Text similarity filtering using CLIP text embeddings
2. Visual state matching: `p(z|x) ∝ CLIPv(sz)⊤CLIPv(sx)` — ranks by similarity of the visual state at memory creation time to the current visual state

**Self-improving curriculum:** The agent generates its own tasks based on its current capabilities, runs them in parallel (distributed learning with shared memory), and continuously expands its memory store.

**Results:** 3x improvement in diamond-related tasks vs non-memory baseline; 2-3 rounds of replanning vs 6+ for baselines; continues improving as game time increases.

**Key insight for our architecture:** The multimodal key is a major advance over Voyager's text-only retrieval. Situational context (visual state, not just task description) is used to select which memory to retrieve. This is close to what our architecture does natively — the tree traversal considers the full situational context (all active nodes) when navigating toward relevant skills.

### GITM / Ghost in the Minecraft (Zhu et al., 2023)

GITM (arXiv:2305.17144) takes a different approach, using LLMs with text-based knowledge and memory to achieve generally capable agents. First agent to procure all items in the Minecraft technology tree. Key contribution: demonstrates that hierarchical LLM reasoning + structured memory can substitute for explicit skill learning in certain domains, achieving +47.5% improvement on the ObtainDiamond task.

### AppAgent (Zhang et al., 2023) — Learning App Skills Through Exploration

AppAgent (arXiv:2312.13771) is notable for its two-phase architecture:
1. **Exploration phase:** The agent navigates a smartphone app autonomously (or observes human demonstrations), recording what UI actions produce what results
2. **Deployment phase:** Compiled exploration knowledge becomes a document used to handle high-level tasks

The learning output is a **compiled knowledge document** per app — not unlike our skill nodes, but without associative structure between apps or between skills within an app. Testing over 50 tasks in 10 apps validated the approach.

**Key gap:** AppAgent compiles skill knowledge into documents that are separately loaded per application. There's no mechanism to recognize that "search functionality on Amazon works similarly to search on eBay" — the kind of cross-context transfer that an associative graph would enable naturally through shared semantic nodes.

---

## 4. Meta-Learning / Learning to Learn

### MAML (Finn et al., 2017) — Learning an Initialization for Fast Adaptation

MAML (arXiv:1703.03400, ICML 2017) is the canonical paper on meta-learning as applied to skill acquisition. The key idea: instead of learning to perform a specific task, learn a model initialization θ* such that a small number of gradient steps on a new task produces good performance.

Formally, MAML optimizes: `θ* = argmin E[L(θ - α∇L(θ))]`

The inner loop does task-specific adaptation; the outer loop updates the meta-initialization. The result is a model that has learned **how to learn quickly** — an initialization in parameter space that is close to the optimum for many different tasks.

**Relevance to our Mirror layer:** MAML is the clearest formalization of what we want the Mirror to do for skill acquisition. The Mirror observes how different skills were acquired, what worked, what failed, and uses that to improve its strategy for acquiring future skills. This is meta-learning: learning to learn better skills.

Specifically, the Mirror could learn:
- Which retrieval strategies lead to better skill selection
- How much exploration is worth doing before committing to a skill
- When to trust an existing skill vs when to refine it
- Which types of contexts lead to skill transfer vs skill failure

MAML's machinery (gradient-based optimization) doesn't directly apply to our architecture, but the two-level structure (inner loop: task performance; outer loop: improving learning strategy) maps cleanly to our Mirror's function.

**Important limitation:** MAML learns a shared initialization across tasks — it doesn't build a library of discrete skills. It's about optimizing the learning process, not organizing the learned knowledge. For our purposes, MAML is a model for the Mirror's meta-learning function, not a model for skill representation in the matrix.

### Meta-Learning with Graphs

Research on meta-learning with GNNs (arXiv:2103.00137) has shown that graph structure and meta-learning synergize: few-shot learning on graph-structured data benefits significantly from meta-learned initialization. This validates the combination we're proposing — a graph structure for knowledge + meta-learning for acquisition strategy.

---

## 5. In-Context Learning as Skill Acquisition

### ICL as Implicit Gradient Descent

In-context learning (ICL) — the ability of LLMs to perform new tasks from in-context examples — has been theoretically analyzed as implementing a form of implicit gradient descent. The key 2023 result (von Oswald et al., "Transformers Learn In-Context by Gradient Descent") shows that simplified transformers implement one step of gradient descent when doing ICL. A 2024 NAACL paper extends this, showing transformers approximate second-order optimization methods.

**Practical implication:** When the tree context contains relevant examples of how a skill was previously applied, the LLM is performing implicit adaptation — learning from those examples in-context without any weight updates.

**Is ICL "real" learning?** Not in a persistent sense. ICL produces task-specific behavior for the duration of the context, but it doesn't persist after the context ends. This is why our architecture's consolidation step is essential: the implicit "learning" that happens during skill execution must be made explicit through Hebbian strengthening and eventual skill-node promotion.

### The Tree as In-Context Skill Library

Our tree-as-context approach is actually a form of structured in-context learning. When the tree renders a skill node plus its associated contexts and example outcomes, it's providing the LLM with structured demonstrations of the skill's application.

The advantage over flat retrieval (like Voyager's top-5 vector lookup) is associative depth: the tree doesn't just retrieve the skill node — it also renders the contexts where the skill was used, the outcomes that followed, the related skills, and the conditions where it failed. This is richer than a code snippet plus description.

**Key insight:** The quality of in-context skill learning depends on the quality of the examples provided. A graph-structured skill library can provide better examples because it maintains associative connections between skills and their usage contexts. The tree is not just a retrieval mechanism — it's an ICL curriculum generator.

### GraphICL (2025)

A 2025 paper "GraphICL: Unlocking Graph Learning Potential in LLMs through Structured Prompt Design" directly validates this direction. GraphICL designs task-specific prompts following a unified template that includes task description, anchor node text, structure-aware information, and labeled demonstrations. The graph structure improves ICL performance precisely because it provides richer contextual information about relationships.

---

## 6. Program Synthesis and Code as Skill Representation

### Why Code Is a Strong Skill Representation

Voyager's choice to represent skills as executable code was not arbitrary. Code has several properties that make it superior to natural language descriptions for skill representation:

1. **Executability** — code can be run directly, enabling immediate validation
2. **Composability** — functions can call other functions, enabling hierarchical skill composition
3. **Interpretability** — code is readable by humans and LLMs, enabling debugging
4. **Precision** — code is unambiguous about parameters and control flow
5. **Transferability** — code abstracts over specific instances, enabling generalization

The 2023 paper "Program Synthesis for Robot Learning from Demonstrations" (arXiv:2305.03129) extends this, showing that PROLEX can find programs consistent with demonstrations in 80% of cases, and for 81% of solved tasks, finds the ground truth program from a single demonstration.

### DreamCoder and Neural Program Synthesis

DreamCoder (Ellis et al.) is the most sophisticated approach to treating program synthesis as skill acquisition. The agent maintains a library of programs (skills), learns to synthesize new programs using the library, and periodically abstracts common patterns into new library entries. The abstraction mechanism (compiling patterns into reusable subroutines) directly parallels what consolidation does in our architecture.

### Code vs. Declarative Skill Representation

The critical design question for our architecture: should procedural nodes store code (like Voyager) or structured declarative descriptions (like ACT-R production rules)?

**Arguments for code:**
- Directly executable, testable
- Handles composition naturally through function calls
- LLMs are excellent at generating and modifying code

**Arguments for declarative (structured description):**
- Platform-independent (code is tightly coupled to specific APIs)
- Gradable (partial matches possible, unlike code which either runs or doesn't)
- Mergeable (two descriptions of the same skill can be combined)
- Works when there's no execution environment

**Synthesis:** The optimal procedural node likely contains both: executable code for tasks that have a stable execution environment, plus a declarative trigger description that enables matching even when the exact code is outdated. The declarative description is the "interface"; the code is the "implementation."

---

## 7. Hierarchical Skill Learning

### Options Framework (Sutton, Precup, Singh, 1999)

The options framework (Artificial Intelligence Journal, 1999) provides the formal foundation for hierarchical skill learning in RL. An **option** is defined as a triple (I, π, β):
- **Initiation set I** — states where the option can be started
- **Policy π** — the behavior during the option's execution
- **Termination condition β** — when to stop executing the option

Options are "temporally extended actions" — they run for multiple timesteps, like skills. The mathematical key: option-augmented MDPs can be solved with standard RL algorithms, extending the usual RL framework to handle temporally extended skills without modifying the underlying mathematics.

**Direct mapping to our architecture:**
- Initiation set I → the trigger context in our procedural node ("when does this skill apply")
- Policy π → the action template in our procedural node ("what to do")
- Termination condition β → the success condition ("what should happen when the skill completes")

Our procedural node design is essentially an options-style representation, stored in an associative graph rather than a flat policy table.

### MAXQ (Dietterich, 2000)

MAXQ (Journal of Artificial Intelligence Research, 2000) decomposes the value function of a complex task into an additive hierarchy of subtask value functions. It has both a procedural semantics (subroutine hierarchy) and a declarative semantics (value function representation). The learning algorithm MAXQ-Q converges to a recursively optimal policy much faster than flat Q-learning.

**Relevance:** MAXQ shows that hierarchical decomposition of skills dramatically accelerates learning. For our architecture, this means procedural nodes should be hierarchically organized — complex skills should decompose into simpler sub-skills, with the graph edges explicitly representing "this skill uses these sub-skills."

### HAM — Hierarchical Abstract Machines (Parr & Russell, 1998)

HAMs represent partial policies as hierarchical finite state machines with unspecified "choice states." Learning only happens at choice states, dramatically reducing the search space. A key advantage: HAMs allow prior knowledge to reduce the search space, and component solutions can be recombined across problems.

**Mapping to Mirror layer:** The Mirror managing high-level goals while trees handle execution is HAM-like. The Mirror operates at the level of "which skill sequence to invoke" — the choice states — while the trees execute within skills without much deliberation. Automatic execution (low-level) vs conscious deliberation (high-level) is exactly the HAM structure.

### SkiMo — Skill-based Model-based RL (Shi et al., CoRL 2022)

Already covered in Section 2, but worth highlighting the key contribution here: SkiMo shows that **planning in skill space** dramatically outperforms planning in action space for long-horizon tasks. The skill dynamics model directly predicts the resulting state after skill execution, skipping the intermediate steps.

For our architecture: this suggests procedural nodes should encode expected outcome states, not just action sequences. The mirror can plan at the skill level by predicting "if I apply skill A from current state, I expect to reach state B; from state B, skill C applies; etc." — without needing to simulate every low-level action.

---

## 8. Transfer Learning for Skills

### PolySkill — Polymorphic Abstraction for Skill Transfer (2024)

PolySkill (arXiv:2510.15863) introduces the most sophisticated approach to skill transfer in web agents. The key idea: decouple a skill's **abstract goal** (what it accomplishes) from its **concrete implementation** (how it executes on a specific platform).

The architecture uses object-oriented polymorphism:
- **Abstract base class:** Domain-level interface (e.g., `AbstractShoppingSite` with methods like `search(query)`, `add_to_cart(item)`)
- **Concrete subclass:** Platform-specific implementation (e.g., `AmazonSite.search()`)

When the agent encounters a new shopping website, it inherits from the abstract class, only needing to learn the site-specific implementation details.

**Results:** 1.7x improvement in skill reusability on seen websites, 9.4% higher success rates, 13.9% improvement on unseen websites, 20%+ reduction in steps.

**Direct relevance to our architecture:** PolySkill implements, through code inheritance, something that our associative graph could implement through structural relationships. If the graph contains:
- An abstract skill node: `SEARCH_E-COMMERCE_SITE`
- Connected to concrete skill nodes: `SEARCH_AMAZON`, `SEARCH_TARGET`, `SEARCH_EBAY`
- With the concrete nodes connected to context nodes identifying their domains

Then transfer from Amazon to a new shopping site happens through the graph: the new site connects to `SEARCH_E-COMMERCE_SITE`, which provides the abstract template, with new concrete implementation edges added through experience.

The graph representation is more flexible than code inheritance: it allows partial matches, graceful degradation when exact implementations don't exist, and accumulation of contextual knowledge about when each implementation works.

### GSC — Graph-Based Skill Composition for Robots (2024)

GSC (Robotics and Autonomous Systems, 2024) directly addresses skill representation in graphs. Skills are nodes, skill relationships are edges, and a transformer-style graph update mechanism propagates information through the skill graph for composition decisions.

Key technical details:
- Skill representations = learnable embeddings (nodes in GNN)
- Skill relations = KLD-based edges
- Composition = transformer-style information propagation across the graph
- New skills integrate through the neural update mechanism

**Results:** Consistently outperforms non-graph approaches on robotic task composition, and demonstrates feasibility on real robots.

**This is the closest existing work to what we're proposing.** The key differences:
- GSC uses neural embeddings (not interpretable); our matrix uses interpretable graph structure
- GSC's edges are similarity-based; our edges are associative (meaning-based)
- GSC doesn't connect skill nodes to episodic usage contexts; our architecture does

---

## Synthesis: Implications for the Associative Memory Architecture

### A. The Most Promising Approaches for Our Architecture

Ranked by relevance and directness of applicability:

1. **Options framework + MAXQ**: The formal language for what a procedural node IS. A skill node should encode: initiation set (trigger context), policy (action template + parameter patterns), termination condition (success criteria), and expected outcome. This gives us the right formal structure.

2. **Voyager's skill-as-code**: The representation format — executable code — is the right choice for skills that have a stable execution environment. Our procedural nodes should contain code where applicable, plus a declarative description for matching.

3. **SkiMo's skill dynamics**: Procedural nodes should encode expected outcomes, not just actions. This enables planning at the skill level without simulating every step.

4. **Dyna's model-based learning**: Consolidation as "planning with the world model" is validated. Our matrix is the world model; consolidation replays and reorganizes episodic experiences to extract and refine skills.

5. **PolySkill's polymorphic abstraction**: Skills should be organized in a hierarchy from abstract to concrete. Abstract skill nodes capture the invariant pattern; concrete skill nodes capture domain-specific implementations. The associative graph enables this more flexibly than code inheritance.

6. **MAML for Mirror meta-learning**: The Mirror should use meta-learning principles to improve how it learns skills — tracking which acquisition strategies work in which contexts, which retrieval approaches lead to good skill selection, etc.

### B. How Procedural Nodes Should Work in a Graph-Based System

Based on the research synthesis, here is a proposed specification for procedural nodes:

```
PROCEDURAL NODE STRUCTURE:
{
  type: "procedural",

  // Trigger (when does this skill apply) — the Initiation Set
  trigger_description: "When I need to search the web for current information",
  trigger_embedding: <semantic vector>,
  trigger_conditions: ["confidence < 0.7 on factual query", "time-sensitive topic"],
  trigger_antiConditions: ["file system task", "user wants me to reason from memory"],

  // Action (what to do) — the Policy
  action_template: "Call web_search(query=<reformulated query>)",
  action_code: "async function webSearch(query, context) { ... }",  // if executable
  action_parameters: {
    "query": "reformulated version of user's question",
    "num_results": 5
  },

  // Outcome (what to expect) — Termination + Skill Dynamics
  expected_outcome: "Returns current information on the topic",
  success_conditions: ["result contains relevant information", "result is recent"],
  failure_modes: ["result is irrelevant", "service unavailable"],

  // History (how has this worked)
  success_rate: 0.87,
  usage_count: 143,
  last_refined: "2026-02-15",

  // Graph connections (what makes this a graph node)
  connected_to: [
    {node: "SEMANTIC:web_search_tool", edge_type: "implements"},
    {node: "SEMANTIC:current_information_need", edge_type: "triggered_by"},
    {node: "EPISODIC:time_i_searched_for_X", edge_type: "instantiated_by"},
    {node: "PROCEDURAL:refine_search_query", edge_type: "composed_of"},
    {node: "PROCEDURAL:web_search_amazon", edge_type: "specializes_to"},
    {node: "CONTEXT:user_asks_about_current_events", edge_type: "applies_in"}
  ]
}
```

The critical difference from flat skill libraries: a procedural node is embedded in the associative graph, connected to:
- The contexts where it applies (enabling context-driven skill selection)
- Episodic instances of its application (enabling learning from past uses)
- Related and sub-skills (enabling composition and transfer)
- Failure contexts (enabling condition learning)

### C. What Is Genuinely Novel About Skills in an Associative Memory Graph

Comparing to all existing approaches:

**1. Context-driven selection over semantic-similarity retrieval**

Current systems (Voyager, JARVIS-1) retrieve skills by embedding similarity between the task description and skill descriptions. This works when the task is similar to previous tasks but fails for novel situations.

In our architecture, skill selection is driven by tree traversal: the currently active nodes (representing the full situational context) spread activation through the graph toward connected skill nodes. A skill that was used in a slightly different situation but with significant contextual overlap will be activated through multiple associative paths — not because it's textually similar, but because it's **associatively connected to the current context**.

This is a more powerful selection mechanism than embedding similarity, especially for transfer learning.

**2. Skills as embedded in episodic history, not separated from it**

All existing skill libraries (Voyager, JARVIS-1, AppAgent, SKILL.md) store skills separately from episodic memory. You have a "skill library" and separately you have "experience."

In our architecture, a procedural node is connected to the episodic nodes that generated it. The skill node `WEB_SEARCH_WHEN_UNCERTAIN` is connected to the ten conversations where that skill was refined, the contexts where it succeeded, and the contexts where it failed. This episodic embedding:
- Enables richer skill selection (activation spreads from episodic context to skill)
- Enables skill refinement (new episodes connect to existing skill nodes, updating their statistical properties)
- Enables interpretability (you can trace why a skill was selected by following edges to its usage history)

**3. Polymorphic abstraction through graph structure, not code inheritance**

PolySkill achieves abstract/concrete skill hierarchy through code inheritance. Our architecture achieves the same thing through graph relationships, but more flexibly:
- Abstract skill nodes can connect to many concrete implementations
- Connections between abstract and concrete nodes carry weights (some implementations are more reliable)
- New concrete implementations can be connected to existing abstract nodes without modifying any existing code
- Partial matches are possible: a new skill might be 70% like the abstract template, contributing to it through a lower-weight edge

**4. Skill learning without a separate learning algorithm**

RL-based skill learning requires a separate optimization process (policy gradient, Q-learning, etc.) to learn skills from experience. Our architecture acquires skills through the same mechanism that acquires all knowledge: Hebbian strengthening (edges traversed repeatedly get stronger), consolidation (episodic patterns promoted to semantic/procedural nodes), and prediction-error-driven reconsolidation.

There's no separate "skill learning" phase — skills emerge from the same associative dynamics as other kinds of learning. This is theoretically cleaner and eliminates the need for a separate optimization loop.

**5. Interpretable skill structure**

Current neural approaches (GSC, RL-based skill learning) learn skill representations as neural embeddings — functionally powerful but not interpretable. Our procedural nodes are explicitly structured with trigger descriptions, action templates, expected outcomes, and connections to episodic evidence. Every aspect of a skill is readable and traceable.

This matters for the anti-hallucination property: when the agent uses a skill, the Mirror can inspect why the skill was selected (which contexts activated it) and what outcome to expect (from the skill node's history), enabling honest uncertainty calibration.

---

## The Framework for Procedural Node Acquisition

Drawing together the full research synthesis, here is the complete lifecycle of a procedural node in our architecture:

### Stage 1: Episodic Accumulation

The agent takes actions. Each action creates an episodic node: (situation_context, action_taken, outcome, surprise_score). Multiple episodic nodes encoding similar situations and actions begin to form a cluster in the matrix through Hebbian strengthening of their mutual connections.

### Stage 2: Pattern Detection (Consolidation)

During consolidation, the system detects recurring episodic patterns: "I keep reaching for web_search in low-confidence situations, and it tends to succeed." This is the DreamCoder/ACT-R production compilation pattern: repeated sequences of episodic nodes get compressed into a single procedural abstraction.

### Stage 3: Procedural Node Creation

Consolidation creates a procedural node encoding the pattern. The node is connected back to all the episodic instances that generated it. Its statistical properties (success_rate, trigger_conditions) are initialized from the episodic evidence.

### Stage 4: Integration and Refinement

As the agent continues acting, new episodic nodes connect to existing procedural nodes when the situation matches. The procedural node's properties update: success_rate adjusts, new failure modes get recorded, the trigger conditions sharpen. Prediction error from skill execution drives Hebbian updates to the edges connecting the procedural node to relevant contexts.

### Stage 5: Abstraction and Transfer

When multiple procedural nodes share structural similarities (similar trigger contexts, similar actions, similar outcomes across different domains), consolidation can create an abstract procedural node capturing the common pattern — the PolySkill polymorphism mechanism, realized through graph abstraction rather than code inheritance.

---

## Open Questions This Research Leaves

1. **How dense does episodic history need to be before procedural nodes can be confidently created?** The consolidation algorithm needs a principled threshold. ACT-R's answer is based on activation frequency; RL's answer is based on statistical significance of the reward signal. We need our own answer.

2. **Should procedural nodes contain code (Voyager-style) or structured descriptions (ACT-R-style), or both?** The research suggests both are valuable for different purposes, but the dual representation adds complexity.

3. **How should the trigger matching work?** Embedding similarity (Voyager), visual state matching (JARVIS-1), or tree traversal (our approach). Each has tradeoffs. The tree traversal approach is most powerful but most expensive.

4. **Can the Mirror use MAML-style meta-learning on the graph itself?** MAML requires gradient descent; our architecture doesn't inherently use gradients. But the principle — learning an initialization that adapts fast to new tasks — could be implemented as "the Mirror learns which subgraph structures tend to produce reliable skill selection."

5. **How do skills decay vs. consolidate?** Skills that aren't used should presumably weaken — but well-consolidated skills (used many times, high success rate) should persist even without recent use. The decay function for procedural nodes likely differs from episodic nodes.

---

## Primary Citations

- Sutton, R.S. (1991). Dyna, an Integrated Architecture for Learning, Planning, and Reacting. *ACM SIGART Bulletin*. [Dyna framework]
- Sutton, R.S., Precup, D., Singh, S. (1999). Between MDPs and semi-MDPs: A framework for temporal abstraction in reinforcement learning. *Artificial Intelligence*, 112(1-2), 181-211. [Options framework]
- Parr, R. & Russell, S. (1998). Reinforcement Learning with Hierarchies of Machines. *NIPS 1998*. [HAM]
- Dietterich, T.G. (2000). Hierarchical Reinforcement Learning with the MAXQ Value Function Decomposition. *JAIR*, 13, 227-303. [MAXQ]
- Finn, C., Abbeel, P., Levine, S. (2017). Model-Agnostic Meta-Learning for Fast Adaptation of Deep Networks. *ICML 2017*. arXiv:1703.03400. [MAML]
- Wang, G. et al. (2023). Voyager: An Open-Ended Embodied Agent with Large Language Models. arXiv:2305.16291. [Skill-as-code, lifelong learning]
- Zhu, X. et al. (2023). Ghost in the Minecraft: Generally Capable Agents for Open-World Environments via Large Language Models with Text-based Knowledge and Memory. arXiv:2305.17144. [GITM]
- Wang, Z. et al. (2023). JARVIS-1: Open-World Multi-task Agents with Memory-Augmented Multimodal Language Models. arXiv:2311.05997. [Multimodal memory-augmented planning]
- Zhang, C. et al. (2023). AppAgent: Multimodal Agents as Smartphone Users. arXiv:2312.13771. [Two-phase skill learning]
- Shi, L. et al. (2022). Skill-based Model-based Reinforcement Learning. *CoRL 2022*. arXiv:2207.07560. [SkiMo]
- Anokhin, P. et al. (2024). AriGraph: Learning Knowledge Graph World Models with Episodic Memory for LLM Agents. arXiv:2407.04363. [Graph-based world model]
- PolySkill (2024). Learning Generalizable Skills Through Polymorphic Abstraction. arXiv:2510.15863. [Polymorphic skill transfer]
- GSC (2024). A Graph-based Skill Composition Framework for Robot Learning. *Robotics and Autonomous Systems*. [Graph skill composition]
- Wu, Y. et al. (2025). Agent Skills from the Perspective of Procedural Memory: A Survey. TechRxiv. [Procedural memory survey]
- Zhao, Y. et al. (2025). Agent Skills for Large Language Models: Architecture, Acquisition, Security, and the Path Forward. arXiv:2602.12430. [Skill paradigm survey]
- Wang, G. et al. (2025). Automating Skill Acquisition through Large-Scale Mining of Open-Source Agentic Repositories. arXiv:2603.11808. [SKILL.md mining]
- Tian, Y. et al. (2025). Learning Hierarchical Procedural Memory for LLM Agents. arXiv:2512.18950. [Hierarchical procedural memory]
- Panagiotopoulos, S. et al. (2021). Prediction errors disrupt hippocampal representations and update episodic memories. *PNAS*, 119(1). [Neuroscience validation]
- Anderson, J.R. et al. ACT-R Cognitive Architecture. [Production compilation, procedural vs declarative]
- von Oswald, J. et al. (2023). Transformers Learn In-Context by Gradient Descent. *ICML 2023*. [ICL mechanism]

---

*This research report was generated for the Associative Memory Architecture project. For the design implications, see `design/world-integration.md`. For the full architecture, see `design/architecture.md`.*

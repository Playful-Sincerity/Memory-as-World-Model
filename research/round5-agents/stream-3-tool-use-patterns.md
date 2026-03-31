# Tool Use as a First-Class Cognitive Operation: Architectural Patterns in Modern AI Agents

**Research date:** 2026-03-29
**For:** Associative Memory Architecture — world-integration design
**Scope:** How leading agent systems structure tool use (decision, execution, observation, learning)

---

## Introduction

The question this research answers is not "do agents use tools?" — they all do. The question is: **how is tool use architecturally structured?** Specifically:

- How does an agent decide which tool to use and when?
- How is the result observed and integrated into reasoning?
- Does the system learn from tool use outcomes, or just use them once?
- Can tools be composed into multi-step sequences?
- What happens when a tool call fails?
- How are tool use experiences stored in memory?

The Associative Memory Architecture needs tool use as a first-class cognitive operation — not an afterthought bolted onto a reasoning loop. The design doc `world-integration.md` frames this well: tool use is where *causal* knowledge is created (Pearl's Layer 2), where skills are born, and where the gap between "knowing about" and "knowing how" is crossed. This report surveys the best existing approaches to understand what to adopt, what to discard, and what no one has solved.

---

## 1. ReAct: Synergizing Reasoning and Acting (Yao et al., 2023)

**Paper:** "ReAct: Synergizing Reasoning and Acting in Language Models" — ICLR 2023. arXiv:2210.03629.

### Architecture

ReAct is the most widely adopted agent pattern. It interleaves **thought traces** (reasoning steps) with **action calls** (tool invocations) in a single sequential loop:

```
Thought: I need to look up X.
Action: search("X")
Observation: [result from tool]
Thought: The result says Y. Now I need Z.
Action: search("Z")
...
Answer: [final response]
```

Each cycle follows the structure: **Thought → Act → Observe → Thought**. The thought trace is generated first (using chain-of-thought prompting), then the action is executed against an external environment (Wikipedia API, search engine, calculator, etc.), and the observation is appended to the context for the next reasoning step.

### Selection Mechanism

Tool selection is **implicit in the thought trace**. The LLM generates a natural-language thought that includes the intent to use a tool ("I should search for..."), and this thought is parsed to extract the action. There is no explicit scoring or selection module — the LLM's in-context reasoning picks the tool.

This is elegant but brittle: it requires the LLM to have learned appropriate tool-use behaviors during pretraining/RLHF.

### Learning

**None.** ReAct does not learn from tool use. Each episode is independent. The observation from a tool call feeds back into the *current* reasoning trace, but nothing is persisted. If the same situation arises in a new session, the agent starts fresh.

The paper acknowledges this: ReAct "depends largely on few-shot in-context learning." The knowledge of how to use tools is frozen in the model's weights or the few-shot prompts, not accumulated from experience.

### Composition

ReAct composes tool calls sequentially within a single reasoning trace. Multi-step tool use is handled by the thought trace: "I got result A, now I need to cross-reference with B." However, there's no explicit planning phase — the composition emerges step-by-step, not from a pre-planned structure.

### Failure Handling

The observation from a failed tool call (empty result, error message) is appended to the context like any other observation. The next thought can recognize the failure and try an alternative. This works, but it relies on the LLM's ability to detect and recover from failure in-context — there is no systematic failure handling mechanism.

One documented failure mode: non-informative search results derail the model's reasoning, and it struggles to reformulate and recover.

### Memory Integration

None beyond the current context window. Observations accumulate in the context but are not stored anywhere outside the episode. There is no mechanism to say "I've done this kind of search before, and the pattern that worked was X."

### Gap Analysis

ReAct's core limitation: it is a **stateless reasoning loop** masquerading as a learning system. The Thought → Act → Observe cycle creates the *appearance* of learning-from-experience during an episode, but across episodes, every tool interaction starts from scratch. This is the single most important gap for the Associative Memory Architecture to address.

ReAct also has no explicit tool selection module, no parallelism, and no failure learning — just sequential in-context reasoning.

---

## 2. Toolformer: Self-Supervised Learning of Tool Use (Schick et al., 2023)

**Paper:** "Toolformer: Language Models Can Teach Themselves to Use Tools" — NeurIPS 2023. arXiv:2302.04761.

### Architecture

Toolformer is not an agent loop — it is a **training methodology** that teaches a language model to insert tool calls at the right positions in a text generation stream. The trained model generates tool calls as inline tokens within its output, like this:

```
The capital of France is [SEARCH("capital of France") → "Paris"] Paris.
```

The tool call is executed, the result is inserted, and the LLM continues generating from the extended context.

### Selection Mechanism — The Key Insight

Toolformer determines whether a tool call is useful by measuring whether it **reduces the language modeling loss** on future tokens. Specifically:

1. Sample candidate API call positions in a text dataset using few-shot prompts
2. Execute each candidate call and get a result
3. Compute the loss on subsequent tokens with and without the result
4. Retain the call only if it reduces loss by more than a threshold

This is the critical insight: **tool use is justified if it improves prediction of what comes next.** The model learns to use tools not because it was told to, but because the empirical signal says the tool helped.

This produces a self-supervised training set that is then used to fine-tune the model with tool calls baked in.

### Learning

Toolformer represents a major improvement over ReAct in that tool use competency is **learned from data**, not prompted in-context. The model learns:
- *When* to insert a tool call (position selection)
- *Which* tool and *what arguments* to use
- *Whether* to use a tool at all for a given context

However, this learning is frozen at training time. Once Toolformer is trained, it has fixed tool-use behavior. It does not continue learning from new tool interactions post-training.

### Composition

Toolformer handles **single-call tool use** — one call per position in the text. Multi-step tool composition (use result of A to inform call to B) is not explicitly handled in the original paper. This is a significant limitation.

### Failure Handling

Not explicitly addressed. The training process filters out tool calls whose results don't help (via the loss criterion), implicitly training the model to not call tools when they won't help. But systematic failure recovery is not part of the architecture.

### Memory Integration

None. Same session-isolation problem as ReAct. The training process is the only form of "memory" — it encodes patterns of useful tool use into the weights.

### Gap Analysis for Our Architecture

Toolformer's loss-reduction criterion is philosophically related to our surprise/prediction-error signal: both ask "did this action help?" But Toolformer requires fine-tuning, while our architecture needs online, graph-based skill acquisition. The core principle — only encode a tool use pattern if it improved the outcome — maps well to our **skill promotion** mechanism (episodic → procedural node via consolidation), but without requiring retraining.

Toolformer also underscores that the question "when to call a tool" is learnable, not just promptable. This should be built into procedural nodes in the matrix.

---

## 3. LATS: Language Agent Tree Search (Zhou et al., 2024)

**Paper:** "Language Agent Tree Search Unifies Reasoning Acting and Planning in Language Models" — ICML 2024. arXiv:2310.04406.

### Architecture

LATS is the most architecturally sophisticated of the agent systems surveyed. It applies **Monte Carlo Tree Search (MCTS)** to the space of possible agent actions, treating multi-step tool use as a tree-search problem rather than a sequential chain.

The structure:

```
Root (initial state)
  └── Action A (tool call 1)
       └── Observation A (result)
            ├── Action B1 (branch 1: follow-up call)
            └── Action B2 (branch 2: alternative follow-up)
                 └── ...
```

LATS maintains a tree of explored trajectories. Each node is a state (the accumulated observations and reasoning so far). Each edge is an action (a tool call or reasoning step). The MCTS algorithm guides which branches to explore based on:

1. **Value function** — an LLM-powered evaluator scores each state's progress toward the goal
2. **Self-reflection** — when a branch fails, the LLM generates a verbal reflection on *why* it failed, which is incorporated into future search decisions
3. **Self-consistency** — multiple branches that reach the same conclusion reinforce each other

### Selection Mechanism

LATS has an explicit multi-step selection mechanism. At each node, it:
1. Generates multiple candidate next actions (exploration)
2. Scores them via the value function
3. Uses Upper Confidence Bound (UCB) to balance exploration vs. exploitation
4. Expands the most promising branch

This is dramatically more sophisticated than ReAct's "generate the next thought step."

### Learning

Within an episode, LATS learns from branch failures through self-reflection. When a branch fails (tool call returns unhelpful result, or the value function scores the state poorly), the LLM reflects on what went wrong, and this reflection informs subsequent search.

However, this is still **within-episode learning only**. LATS does not persist the tree structure, the value scores, or the reflections across episodes. The next session restarts from scratch.

LATS achieves 92.7% pass@1 on HumanEval with GPT-4, outperforming all prior prompting-based methods. The improvement comes from being able to explore multiple trajectories and backtrack — not from persistent learning.

### Composition

LATS excels at multi-step tool composition. The tree structure explicitly represents multi-step plans: "call A, then based on A's result, call B or C, then synthesize." The MCTS algorithm ensures that dead ends get pruned and promising paths get deeper exploration.

### Failure Handling

LATS has the best failure handling of the systems surveyed. Failed branches:
- Are scored negatively by the value function
- Trigger a self-reflection that explains the failure
- Inform the UCB score, reducing the probability of re-exploring that branch
- The reflection is appended to sibling branches as context ("I tried X and it failed because Y")

### Memory Integration

None across episodes. Within an episode, the tree structure itself is the working memory — all explored branches are available as context for new decisions. But nothing persists.

### Gap Analysis

LATS represents a significant insight for our architecture: **tool use planning is a search problem, not a chain problem.** The tree structure is natural — it maps directly to our Trees plane. A subconscious tree growing in the matrix toward a goal, spawning branches for different possible tool sequences, backtracking when a branch fails — this is LATS, but made persistent.

The critical question LATS leaves unanswered: after the episode ends, where does the search tree go? In our architecture, it would consolidate into the matrix: successful trajectories strengthen their paths, failure reflections become procedural nodes ("when in context X, do not call tool Y"), and the structure of effective multi-step plans becomes learned patterns rather than re-searched every time.

The value function concept from LATS also maps to our Mirror's confidence evaluation — the Mirror can act as an online value function, assessing partial trajectories and redirecting the subconscious trees.

---

## 4. Tool Learning with Foundation Models — Survey (Qin et al., 2023)

**Paper:** "Tool Learning with Foundation Models" — ACM Computing Surveys. arXiv:2304.08354.

This is the most comprehensive overview of the field. It proposes a general framework with four components:

1. **Tool set** — available tools (APIs, calculators, search engines, code executors)
2. **Environment** — where tool calls execute (web, file system, database)
3. **Controller** — the LLM deciding which tool to call
4. **Perceiver** — how results are incorporated into the LLM's context

The survey identifies five categories of tool-use capability:
- **Tool selection** — choosing from a set of available tools
- **Input construction** — forming the right arguments
- **Result integration** — incorporating observations into reasoning
- **Tool composition** — chaining multiple tools
- **Tool creation** — generating new tools

### Tool Retrieval Problem

A significant challenge documented in this survey: when hundreds or thousands of tools are available, the agent cannot receive all tool descriptions in its context window. The solution used in ToolBench (Qin et al., 2023, arXiv:2307.16789 / ToolLLM) is a **neural API retriever** — a dense retrieval model that selects the top-k most relevant tools for a given query.

ToolBench assembled 16,464 real-world RESTful APIs across 49 categories. ToolLLaMA (the fine-tuned agent) uses a retriever to narrow this to a relevant subset before the LLM plans its tool use. Retrieval is based on semantic embedding similarity between the user query and tool descriptions.

Recent work (2025-2026) shows that standard embedding models perform poorly on tool retrieval because they embed tool descriptions, not usage patterns. Tool2Vec proposes usage-driven embeddings — embedding tool usage examples rather than descriptions, so tools end up in the same embedding neighborhood as the queries that typically activate them.

### Learning How to Select Tools

The survey distinguishes three levels of tool-use competency:
1. **Prompting** — few-shot examples teach the LLM to use tools (ReAct)
2. **Fine-tuning** — the model's weights are updated to encode tool-use patterns (Toolformer, ToolLLaMA)
3. **Autonomous tool creation** — the model generates new tools for novel situations (see Section 6)

Each level requires more infrastructure but provides more generalization.

### Gap Analysis

The survey explicitly identifies "ensuring trustworthy tool use" and "enabling tool creation" as open problems. It does not address how tool use history could be stored and reused structurally — the memory component is treated as a separate concern.

Our architecture addresses the retrieval problem differently: rather than a separate retriever, procedural nodes in the matrix are connected to the contexts where they apply. Finding the right tool for a situation becomes graph traversal rather than vector search — and the traversal is weighted by actual usage history, not just semantic similarity.

---

## 5. Voyager: Lifelong Learning with a Skill Library (Wang et al., 2023)

**Paper:** "Voyager: An Open-Ended Embodied Agent with Large Language Models" — arXiv:2305.16291.

Voyager is the most directly relevant system for our architecture because it is the only surveyed system that **genuinely learns skills** from tool/action use and builds a persistent library.

### Architecture

Three components:
1. **Automatic curriculum** — GPT-4 generates progressively harder tasks based on current inventory, world state, and completed/failed tasks. The curriculum adapts to what the agent has learned.
2. **Skill library** — an ever-growing library of executable JavaScript programs, each representing a learned behavior
3. **Iterative prompting mechanism** — code is generated, executed in Minecraft, errors and observations are fed back, code is refined over multiple rounds until it succeeds

The skill library is the critical innovation. Each skill is:
- An executable JavaScript function
- Indexed by its docstring embedding
- Retrievable via cosine similarity search when facing a new task
- Composable — complex skills call simpler ones

### Skill Acquisition Loop

```
1. Curriculum proposes task ("collect 3 diamonds")
2. Retrieve top-5 relevant skills from library via embedding search
3. Generate new code using retrieved skills + GPT-4
4. Execute in Minecraft
5. If success: add new function to library
6. If failure: append error trace + environment state, re-generate
   (up to 4 iterations)
7. If still failing: abandon, curriculum proposes easier task
```

### Learning

This is real, persistent skill learning. Over time, Voyager accumulates:
- Low-level skills ("find wood", "craft planks")
- Compound skills ("build shelter" = find trees + craft planks + craft sticks + ...)
- Progressive abstraction as skills call each other

The paper reports 3.3x more unique items collected, 15.3x faster tech tree unlocking compared to prior methods. The skill library is the main driver.

### Retrieval Mechanism

Vector embedding search (cosine similarity) over docstrings. When faced with a new task, the query is embedded and matched against all skill descriptions. The top-5 retrieved skills are injected into the generation prompt.

This is efficient but has the same limitation as all embedding-based retrieval: it matches on semantic similarity of descriptions, not on *contextual appropriateness* — which depends on the agent's current state, prior interactions, and failure history.

### Failure Handling

Failures are genuinely informative in Voyager. The error trace (execution error + environment state) is fed back to the code generator, which creates a corrected version. After 4 failed iterations, the task is abandoned as too hard for current capabilities, and the curriculum backs off.

Failed task attempts are not stored in the skill library — only successes are. This means failure knowledge isn't systematically persisted, though the curriculum implicitly tracks what has been attempted.

### Gap Analysis

Voyager is the closest existing system to what the Associative Memory Architecture wants for tool use. Its gaps are exactly the gaps the architecture is designed to fill:

1. **Skills are isolated programs**, not nodes in a connected graph. Voyager can't discover that skill A and skill B share underlying logic — they're just entries in a vector store. Our architecture: skills are procedural nodes in the matrix, connected to the episodic memories that produced them, connected to each other via shared context edges.

2. **Retrieval is embedding-based**, not graph traversal. Finding relevant skills requires a fresh vector search every time. Our architecture: the Mirror grows a tree into the matrix that naturally encounters relevant procedural nodes via associative edges — contextual appropriateness is encoded in the graph topology, not just in description semantics.

3. **Failure knowledge is discarded**. Voyager doesn't encode "I tried X and it failed because Y." Our architecture: failure episodes encode as episodic nodes with causal edges to the failure outcome, promoting over time to procedural knowledge ("when in context X, avoid action Y because Z").

4. **Curriculum is externally generated**. GPT-4 proposes the curriculum; the agent doesn't decide what to learn next. Our architecture: the Mirror identifies gaps (low confidence, sparse regions, unreached goals) and generates its own curriculum through curiosity — the same mechanism that governs all cognition.

---

## 6. CREATOR, Chameleon, TaskWeaver — Tool Creation

### CREATOR: Creating New Tools (Qian et al., 2023)

**Paper:** arXiv:2305.14318. "CREATOR: Tool Creation for Disentangling Abstract and Concrete Reasoning."

CREATOR separates reasoning into two phases:
1. **Creation** — given a problem, abstract a reusable Python function that could solve this class of problems
2. **Decision** — use the created function (tool) to solve the specific problem

The key insight: LLMs are better at reasoning abstractly ("here is a general algorithm for X") than at executing specific steps. By having the model *create* the tool rather than *be* the tool, CREATOR achieves better performance on complex math and reasoning benchmarks.

CREATOR outperformed chain-of-thought, program-of-thought, and tool-using baselines on MATH and TabMWP benchmarks by disentangling the abstract reasoning (tool creation) from the concrete execution (tool use).

The progression CREATOR implies: **use a tool → learn when to use it → create new tools for gaps.** This is the complete skill learning arc.

### Chameleon: Compositional Tool Sequencing (Lu et al., 2023)

**Paper:** arXiv:2304.09842. "Chameleon: Plug-and-Play Compositional Reasoning."

Chameleon is an LLM-based **planner** that assembles sequences of tools for complex reasoning tasks. Given a problem, a GPT-4 planner generates an execution program — a sequence of tool calls (vision models, search engines, Python functions, LLMs) that together solve the problem.

Achieves 86.54% on ScienceQA (11.37% above prior SOTA) and 98.78% on TabMWP (17% above prior SOTA) by treating tool composition as a program synthesis problem.

Key architectural contribution: the **tool sequence is generated as a plan** before execution begins. This separates planning from execution, unlike ReAct's interleaved approach.

### TaskWeaver: Code as Action Space (Qiao et al., 2023)

**Paper:** arXiv:2311.17541. Microsoft's code-first agent framework.

TaskWeaver treats all tool use as code execution. User requests are converted to code snippets; tools are Python functions; the agent generates, executes, and refines code in a stateful Python environment. Two roles:
- **Planner** — decomposes tasks into subtasks
- **Code Interpreter** — generates and executes Python for each subtask

The insight: representing tool use as code gives the agent maximum compositional flexibility — it can express arbitrary multi-tool pipelines as programs. Memory between calls is maintained through Python variables.

### Gap Analysis — Tool Creation

The CREATOR work demonstrates that **tool creation is achievable by prompting alone** — no fine-tuning required. This is important for our architecture: the Mirror can recognize a gap ("I keep needing to do X but no procedural node exists") and create a new procedural node by generating code/action templates. Tool creation is not special — it's the natural endpoint of the skill learning arc.

Our architecture can go further: tools created through CREATOR-style abstraction can be connected in the matrix to the episodic memories that motivated their creation and to all contexts where they apply, creating a living, associatively-connected tool library rather than a flat list of functions.

---

## 7. Reflexion: Verbal Reinforcement Learning from Failure (Shinn et al., 2023)

**Paper:** "Reflexion: Language Agents with Verbal Reinforcement Learning" — NeurIPS 2023. arXiv:2303.11366.

### Architecture

Reflexion is the most systematic approach to learning from tool use failures. The framework uses verbal self-reflection as a substitute for gradient-based learning:

1. **Agent acts** (tool calls, decisions) until it succeeds or fails
2. **Evaluator scores** the outcome (binary success, or more nuanced feedback)
3. **Reflector generates** a verbal summary of what went wrong and how to do better
4. This reflection is stored in an **episodic memory buffer**
5. In the next episode, the agent loads relevant past reflections into context before starting

The reflection becomes a form of few-shot learning from the agent's own prior failures.

### Learning from Failure

Reflexion achieves 91% pass@1 on HumanEval (vs GPT-4's 80%) by iterating over failures. The key mechanism: the reflection traces credit assignment to specific decisions ("I called the wrong API at step 3 because I misread the parameter format").

However, the episodic memory buffer is linear — reflections are retrieved by recency, not by contextual relevance. The agent may load reflections from past failures that aren't relevant to the current problem.

### Gap Analysis

Reflexion is the closest existing system to our failure-encoding concept. The mapping to our architecture:

- **Reflection generation** → Mirror's post-action evaluation ("compare predicted vs. actual outcome")
- **Reflection storage** → episodic nodes connected to the action that triggered them (causal edge)
- **Reflection retrieval** → graph traversal from current context to relevant failure memories

But Reflexion's linear memory buffer is exactly the problem our architecture solves. Instead of appending reflections to a list, failure knowledge becomes graph-native: the procedural node for "tool X" has a connected set of failure episodes, each with their context, connected to the situations they apply to. Retrieval via traversal means contextually relevant failures surface naturally without explicit search.

---

## 8. Memory-Augmented Agents: MemGPT, Mem0, AriGraph

### MemGPT: OS-Inspired Memory Management (Packer et al., 2023)

**Paper:** arXiv:2310.08560. "MemGPT: Towards LLMs as Operating Systems."

MemGPT applies operating system memory management principles to LLMs: a two-tier architecture with main context (RAM analog) and external storage (disk analog). The agent uses function calls to move information between tiers — promoting important information into context, archiving less relevant information to external storage.

Tool use in MemGPT is mediated by the memory system: the agent calls memory functions (`core_memory_append`, `archival_memory_search`, etc.) alongside regular tools. Memory management is itself tool use.

**Gap:** MemGPT's external storage is a flat database retrieved by embedding search. There is no structure to the stored memories — no associations, no graph topology, no causal edges. The system can retrieve what it stored, but cannot discover connections it didn't explicitly encode. This is the retrieval vs. navigation distinction at the core of our architecture.

### AriGraph: Knowledge Graph World Models (Anokhin et al., 2024)

**Paper:** arXiv:2407.04363. IJCAI 2024.

AriGraph builds a semantic knowledge graph + episodic memory for LLM agents in text-based game environments. The agent explicitly constructs and updates a graph as it explores, integrating semantic facts (object types, locations, relationships) with episodic events (what happened at step N).

Results show this significantly outperforms both RAG-based memory and RL baselines on complex text game tasks.

AriGraph is architecturally closer to our vision than any other surveyed system — but it is designed for text games, where the world has a fixed ontology (objects, rooms, actions). The general case — arbitrary tool use, open-ended knowledge domains — requires a more flexible graph structure and a mechanism for the agent to decide what is worth encoding.

### Mem0: Scalable Long-Term Memory (2025)

**Paper:** arXiv:2504.19413.

Mem0g (the graph-enhanced version) builds on Mem0 with graph consolidation of related concepts. It demonstrates that graph-structured memory outperforms flat retrieval for production agents. However, the graph is a post-hoc addition to a retrieval architecture, not the fundamental substrate — the memory system still primarily works by searching semantically similar memories rather than traversing associations.

---

## 9. Plan-and-Execute and Hierarchical Planning

Several frameworks separate planning from execution for multi-step tool use:

**Plan-and-Execute (LangChain/LangGraph):** A planner LLM generates a multi-step plan; executor agents carry out each step using tools. Benefits: parallelism (independent steps run in parallel), efficiency (lightweight executor, heavyweight planner), cleaner separation of concerns.

**LLMCompiler:** Extends Plan-and-Execute by generating a DAG of tasks with explicit dependency annotations. Tasks with no dependencies run in parallel; dependent tasks wait. More efficient than strictly sequential execution.

**GAP: Graph-Based Agent Planning (2025):** arXiv:2510.25320. Explicitly models inter-task dependencies as a graph to enable parallel tool execution with dependency tracking. Shows that existing paradigms including ReAct fail to exploit inherent parallelism among independent sub-tasks.

**Gap Analysis:** Plan-and-Execute separates planning from execution but does not address learning from execution outcomes. Plans are generated fresh for each task; there is no mechanism for "I made a similar plan last week, and step 3 consistently fails — avoid that structure." Our architecture provides this through procedural nodes encoding successful plan patterns.

---

## 10. Synthesis: What Exists, What's Missing, What We Can Build

### Best Patterns to Adopt

**From ReAct:** The Thought → Act → Observe cycle as the basic unit of tool-mediated reasoning. This maps naturally to: Mirror generates intention, subconscious tree grows toward a tool, action executes, result returns as a new episodic node at the tree's tip, tree continues growing from that node.

**From LATS:** Treat tool selection and sequencing as a search problem, not a chain. Multiple candidate tool sequences should be explorable, with the Mirror acting as the value function. Failed branches produce verbal reflections that inform the search. This maps to: spawning parallel subconscious trees, each exploring a different tool sequence, with the Mirror evaluating and pruning based on confidence.

**From Voyager:** Persistent skill library as a first-class architectural component. Successful tool use patterns should consolidate into procedural nodes. Curriculum learning — the Mirror generating progressively harder tasks based on current capability — is a natural extension of the Mirror's curiosity mechanism.

**From Reflexion:** Verbal failure reflections stored as episodic memory, retrievable in future relevant episodes. In our architecture: failure episodes with causal edges to their context, surfaced via graph traversal rather than recency-based retrieval.

**From CREATOR:** Tool creation as the natural endpoint of the skill learning arc. When no procedural node exists for a needed capability, the Mirror can generate one. Tool creation is not special — it's the Mirror recognizing a gap and filling it.

**From Toolformer:** The loss-reduction criterion — "did this tool call improve predictions?" — maps to our surprise/prediction-error signal. Encode a tool use pattern as a skill only when it demonstrably improved the outcome. This principle should govern skill promotion from episodic to procedural nodes during consolidation.

### What No System Does Well (The Gaps)

**Gap 1: Persistent, associative skill memory.** Every system surveyed either (a) forgets tool use history entirely (ReAct, LATS), (b) stores skills in a flat list retrieved by embedding search (Voyager), or (c) stores reflections in a linear buffer (Reflexion). None connects skills to the contexts that produced them, to each other via shared structure, or to the failure episodes that define their limits. This is the central gap.

**Gap 2: Causal knowledge from tool use.** Tool use is the primary mechanism for creating causal (not just associative) knowledge. When an agent searches and finds an answer, it learns "search → answer" (causal, not just correlational). No current system explicitly encodes and accumulates this causal structure. All systems treat tool results as observations that update current reasoning, not as causal edges that update the world model. AriGraph comes closest but is domain-specific.

**Gap 3: Failure as first-class knowledge.** Reflexion handles within-episode failure best, but failure knowledge is not integrated with the broader knowledge structure. There's no connection between "this tool call failed in context X" and the agent's general knowledge about tool X, context X, or similar past failures. In a graph, these connections would exist naturally — failure episodes are nodes connected to the procedural node they implicate and the context nodes they occurred in.

**Gap 4: Skill transfer.** Voyager's skills are isolated programs. If skill A and skill B share underlying logic, Voyager cannot discover this. Graph-native skill representation solves this: if two procedural nodes share many context nodes (their trigger conditions overlap), they're likely related — traversal will surface both when either is relevant.

**Gap 5: Self-directed skill learning.** All surveyed systems learn skills reactively (when given a task) or require external curriculum (Voyager's GPT-4 curriculum generator). No system has an agent that recognizes its own capability gaps and decides to practice. Our Mirror, watching its own traversal patterns and noting where confidence is low and care is high, generates its own learning agenda.

**Gap 6: Tool composition planning that persists.** LATS searches for multi-step tool plans at runtime. Every time. There is no mechanism to store "when I need to do X, the effective plan is: call A, then call B with A's result, then synthesize." Successful multi-step plans should consolidate into the equivalent of macro-skills — procedural nodes with sequencing structure.

### How the Associative Memory Architecture Addresses These Gaps

The architecture as described in `world-integration.md` and `architecture.md` directly addresses each gap:

**Tool use as branch growth.** A tool call is a tree branch that extends beyond the matrix into the world. The result returns as a new episodic node at the tip. This is not a new mechanism — it's the same traversal mechanism applied to external space. The result node connects to the intention node (causal edge: "I searched because I needed to know X") and to the content of the result (semantic edges from consolidation).

**Procedural nodes as compressed skill patterns.** Over many successful tool use episodes, consolidation promotes the pattern into a procedural node: `[trigger context] → [action template] → [expected outcome]`. This node is:
- Connected to the episodic memories that produced it (causal edges backward)
- Connected to the contexts where it applies (associative edges to context nodes)
- Connected to other procedural nodes that share context (associative edges between skills)
- Connected to failure episodes that define its limits (negative causal edges)

**The Mirror as value function + curriculum generator.** The Mirror evaluates partial tool-use trajectories (LATS's value function role), recognizes capability gaps (low confidence + high care = curiosity), generates self-directed learning tasks, and encodes meta-memories about what strategies worked.

**Graph traversal as skill retrieval.** Instead of a separate vector search over skill descriptions, finding the right tool is part of normal tree growth. The tree grows from the current context; procedural nodes are connected to the contexts they apply to; the traversal algorithm surfaces them naturally. Historical success rate is encoded in edge weights — well-tested skills have stronger edges to their contexts.

**Causal edges as the permanent record.** Every action creates a causal edge in the matrix: (intention) →caused→ (action) →caused→ (result). These edges persist and compound. Over time, the matrix accumulates a causal map of the agent's interactions with the world. This is Pearl's Layer 2 by construction.

---

## Conclusion

The field of agent tool use has advanced from simple ReAct loops (2023) to multi-step tree search (LATS, 2024) and skill library construction (Voyager, 2023). But a fundamental gap persists across all systems: **tool use history is not integrated with the agent's knowledge structure.** Systems either forget entirely, store in flat retrieval indices, or maintain linear buffers — none connect tool use experiences to each other and to the broader world model via associative graph structure.

The Associative Memory Architecture treats tool use as a first-class cognitive operation that generates three kinds of knowledge:
1. **Episodic** — what happened when I used this tool in this context
2. **Procedural** — when to use this tool and how, distilled from episodic patterns
3. **Causal** — what effects actions have in the world, accumulated through interventional experience

By storing all three in the matrix with typed edges connecting them to contexts, to each other, and to failure episodes, the architecture closes the gap that every surveyed system leaves open: the transition from a system that uses tools to a system that learns — and keeps learning — from using them.

---

## Key Citations

- Yao et al. (2023). "ReAct: Synergizing Reasoning and Acting in Language Models." ICLR 2023. [arXiv:2210.03629](https://arxiv.org/abs/2210.03629)
- Schick et al. (2023). "Toolformer: Language Models Can Teach Themselves to Use Tools." NeurIPS 2023. [arXiv:2302.04761](https://arxiv.org/abs/2302.04761)
- Zhou et al. (2024). "Language Agent Tree Search Unifies Reasoning Acting and Planning in Language Models." ICML 2024. [arXiv:2310.04406](https://arxiv.org/abs/2310.04406)
- Qin et al. (2023). "Tool Learning with Foundation Models." ACM Computing Surveys. [arXiv:2304.08354](https://arxiv.org/abs/2304.08354)
- Qin et al. (2023). "ToolLLM: Facilitating Large Language Models to Master 16000+ Real-world APIs." ICLR 2024 Spotlight. [arXiv:2307.16789](https://arxiv.org/abs/2307.16789)
- Wang et al. (2023). "Voyager: An Open-Ended Embodied Agent with Large Language Models." [arXiv:2305.16291](https://arxiv.org/abs/2305.16291)
- Qian et al. (2023). "CREATOR: Tool Creation for Disentangling Abstract and Concrete Reasoning." [arXiv:2305.14318](https://arxiv.org/abs/2305.14318)
- Lu et al. (2023). "Chameleon: Plug-and-Play Compositional Reasoning with Large Language Models." NeurIPS 2023. [arXiv:2304.09842](https://arxiv.org/abs/2304.09842)
- Qiao et al. (2023). "TaskWeaver: A Code-First Agent Framework." [arXiv:2311.17541](https://arxiv.org/abs/2311.17541)
- Shinn et al. (2023). "Reflexion: Language Agents with Verbal Reinforcement Learning." NeurIPS 2023. [arXiv:2303.11366](https://arxiv.org/abs/2303.11366)
- Packer et al. (2023). "MemGPT: Towards LLMs as Operating Systems." [arXiv:2310.08560](https://arxiv.org/abs/2310.08560)
- Anokhin et al. (2024). "AriGraph: Learning Knowledge Graph World Models with Episodic Memory for LLM Agents." IJCAI 2024. [arXiv:2407.04363](https://arxiv.org/abs/2407.04363)
- Zhou et al. (2025). "GAP: Graph-Based Agent Planning with Parallel Tool Use and Reinforcement Learning." [arXiv:2510.25320](https://arxiv.org/abs/2510.25320)

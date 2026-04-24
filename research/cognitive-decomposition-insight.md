# Cognitive Decomposition: The Core AM Architectural Thesis

*Crystallized 2026-04-06, from discussion on deterministic vs. probabilistic orchestration*

---

## The Insight

An LLM performs many cognitive functions through one mechanism — next-token prediction via weights. Memory, association, reasoning, language, creativity — all compressed into the same probabilistic substrate. This is why it hallucinates: it uses the same mechanism for "what's the capital of France" (should be deterministic) as for "write me a poem" (should be creative). It cannot distinguish between recalling a fact and generating a plausible-sounding one.

Associative Memory doesn't make the LLM more deterministic. It **pulls out the functions that should never have been probabilistic in the first place** and gives them a proper deterministic home.

## The Decomposition

| Cognitive Function | Currently Lives In | AM Moves It To | Why |
|---|---|---|---|
| Memory / recall | LLM weights (unreliable) | Graph nodes/edges (persistent) | Memory shouldn't be probabilistic |
| Association | LLM attention (opaque) | Spreading activation (inspectable) | Associations are structural, not generated |
| Logical inference | LLM reasoning (hallucination-prone) | Graph traversal (deterministic) | "A connects to B connects to C" is a fact, not a guess |
| Language understanding | LLM | LLM (stays here) | This IS what probabilistic is for |
| Creative synthesis | LLM | LLM (stays here) | This IS what probabilistic is for |

## Why This Is Anti-Hallucination by Design

Not by guardrail. Not by validation after the fact. By removing the LLM from the functions where hallucination originates. The LLM can't hallucinate a connection that doesn't exist in the graph, because it never generates connections — the graph is the authority on what exists.

This is Level 3 hybrid integration (shared representation), not Level 1 (external tool call). The graph isn't a tool the LLM calls. It's the reasoning substrate itself.

"LLM as engine, graph as mind." The engine burns fuel (probabilistic, energetic, creative). The mind holds structure (deterministic, persistent, inspectable).

## What the LLM "Believes" Should Ideally Be Deterministic

A key reframe: we think of LLM "beliefs" as emergent properties of weights. But beliefs — things an agent holds to be true — should be deterministic. Either you know Paris is the capital of France or you don't. The graph makes beliefs explicit, inspectable, and correctable. The LLM's job is to interpret those beliefs in context, not to hold them.

## Open Research Questions

### 1. How do you make logical inference deterministic on a graph?

Graph traversal gives you "A is connected to B" deterministically. But inference requires more:
- Transitive reasoning: "A→B and B→C, therefore A→C" — achievable via path finding
- Analogical reasoning: "A:B :: C:?" — harder, requires structural similarity matching
- Abductive reasoning: "We observe X, what explains it?" — requires backward search from effects to causes
- Defeasible reasoning: "A usually implies B, but not when C" — requires exception handling in the graph

Which of these can be made fully deterministic on a graph, and which still need the LLM?

### 2. How do LLMs actually reason?

Understanding what to extract requires understanding the mechanism:
- Attention patterns (what the model "looks at" when reasoning)
- Chain-of-thought as explicit serialization of implicit reasoning
- Circuit-level analysis (mechanistic interpretability) of how facts are retrieved vs. generated
- Where exactly hallucination enters the generation process

### 3. Token economics of graph traversal vs. LLM reasoning

Would graph-based reasoning be cheaper?
- Graph traversal: O(V+E) deterministic computation, no tokens needed for the traversal itself
- LLM reasoning: O(n) tokens for chain-of-thought, each token costs money
- But: the LLM still needs to interpret graph results and formulate queries — those cost tokens
- Key variable: how many reasoning steps can be offloaded to the graph engine?
- If 80% of "reasoning" is actually memory retrieval and association traversal, the savings could be enormous
- If only 20% is, the overhead of maintaining the graph may not pay off

Needs empirical measurement once AM has a working prototype.

### 4. The Inversion: LLM as Tool Call Within a Deterministic Engine

The deepest version of the architecture: the graph engine is the orchestrator, and the LLM is a tool it calls when it hits something it can't handle deterministically. Not "LLM calls graph database" but "graph engine calls LLM."

The graph traverses, activates, infers. When it reaches a node that requires natural language interpretation, creative synthesis, or ambiguity resolution — it invokes the LLM as a bounded subtask. The LLM returns a result. The graph engine continues.

This is the full inversion of current agent architectures. And it may be the right one for AM — if most cognitive work is traversal and association (deterministic), the LLM becomes a specialist called occasionally, not the general contractor managing everything.

**Status:** Idea to explore. Return to this in a future session.

---

## Connection to Broader Landscape

This insight emerged from studying the ATLAS paper (Lwin & Kumar, AIware '26) on deterministic vs. LLM-controlled orchestration, and the broader landscape of hybrid deterministic-probabilistic systems. The same architectural principle — separate what should be deterministic from what should be probabilistic — appears across:

- Workflow engines (Temporal, n8n) for execution control
- SAT/SMT solvers (Z3) for logical verification
- Formal planners (PDDL) for plan search
- State machines (LangGraph, XState) for state management
- Constrained decoding (Outlines) for output shaping

AM applies this principle to cognition itself, which is deeper than any of these. It's not constraining the LLM's behavior — it's replacing the LLM's functions where a deterministic engine would be more appropriate.

Full landscape survey: `research/deterministic-probabilistic-landscape.md`
Full taxonomy: `research/deterministic-probabilistic-taxonomy.md`

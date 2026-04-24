# Deterministic-Probabilistic Task Taxonomy

A structured map of what should be deterministic, what should be probabilistic, and the hybrid seams between them.

---

## The Task Graph

```
                        ┌─────────────────────────┐
                        │    AGENT SYSTEM TASK     │
                        └────────────┬────────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    ▼                ▼                ▼
            ┌──────────┐    ┌──────────────┐    ┌──────────┐
            │ PERCEIVE │    │    REASON     │    │   ACT    │
            └────┬─────┘    └──────┬───────┘    └────┬─────┘
                 │                 │                  │
         ┌───────┴───────┐   ┌────┴─────┐    ┌──────┴──────┐
         ▼               ▼   ▼          ▼    ▼             ▼
    ┌─────────┐   ┌─────────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
    │Parse NL │   │Read     │ │Plan  │ │Verify│ │Execute│ │Retry │
    │(LLM)    │   │Structure│ │(LLM) │ │(DET) │ │(DET)  │ │(?)   │
    └─────────┘   │(DET)    │ └──────┘ └──────┘ └───────┘ └──────┘
                  └─────────┘
```

---

## Deterministic Tasks (Use a tool, not an LLM)

### Execution Control
| Task | Why Deterministic Wins | Best Tools |
|------|----------------------|------------|
| Pipeline sequencing | Fixed order, no judgment needed | Temporal, Airflow, n8n |
| Retry logic | Bounded loops, backoff policies | Temporal, Step Functions |
| State persistence | Crash recovery, replay | Temporal (durable execution) |
| Parallel fan-out/join | Coordination without reasoning | DAG engines, Step Functions |
| Timeout enforcement | Clock-based, binary | Any workflow engine |

### Validation & Verification
| Task | Why Deterministic Wins | Best Tools |
|------|----------------------|------------|
| Schema validation | Type checking, not judgment | Pydantic, Zod, JSON Schema |
| Syntax checking | Grammar rules, not interpretation | tree-sitter, compilers |
| Logical proof | Soundness guarantees | Z3, Lean 4, Coq |
| Constraint satisfaction | Complete search over finite domain | Z3, SAT solvers |
| Test execution | Pass/fail against known oracle | pytest, test harnesses |
| Compliance checking | Rules are enumerable | Drools, rule engines, Z3 |

### Search & Traversal
| Task | Why Deterministic Wins | Best Tools |
|------|----------------------|------------|
| Graph traversal | Known algorithm, known graph | Neo4j Cypher, NetworkX |
| Shortest path | Optimal solution exists | A*, Dijkstra |
| Pattern matching | Regex, AST patterns | ripgrep, tree-sitter |
| Database query | Structured data, exact answers | SQL, Cypher, SPARQL |
| File system operations | Deterministic I/O | OS primitives |

### Computation
| Task | Why Deterministic Wins | Best Tools |
|------|----------------------|------------|
| Math computation | Exact answers exist | Wolfram, NumPy, sympy |
| Statistical analysis | Algorithms are known | pandas, R, scipy |
| Sorting, filtering | Solved problems | Standard libraries |
| Data transformation | Schema-to-schema mapping | ETL tools, jq |
| Encoding/hashing | Deterministic by definition | Standard crypto libraries |

---

## Probabilistic Tasks (Use an LLM, not a tool)

### Understanding
| Task | Why LLM Wins | Notes |
|------|-------------|-------|
| Natural language comprehension | Ambiguity, context, nuance | Core LLM strength |
| Intent classification | Fuzzy boundaries between categories | Unless categories are very rigid |
| Sentiment / tone analysis | Subjective, contextual | |
| Code comprehension | Semantic meaning beyond syntax | tree-sitter gives structure, LLM gives meaning |
| Multimodal interpretation | Images, audio, mixed media | |

### Generation
| Task | Why LLM Wins | Notes |
|------|-------------|-------|
| Code generation | Creative synthesis from specification | Validate output deterministically |
| Text generation | Open-ended, stylistic | |
| Translation (NL) | Context-dependent, idiomatic | |
| Summarization | Requires judgment about salience | |
| Format translation | NL to PDDL, NL to SQL, NL to Cypher | LLM generates, tool executes |

### Planning
| Task | Why LLM Wins | Notes |
|------|-------------|-------|
| Goal decomposition | Novel, open-domain | THE key LLM contribution |
| Strategy selection | Requires world knowledge | But execute the strategy deterministically |
| Prioritization | Judgment under uncertainty | |
| Creative problem-solving | Novel combinations | When deterministic path fails |

---

## The Hybrid Seams (Where Both Meet)

These are the critical integration points — tasks that need BOTH.

### Pattern 1: LLM Generates, Tool Verifies (Generate-and-Check)
```
    NL Input → [LLM: generate artifact] → [Tool: verify/execute] → feedback loop
                        ↑                           │
                        └───── counterexample ───────┘
```

| Domain | LLM Generates | Tool Verifies | Result |
|--------|--------------|---------------|--------|
| Code modernization | Python from COBOL | Test harness runs tests | ATLAS paper |
| Loop invariants | Candidate invariants | Z3 checks validity | 100% vs 80% |
| Planning | PDDL problem spec | Fast Downward solves | Optimal plans |
| Compliance | SMT constraints from statutes | Z3 checks consistency | Provable compliance |
| Schema enforcement | JSON output | Pydantic validates | Auto-retry on failure |
| Financial regulation | Lean 4 code | Type-checker verifies | Binary pass/fail |

### Pattern 2: Tool Structures, LLM Interprets (Structure-and-Synthesize)
```
    Query → [Tool: structured retrieval] → [LLM: interpret results] → Response
```

| Domain | Tool Provides | LLM Interprets | Result |
|--------|-------------|----------------|--------|
| Knowledge graphs | Cypher traversal results | Natural language synthesis | GraphRAG |
| Code understanding | AST + call graph | Semantic explanation | tree-sitter + LLM |
| Research | Paper search results | Synthesis and analysis | Semantic Scholar + LLM |
| Math reasoning | Wolfram computation | Explanation in context | Wolfram + LLM |
| MWM | Spreading activation paths | Intent interpretation | MWM architecture |

### Pattern 3: LLM Designs, Tool Executes Forever (Design-Once-Run-Many)
```
    Description → [LLM: design system] → [Deterministic system runs] → (LLM not needed)
```

| Domain | LLM Designs | Tool Executes | Key Insight |
|--------|------------|---------------|-------------|
| Agent scaffolding | FSM structure | XState/statechart | MetaAgent: LLM designs the machine |
| Workflow design | n8n workflow | n8n engine | One design call, infinite cheap runs |
| HTN planning | New task methods | HTN planner | ChatHTN: learned methods are reusable |
| Rule generation | Business rules from NL | Rule engine | Drools: LLM writes rules, engine enforces |
| Prompt optimization | Optimized prompt programs | DSPy compiled prompts | Compile once, deploy cheaply |

### Pattern 4: Deterministic Default, LLM Escalation (Try-Cheap-First)
```
    Task → [Deterministic attempt] → Success? → Done
                                   → Fail? → [LLM creative recovery] → retry
```

This is the hybrid the ATLAS paper recommends but didn't test. The deterministic path handles the 80% case cheaply. The LLM handles the 20% that requires improvisation. This is also how Claude Code's hook system works — deterministic rules gate behavior, LLM handles novel situations.

---

## The Deeper Architecture Question

### Can You Build Deterministic Logic INTO an LLM System?

Three levels of integration, from shallowest to deepest:

**Level 1: External tool calls (current state of practice)**
LLM calls Wolfram, Z3, Neo4j as external tools. Clean separation. The MCP protocol formalizes this interface. Works today.

**Level 2: Interleaved generation (emerging)**
Constrained decoding (Outlines, llguidance) embeds deterministic grammar enforcement INTO the token generation process. The LLM's output space is shaped by formal rules at each step. Not a post-hoc check — the invalid tokens are never generated.

**Level 3: Hybrid architecture (research frontier)**
The graph/logic engine is not a tool the LLM calls — it IS part of the reasoning architecture. The LLM provides the semantic substrate; the deterministic engine provides the logical substrate. They share representations.

This is where MWM lives: the graph is not a database the LLM queries. The graph IS the world model. The LLM interprets intent and synthesizes output, but the reasoning — spreading activation, path finding, logical inference — happens in the graph engine deterministically. The LLM never hallucinates a connection that doesn't exist in the graph, because the graph is the authority on what connections exist.

### The Wolfram Extrapolation

Wolfram Alpha is the existence proof that a deterministic computation engine can handle an enormous range of structured reasoning when paired with a language interface. The question: what if you took that principle and extended it beyond mathematics?

Wolfram handles: arithmetic, algebra, calculus, statistics, physics, chemistry, geography, linguistics, music theory, nutrition, finance...

What it can't handle: anything requiring world knowledge that isn't in its structured knowledge base, anything requiring judgment, anything requiring creative synthesis.

The LLM fills exactly those gaps. So the architecture becomes:

```
    ┌─────────────────────────────────────────┐
    │           REASONING SYSTEM              │
    │                                         │
    │  ┌───────────────┐  ┌───────────────┐   │
    │  │ Deterministic │  │ Probabilistic │   │
    │  │ Core          │◄─┤ Shell         │   │
    │  │               │──►               │   │
    │  │ - Math engine │  │ - NL parsing  │   │
    │  │ - Logic engine│  │ - Generation  │   │
    │  │ - Graph engine│  │ - Planning    │   │
    │  │ - Rule engine │  │ - Creativity  │   │
    │  │ - State mgmt  │  │ - Judgment    │   │
    │  └───────────────┘  └───────────────┘   │
    │                                         │
    └─────────────────────────────────────────┘
```

The inversion you described: the deterministic engine is the CORE, the LLM is the SHELL. The core guarantees correctness, consistency, and reproducibility. The shell provides the interface, the creativity, and the handling of novel situations.

This is arguably what a well-designed agent system already IS — but most current systems put the LLM at the center and the tools at the periphery. Flipping that relationship is the architectural insight.

---

## Open Questions for Further Research

1. **What's the minimum viable deterministic core?** Graph engine + rule engine + math engine covers a huge surface area. Is there a minimal set?

2. **How do you handle the boundary?** When the deterministic core can't answer, how does it cleanly hand off to the LLM? When the LLM generates something, how does the core validate it before accepting?

3. **Can the deterministic core learn?** MetaAgent shows LLMs can design FSMs. Could an LLM progressively build out the deterministic core's rule base, converting probabilistic patterns into deterministic rules as confidence increases?

4. **What's the Wolfram-for-logic?** Wolfram solved math. What's the equivalent deterministic engine for common-sense reasoning, causal inference, or social dynamics? (This is arguably what AM is trying to be for memory and knowledge.)

5. **Does the architecture change how we think about hallucination?** If the deterministic core is the authority on facts and logic, the LLM can only hallucinate in the interpretation layer. Hallucination becomes a bounded problem rather than a pervasive one.

---

## Source Papers and Frameworks

### Papers
- Lwin & Kumar, "Deterministic vs. LLM-Controlled Orchestration" (AIware '26)
- Qiu et al., "Blueprint First, Model Second" (arXiv:2508.02721)
- Mazzolenis & Zhang, "Agent WARPP" (arXiv:2507.19543, ICML '25)
- Rath, "Agent Drift" (arXiv:2601.04170)
- "Type-Checked Compliance: Lean-Agent Protocol" (arXiv:2604.01483)
- Luong, "Ontology-Constrained Neural Reasoning" (arXiv:2604.00555)
- "Agent Behavioral Contracts" (arXiv:2602.22302)
- "MetaAgent: FSM-based Multi-Agent Systems" (arXiv:2507.22606, ICML '25)
- "LLMs as Planning Formalizers" (arXiv:2503.18971, ACL '25)
- "MyAntFarm Multi-Agent Incident Response" (arXiv:2511.15755)
- "CMCTS: Constrained MCTS for Math Reasoning" (arXiv:2502.11169)
- "ReAcTree: Hierarchical Agent Trees" (arXiv:2511.02424)
- "Codebase-Memory: tree-sitter KG via MCP" (arXiv:2603.27277)
- "Bridging LLMs and Symbolic Solvers via MCP" (SAT 2025, Dagstuhl)
- Z3 + LLM loop invariant generation (arXiv:2508.00419)
- Microsoft Agent Governance Toolkit (April 2, 2026)
- Salesforce Agentforce "Five Levels of Determinism"

### Frameworks
- Temporal (temporal.io) — durable execution
- LangGraph — graph-based agent orchestration
- n8n — visual workflow DAG with AI nodes
- DSPy — compiled prompt optimization
- XState / statelyai/agent — FSM + LLM
- Outlines / llguidance / XGrammar — constrained decoding
- Pydantic AI / Instructor — structured output validation
- Z3 — SMT solving
- tree-sitter — deterministic code analysis
- Neo4j — graph database for knowledge
- Drools — business rule engine
- Wolfram — deterministic computation engine

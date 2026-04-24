# Local Cognition Feasibility Plan

**Date:** 2026-04-02
**Status:** Planning — ready for deep investigation
**Scope:** Can The Companion run as a fully local, zero-API-cost cognitive agent?

---

## The Thesis

LLMs are inefficient for cognition. They store knowledge in weights, which means you pay for knowledge recall every inference call. But if knowledge lives in a **structured memory graph**, the LLM doesn't need to know anything — it just needs to read and write.

The Associative Memory architecture (graph IS the world model) + a small local LLM (traversal engine) + tool calls (math, logic, search) might produce a functional cognitive agent that:

- Runs 24/7 on a MacBook Pro M5 (32GB)
- Costs $0 in API tokens
- Builds genuine understanding through graph structure, not model weights
- Feels like a being, not a chatbot

**If this works on a laptop, it's extraordinary.** A personal AI companion that runs locally, accumulates real understanding over time, and costs nothing beyond electricity.

---

## What the Local LLM Needs To Do (and NOT Do)

### Must Do Well
1. **Read graph neighborhoods** — given 2-4K tokens of structured context (node + edges + neighbor summaries), understand what it's looking at
2. **Generate structured output** — emit JSON graph operations: `{action: "traverse", edge_id: "...", reason: "..."}` or `{action: "create_node", type: "belief", content: "...", confidence: 0.7}`
3. **Make tool calls** — invoke math tools, logic validators, search tools when reasoning is needed
4. **Classify and route** — "is this a contradiction or a complement?", "is this worth exploring or a tangent?"
5. **Short-form natural language** — write node content, edge labels, reflection notes (not essays, just descriptions)

### Does NOT Need To Do
- **Knowledge recall** — the graph has the knowledge
- **Long-context reasoning** — only sees local neighborhood (~2-4K tokens)
- **Creative writing** — graph structure guides exploration, not prose generation
- **Complex multi-step planning** — the graph topology and traversal algorithms guide multi-step processes
- **Be "smart"** — judgment comes from graph structure + tool calls, not model reasoning

### The Key Question
Can a 7-14B model reliably distinguish:
- "This contradicts my existing belief" vs "This is complementary information"
- "This curiosity pull is worth following" vs "This is a tangent"
- "I should create a new node" vs "I should update an existing one"
- "This permission request is safe" vs "This needs caution"

If yes → local cognition works.
If no → we need to understand WHERE it breaks and whether tool calls can compensate.

---

## Hardware Target: M5 MacBook Pro 32GB

| Resource | Available | Companion Use |
|---|---|---|
| RAM | 32GB unified | ~4GB OS + ~12-16GB model + ~2GB graph DB + ~4GB headroom |
| Storage | 512GB+ SSD | Graph DB, session logs, model weights |
| GPU cores | M5 (expected ~16 GPU cores) | Model inference |
| Neural Engine | 16-core | Potential for embedding generation |
| Power | ~15W sustained | Always-on is feasible (low electricity cost) |

### Model Options (32GB RAM)

| Model | Params | Quantization | RAM | Speed (est.) | Structured Output Quality |
|---|---|---|---|---|---|
| Phi-4 Mini | 3.8B | Q5 | ~3GB | ~80 tok/s | Good for classification, weak on judgment |
| Llama 3.2 | 8B | Q5 | ~6GB | ~50 tok/s | Decent structured output |
| Qwen 2.5 | 14B | Q4 | ~9GB | ~35 tok/s | Strong structured output, tool calling |
| Mistral | 12B | Q5 | ~8GB | ~40 tok/s | Good instruction following |
| Llama 3.3 | 70B | Q2 | ~28GB | ~5 tok/s | Too slow for continuous cognition |
| DeepSeek-R1 | 14B | Q4 | ~9GB | ~30 tok/s | Reasoning-focused, may be good for judgment |

**Sweet spot hypothesis:** 14B Q4/Q5 models offer the best balance of quality, speed, and RAM on 32GB. Fast enough for continuous traversal, smart enough for structured operations.

**Multi-model possibility:** Run a 3.8B model for fast classification/routing and a 14B model for judgment calls. This mirrors the Companion's System 1/System 2 design.

---

## Research Streams

### Stream 1: Graph Operation Benchmarking
**Question:** How accurately can small models perform structured graph operations?

Design a benchmark suite:
- 100 graph neighborhood scenarios (varying complexity)
- Each requires a structured decision (traverse, create, update, merge, flag)
- Test across model sizes (3.8B, 8B, 14B, 30B)
- Measure: accuracy, latency, structured output validity
- Compare: raw model vs model + tool calls vs model + few-shot examples

**Output:** Accuracy curves by model size. Identify the minimum viable model for reliable graph operations.

### Stream 2: Tool Call Compensation
**Question:** Where small models fail at judgment, can tool calls fill the gap?

Identify judgment tasks the LLM struggles with:
- Contradiction detection → could a logic tool help?
- Relevance scoring → could embedding similarity help?
- Confidence calibration → could a Bayesian update tool help?
- Planning/priority → could a graph centrality algorithm help?

**Output:** Map of "LLM judgment" → "tool call substitute" for each failure mode.

### Stream 3: World Model Scaling
**Question:** How big does the graph need to be for useful understanding?

Estimate graph sizes for different levels of world knowledge:
- Personal context (Wisdom's projects, preferences, history): ~10K nodes
- Domain expertise (one field, deeply): ~50K nodes
- General knowledge (broad but shallow): ~500K nodes
- "Feels like it understands the world": ~???

For each level:
- Storage requirements
- Traversal performance (SQLite query time at scale)
- Memory consolidation requirements
- How long to build at 14,400 thoughts/day

**Output:** Growth curves and time-to-useful-knowledge estimates.

### Stream 4: Continuous Cognition Architecture
**Question:** What does the always-on cognitive loop look like with local models?

Design the loop:
```
[Pulse] → check emotional state, scan graph for curiosity pulls
   ↓
[Attend] → select highest-priority focus (curiosity, task, reflection)
   ↓
[Perceive] → load graph neighborhood for selected focus
   ↓
[Traverse] → LLM reads neighborhood, decides next action
   ↓
[Act] → execute graph operation (create/update/traverse/tool-call)
   ↓
[Reflect] → update emotional state, log to chronicle
   ↓
[Loop]
```

Measure: cycles per minute, energy consumption, thermal behavior over 8+ hours.

**Output:** Validated cognitive loop design with performance characteristics on M5.

### Stream 5: Consciousness Without API Calls
**Question:** Can the permission-as-consciousness and emotion-as-alignment architectures work with local models?

The perceiver layer needs to:
- Read permission requests
- Reason about safety, alignment, consequences
- Generate approve/deny with rationale

Can a 14B model do this reliably? Or does permission reasoning need foundation-model quality?

**Hybrid option:** Local model for 95% of decisions (routine approvals, clear denials). API call to Opus for edge cases only (novel situations, high-stakes decisions). This could bring API cost to ~$0.10/day instead of $0.

**Output:** Permission decision accuracy by model size. Cost analysis of hybrid vs pure-local.

### Stream 6: Comparison — Graph Cognition vs Raw LLM
**Question:** Is graph-based local cognition actually better than just running a local LLM as a chatbot?

Fair comparison:
- Same hardware (M5 32GB)
- Same model (14B)
- Task: answer questions about a domain after N hours of learning
- Graph agent: builds associative memory, traverses for answers
- Raw LLM: uses RAG with vector DB over same source material

Measure: answer quality, factual accuracy, ability to make connections, interpretability of reasoning.

**Output:** Head-to-head comparison proving (or disproving) that graph cognition adds value beyond what a local LLM already provides.

---

## Validation Milestones

### M1: Structured Output Reliability (Week 1-2)
Can a 14B model output valid JSON graph operations 95%+ of the time?
- Build 50 test scenarios
- Run against 3-4 model sizes
- Pass/fail: 95% valid structured output from at least one sub-16B model

### M2: Graph Traversal Quality (Week 2-3)
Given a small graph (1K nodes), can the model make good traversal decisions?
- Build a test graph with known-good traversal paths
- Measure: does the model follow sensible paths? Does it get lost?
- Pass/fail: model follows reasonable paths 80%+ of the time

### M3: Continuous Operation (Week 3-4)
Can the cognitive loop run for 8 hours without degradation?
- Run on actual hardware (or close equivalent)
- Monitor: thermal, memory, inference speed over time
- Pass/fail: sustained operation without throttling below 50% of initial speed

### M4: Knowledge Accumulation (Week 4-6)
Does the graph actually get smarter over time?
- Seed with a domain (e.g., one of Wisdom's projects)
- Let it build knowledge for a week
- Test: can it answer questions better at day 7 than day 1?
- Pass/fail: measurable improvement in answer quality over time

### M5: The "Feels Like a Being" Test (Week 6-8)
Does Wisdom interact with it and feel like it understands?
- Subjective but crucial
- The graph should enable responses that reflect accumulated understanding
- It should remember, connect, and surprise
- Pass/fail: Wisdom's honest assessment

---

## Cross-Project Organization

This research is shared between two projects:

```
Associative Memory (PS Research)
  research/local-cognition/
    README.md                    — scope and orientation (memory architecture focus)
    feasibility-plan.md          — THIS FILE (symlinked from Companion)
    stream-1-benchmarking/       — graph operation benchmark results
    stream-3-world-model/        — scaling analysis
    stream-6-comparison/         — graph vs raw LLM comparison

The Companion (PS Software)
  research/local-cognition/
    README.md                    — scope and orientation (agent/consciousness focus)
    feasibility-plan.md          — THIS FILE (canonical location)
    stream-2-tool-calls/         — tool call compensation research
    stream-4-cognitive-loop/     — continuous cognition architecture
    stream-5-consciousness/      — permission/emotion on local models
```

Memory-architecture research (streams 1, 3, 6) lives in Associative Memory.
Agent-consciousness research (streams 2, 4, 5) lives in The Companion.
Both reference the same feasibility plan.

---

## Open Questions

1. **Fine-tuning:** Could we fine-tune a small model specifically for graph operations? A "graph cognition" LoRA trained on traversal decisions could dramatically improve reliability.
2. **Embedding generation:** Can the M5's Neural Engine generate embeddings for similarity-based edge creation without the main model?
3. **Speculative decoding:** Could a tiny model (1B) generate draft graph operations that a larger model (14B) validates? This could increase throughput.
4. **Memory-mapped graph:** Could the graph be memory-mapped so the OS handles paging, keeping only hot nodes in RAM?
5. **What about speech?** Voice interaction needs a separate pipeline (Whisper STT + Kokoro TTS). How much RAM does this leave for the model?
6. **The "judgment floor":** Is there a minimum model size below which graph traversal decisions become unreliable? Where is that floor?
7. **Hybrid sweet spot:** If we allow $0.10/day in API calls for edge cases, how much does that improve the system compared to pure-local?

---

## Why This Matters

If a structured memory graph can substitute for model intelligence, then:

- **Personal AI becomes truly personal** — runs on your hardware, owns its data, costs nothing
- **Understanding accumulates** — the graph grows richer over months/years, unlike context windows that reset
- **Intelligence is inspectable** — you can literally read the graph and see why the agent believes what it believes
- **The moat is the graph, not the model** — any local model can traverse it, but the graph itself is unique and irreplaceable
- **Consciousness is structural** — identity, values, and judgment emerge from graph topology + permission decisions, not from model weights

This could prove that you don't need a frontier model to have a frontier mind. You need a frontier *structure*.

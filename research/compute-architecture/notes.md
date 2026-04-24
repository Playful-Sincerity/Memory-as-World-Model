# Compute Architecture for Memory as World Model

Voice notes captured 2026-04-03. These are early-stage ideas about designing hardware and software architectures optimized specifically for the AM graph architecture.

## Core Premise

Once the full AM architecture is developed, we should design compute architectures that are perfectly optimized around it — not just run AM on general-purpose hardware, but build systems where the hardware itself reflects the graph's structure.

## Two-System Design

The architecture has two distinct processing systems, both operating within the memory structure:

### System A: Memory Engine (LLM-based)
- Optimized for **reading, writing, and exploring** the memory graph
- Minimal bias — doesn't carry pretrained world knowledge the way current LLMs do
- Pre-loaded with understanding of all major human languages (the "what is understanding?" question — maybe just structural/syntactic competence, not world knowledge)
- Weights and biases exist to serve reading the memories themselves, not to store knowledge independently
- The system should NOT rely on LLM weights for factual knowledge — it builds its own knowledge base through exploration

### System B: Logic/Reasoning Engine
- Optimized for **logic, thinking, and proposing**
- Works alongside the memory engine within the same memory structure
- Connected to a **pure math engine** for logic-based calculations (like a human using a calculator)
- Ideally the math/logic capability is baked into the network architecture, not bolted on

## Key Question: Can Reasoning Emerge from Memory Structures?

If the memory graph is rich enough — with hierarchical trees, regional nodes, association networks — can reasoning itself emerge from traversal patterns? Or does reasoning require a separate mechanism that reads the graph and proposes?

The current hypothesis: reasoning needs its own engine, but that engine's "thinking" should be grounded in what the memory graph contains, not in pretrained weights.

## Prior Art to Find

Wisdom has prior notes about computing architecture inventions involving:
- Node-based compute architectures
- Regional nodes and hierarchy nodes
- Custom hardware designs for graph-like structures

**TODO:** Search Inventions Portfolio (`~/Wisdom Personal/Inventions Portfolio/`) and ChatGPT Archive for these earlier ideas.

## Connection to Local Cognition Research

The `local-cognition/` research direction asks: can a small local model (14B) serve as the engine while the graph provides the intelligence? The compute architecture direction goes further: what if the hardware itself is designed around the graph?

Spectrum of ambition:
1. **Near-term:** Local LLM + graph on commodity hardware (local-cognition research)
2. **Medium-term:** Software architecture with separated memory-engine and logic-engine
3. **Long-term:** Custom compute hardware optimized for graph traversal and memory operations

## Open Questions

1. What does "understanding language" mean without world knowledge? Is there a minimal language model that has syntax/grammar/semantics but no factual beliefs?
2. How do you prevent the memory engine from developing biases through its training, even if you strip pretrained knowledge?
3. What's the interface between the logic engine and the memory graph? How does it "propose" something back to the graph?
4. Could the math engine be a differentiable logic module inside the network, or does it need to be a symbolic system called as a tool?
5. What existing neuromorphic or graph-processing hardware (e.g., Intel Loihi, Graphcore IPU) comes closest to what we'd want?

---
timestamp: "2026-04-11"
category: idea
related_project: Associative Memory
---

# Architecture Deep Notes — Compute, Models, Compression, Bias

## Two-Model Architecture
You have an LLM optimized for reading, writing, and exploring. Then you have another tool optimized for logic, thinking, and proposing. Both operate within the memory structure cohesively. The weights and biases of both systems are simply enablers for reading the memories themselves. Connected to a pure math engine for logic-based calculations (like a human uses a calculator). Ideally somehow baked into the network.

## Knowledge Autonomy
If the system wants to say something about a subject or answer a question, it needs to learn about that subject and build its own knowledge base. It can't rely on the LLM's training data. The knowledge must be grounded in explored and stored memories.

## Multimodal Memory
AM could store anything as a memory, not just text. Uses a multimodal model to read its trees, or multiple very small models. One of the most important questions: how to make sure it's not taking the biases of the model itself? How to make it a "this is what happened" model without value associations? It's going to be highly variable depending on which model you used to seed it.

## Bias Prevention
Critical design constraint: how do you ensure the model is just a good recorder ("this is what happened") without putting value associations or biases into memories? The seeding model's biases will propagate. This needs an architectural solution, not just fine-tuning.

## Small Model + Big Context
Really small model with really big context window? Could this be the right architecture for the memory reader?

## Custom Compute Architectures
After the full AM architecture is developed, think about building compute architectures perfectly optimized around it. Hardware designed for memory graphs, not general-purpose tensor operations.

## Computing Architecture Inventions
Find the earlier notes about computing architecture with nodes, regional nodes, hierarchy nodes, etc. Those ideas may map to AM's graph structure.

## Memory Compression in a Compiler
Memory compression algorithms implemented at the compiler level. Procedural compression based on associated value — more valuable memories store full fidelity (video, images), gradual abstraction layers compress less valuable ones.

## LCM Study
Study Large Concept Models (LCM). Relevant to how AM structures meaning.

## Zig Memory Graph
Explore Zig as an implementation language for the memory graph. Zig's memory control and performance characteristics may be ideal for graph operations.

## Unified Information Framework
A single parse for all modes of perception and memory. These are the nodes and connections in the matrices. Store video and image memories with descriptors. Memory archiving system, automated. An AI should be a readable file system with multidimensional linking between files.

## Big O Awareness
How efficient the code is matters deeply for AM — graph operations at scale need to be optimized.

## Arbitrator Agent
Arbitrator agent that asks sub-agents for the metaphase sections and their rationale when reconciling differences. Relevant to AM's multi-model architecture.

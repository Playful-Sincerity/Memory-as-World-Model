# Memory as World Model (MWM)

A memory architecture for AI agents where **the memory structure IS the interpretable world model**. The graph replaces the role that pretrained weights currently play in forming beliefs and understanding. LLM as traversal engine, graph as mind.

## Core Thesis

Today's LLMs bundle three things into one weight space: language, knowledge, and reasoning. Interpretability in that substrate is therefore forensic — reverse-engineering features and circuits in a system that was never designed to be read.

MWM separates the three components. The LLM becomes a traversal and reading engine, optimized for navigating a structured graph and rendering language from it. The graph is the agent's world model — beliefs as explicit nodes with confidence, evidence chains, and timestamps; associations as linguistic edges formed through co-occurrence. A separate reasoning tool handles logic and math. No weights carrying beliefs. Three distinct components, each doing what it's good at.

The question *"why does this agent believe X?"* answers by tracing a path in the graph, not by training a probe against the weights.

## Key Principles

- **Navigation, not retrieval** — agents traverse their experiential graph, not search a database
- **LLM as engine, graph as mind** — the LLM reasons at local neighborhoods; the graph carries the belief structure
- **Epistemic humility + curiosity** — when the path doesn't exist, the agent is curious, not silent
- **Interpretable by design** — you can read why the agent believes what it believes by tracing the graph
- **Anti-hallucination by design** — claims must trace back to experiential nodes
- **Action-serving** — the graph exists to support aligned action, not just retrieval

## Architecture — Three Planes

- **Matrix** — the full experiential graph (long-term memory + world model)
- **Trees** — the active working context, growing and shrinking through spreading activation
- **Mirror** — the persistent self-observation layer holding values and self-model

## The Search for a Unified Substrate

MWM's interpretability promise only fully holds when the substrate is unified across modalities. An agent whose life includes text *and* images *and* audio *and* sensor streams *and* inner states (imaginations, dreams, plans) has beliefs that cross modality boundaries. If those beliefs live in modality-specific opaque stores glued together by shared-latent projections, the interpretability ends precisely at the modality boundaries where the most interesting beliefs live.

What MWM commits to instead is a *unified file structure for the memory store* — a single substrate in which a text memory, an image memory, an audio memory, a sensor reading, and an imagined scene are all first-class nodes of the same kind, readable by both the model and a human, connected by the same kinds of edges. Every node's canonical layer is natural-language description; modality-specific data (pixel pointers, waveform pointers, modality-native embeddings) hang off the readable layer rather than replacing it. Cross-modal edges are first-class. The graph topology is modality-agnostic; only the node content is modality-specific.

This is a major research direction in its own right. Full articulation at [design/multimodal-unified-substrate.md](design/multimodal-unified-substrate.md); elevated in the paper at Section 8.

## Status

Research / design phase. Five+ rounds of structured research complete. Design documents and vision established. No implementation code yet. Target: a working implementation plus a companion implementation paper.

## Project Structure

- [vision.md](vision.md) — core thesis and philosophy
- [design/](design/) — architecture, data model, traversal, pruning, consolidation, value-system
- [research/](research/) — multi-round research findings (50+ systems surveyed across audits, Round 3/4/5/6 synthesis)
- [research/local-cognition/](research/local-cognition/) — whether MWM can run on local LLMs
- [journal/](journal/) — development and evolution journal
- [diagrams/](diagrams/) — visual architecture

## Part of The Synthetic Sentiences Project

MWM is the memory subsystem of [The Synthetic Sentiences Project](https://github.com/Playful-Sincerity/SSP-Synthetic-Sentiences-Project) — a broader research program on the architecture of synthetic sentiences (AI entities whose understanding is interpretable, earned, and designed for alignment). This repo is the focused memory architecture; SSP is the program it sits within.

The other subsystems of SSP — earned conviction, value-aligned modulation, mirror architecture, imagination-first perception (GRP), epistemic prosody, sleep/dream cycles, action, trees — all build on, modulate, or consume MWM's graph. MWM is the substrate. SSP shows how that substrate supports a full sentience.

## Playful Sincerity Research

Part of [Playful Sincerity Research](https://github.com/Playful-Sincerity). The full ecosystem is at [~/Playful Sincerity/](https://github.com/Playful-Sincerity) (mostly local; progressively going public).

I now have comprehensive research across all seven areas. Let me compose the full assessment.

---

# Rigorous Assessment: Can the Associative Memory Architecture Constitute General Intelligence?

## 1. CHOLLET'S FRAMEWORK: Skill-Acquisition Efficiency

Chollet defines intelligence as **"skill-acquisition efficiency over a scope of tasks, with respect to priors, experience, and generalization difficulty."** The key insight is that you can "buy" arbitrary skill levels by giving a system unlimited priors (pretrained weights) or unlimited experience (training data), but this masks the system's actual generalization power. True intelligence is what remains when you control for those inputs.

### How the Architecture Scores

**Strengths against Chollet's criteria:**
- The architecture explicitly separates priors (the LLM's pretrained weights) from experience (the memory graph). This is structurally aligned with Chollet's framework -- you can literally measure what the graph learned versus what the LLM already knew.
- Epistemic humility is built in: the agent can sense the density of its graph in a region, distinguishing "I know I don't know" from "I don't know what I don't know." This is a genuine form of self-aware skill assessment.
- The cold-start property (empty graph = maximum curiosity) mirrors Chollet's emphasis on what a system can learn from minimal experience.

**Critical weaknesses against Chollet's criteria:**
- **Chollet's definition demands novel task acquisition.** The architecture acquires new *knowledge* from experience efficiently -- it builds associations, consolidates episodic to semantic memory, and grows richer representations over time. But acquiring a new *skill* (a new procedure, a new way of reasoning, a new problem-solving strategy) is fundamentally different from acquiring new associations. The architecture has no clear mechanism for learning a new *algorithm* or *reasoning procedure* from experience. The LLM provides the reasoning; the graph provides the knowledge. If the LLM cannot already reason in a particular way, the graph cannot teach it to.
- **The ARC criterion is devastating.** ARC tasks require deducing abstract transformation rules from 2-3 examples and applying them to novel inputs. This is pure procedural generalization. The architecture's Hebbian co-occurrence learning builds associative connections, not procedural abstractions. It can learn that A and B are related, but it cannot learn that "when you see pattern X, apply transformation Y" -- unless the LLM already knows how to do that kind of reasoning.
- **Generalization difficulty.** Chollet emphasizes that intelligence manifests when generalization difficulty is high -- when the system must extrapolate far beyond its priors and experience. The architecture generalizes within the *associative* domain well (unexpected connections, serendipitous bridges between distant memories), but this is a specific type of generalization, not the broad skill-acquisition efficiency Chollet demands.

**Honest score against Chollet: Low-to-moderate.** The architecture is an excellent knowledge-acquisition system with genuine interpretability advantages, but it does not demonstrate the procedural skill-acquisition efficiency that Chollet's definition requires. It acquires *content*, not *capability*.

---

## 2. LEGG & HUTTER'S FORMAL DEFINITION

Legg and Hutter define universal intelligence as: **an agent's expected performance across all computable environments, weighted by the inverse of each environment's Kolmogorov complexity** (simpler environments count more). Mathematically: Upsilon(pi) = Sum over all environments mu of [ 2^(-K(mu)) * V_mu^pi ], where K(mu) is the Kolmogorov complexity of environment mu and V_mu^pi is the expected total reward of agent pi in environment mu.

### How the Architecture Scores

**The fundamental issue:** This definition demands performance across *all* computable environments. The architecture is designed for a specific type of environment: one where an agent receives experiential input (primarily linguistic), stores it, forms associations, and uses those associations to reason and respond. It is not designed to, and cannot, play Go, control a robot, prove theorems in novel formal systems, or navigate a 3D environment.

**What limits it:**
- The architecture depends on an LLM as its reasoning engine. Its upper bound on any task is the LLM's capability on that task, given perfect context. It can never exceed the LLM's reasoning ceiling; it can only improve the *knowledge context* the LLM reasons from.
- The Legg-Hutter measure weights simpler environments more heavily. For simple conversational and knowledge-retrieval environments, the architecture could score well. But the measure spans all computable environments, and the architecture has no mechanism for many of them (spatial navigation, physical manipulation, mathematical discovery of new formalisms).
- The architecture cannot modify its own reasoning process. It can modify what it knows (the graph) but not how it thinks (the LLM). A truly universal agent in the Legg-Hutter sense would need to adapt its reasoning procedures, not just its knowledge base.

**Honest score against Legg-Hutter: Low.** The architecture operates in a narrow band of computable environments (language-mediated, associative, knowledge-intensive). It is not a universal agent and does not claim to be. This framework is probably the wrong yardstick for what the architecture is actually attempting.

---

## 3. THE STRONGEST ARGUMENTS AGAINST THIS BEING AGI

### 3a. The Connectionist Argument

**Steel-manned objection:** "Graph-based systems represent knowledge as discrete nodes and explicit edges. But the power of neural networks comes from *distributed representations* -- where a concept like 'cat' is not a single node but a pattern across thousands of dimensions. These distributed representations capture subtle gradients of meaning, handle ambiguity naturally, and enable graceful degradation. An explicit graph can represent 'ice cream is connected to motorcycles via the road trip,' but it cannot represent the rich, graded, multi-dimensional similarity space that emerges from distributed encoding. You're trading the most powerful representational innovation in AI history for interpretability."

**This objection is strong.** The architecture explicitly chooses interpretable, discrete, linguistically-labeled associations over opaque distributed representations. The vision document states this clearly: "The association isn't hidden in a weight matrix -- it's a linguistic, interpretable link." This is a genuine tradeoff, and the connectionist is right that distributed representations capture things explicit graphs cannot. The subtle shading between concepts, the way context shifts meaning continuously, the ability to blend representations in novel ways -- these are properties of high-dimensional distributed spaces that graphs do not naturally possess.

**Partial response:** The architecture does not eliminate distributed representations -- it delegates them to the LLM. The graph provides structured knowledge; the LLM provides distributed reasoning over that structure. The question is whether this division loses something essential. I believe it does: the LLM's distributed representations are generic (pretrained), while the graph's associations are personal (experiential). But the *reasoning over* those personal associations still runs through generic representations. A deeply personal distributed representation would be something different -- and the architecture cannot produce one.

### 3b. The Embodied Cognition Argument

**Steel-manned objection:** "Understanding requires grounding in sensorimotor experience. You cannot truly understand 'heavy' without having lifted something, 'red' without having seen red, 'warm' without having felt warmth. This architecture processes linguistic tokens and forms associations between them, but every node in the graph is ultimately grounded in language, not in physical experience. Harnad's symbol grounding problem applies directly: the graph's symbols only refer to other symbols. Your agent can talk about the world fluently without understanding it at all. Lakoff showed that even abstract concepts are grounded in bodily metaphors ('understanding is grasping,' 'time is motion'). Without a body, you have sophisticated symbol manipulation, not genuine understanding."

**This objection has real force but is not fatal.** Recent research (arxiv 2601.17588) argues that "intelligence requires grounding but not embodiment" -- that what matters is a mechanism for prescribing externally consistent meaning to symbols, and interaction with an environment (even a non-physical one) can provide this. The architecture's multimodal design (nodes can be images, sounds, sensor readings) and its interaction with the world through tools, APIs, and user conversations provide *some* grounding. But it is undeniably a weaker form of grounding than embodied experience. The architecture's "experiential distance" (PMI from co-occurrence) is experiential within a linguistic/digital environment, not a physical one.

**The honest position:** This is a real limitation that bounds what the architecture can achieve but does not invalidate it. Many valuable forms of intelligence operate without full embodiment. The architecture can be grounded in digital experience (tool use, API interaction, user feedback) even if not in physical experience.

### 3c. The Scaling Laws Argument

**Steel-manned objection:** "The empirical evidence is that scaling model parameters and training data produces reliable, predictable improvements in capability. OpenAI's o3 scored 87.5% on ARC-AGI-1 -- the very benchmark designed to test Chollet's definition of intelligence -- through scaling and test-time compute, not through novel architecture. o3 went from 5% (GPT-4o) to 87.5% in a single generation. The Kaplan and Chinchilla scaling laws show a direct, predictable relationship between compute and capability. Why would you build an elaborate cognitive architecture when the empirical path to general capability is to make models bigger? Every cognitive architecture in history has been outperformed by the next generation of scaled neural networks."

**This is the most practically threatening objection.** The scaling results are real and dramatic. But there are counterarguments:
- o3's ARC-AGI-1 performance cost orders of magnitude more compute per task than human performance. ARC-AGI-2 dropped top scores to 24-54%, suggesting the problem is not fully solved by scaling.
- Chollet himself notes that "o3 still fails on some very easy tasks, indicating fundamental differences with human intelligence" and that these systems "cannot autonomously learn these skills."
- Scaling laws may be hitting diminishing returns. The current frontier conversation has shifted toward test-time compute and reasoning, not just pretraining scale.
- Even if scaling produces capability, it does not produce interpretability, persistent personalized memory, or value-aligned cognition -- which are this architecture's actual contributions.

**The honest position:** If the only goal is task performance, scaling may indeed be the more practical path. But the architecture is not primarily competing on task performance. It is competing on interpretability, experiential personalization, and cognitive transparency. These are orthogonal to the scaling argument.

### 3d. The Cognitive Science Argument

**Steel-manned objection:** "You are implementing *metaphors* of cognition, not *mechanisms* of cognition. You call something 'consciousness' and name it 'the Mirror,' but it is a persistent context window with priority heuristics -- not consciousness. You call them 'emotions' but they are numerical modulation parameters -- not emotions. You invoke Damasio's somatic marker hypothesis, Collins & Loftus spreading activation, and ACT-R decay equations, but you are using these as loose inspirations, not as the specific computational mechanisms they describe in their original contexts. The cognitive science literature is full of careful, falsifiable theories about how these systems work in biological brains. Your architecture borrows the vocabulary without the constraint. A real cognitive scientist would ask: what predictions does this make that I can test? What would falsify your theory of how this Mirror works? If the answer is 'nothing,' then it is not a scientific theory of cognition -- it is an engineering system wearing cognitive science clothing."

**This is the most intellectually honest objection.** The architecture does indeed use cognitive science terminology in ways that may overstate the correspondence. "Consciousness," "emotions," "subconscious" -- these are heavyweight terms being applied to engineering constructs that are considerably simpler than the phenomena they reference. The Mirror is not conscious; it is a persistent evaluation loop. The "emotions" are not felt; they are numerical parameters that modulate system behavior.

**However:** The architecture's designers appear aware of this (the value-system document references Damasio specifically and uses emotions as "the mechanism by which values become operational," not as phenomenal experience). The question is whether the *functional role* is analogous enough to justify the terminology. In cognitive architecture research, this is standard practice -- ACT-R, SOAR, CLARION, and Global Workspace Theory all use cognitive terminology for computational constructs. The risk is in confusing the map for the territory.

---

## 4. WHAT IS GENUINELY MISSING FOR GENERAL INTELLIGENCE

### 4a. Sensorimotor Grounding

**Status: Partially addressed, pathway exists.** The architecture is designed as modality-agnostic (nodes can be any modality). It has a pathway to grounding through tool use, sensor integration, and multimodal nodes. But it currently operates primarily in language, and linguistic grounding alone is weak grounding. **Assessment: Not fundamentally blocked, but the pathway requires significant development.**

### 4b. Compositional Reasoning Beyond the Graph

**Status: Fundamental limitation.** The architecture relies on the LLM for compositional reasoning. The graph provides associative knowledge; the LLM composes it. But the graph itself has no compositional mechanism -- it cannot combine two nodes to produce a novel inference that the LLM cannot already make from the node contents. ARC-AGI-2 results confirm that even frontier models struggle with "multiple rules that interact with each other." The architecture does not address this; it inherits whatever compositional reasoning ability the LLM provides. **Assessment: Genuinely limited. The graph enables better knowledge retrieval but does not enhance compositional reasoning capability.**

### 4c. Meta-Learning (Learning to Learn)

**Status: Partially addressed through the Mirror.** The Mirror creates meta-memories ("I branched deeply here and it was useful"), adjusts future emotional responses based on outcomes, and learns from spawned tree results. This is a form of meta-learning -- learning about the learning process itself. However, it is meta-learning about *knowledge acquisition strategies*, not about *reasoning strategies*. The architecture can learn to explore differently but cannot learn to reason differently. MAML and related meta-learning approaches optimize the learning process itself at a more fundamental level. **Assessment: Partial pathway exists for strategic meta-learning; fundamentally limited for procedural meta-learning.**

### 4d. Temporal Reasoning and Planning

**Status: Underspecified.** The architecture has temporal elements (episodic memories are timestamped, consolidation uses temporal ordering, the Mirror maintains a continuous timeline). But explicit planning -- constructing and evaluating future action sequences -- is not a native operation of the architecture. Planning would need to be delegated to the LLM, with the graph providing relevant memories of past plans and outcomes. The "predicted_future_utility" component in the priority system gestures toward prospective cognition but is not developed. **Assessment: Pathway exists through LLM delegation and temporal memory structures, but planning is not an architectural strength.**

### 4e. Social Cognition and Theory of Mind

**Status: Interesting potential.** Because different agents build different graphs from different experiences, the architecture has a natural basis for understanding that other minds see the world differently. If agent A can inspect agent B's graph, it has a literal window into a different worldview. This is theory of mind by architecture, not by simulation. However, real social cognition involves predicting *behavior* from inferred mental states, which requires more than graph comparison -- it requires modeling dynamic processes within another mind. **Assessment: Structural advantage for perspective-taking; limited for dynamic behavioral prediction.**

---

## 5. HISTORICAL PRECEDENT: Avoiding "This Time It's Different"

### The Pattern That Repeats

| Era | Paradigm | Core Claim | What Actually Happened |
|-----|----------|-----------|----------------------|
| 1960s-70s | Symbolic AI | Formal logic can represent all intelligence | Brittleness, frame problem, combinatorial explosion. Could not handle uncertainty or learning. |
| 1980s | Expert Systems | Capture human expertise in rules | Maintenance nightmare, brittleness at domain boundaries, could not learn or generalize. |
| 1990s-2000s | Neural Networks | Parallel distributed processing is the path | Training difficulties, limited data, compute constraints. Needed 20 more years of hardware. |
| 2010s-now | Deep Learning/Transformers | Scale is all you need | Producing remarkable capabilities but with hallucination, opacity, no persistent memory, no grounding. |

**The common failure mode:** Each paradigm identified a *real* ingredient of intelligence, built systems that excelled at demonstrating that ingredient, and then claimed (or was claimed to be) the path to *general* intelligence. Each time, the missing ingredients turned out to be more important than expected.

### Is This Architecture Falling Into the Same Trap?

**Honestly: partially yes.** The architecture identifies a real ingredient -- that an interpretable, experiential, associative memory structure can serve as a cognitive substrate. This is a genuine contribution. The danger is in claiming that this ingredient, when combined with an LLM reasoning engine, constitutes a path to general intelligence.

**Specific parallels to watch for:**
- **Expert systems parallel:** Expert systems separated knowledge (rules) from inference (the inference engine), exactly as this architecture separates knowledge (the graph) from reasoning (the LLM). Expert systems failed because hand-coded rules were brittle and couldn't learn. This architecture's graph *does* learn from experience (a genuine advance), but it learns associations, not procedures. If the graph hits the same ceiling -- rich knowledge, brittle reasoning -- the parallel is exact.
- **Cognitive architecture parallel:** ACT-R and SOAR have been developed for 40+ years. They incorporate many of the same components (spreading activation, decay, memory types, production rules). Despite decades of refinement, no cognitive architecture has achieved general intelligence. The key lesson: **architectural elegance does not automatically produce general capability.** ACT-R has beautiful mathematics for memory activation. It still cannot pass a Turing test.
- **What a skeptic in 2030 would say:** "The memory graph people thought that if you just organized experience in the right structure, intelligence would emerge. But associative retrieval is not reasoning. Navigation is not understanding. They built beautiful, interpretable knowledge structures that couldn't actually *think* -- they just provided better context for the thing that could think (the LLM). And when LLMs got good enough to manage their own context, the elaborate graph architecture became unnecessary overhead."

**This is the scenario the architecture needs to defend against.** If LLMs develop robust long-term memory natively (through extended context, state-space models, or architectural innovations), the graph's value proposition weakens considerably.

---

## 6. THE INTERPRETABILITY-CAPABILITY TRADEOFF

### The Core Tension

Neural networks learn rich distributed representations precisely *because* they are opaque. A concept is not a single node -- it is a pattern across thousands of dimensions, allowing for subtle gradations, context-sensitivity, and compositional blending that explicit representations cannot match.

Recent research confirms this tension is real:
- A 2024 study across 45 datasets found that interpretable models (like explainable boosting machines) lose approximately 4% average accuracy compared to opaque models -- a small but consistent gap.
- Neural-symbolic programs face "a fundamental trade-off between expressiveness (requiring more neural network modules) and interpretability (favoring symbolic modules)."
- Mechanistic interpretability research (growing rapidly -- 23+ papers in 2024 alone) is attempting to make opaque representations readable *after the fact*, rather than forcing interpretability at design time.

### What This Means for the Architecture

The architecture makes a **deliberate choice** to sacrifice representational richness for interpretability. Associations are discrete, labeled, weighted edges between discrete nodes. You can trace any belief to its experiential basis. But you lose:

- **Graded similarity:** In a distributed representation, "cat" and "kitten" share overlapping activation patterns that naturally encode their similarity. In the graph, their relationship must be explicitly represented as an edge.
- **Context-sensitivity:** In a distributed representation, the meaning of a word shifts continuously with context. In the graph, a node has fixed content; context comes from which other nodes are co-activated, which is coarser.
- **Novel combinations:** Distributed representations can be blended in novel ways (the way neural style transfer blends content and style). The graph can only combine nodes that exist, along paths that exist.

**The critical question:** Does the architecture's delegation to the LLM for reasoning offset this loss? Partially. The LLM still has its distributed representations -- it processes the graph's contents through them. But the *personal knowledge* is in the graph, in interpretable form, and that knowledge is structurally simpler than what distributed representations can encode.

**The honest assessment:** Yes, interpretability comes at a real cost to expressiveness. The architecture bets that this cost is worth paying for transparency, debuggability, and value alignment. Whether that bet pays off depends on what you're optimizing for. For tasks requiring rich, subtle, context-sensitive representations, distributed approaches win. For tasks requiring transparent, auditable, trustworthy reasoning from personal experience, this architecture has a genuine advantage.

---

## 7. WHAT THIS ARCHITECTURE ACTUALLY IS -- THE TRUE CLAIM

Having applied every framework and every objection I can muster, here is my honest assessment of the defensible claims:

### What It Is NOT

- **It is not AGI.** It cannot acquire new reasoning skills from experience. It cannot perform across diverse computable environments. It lacks procedural learning, robust compositional reasoning, and sensorimotor grounding. Calling it AGI or a path to AGI would be the kind of overclaim that produces AI winters.
- **It is not a theory of consciousness.** The Mirror is a persistent evaluation loop with priority heuristics, not a model of phenomenal consciousness. The terminology is suggestive, which is both a strength (evocative, memorable) and a risk (overclaim).
- **It is not a replacement for the LLM.** The architecture explicitly depends on the LLM for reasoning. The graph is the mind; the LLM is the engine. But an engine without fuel goes nowhere, and a mind without reasoning capability goes nowhere. They are co-dependent.

### What It IS -- Defensibly

**1. A novel cognitive substrate for AI agents.** No existing production system treats the memory graph as the primary interpretable world model, uses tree-as-context (growing subgraph IS the context), implements Hebbian co-occurrence as the primary association mechanism, or has parallel growing trees sharing a context budget. The architecture's audit of 65+ systems confirms structural novelty. This is a real contribution to cognitive architecture design.

**2. A principled separation of knowledge and reasoning.** This is the architecture's most important insight. By externalizing the world model from the LLM's weights into a readable graph, it creates a system where:
- You can read why the agent believes what it believes
- You can compare different agents' worldviews by diffing their graphs
- You can audit for bias, gaps, and errors in the knowledge structure
- The reasoning engine (LLM) becomes interchangeable while the identity (graph) persists

This separation is genuinely novel at the level of ambition being attempted and addresses a real, urgent problem in AI deployment (opacity, hallucination, inability to audit beliefs).

**3. A framework for interpretable, value-aligned AI agents.** The value system (Mirror evaluates alignment, produces emotions that modulate cognition) is an engineering framework for building agents whose decision-making is transparent. You can trace: why did the agent care about this? (values) what did it feel about the input? (emotions) how did that shape its exploration? (modulated traversal) what did it find? (graph contents) how confident is it? (dual-axis confidence). This traceability is valuable for alignment research and for building AI systems that humans can trust.

**4. A contribution to the interpretability-versus-capability conversation.** The architecture is an existence proof (in design, not yet in implementation) that a highly interpretable cognitive system can be constructed. It makes the interpretability cost explicit and conscious rather than accepting opacity as inevitable. Even if the expressiveness tradeoff is real, having a concrete alternative architecture that prioritizes transparency is valuable for the field.

### The Framing That Is Both Honest and Compelling

The strongest defensible framing is: **"A novel cognitive architecture that externalizes the AI world model from opaque pretrained weights into an interpretable, experiential memory graph -- enabling transparent, auditable, value-aligned AI agents whose beliefs can be read, compared, and corrected."**

This is true. It is novel. It is valuable. It does not overclaim into AGI territory. It positions the work within the cognitive architecture tradition (ACT-R, SOAR, Global Workspace Theory) while identifying what is genuinely new. It connects to the urgent practical problems of the moment (AI interpretability, hallucination, alignment) rather than to speculative claims about general intelligence.

### The Key Risks to Acknowledge

1. **Execution risk:** The architecture is in design phase with no implementation. Many beautiful architectures fail on contact with reality. The open questions document is honest about what is unresolved (encoding granularity, consolidation timing, LLM integration boundaries, scaling).

2. **The LLM dependency:** If LLMs develop native long-term memory and interpretable reasoning (through mechanistic interpretability breakthroughs or architectural innovations), the architecture's value proposition narrows. The architecture bets that the graph-as-world-model will remain valuable even as LLMs improve. This is a reasonable bet for the medium term but not guaranteed long-term.

3. **The associative ceiling:** Hebbian co-occurrence is elegant and well-motivated, but it is a single learning mechanism. Biological brains use Hebbian learning alongside neuromodulation, error-driven learning, homeostatic regulation, and other mechanisms. Relying solely on co-occurrence may produce a system that forms rich associations but cannot discover causal relationships, counterfactual reasoning chains, or abstract structural patterns that co-occurrence alone does not reveal.

4. **The metaphor risk:** Using terms like "consciousness," "emotions," "subconscious," and "mind" for engineering constructs creates expectations the system cannot meet. A reviewer or critic will seize on these terms and demand justification at the level the terms normally imply. The paper should use these terms carefully, with explicit acknowledgment of the functional-analogy framing.

### Final Verdict

This architecture is a **genuine contribution to cognitive architecture and interpretable AI**, not a path to AGI. Its novelty is real and defensible across multiple dimensions. Its value is in making AI cognition transparent, not in making AI cognition general. The most productive path forward is to implement it, demonstrate the interpretability advantages concretely, and position it as a new paradigm for building AI agents whose reasoning can be understood, audited, and trusted -- rather than as a step toward general intelligence.

The true claim is strong enough. It does not need to be AGI to matter.

---

Sources:
- [Chollet, "On the Measure of Intelligence" (arXiv:1911.01547)](https://arxiv.org/abs/1911.01547)
- [Legg & Hutter, "Universal Intelligence" (arXiv:0712.3329)](https://arxiv.org/abs/0712.3329)
- [ARC Prize 2025 Results and Analysis](https://arcprize.org/blog/arc-prize-2025-results-analysis)
- [Announcing ARC-AGI-2 and ARC Prize 2025](https://arcprize.org/blog/announcing-arc-agi-2-and-arc-prize-2025)
- [OpenAI o3 Breakthrough on ARC-AGI](https://arcprize.org/blog/oai-o3-pub-breakthrough)
- [Symbol Ungrounding: LLM Successes and Failures Reveal Human Cognition](https://pmc.ncbi.nlm.nih.gov/articles/PMC11529626/)
- [Intelligence Requires Grounding But Not Embodiment (arXiv:2601.17588)](https://arxiv.org/html/2601.17588v1)
- [Challenging the Performance-Interpretability Trade-Off (Springer, 2024)](https://link.springer.com/article/10.1007/s12599-024-00922-2)
- [Neuro-Symbolic AI Systematic Review 2024 (arXiv:2501.05435)](https://arxiv.org/pdf/2501.05435)
- [A Universal Knowledge Model and Cognitive Architectures for AGI (ScienceDirect, 2024)](https://www.sciencedirect.com/science/article/abs/pii/S1389041724000731)
- [An Analysis and Comparison of ACT-R and Soar (arXiv:2201.09305)](https://arxiv.org/abs/2201.09305)
- [AI Winter - Wikipedia](https://en.wikipedia.org/wiki/AI_winter)
- [Benchmarking Hebbian Learning Rules for Associative Memory (arXiv:2401.00335)](https://arxiv.org/abs/2401.00335)
- [Meta-Learning Approaches for Few-Shot Learning: A Survey (ACM Computing Surveys, 2024)](https://dl.acm.org/doi/10.1145/3659943)
- [Towards Cognitive AI Systems: A Survey on Neuro-Symbolic AI (arXiv:2401.01040)](https://arxiv.org/pdf/2401.01040)
- [Connectionist Representations: The State of the Art (UCSD CRL)](https://crl.ucsd.edu/newsletter/8-1/Article1.html)
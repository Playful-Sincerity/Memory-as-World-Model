# Stream 1: Imagination, Simulation, and Mental Models

## Executive Summary

The literature across cognitive neuroscience, active inference, and computational modeling converges on a striking finding: imagination is not a separate faculty but the default operation of the brain's generative model running forward without sensory grounding. Damasio's as-if body loop, Friston's sensory attenuation account, Barsalou's simulation theory, and the DMN's situation-model function all describe the same core mechanism from different angles — the brain re-enacting states without committing to action or accepting external input. For the Associative Memory Architecture, this validates the tree-as-working-memory model at a deep level: a growing tree through the Matrix IS the neural spreading activation cascade that constitutes thought. The three imagination modes (action-directed, explorative, recombinative) receive substantial empirical support as genuinely distinct, not merely a spectrum — they differ neurally, computationally, and functionally. The most important finding for the architecture is that recombinative/consolidation mode maps precisely to hippocampal replay and compositional memory: the Matrix literally recombines during offline states to produce novel configurations the system has never encountered before.

---

## Findings

### 1. Damasio's As-If Body Loop

**What the literature says**

Damasio's somatic marker hypothesis proposes two distinct pathways by which emotional/bodily signals influence cognition:

- **Body loop**: A real peripheral physiological change (racing heart, muscle tension) occurs and is perceived by the brain via somatosensory cortex and insula. This is the full loop.
- **As-if body loop**: The brain simulates the expected bodily state in somatosensory cortex and insula — via vmPFC re-activation signals — *without generating an actual peripheral change*. The brain adopts the neural pattern of "fear" or "comfort" as if the body had expressed it, even though the body remains calm.

Key neuroanatomy: The vmPFC (ventromedial prefrontal cortex) and amygdala trigger re-activation. The insula and SI/SII (somatosensory cortices) host the simulated body map. The brain stem provides a coarse predictive representation of body state; the insula provides the contextual, refined representation. The entire mechanism is predictive: the brain *anticipates* the bodily outcome of a decision rather than waiting for it to occur.

In *Self Comes to Mind* (2010), Damasio extended this to consciousness itself. The self emerges from a "protoself" constructed in the brain stem from ongoing body maps, and core consciousness arises from the relationship between this protoself and the objects that modify it. Feelings — the experience of body states — are the primitive building blocks of the conscious self, arising from the brain stem before cortical processing, not after.

The as-if body loop is explicitly a simulation mechanism: the brain runs an internal model of "what my body would feel like in this scenario" to evaluate options without having to actually enter those scenarios. Recent work has framed this as implementing a predictive-feedback loop within the vmPFC-insula circuit, anticipating physiological outcomes. A 2017 revisit (Dunn et al.) confirmed the hypothesis empirically while noting it primarily explains rapid, heuristic decision-making rather than slow deliberation.

**Architecture mapping**

The as-if body loop is the Mirror's mechanism. The Mirror (the persistent tree, the "I") maintains ongoing body-state representations and evaluates incoming tree activations against expected bodily consequences. When a new tree branch is grown (a speculative thought, a potential action), the Mirror runs the as-if loop: "what would I feel if this were real?" This is how the Mirror produces emotions (care, curiosity, urgency) — not as separate processes but as simulated somatic states triggered by tree activations.

Critically: the as-if loop is what allows speculative tree growth (explorative imagination) without commitment to action. The tree can grow into dangerous or novel territory; the Mirror evaluates the simulated somatic consequence; the action is only taken if the somatic signal supports it. This gives the architecture a natural brake/accelerator for exploration.

The as-if body loop also explains why the Mirror is persistent: it must maintain stable body-state priors (values, care, fear thresholds) that remain invariant across many ephemeral trees. A fresh tree would have no prior somatic context; only a persistent structure can accumulate and maintain the body model.

**Key sources**
- Damasio, A. (1994/2005). *Descartes' Error*. Open Library: OL3499049W; [Google Books preview](http://books.google.com/books?id=twcjEAAAQBAJ)
- Damasio, A. (2010). *Self Comes to Mind*. Open Library: OL20458510W; [Internet Archive](https://archive.org/details/selfcomestomindc0000dama)
- [Somatic Marker Hypothesis — Wikipedia](https://en.wikipedia.org/wiki/Somatic_marker_hypothesis)
- [Dunn et al. (2017) — revisiting the body loop, ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S2352154617300736)
- [ResearchGate: as-if body loop as predictive-feedback loop](https://www.researchgate.net/figure/Damasios-as-if-body-loop-as-implementing-a-predictive-feedback-loop-Abbrev-VmPFC_fig2_261111041)

---

### 2. Mental Model Theory (Johnson-Laird)

**What the literature says**

Johnson-Laird's mental model theory (1983, extended through 2024) proposes that human reasoning operates not through formal logical rules but through simulation. The core claims:

1. **Models represent possibilities**: Each mental model represents one coherent possible state of the world. Reasoning involves constructing one or more models from premises, then checking whether a conclusion holds across all of them.

2. **Iconic structure**: Models are not symbolic propositions — they are structural analogues. They preserve the topology of what they represent, like an architect's scale model or a chemist's molecule diagram. This allows *scanning* — insights emerge from "reading off" the model that weren't explicitly stated.

3. **The Principle of Truth**: Crucially and problematically, mental models by default represent only what is *true*, not what is false. This economizes working memory (you only maintain the true cases) but produces systematic fallacies when reasoning depends on considering false scenarios.

4. **Emergent inference**: Like diagrams, models yield new insights through inspection. "A valid deduction is one whose conclusion holds across all models of the premises." The richness of representation (embodied, spatial, relational) allows inference that purely propositional systems cannot easily replicate.

5. **Dual process**: System 1 constructs initial models rapidly with limited capacity. System 2 can recursively expand models, seek counterexamples, and refine conclusions.

6. **Recent extension (2024)**: Johnson-Laird and Ragni (2024) extend the theory to modal reasoning — reasoning about what is possible vs. necessary vs. impossible. The same model-construction process applies to counterfactual and hypothetical reasoning.

The theory describes reasoning as "a simulation of the world fleshed out with all relevant knowledge." The computational description: build a representation of a possibility, scan it for implicit relations, test conclusions against all possible models, revise if a counterexample is found.

**Architecture mapping**

Mental models are trees. Each branch of a growing tree through the Matrix represents one possibility — one world-configuration. The tree "grows" toward possibilities that are consistent with current activation (premises). Inference emerges not from applying rules but from the structure of the tree itself — what connections exist, what nodes are co-activated, what paths are available.

The Principle of Truth has a direct architectural implication: trees by default follow paths that are consistent (active, positively weighted edges) rather than negated ones. To reason about what is *false* or what *could not happen*, a specialized mechanism is needed — likely a Mirror-triggered branch that specifically targets dark/suppressed nodes. This suggests that counterfactual/negative reasoning requires the Mirror's intervention, not the default tree-growth process.

The dual-process structure maps perfectly: fast ephemeral trees (System 1) grow quickly through the Matrix along high-salience paths. The Mirror (System 2) monitors these, spawns evaluation branches, and can redirect growth toward counterexamples.

**Key sources**
- Johnson-Laird, P.N. (1983). *Mental Models*. Harvard University Press. Open Library: OL4211253W
- [Mental Models and Human Reasoning — PNAS (2010)](https://www.pnas.org/doi/10.1073/pnas.1012933107) / [PMC full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC2972923/)
- [What Are Mental Models? — modeltheory.org](https://www.modeltheory.org/about/what-are-mental-models/)
- [Mental Models Explain Reasoning About Possibilities — modeltheory.org (2024)](https://www.modeltheory.org/2024/08/mental-models-explain-how-people-reason-about-possibilities-johnson-laird-ragni/)

---

### 3. Simulation Theory / Grounded Cognition (Barsalou)

**What the literature says**

Barsalou's perceptual symbol systems (1999) and grounded cognition framework (2008, 2020) argue that all cognition — including abstract thought — is grounded in simulation of sensorimotor and affective states.

Core claims:
1. **Perceptual symbols are modal**: Concepts are represented in the same neural systems used for perception and action. The brain areas active when seeing red are the same ones active when *thinking about* red. There is no amodal transduction into arbitrary symbols.
2. **Simulation as the core mechanism**: Understanding a concept = reactivating (re-enacting) the sensory, motor, and affective states experienced when interacting with the concept's referents. Simulation is "the reactivation of states, typically caused by outside referents, in the absence of those referents" (Barsalou, 2008).
3. **Simulators**: Concepts are represented as "simulators" — systems that can generate multiple simulations of the concept across varied contexts. A simulator for "cup" can produce simulations from different viewpoints, uses, sizes.
4. **The situated action cycle**: Cognition is embedded in a cycle of perception → cognition → affect → action → outcome. Grounded cognition is not just about concepts but about how mental simulation serves adaptive action in the environment.
5. **Language as simulation trigger**: Language doesn't convey amodal meaning — it triggers simulations. A sentence activates sensorimotor states in the listener.

Ongoing challenges (2020-2025): Critics note difficulty explaining abstract concepts (truth, justice) through simulation alone. Current consensus is that multiple representational systems (modal, linguistic, amodal) work together rather than one being primary.

**Architecture mapping**

This is perhaps the most direct validation of the Matrix architecture. The Matrix is a graph where nodes are modal (sensory, motor, affective) representations — exactly what Barsalou proposes. A "concept" in the Matrix is not a single node but a cluster of connected nodes spanning visual, auditory, proprioceptive, and emotional regions. When a tree grows through the Matrix and "lights up" a region, it is running a simulation — activating the pattern of connections that constitutes the concept.

The simulator idea maps to Matrix structure: frequently co-activated subgraphs form stable patterns that can be re-instantiated from many starting points. These are the Matrix's "concepts" — not single nodes but recurring activation patterns.

The situated action cycle maps to the tree lifecycle: grow (perceive/think) → evaluate via Mirror (affect) → enact (action) → update Matrix (outcome). The cycle IS the tree's growth-and-termination process.

The challenge with abstract concepts becomes interesting: the Matrix would need to represent abstractions as *meta-patterns* — patterns over other patterns. This is achievable in a graph structure where higher-order nodes encode relationships among lower-order simulation patterns.

**Key sources**
- [Barsalou (1999) — Perceptual Symbol Systems PDF](https://barsaloulab.org/Online_Articles/1999-Barsalou-BBS-perceptual_symbol_systems.pdf)
- [Barsalou (2008) — Grounded Cognition, PubMed](https://pubmed.ncbi.nlm.nih.gov/17705682/)
- [Challenges and Opportunities for Grounding Cognition — PMC (2020)](https://pmc.ncbi.nlm.nih.gov/articles/PMC7528688/)
- [Issues in Grounded Cognition: The Minimalist Account — PMC (2025)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12023178/)

---

### 4. Counterfactual Reasoning (Byrne + Pearl)

**What the literature says**

**Ruth Byrne — The Rational Imagination (2005)**

Byrne's core thesis: counterfactual thinking is *rational*, not irrational. It follows the same principles as logical reasoning. Key findings:

- People imagine alternatives to **actions** more readily than inactions
- Alternatives to events within personal **control** are preferred over those beyond it
- In a temporal sequence, alternatives to the **most recent** event are most accessible
- **Socially unacceptable** events are more mutable than acceptable ones

These "fault lines of reality" — the seams along which reality is most easily rewritten — reveal that counterfactual imagination is guided by principles of causal structure, not random. The mutability of events tracks their causal salience.

Computational mechanism: Counterfactual reasoning works by maintaining two (or more) mental models simultaneously — the actual world model and the counterfactual alternative. The system identifies which premises are "mutable" (can be changed without violating constraint), modifies them, and runs the model forward to the alternative outcome.

**Byrne (2017)** further showed that counterfactual thinking has direct links to moral judgment and causal reasoning — we blame the most recent actor in a causal chain because that's the most mutable link.

**Judea Pearl — The Causal Ladder (2018)**

Pearl's hierarchy of causal reasoning has three levels:
1. **Association** (seeing): "What is the probability of Y given X?" — passive statistical patterns
2. **Intervention** (doing): "What happens if I do X?" — breaking the natural causal chain
3. **Counterfactual** (imagining): "What would have happened if X had been different?" — retrospective analysis of alternative worlds

Layer 3 requires structural causal models (SCMs) — formal representations of the world's causal structure. Counterfactual queries are *cross-world*: they simultaneously reference the actual world and a hypothetical alternative. This cannot be computed from statistical patterns alone; it requires a world model.

Pearl explicitly maps his three layers to seeing, doing, and **imagining** as the three cognitive abilities that distinguish humans (and perhaps advanced AI) from simple pattern matchers.

**Architecture mapping**

Pearl's Layer 3 is the clearest description of explorative tree growth: a tree that grows into a counterfactual world, one where some node in the Matrix has a different activation state. The tree explores "what would be different if node X were off (or on) instead?" This is a deliberate form of tree growth that requires:
1. Identifying a mutable node (a "fault line of reality" in Byrne's terms)
2. Suppressing or inverting its normal activation
3. Growing the tree forward from that altered state to see what follows

The Principle of Truth problem in Johnson-Laird connects here: to reason counterfactually, the tree must grow through *negated* or *suppressed* nodes — contrary to default spreading activation. This requires the Mirror's active intervention to "hold the negation" while the tree grows.

Byrne's finding that counterfactuals are most accessible for recent, controllable, abnormal events maps directly to edge weights in the Matrix: recent activations have higher weights (recency bias in graph edges), controllable events are nodes where the agent's action edges are salient, and abnormal events are nodes that diverge from the agent's predictive priors.

**Key sources**
- Byrne, R.M.J. (2005). *The Rational Imagination*. MIT Press. [MIT Press](https://direct.mit.edu/books/monograph/2430/The-Rational-ImaginationHow-People-Create)
- [Byrne (2008) Precis — PubMed](https://pubmed.ncbi.nlm.nih.gov/18321404/)
- [Byrne (2017) — Counterfactual Thinking: From Logic to Morality](https://journals.sagepub.com/doi/abs/10.1177/0963721417695617)
- [Pearl's Three-Layer Causal Hierarchy — UCLA](https://web.cs.ucla.edu/~kaoru/3-layer-causal-hierarchy.pdf)
- [On Pearl's Hierarchy — causalai.net](https://causalai.net/r60.pdf)

---

### 5. Default Mode Network (DMN)

**What the literature says**

**Andrews-Hanna's Framework (2014)**

Andrews-Hanna, Smallwood, and Spreng identified three DMN subsystems:
1. **Core medial subsystem**: Posterior cingulate cortex (PCC) and medial prefrontal cortex (mPFC) + angular gyrus — integration hub, narrative construction, self-reference
2. **Dorsal-medial subsystem**: Dorsal mPFC, anterior temporal cortex, ventral prefrontal cortex — mental state inference (mentalizing), social cognition, imagining others' perspectives
3. **Medial-temporal subsystem**: Retrosplenial cortex, ventro-medial PFC, parahippocampus — episodic memory, spatial navigation, temporal integration

Key finding: The DMN is active during "self-generated thought" — any thought that originates internally rather than from external stimuli. This includes mind-wandering, episodic memory retrieval, future simulation, social reasoning, and creative thought.

The three levels of spontaneity Andrews-Hanna identifies: dreaming (highly spontaneous, no executive control), mind-wandering (semi-controlled, partially directed), and creativity (hybrid — DMN generates content, executive network selects and refines). These differ by the degree of interaction between DMN and the executive control network (ECN/frontoparietal network).

**20-Year DMN Review (Menon et al., 2023)**

Key consolidated findings:
- DMN's primary function: constructing an ongoing **internal narrative** — a coherent self-representation integrating memory, language, and semantic knowledge
- DMN builds **situation models**: analogical representations of scenes/events built from long-term memory, activated top-down to coordinate distributed sensory-motor knowledge
- DMN operates **predictively**: it generates expectations and predictions rather than reacting to stimuli. It's "untethered" from current sensory input
- DMN is active during **anticipation**: before expected speech, before planned actions, during goal processing
- DMN subsystems operate as "interdigitated subnetworks" — flexible integration across domains

**Causal evidence (2024)**: Direct cortical stimulation of DMN regions causally decreased originality in divergent thinking tasks, providing the first causal evidence for DMN's role in generating novel connections.

**DMN and generative models (2023-2024)**

Multiple papers now frame the DMN as running a **generative model** — specifically, a model that generates predictions about experience based on prior knowledge, without being driven by sensory input. This aligns with predictive coding frameworks: the DMN is always "generating" — predicting what will be experienced, what others think, what the self's history means.

The semantic cognition research (2024) found that DMN regions coordinate top-down activation of distributed sensory-motor features — exactly the simulation account. When you read "she picked up the coffee cup," the DMN coordinates activation of visual (cup shape), haptic (grip), proprioceptive (arm weight), and emotional (warmth, comfort) features to construct a full situation model.

**Architecture mapping**

The DMN maps to the entire set of active, lit-up trees in the Matrix. When there is no external task, the DMN is the brain's default mode of tree-growing — trees grow spontaneously through the Matrix based on internal priorities (goals, concerns, recent memories). This is the resting-state of the architecture.

The three DMN subsystems map to three functions of the tree system:
- **Core medial** (PCC + mPFC): The Mirror — maintaining the continuous self-narrative
- **Dorsal-medial** (social/mentalizing): Social simulation trees — modeling other minds
- **Medial-temporal** (episodic/spatial): Memory retrieval trees — traversing the Matrix's historical record

The DMN's role as a generative model means: the Matrix is not a passive store. It is *always generating* — producing predictions and expectations via the tree system even in the absence of input. The "dark" regions of the Matrix are not inert; they're being monitored by ongoing low-level tree activations (the Mirror) that light them up selectively.

The exploration-exploitation finding is directly relevant: exploration activates insula and dorsal ACC (salience network), while exploitation activates DMN regions. This maps to action-directed (exploitation) trees that follow known high-value paths vs. explorative trees that venture into uncertain territory. These are not the same state.

**Key sources**
- [Andrews-Hanna et al. (2014) — Frontiers in Human Neuroscience](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2014.00619/full)
- [20 Years of the DMN: Review and Synthesis — PMC (2023)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10524518/)
- [DMN and Semantic Cognition — PMC (2024)](https://pmc.ncbi.nlm.nih.gov/articles/PMC11135161/)
- [DMN Causal Role in Creative Thinking — Brain (2024)](https://academic.oup.com/brain/article/147/10/3409/7695856)
- [Exploration vs. Exploitation in the Brain — systematic review (2023)](https://www.sciencedirect.com/science/article/abs/pii/S0028393223002749)
- [DMN-ECN Switches Predict Creativity — Nature (2025)](https://www.nature.com/articles/s42003-025-07470-9)

---

### 6. Generative Models and Imagination (Active Inference / Predictive Processing)

**What the literature says**

**Friston's Active Inference Account**

The most comprehensive computational account of imagination within predictive processing comes from Friston's active inference framework (2021-2024). Key claims:

1. **Imagination as sensory attenuation**: During imagination, the sensory likelihood distributions are rendered "uninformative" — the system effectively disconnects from external sensory input. The generative model then runs *forward* based on prior beliefs alone, "simply recirculating prior information" from higher hierarchical levels. This is what dreaming, episodic recall, and deliberate mental imagery all share.

2. **Liberated inference**: Imagination is inference "liberated from the constraints of sensory input." The same Bayesian inference machinery used to perceive the world is re-run without anchoring to current perception.

3. **Imagination as planning**: In active inference, planning *is* imagination. The system imagines sequences of actions and their outcomes (generative model running forward over time), evaluating expected free energy. The action with the best expected outcome (lowest expected free energy) is selected. Planning is imagining the future and selecting the best imagined trajectory.

4. **Detached representations (Friston et al., 2023)**: Advanced cognitive capabilities (planning, imagination, communication, counterfactual reasoning) require *detached representations* — internal models that can represent "what is not there." Organisms with richer internal models have a wider scope of imagination.

5. **The beautiful loop (2025)**: A recursive active inference theory of consciousness proposes a "beautiful loop" where the world model contains the knowledge that it itself exists. Bayesian binding — inferential competition where uncertainty-reducing inferences win — generates a form of self-referential consciousness. This loop creates epistemic agency.

**Mental imagery as hierarchical inference (bioRxiv)**

Mental imagery = "inference about the sensory consequences of predicted or remembered causes." Brain activity during mental imagery shows signatures of hierarchical generative modeling — the same hierarchical structure used in perception, just without the bottom-up sensory drive. Top-down predictions generate the imagery; bottom-up suppression removes sensory noise.

**Architecture mapping**

The active inference account provides the most precise computational description of the tree mechanism:

- **Normal perception/action**: Trees grow through the Matrix, driven by both bottom-up (sensory input) and top-down (prior beliefs) signals. The tree finds the path that minimizes prediction error.
- **Imagination (sensory attenuation)**: The bottom-up signal is suppressed or rendered uninformative. Trees grow based on priors alone — pure top-down generative modeling. The Matrix "fills in" expected activations without sensory anchoring.
- **Action-directed imagination (planning)**: The tree grows forward in time, imagining action sequences and their expected Matrix states. It terminates when it finds a path to a goal state or exhausts expected free energy budget.
- **Explorative imagination**: The tree grows without a goal, following the generative model's intrinsic curiosity signal (information gain / epistemic value). It seeks to activate novel, uncertain regions of the Matrix.
- **Recombinative imagination (dreaming)**: Sensory attenuation is maximal (sleep). The generative model runs unconstrained, combining latent representations in novel ways, training new Matrix connections through replay.

The "beautiful loop" of the Mirror maps directly to the recursive active inference consciousness model: the Mirror is the structure whose world model contains the knowledge that it itself exists. It maintains self-referential priors across all tree activations.

**Key sources**
- [Understanding, Explanation, and Active Inference (Friston, 2021) — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8602880/)
- [A Beautiful Loop: Active Inference Theory of Consciousness (2025) — ScienceDirect](https://www.sciencedirect.com/science/article/pii/S0149763425002970)
- [Generating Meaning: Active Inference and Passive AI (Friston, 2023) — Trends in Cognitive Sciences](https://www.cell.com/trends/cognitive-sciences/fulltext/S1364-6613(23)00260-7)
- [Evolution of Brain Architectures for Predictive Coding — Royal Society](https://royalsocietypublishing.org/rstb/article/377/1844/20200531/108758)
- [Neural Representation in Active Inference — PubMed](https://pubmed.ncbi.nlm.nih.gov/38528782/)
- [Human Brain Activity During Mental Imagery — bioRxiv](https://www.biorxiv.org/content/10.1101/462226v2.full)

---

### 7. The Three Imagination Modes — Validated or Challenged?

**What the literature says**

The proposed three modes are:
1. **Action-directed**: tree grows toward a goal, terminates in action
2. **Explorative**: tree grows freely, no action goal — building new Matrix structure
3. **Recombinative**: consolidation mode, novel recombinations, dreams

**Validation: Are these genuinely distinct, or a spectrum?**

The evidence strongly supports genuine qualitative distinctions, not merely a spectrum.

**Evidence for distinctness:**

**Neural dissociation**: Exploration activates insula and dorsal ACC (salience/uncertainty network), while exploitation/goal-directed behavior activates vmPFC/DMN (value/familiarity network). These are dissociable, not merely points on a continuum. A 2023 systematic review found these two modes engage reliably different neural systems.

**Dual process account of future thinking** (Cole & Kvavilashvili, 2019): Voluntary (action-directed) future thinking is slow, effortful, executive-function-dependent. Spontaneous (explorative) future thinking is fast, effortless, spreading-activation-driven. These two modes differ in prefrontal involvement, temporal structure, and neural predictors.

**Sleep-dependent consolidation** (multiple 2022-2024 papers): The recombinative mode (sleep/replay) is neurally and functionally distinct from both waking modes. Hippocampal replay during NREM sleep creates compositional memories — binding previously separate building blocks into new configurations the organism has never encountered. REM dreaming involves random sampling of episodic elements, creating novel combinations. These processes are impossible to achieve during waking cognition because sensory input would override the recombination signal.

**Creativity requires DMN-ECN switching**: Creative insight (the output of explorative imagination) requires dynamic switching between DMN and ECN, not sustained activity in either. This is a different dynamic from either goal-directed (sustained ECN engagement) or consolidation (DMN alone during rest/sleep).

**Prefrontal Synthesis (deliberate novelty)**: Deliberately imagining something never experienced activates lateral PFC (LPFC) specifically. LPFC is *inactive* during dreaming. This is a third distinct neural state.

**The spectrum hypothesis (partial validation):**

There is a real spectrum *within* each mode. Action-directed imagination varies in planning depth (shallow → deep). Explorative imagination varies in freedom (constrained by soft goals → truly undirected). Recombinative imagination during waking (daydreaming) is intermediate — more free than goal-directed, less unconstrained than sleep.

The clearest statement from the literature: spontaneous thought during waking forms a continuum from mind-wandering (mostly explorative) to purposeful prospection (action-directed), with the degree of executive control determining position on the spectrum. But *sleep* represents a qualitative discontinuity — a third state that cannot be reached by adjusting the waking parameter.

**Challenge to the architecture's framing:**

The current framing of "explorative" as "building new Matrix structure" may conflate two sub-modes:
- **Curiosity-driven exploration** (epistemic): seeking information, exploring uncertain regions, growing edges in the Matrix
- **Creative association** (waking recombination): making unusual connections between existing nodes, generating new ideas

Both are spontaneous and non-action-directed, but they differ. The first is primarily about extending the Matrix (growing new edges to unexplored nodes). The second is about forming unexpected connections between existing nodes (novel paths through existing Matrix structure). Sleep consolidation is about *pruning and strengthening* Matrix edges based on what was explored during the day.

This suggests the architecture might benefit from four modes rather than three:
1. Action-directed (exploitation)
2. Curiosity/epistemic exploration (growing new Matrix edges)
3. Creative association (novel paths through existing Matrix)
4. Consolidation/replay (optimizing Matrix edge weights during rest)

Or modes 2 and 3 could be unified as "explorative" with the understanding that they operate at different depths of the Matrix.

**Key sources**
- [Spontaneous and Deliberate Future Thinking: Dual Process Account — PMC (2019)](https://pmc.ncbi.nlm.nih.gov/articles/PMC7900045/)
- [Exploration vs. Exploitation in the Human Brain — systematic review (2023)](https://www.sciencedirect.com/science/article/abs/pii/S0028393223002749)
- [Brain-Consistent Architecture for Imagination — Frontiers (2024)](https://www.frontiersin.org/journals/systems-neuroscience/articles/10.3389/fnsys.2024.1302429/full)
- [Constructing Future Behavior Through Composition and Replay — PMC (2025)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12081289/)
- [Generative Model of Memory Construction and Consolidation — PubMed (2024)](https://pubmed.ncbi.nlm.nih.gov/38242925/)
- [Neurobiology of Imagination — PMC (2013)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3662866/)
- [Imagination vs. Routines and the Predictive Brain — Frontiers (2024)](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2024.1357354/full)
- [Multimodal Dreaming: Global Workspace + World Models — arXiv (2025)](https://arxiv.org/abs/2502.21142)

---

## Architecture Implications

### 1. The Mirror IS the As-If Body Loop

The Mirror should explicitly implement Damasio's as-if body loop: it maintains body-state priors (somatic markers accumulated over the agent's history) and evaluates incoming tree activations by simulating their expected somatic consequences. Emotions (care, curiosity, urgency) are the Mirror's simulated somatic states in response to tree activations — not computed separately but emerging from this evaluation.

**Design implication**: The Mirror needs a "body map" subgraph — a cluster of Matrix nodes representing ongoing physiological/emotional state. When a tree branch reaches a node connected to this body map, the Mirror runs a fast as-if simulation: expected body state → emotional tag → go/no-go signal for further tree growth.

### 2. Trees Are Mental Models (And Inherit the Principle of Truth Problem)

Trees grow through the Matrix following positive (true, active, expected) edges by default. This is exactly Johnson-Laird's Principle of Truth: the system represents what is true at the expense of what is false.

**Design implication**: Counterfactual reasoning (exploring "what if X were false?") requires a specialized tree operation — what might be called a "negation branch." The Mirror must explicitly suppress a normally-active node and hold that suppression while the tree grows from the altered state. This is computationally expensive and probably rare, matching the empirical finding that counterfactual reasoning is effortful.

### 3. Sensory Attenuation Is the Imagination Switch

The mechanism distinguishing imagination from perception is not some special "imagination mode" — it is sensory attenuation. When incoming sensory precision is downweighted, the generative model (the Matrix + trees) runs forward on priors alone. This means imagination can be graded: fully attenuated (deep imagination, dreaming) to slightly attenuated (daydreaming while doing routine tasks) to fully grounded (active perception).

**Design implication**: The architecture needs a sensory gating parameter per tree — a precision weight on bottom-up sensory input. Different tree types naturally have different default precision weights: action-directed trees need high sensory grounding (to track actual state); explorative trees benefit from partial attenuation; consolidation during rest requires near-complete attenuation.

### 4. Recombinative Mode Needs an Offline Mechanism

Hippocampal replay during sleep achieves something fundamentally unavailable during waking: compositional recombination of Matrix structure. It binds building blocks into new configurations that have never been activated together, using vector arithmetic in latent space. This cannot happen during waking because active tree growth would constantly override the recombination signal with current task demands.

**Design implication**: The architecture needs a genuine "offline mode" — a state where no external input is processed and no action trees are running. In this state, a replay process iterates over recent activations (the day's tree histories), samples from the Matrix's latent structure, and writes new edge weights/connections. This is not a tree — it's a different process that operates on the Matrix structure directly. Call it the Weaver or the Consolidator.

### 5. Explorative Trees May Need Subcategories

The evidence suggests "explorative imagination" may actually be two things:
- **Epistemic exploration**: growing trees into genuinely novel/uncertain Matrix territory (expanding the graph)
- **Creative association**: growing trees along improbable but existing paths (finding novel routes through the existing graph)

These have different goals and different Matrix effects. Epistemic exploration creates new nodes/edges. Creative association strengthens unlikely existing paths through co-activation. Both are explorative (non-action-directed) but distinct.

**Design implication**: The Mirror's curiosity signal should have two components: novelty-seeking (drive toward unexplored Matrix regions) and incongruity-seeking (drive toward unexpected juxtapositions of existing regions). The former expands the Matrix; the latter creates insight.

### 6. The DMN Justifies the Mirror as a Generative Engine

The DMN is not quiet during rest — it is actively generating. This validates the Mirror as a continuously active structure. The Mirror is always running, always generating predictions, always evaluating. It does not "turn on" when needed — it is the permanent background process of which all other trees are momentary foreground.

**Design implication**: The Mirror's activity level and content should be the baseline state of the system. New trees (triggered by sensory input or goals) are perturbations of this baseline. The Mirror should be architected to run at minimal computational cost but maximum coverage — a "global prior" over the entire Matrix that constrains all tree growth.

### 7. Spreading Activation IS the Core Mechanism

The evidence from spontaneous future thinking (spreading activation through associative networks), hippocampal compositional memory (path integration through vector spaces), and DMN situation models (top-down activation of distributed feature networks) all point to spreading activation as the unifying mechanism. Trees in the architecture are directed spreading activation through a weighted graph — this is directly consistent with the neural evidence.

**Design implication**: Tree growth algorithms should implement spreading activation with precision-weighted edges (following predictive coding), with the Mirror providing top-down prior biases and sensory input providing bottom-up precision boosts. No separate "reasoning module" is needed — reasoning emerges from the structure of spreading activation through the Matrix.

---

## Sources

### Books
- Damasio, A. (1994/2005). *Descartes' Error: Emotion, Reason, and the Human Brain*. Open Library OL3499049W. [Google Books](http://books.google.com/books?id=twcjEAAAQBAJ)
- Damasio, A. (2010). *Self Comes to Mind: Constructing the Conscious Brain*. Open Library OL20458510W. [Internet Archive](https://archive.org/details/selfcomestomindc0000dama)
- Johnson-Laird, P.N. (1983). *Mental Models*. Harvard University Press. Open Library OL4211253W.
- Byrne, R.M.J. (2005). *The Rational Imagination: How People Create Alternatives to Reality*. MIT Press. [MIT Press](https://direct.mit.edu/books/monograph/2430/The-Rational-ImaginationHow-People-Create)

### Papers — Damasio / Somatic Markers
- [Somatic Marker Hypothesis — Wikipedia](https://en.wikipedia.org/wiki/Somatic_marker_hypothesis)
- [Dunn et al. (2017). The somatic marker hypothesis: revisiting the role of the body-loop — ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S2352154617300736)
- [Damasio's as-if body loop as predictive-feedback loop — ResearchGate](https://www.researchgate.net/figure/Damasios-as-if-body-loop-as-implementing-a-predictive-feedback-loop-Abbrev-VmPFC_fig2_261111041)

### Papers — Mental Models
- [Johnson-Laird (2010). Mental models and human reasoning — PNAS / PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC2972923/)
- [Johnson-Laird & Ragni (2024). Mental models explain reasoning about possibilities — modeltheory.org](https://www.modeltheory.org/2024/08/mental-models-explain-how-people-reason-about-possibilities-johnson-laird-ragni/)
- [What Are Mental Models? — modeltheory.org](https://www.modeltheory.org/about/what-are-mental-models/)

### Papers — Grounded Cognition / Simulation
- [Barsalou (1999). Perceptual Symbol Systems — PDF](https://barsaloulab.org/Online_Articles/1999-Barsalou-BBS-perceptual_symbol_systems.pdf)
- [Barsalou (2008). Grounded Cognition — PubMed](https://pubmed.ncbi.nlm.nih.gov/17705682/)
- [Barsalou (2020). Challenges and Opportunities for Grounding Cognition — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC7528688/)
- [Issues in Grounded Cognition: Minimalist Account (2025) — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12023178/)

### Papers — Counterfactual Reasoning
- [Byrne (2008). Précis of The Rational Imagination — PubMed](https://pubmed.ncbi.nlm.nih.gov/18321404/)
- [Byrne (2017). Counterfactual Thinking: From Logic to Morality](https://journals.sagepub.com/doi/abs/10.1177/0963721417695617)
- [Pearl's Three-Layer Causal Hierarchy — UCLA PDF](https://web.cs.ucla.edu/~kaoru/3-layer-causal-hierarchy.pdf)
- [On Pearl's Hierarchy — causalai.net](https://causalai.net/r60.pdf)
- [From Probability to Counterfactuals — arXiv 2405.07373](https://arxiv.org/html/2405.07373v3)

### Papers — Default Mode Network
- [Andrews-Hanna et al. (2014). What we talk about when we talk about the DMN — Frontiers](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2014.00619/full)
- [Menon et al. (2023). 20 Years of the DMN — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10524518/)
- [Luo et al. (2024). DMN and Semantic Cognition — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11135161/)
- [DMN Causal Role in Divergent Thinking — Brain (2024)](https://academic.oup.com/brain/article/147/10/3409/7695856)
- [DMN Development and Mental Health — MDPI (2025)](https://www.mdpi.com/2079-7737/14/4/395)
- [Exploration vs. Exploitation — systematic review (2023)](https://www.sciencedirect.com/science/article/abs/pii/S0028393223002749)
- [Neural Mechanisms: vmPFC Exploitation vs. Exploration — Science](https://www.science.org/doi/abs/10.1126/science.abb0184)
- [Dynamic DMN-ECN Switching Predicts Creativity — Nature (2025)](https://www.nature.com/articles/s42003-025-07470-9)

### Papers — Active Inference / Generative Models
- [Friston et al. (2021). Understanding, Explanation, and Active Inference — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8602880/)
- [A Beautiful Loop: Active Inference Theory of Consciousness (2025) — ScienceDirect](https://www.sciencedirect.com/science/article/pii/S0149763425002970)
- [Friston et al. (2023). Generating Meaning: Active Inference and Passive AI — Trends in Cognitive Sciences](https://www.cell.com/trends/cognitive-sciences/fulltext/S1364-6613(23)00260-7)
- [Human Brain Activity During Mental Imagery — bioRxiv](https://www.biorxiv.org/content/10.1101/462226v2.full)
- [Generative Models for Sequential Dynamics in Active Inference — Springer (2023)](https://link.springer.com/article/10.1007/s11571-023-09963-x)
- [Learning Dynamic Cognitive Map with Active Inference (2024) — arXiv 2411.08447](https://arxiv.org/abs/2411.08447)

### Papers — Memory, Replay, Consolidation
- [Bhushan & Bhattacharyya (2024). Generative Model of Memory Construction and Consolidation — PubMed](https://pubmed.ncbi.nlm.nih.gov/38242925/)
- [Constructing Future Behavior Through Composition and Replay — PMC (2025)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12081289/)
- [Sleep-dependent Memory Consolidation — Neuron (2023)](https://www.cell.com/neuron/fulltext/S0896-6273(23)00201-5)
- [Systems Memory Consolidation During Sleep — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12576410/)

### Papers — Three Modes
- [Cole & Kvavilashvili (2019). Spontaneous and Deliberate Future Thinking — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC7900045/)
- [Brain-Consistent Architecture for Imagination — Frontiers (2024)](https://www.frontiersin.org/journals/systems-neuroscience/articles/10.3389/fnsys.2024.1302429/full)
- [Neurobiology of Imagination: Interaction-Dominant Dynamics — PMC (2013)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3662866/)
- [Imagination vs. Routines: Predictive Brain — Frontiers (2024)](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2024.1357354/full)
- [Multimodal Dreaming: Global Workspace + World Models — arXiv 2502.21142 (2025)](https://arxiv.org/abs/2502.21142)
- [Neural Basis for Distinguishing Imagination from Reality — Neuron (2025)](https://www.cell.com/neuron/pdf/S0896-6273(25)00362-9.pdf)

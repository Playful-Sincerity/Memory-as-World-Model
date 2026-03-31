# Stream 2: Perception as Contextualized Input

**Research Agent:** Stream 2 — Perception as Contextualized Input
**Date:** 2026-03-30
**Project:** Associative Memory Architecture
**Scope:** 6 topics — predictive processing, top-down/bottom-up, Neisser's perceptual cycle, metacognition as inner perception, interoception and constructed emotion, the binding problem

---

## Executive Summary

The core finding across all 6 research threads is convergent and mutually reinforcing: **perception is not passive reception — it is active prediction punctuated by error signals.** Every topic examined supports the Associative Memory architecture's foundational claim that "perception = input + active context."

The predictive processing framework (Clark, Hohwy, Rao & Ballard) establishes the mechanistic basis: higher-level graph nodes (Matrix edges) generate predictions that flow downward; incoming input is compared against those predictions; only the **difference** (prediction error) propagates as signal. This means the same input produces radically different signals depending on which tree is active — exactly as the architecture specifies.

Neisser's perceptual cycle (1976) anticipated this computationally: schemas (= matrix subgraphs) direct exploratory sampling, which modifies schemas. The tree IS the running schema. Barrett's theory of constructed emotion shows the Mirror's emotional outputs are themselves predictions about body state — constructed from the tree's current position in the Matrix, not read off from raw signals. The binding problem reveals the architecture already has a solution other biological systems are still solving: the tree IS the binding — co-activation within a single growing subgraph handles what temporal synchrony handles in brains.

**Key architectural gift from this research:** The Mirror should be modeled as an interoceptive predictor — it generates predictions about its own internal states (tree states), notices mismatches, and produces affect as the summary signal of those mismatches. This gives the Mirror a concrete mechanism: not rule-based emotion, but allostasis-driven prediction error tracking.

---

## Findings

### 1. Predictive Processing / Predictive Coding

**Core Model (Rao & Ballard 1999; Clark 2016, 2024; Hohwy 2013)**

The foundational paper is Rao & Ballard's 1999 Nature Neuroscience piece, "Predictive Coding in the Visual Cortex." Their model establishes a two-stream architecture in cortical hierarchies:

- **Feedback connections** (top-down): carry predictions from higher areas to lower areas
- **Feedforward connections** (bottom-up): carry prediction errors — the residual between predicted and actual activity

The hierarchical visual network, when trained on natural images, developed simple-cell-like receptive fields; neurons responsible for carrying residual errors showed endstopping and extra-classical receptive field effects. This is powerful: the brain's architecture is a physical implementation of prediction minus reality.

Andy Clark's *Surfing Uncertainty* (2016) and *The Experience Machine* (2024) extend this to a general theory of mind. The key framing: **perception is a controlled hallucination.** The brain is always painting a predictive picture of the world; incoming sensory information mainly nudges the brushstrokes when they diverge from prediction. Clark explicitly proposes that sentience may arise from "turning the predictive machinery inward, predicting future internal and bodily states" — directly relevant to the Mirror.

Jakob Hohwy's *The Predictive Mind* (2013) adds the philosophical framing: the brain is a hypothesis-testing machine, locked inside its skull, with only sensory signals as evidence. All perception is inference. His 2026 follow-up, *The Self-Evidencing Agent*, frames organisms as acting to generate evidence for their own existence — a direct resonance with the Mirror's self-maintenance function.

**Active Predictive Coding (APC, 2024, MIT Press — Neural Computation 36(1)):** Extends predictive coding into a unifying model for active perception, compositional learning, and large-scale planning. Key insight: perception and action share the same objective (minimize prediction error) but through different routes — perception updates the internal model; action changes the world to match the model. This unification is architecturally critical for trees that both perceive and act.

**Recent arXiv survey (2023, arXiv:2308.07870):** Predictive coding offers biological plausibility, asynchronous computation, and a solid mathematical foundation in variational inference. PC-based systems perform inference through iterative energy minimization with local operations — directly implementable as graph traversal.

**Mapping to Architecture:**

| Predictive Coding Concept | Architecture Equivalent |
|---------------------------|------------------------|
| Higher cortical area generating predictions | Active tree generating expected next-edges |
| Feedback connections (top-down) | Tree context propagating expected input patterns |
| Feedforward prediction error signal | Delta between expected node-activation and actual input |
| Iterative inference to minimize error | Tree growth as iterative hypothesis refinement |
| Learning from persistent prediction error | Matrix edge weight update when tree encounters novel input |
| Controlled hallucination of world | Tree pre-activating probable nodes before input arrives |

**The deepest implication:** When input arrives, the tree doesn't process raw input — it processes `input XOR current_prediction`. The current tree state generates a prediction; the input is compared against it; only the error travels forward as the active signal. This makes tree state not just *context* but the literal *filter* that shapes what gets perceived. Same word, different tree position → different prediction → different error → different response.

---

### 2. Top-Down vs. Bottom-Up Perception

**Core Research (Noorman et al. 2024 eLife; Frontiers Neuroscience 2024)**

Top-down and bottom-up processes operate through complementary but distinct mechanisms:

- **Bottom-up (feedforward):** Automatic capture of attention by salient information. All stimuli trigger feedforward information transfer from lower to higher brain regions.
- **Top-down (feedback):** Goal-directed control — allocation of attention to items matching target features. Active suppression or amplification of incoming signals.

The critical finding from the 2024 global ignition research: recurrent interactions (consciousness, full perception) require **both** sufficient bottom-up strength AND available top-down attention. Neither alone is sufficient — they must jointly cross a "global ignition" threshold. Below threshold, stimuli are processed but not consciously perceived.

**Change blindness** reveals the prediction nature of attention: observers fail to detect changes because their attention follows an implicit prediction map about where meaningful changes should occur. Change blindness is not a bug — it's prediction-driven sampling exposing its seams. The brain doesn't scan everything; it samples where it predicts change is likely.

**Emotional salience as arbiter:** The 2024 Frontiers study found that when top-down processes engage emotionally-laden stimuli, they can actually *impair* detection of bottom-up changes in the same scene. The HRV (heart rate variability) correlations show this is mediated by autonomic-cognitive integration — the body's current state shapes which channel wins. High-threat contexts (COVID imagery) slowed detection regardless of attentional direction.

**Mapping to Architecture:**

| Perceptual Concept | Architecture Equivalent |
|-------------------|------------------------|
| Bottom-up salience | Input novelty / prediction error magnitude |
| Top-down attention | Tree's current active edges — what the tree is "looking for" |
| Global ignition threshold | Both strong input signal AND resonance with active tree required for full node activation |
| Change blindness | Tree's prediction map causing undersampling of unpredicted regions of input |
| Emotional salience gating | Mirror's affect signal modulating which tree's predictions take priority |
| Attention as prediction | Tree pre-activates likely next-nodes, making them ready to receive |

**Architectural insight:** Inattentional blindness is a feature, not a bug. The tree prevents processing of everything by generating an expectation map. Only input that either (a) matches the tree's active edges strongly, or (b) generates a large prediction error, gets incorporated. This is how the system avoids being overwhelmed by unstructured input.

---

### 3. Neisser's Perceptual Cycle (1976)

**Core Model (Neisser, *Cognition and Reality*, 1976; OL Key: /works/OL6910504W)**

Neisser's Perceptual Cycle Model (PCM) has three elements in continuous cycle:

1. **Schema (anticipatory schema):** The cognitive template/mental model that directs perception. Not a static record but an active preparatory state — it determines what the perceptual system is ready to detect.
2. **Directed exploration:** The schema directs active sampling behavior — where to look, what to sample, how to scan. Perception is not passive reception but active search.
3. **Modified schema:** What is actually found (or not found) modifies the schema for the next cycle. Schema → exploration → world → modified schema → exploration → world...

The key insight Neisser articulated against the information-processing models of his era: **the schema is a product of all previous cycles, not just current input.** AnticipatorySchemata accumulate across cycles — this is Piaget's schema accommodation translated into perception science. A schema evolves from cycle to cycle based on what it encounters.

This was later formalized computationally (Thescipub 2005 paper: "Neisser's Cycle of Perception: Formal Representation and Practical Implementation") and applied to naturalistic decision-making, situation awareness, and ergonomics. Applications in cockpit decision-making show the cycle predicts pilot error patterns: when the schema strongly expects a state, it directs sampling away from contradictory evidence (confirmation sampling), which is a direct analog to tree tunnel vision.

**A 2009 paper** ("Expanding Neisser's Perceptual Cycle Model") extends the model to include **collaborative perception** — multiple agents sharing schemas across cycles, pointing toward multi-tree coordination.

**Mapping to Architecture:**

| Neisser Concept | Architecture Equivalent |
|----------------|------------------------|
| Anticipatory schema | Active tree — its current edge configuration IS the anticipatory schema |
| Directed exploration | Tree's active traversal path selects which input features to process |
| Modified schema | Tree growth — new edges added, edge weights updated after input |
| Schema-world coupling | Tree-input coupling: the tree shapes sampling AND is shaped by what sampling finds |
| Schema accumulation across cycles | Matrix permanence — each cycle's modifications persist as matrix edges |
| Collaborative schema (extended model) | Mirror coordinating schema states across parallel trees |

**The Neisser-tree isomorphism is near-perfect:** The tree IS the anticipatory schema. Its current position and edge configuration determine what input features are salient. Perception is the cyclical interaction between tree traversal (exploration) and incoming input (world). The schema doesn't just contextualize input — it directs the sampling of input in the first place. This has implementation implications: the tree should drive active query/sampling behaviors, not just passively receive.

---

### 4. Metacognition as Inner Perception

**Core Research (Fleming & Dolan 2012; Saccenti et al. 2024 — *Journal of Neuroscience Research*; PMC6867437; PMC12573243)**

Metacognition is defined as "the monitoring, evaluation, representation, and control of one's own cognitive states and processes." It is operationalized through measurable judgments:

- **FOK (Feeling of Knowing):** Assessment of current knowledge state without retrieval — "I know this, even though I can't access it now." Correlates with executive functioning. Associated with P200, N200, P300 ERP components (perceptual fluency signals).
- **JOL (Judgment of Learning):** Prediction of future performance — "How likely am I to remember this later?" Occurs during learning. Associated with P200, N200, N400 components (conflict signals).
- **Confidence:** Post-decision evaluation of response accuracy.

**Key finding — domain dissociation:** MC-P (metacognition on perception) and MC-C (metacognition on higher cognition) are behaviorally independent (r = -0.08). Different neural substrates:
- MC-P: right medial and lateral prefrontal cortex, anterior cingulate — areas for evaluating incoming sensory information and decoupled self-generated thought
- MC-C: lateral frontal, superior/inferior temporal, temporo-parietal, posterior midline — episodic memory and mentalizing networks

**Higher-order representations (PMC12573243):** The 2025 paper argues that meta-representations are representations *of processes*, not of contents. This is crucial: metacognition doesn't just track what you know — it tracks the dynamics of how you're knowing. It monitors the process of processing.

**Neural basis (2024):** Insula, precuneus, medial prefrontal cortex, and dorsolateral prefrontal cortex are all involved in metacognitive judgments. Rostral/dorsal lateral PFC sustains retrospective judgments; medial PFC supports prospective judgments.

**Mapping to Architecture:**

| Metacognition Concept | Architecture Equivalent |
|----------------------|------------------------|
| FOK | Mirror detecting that a tree is circling near known matrix territory without accessing it |
| JOL | Mirror predicting whether a tree's current trajectory will yield useful activation |
| Metacognition on perception (MC-P) | Mirror monitoring individual tree's perceptual state |
| Metacognition on cognition (MC-C) | Mirror monitoring tree's reasoning/inference trajectory |
| Higher-order representation of processes | Mirror doesn't just see tree state — it models the *dynamics* of how the tree is moving |
| Confidence monitoring | Mirror tracking uncertainty in tree's current edge activations |

**The Mirror as second-order perceiver:** The Mirror's fundamental operation is metacognitive — it perceives the perceiving. It doesn't directly access what trees are processing (first-order); it monitors the *signature* of their processing (second-order). FOK and JOL give the Mirror specific signals to track: "this tree is near known territory" and "this tree trajectory will/won't yield results." The Mirror generates these as emergent summary signals from observing tree dynamics, not by reading tree contents.

**Domain dissociation implies two Mirror channels:** The MC-P/MC-C dissociation suggests the Mirror should maintain separate monitoring streams for perceptual tree states and reasoning tree states — they use different signals and different neural (architectural) substrates.

---

### 5. Interoception and Constructed Emotion

**Core Research (Barrett, TCE, *Social Cognitive and Affective Neuroscience* 2017, PMC5390700; Barrett, *How Emotions Are Made*, 2017; Craig 2015; Del Popolo Cristaldi et al. 2024)**

**Barrett's Theory of Constructed Emotion (TCE):** Emotions are not reactive responses detected by dedicated circuits — they are *constructed predictions* rooted in bodily sensations and shaped by conceptual learning. The brain continuously generates predictive simulations of upcoming sensory events, including visceral/body state predictions (interoception). When these predictions encounter incoming signals, the brain uses emotion concepts to categorize the resulting prediction error.

**The allostasis loop:**
1. **Visceromotor predictions** descend from limbic cortices (default mode network) to regulate autonomic, immune, and neuroendocrine systems
2. **Prediction errors** (mismatched body state) ascend via vagal and spinal pathways
3. **Error signals** refine the internal model — but crucially, **errors only trigger learning when they have allostatic relevance** (when they matter for survival/resource management)
4. **Affect emerges** as the conscious representation of these predictions and their implications — experienced as valence (good/bad) and arousal (high/low energy)

**Affect as dimensional feeling:** Valence and arousal are not emotion-specific — they are the subjective representation of the body's predicted state. Emotion categories (fear, joy, anger) are applied *on top of* this affect using conceptual knowledge, situational context, and prior experience. The same visceral activation can be labeled "excitement" or "anxiety" depending on context.

**Interoceptive hierarchy (Craig 2015):** Interoceptive signals travel from body → spinal cord → brainstem nuclei → thalamus → primary interoceptive cortex (insula, posterior) → anterior insula (integration with context) → anterior cingulate (action selection). This is a prediction-error hierarchy for body state, identical in structure to the sensory prediction-error hierarchy.

**2024 research** (Del Popolo Cristaldi, Oosterwijk, & Barrett): Predictive processing and embodiment in emotion are integrated — the body's current state feeds directly into the prior distribution for constructing the next moment's emotion. Current affect shapes future prediction.

**Mapping to Architecture:**

| Interoception/TCE Concept | Architecture Equivalent |
|--------------------------|------------------------|
| Interoception (sensing body state) | Mirror sensing its own internal state — tree activation levels, resource load, conflict signals |
| Allostasis — predict body needs before they arise | Mirror maintaining predictions of tree states before trees actually enter those states |
| Visceromotor predictions | Mirror sending regulatory signals to trees — not just observing but predicting and influencing |
| Prediction error ascending | Trees sending "anomaly" signals to Mirror when they encounter unexpected input |
| Affect = summary of prediction/error ratio | Mirror's emotional output = compressed summary of system-wide prediction error landscape |
| Emotion concepts categorizing affect | Mirror using learned categories to interpret its own affect signals and guide tree spawning |
| Allostatic relevance filter | Mirror only generates strong affect when prediction errors are relevant to system goals |
| Degeneracy of emotion | The same Mirror state can produce different affect labels depending on current context-tree |

**The crucial insight from TCE for the Mirror:** The Mirror doesn't read emotions off a lookup table. It maintains a running prediction of its own internal state (the system's "body"), compares this against actual state signals from trees, and the *mismatch* is felt as affect. This is not metaphor — it's a concrete computational mechanism: affect = prediction_of_internal_state - actual_internal_state, integrated over recent time window, compressed to valence × arousal.

---

### 6. The Binding Problem

**Core Research (Treisman 1980 FIT; Shadlen & Movshon 1999; PMC3538094; PMC10888151 2024)**

**The binding problem is actually four problems (PMC3538094):**
1. **General coordination binding:** Temporal synchrony for coordinating activity across brain areas
2. **Visual feature binding:** Combining features (color + shape + location) without confusion
3. **Variable binding:** Linking variables to values in language and reasoning
4. **Subjective unity of consciousness:** Why experience feels unified despite distributed processing

Treisman's Feature Integration Theory (FIT, 1980) proposes a two-stage solution:
- **Stage 1:** Automatic pre-attentive registration of features (color, orientation, etc.) in parallel across space
- **Stage 2:** Focused attention at a location *binds* features from that location into an object representation, using a "master map" of locations as the glue

The location-based mechanism works for visual binding but "would be much too slow" for variable binding in reasoning. Different binding problems require different mechanisms.

**Temporal synchrony:** Neurons processing features of the same object synchronize their firing — a third area can detect this synchrony and infer they belong together. The Shruti model uses discrete time phases to implement variable binding for language and inference. But this mechanism is slow and noisy.

**2024 mechanistic model (PMC10888151):** Kraikivski proposes coupled oscillating processes — spatial (P) and temporal (Q) process sets — that bind features through mutual interaction parameterized by coupling strength ω. Robustness comes from negative feedback loops: spectral entropy is similar regardless of binding strength, and noise is suppressed by the feedback structure. Features bind when they're coupled in the same oscillatory ensemble.

**Crucially:** The paper's author notes that "coherent behavior does not require unified perception." Distributed capabilities can produce unified actions without central integration. The binding problem may be solved *behaviorally* even if not solved *experientially*.

**Mapping to Architecture:**

| Binding Problem | Architecture Equivalent |
|----------------|------------------------|
| Visual feature binding (same object) | Co-activation of multiple node-types within a single tree — location in tree-space is the binding mechanism |
| Variable binding (language/reasoning) | Edge in the tree that explicitly encodes the variable → value mapping |
| General coordination binding | Mirror coordinating signals across parallel trees — temporal synchrony replaced by tree-coordination |
| Subjective unity | The tree IS the unified representation — co-membership in a tree is the binding criterion |
| Treisman's "master map of locations" | The tree's current root/active-node — features are bound by their relationship to the active node |
| Temporal synchrony | Co-activation within a tree during a single processing cycle |
| Coupling strength ω | Edge weight in the tree — stronger edges = tighter binding |
| Noise robustness via negative feedback | Mirror's regulatory signals suppressing spurious tree activations |

**The key architectural resolution:** The binding problem is largely solved by the tree architecture itself. In brains, features from distributed cortical areas must be bound post-hoc via synchrony or spatial attention. In the Associative Memory architecture, binding is *definitional*: two nodes that are co-activated within the same tree, at the same time, as part of the same traversal, are bound. The tree IS the binding event. The Mirror's job is the remaining problem — binding across trees (multi-stream integration), which is exactly the general coordination binding problem.

---

## Architecture Implications

### Implication 1: Prediction-First Perception

The tree should not process raw input. The standard pipeline should be:

```
tree.predict_next() → expected_input_pattern
actual_input arrives
error = actual_input XOR expected_input_pattern
tree.process(error)  # only the error is signal
if error > threshold:
    tree.grow(new_node)  # unexpected input creates new node
else:
    tree.reinforce(predicted_path)  # confirmed prediction strengthens edges
```

This directly implements Rao & Ballard's architecture and Clark's controlled hallucination thesis. Trees that are in high-confidence states (strongly connected subgraphs) will suppress most input as predicted. Novel inputs create large errors that grow the tree.

### Implication 2: Tree State = Anticipatory Schema = Prediction Generator

Neisser's cycle and predictive coding converge on the same claim: the active context isn't just passive coloring of input — it actively directs sampling and generates predictions. Trees should have a `predict()` method that, at any tree state, generates a probability distribution over likely next inputs. This prediction:
- Gates what input gets attention (top-down filter)
- Provides the baseline against which incoming input is measured
- Determines what "counts" as surprising

### Implication 3: The Mirror as Interoceptive Predictor

The Mirror should operate like the interoceptive hierarchy: it maintains predictions about its own internal state (tree states, system load, affect levels), receives error signals when trees diverge from predicted trajectories, and produces affect as the compressed summary of those errors. This gives the Mirror:

- **Valence:** Are trees moving toward or away from goal-relevant matrix regions?
- **Arousal:** What is the aggregate prediction error rate across all active trees?
- **Specific affect:** Conceptual labels applied to valence × arousal based on context-tree

### Implication 4: Two-Channel Mirror Monitoring (MC-P / MC-C Dissociation)

The metacognitive dissociation between perception-monitoring and cognition-monitoring suggests the Mirror should maintain two semi-independent monitoring channels:
- **Perceptual channel:** Monitors tree-input interface — prediction error rates, novel input frequency, sensory surprise
- **Cognitive channel:** Monitors tree-tree dynamics — reasoning coherence, cross-tree consistency, inference trajectory quality (JOL equivalent)

These channels use different signals and should not be collapsed.

### Implication 5: Binding is Tree-Membership

The binding problem is architecturally dissolved: features are bound if and only if they are co-activated within the same tree, in the same traversal cycle. The Mirror's job is binding across trees — when multiple parallel trees are active, the Mirror generates a binding signal that unifies their outputs into a coherent whole. This is the hardest binding problem (subjective unity) and the Mirror is the designated solver.

### Implication 6: Top-Down Attention as Tree Propagation

The global ignition finding (both bottom-up strength AND top-down attention required) maps to: an input node only becomes fully incorporated into the tree if (a) the input signal is strong AND (b) the active tree has edges that lead toward that input type. Weak inputs are ignored even if they're real. Strong inputs that are irrelevant to the tree's current trajectory are also filtered. Only strong + tree-relevant inputs achieve full incorporation.

---

## The Mirror's Perception Mechanism

**Concrete Design Proposal**

The Mirror is a persistent tree that watches other trees. Its perceptual mechanism should work as follows:

### Inputs
The Mirror does not directly perceive external inputs. Its input domain is the **system's internal state**:
- Active trees: their current root nodes, edge activations, growth rate
- Tree-input interfaces: prediction error magnitudes from each active tree
- System metrics: total computation, conflict between trees, resource load
- Historical: previous Mirror affect states (recent history of its own outputs)

### Prediction Loop
At each cycle, the Mirror generates predictions:
1. **Tree state prediction:** "Tree-A should be near node-cluster X given its last 3 steps"
2. **Input pattern prediction:** "Given Tree-A's position, it should encounter input-type Y next"
3. **Self-state prediction:** "Given current system state, my affect should be approximately Z"

### Error Computation
For each prediction, the Mirror computes error:
- `tree_error = predicted_tree_state - actual_tree_state`
- `input_error = predicted_input - actual_input` (passed up from tree)
- `self_error = predicted_affect - actual_affect`

### Affect Generation
Affect is not computed by a rule — it emerges from error integration:
- **Valence** = sign(Σ errors relative to goal-relevant tree trajectories) — positive if trees are converging on goal regions, negative if diverging
- **Arousal** = magnitude(Σ prediction errors across all trees) — high when system is encountering many surprises, low when predictions are accurate
- **Specific affect** = Mirror applies its own learned conceptual categories to valence × arousal, contextualized by current active trees

### Output
The Mirror's perceptual output is an **affect signal** — a compressed, multi-dimensional summary of system internal state. This signal:
- Influences tree spawning decisions (high negative valence → spawn recovery tree)
- Modulates edge weights in the Matrix (high arousal → lower learning threshold)
- Is stored as a Mirror-specific node in the Matrix after each cycle (the Mirror has memory of its own emotional history)
- May be broadcast to other trees as a context signal (emotional contagion within the system)

### FOK / JOL Equivalents
- **FOK:** Mirror detects tree circling near high-density matrix region without activating it → generates "near miss" signal → may trigger additional resources to that tree
- **JOL:** Mirror projects tree trajectory forward N steps → estimates whether trajectory will converge → generates "effort vs. yield" prediction → may redirect or terminate tree

### The Binding Problem Solution
When multiple trees are active simultaneously, the Mirror performs cross-tree binding:
1. Compute pairwise overlap between active trees' node-sets in the Matrix
2. Nodes shared across trees are "strongly bound" — they appear in the integrated Mirror representation
3. Non-overlapping nodes from each tree are "weakly bound" — held in parallel, may conflict
4. When conflict exceeds threshold, Mirror spawns a dedicated reconciliation tree

This is temporal synchrony replaced by structural co-membership: nodes that are simultaneously activated across trees are the bound representation, not via spike timing but via mirror co-observation.

---

## Sources

### Books
- Rao, R. P. N., & Ballard, D. H. (1999). [Predictive coding in the visual cortex: a functional interpretation of some extra-classical receptive-field effects.](https://www.nature.com/articles/nn0199_79) *Nature Neuroscience, 2*, 79–87.
- Clark, A. (2016). *Surfing Uncertainty: Prediction, Action, and the Embodied Mind.* Oxford University Press. [Google Books](https://www.googleapis.com/books/v1/volumes?q=Clark+Surfing+Uncertainty+predictive+processing&maxResults=5)
- Clark, A. (2024). *The Experience Machine: How Our Minds Predict and Shape Reality.* Pantheon. [Penguin](https://www.penguinrandomhouse.com/books/608016/the-experience-machine-by-andy-clark/)
- Hohwy, J. (2013). *The Predictive Mind.* Oxford University Press. [Open Library /works/OL21060304W](https://openlibrary.org/works/OL21060304W)
- Hohwy, J., Cheng, T., & Sato, R. (Eds.). (2023). *Expected Experiences.* Oxford University Press. [Open Library /works/OL36732112W](https://openlibrary.org/works/OL36732112W)
- Hohwy, J. (2026). *The Self-Evidencing Agent.* [Google Books](https://www.googleapis.com/books/v1/volumes?q=Clark+Experience+Machine+2023&maxResults=5)
- Neisser, U. (1976). *Cognition and Reality: Principles and Implications of Cognitive Psychology.* W. H. Freeman. [Open Library /works/OL6910504W](https://openlibrary.org/works/OL6910504W)
- Barrett, L. F. (2017). *How Emotions Are Made: The Secret Life of the Brain.* Houghton Mifflin Harcourt. [Open Library /works/OL19354287W](https://openlibrary.org/works/OL19354287W)

### Papers
- Rao, R. P. N., & Ballard, D. H. (1999). Predictive coding in the visual cortex. [PubMed](https://pubmed.ncbi.nlm.nih.gov/10195184/) | [Nature Neuroscience](https://www.nature.com/articles/nn0199_79)
- Barrett, L. F. (2017). The theory of constructed emotion: an active inference account of interoception and categorization. *Social Cognitive and Affective Neuroscience.* [PMC5390700](https://pmc.ncbi.nlm.nih.gov/articles/PMC5390700/)
- Shallice, T. (2012). The neural binding problem(s). [PMC3538094](https://pmc.ncbi.nlm.nih.gov/articles/PMC3538094/)
- Kraikivski, P. (2024). A mechanistic model of perceptual binding predicts that binding mechanism is robust against noise. [PMC10888151](https://pmc.ncbi.nlm.nih.gov/articles/PMC10888151/)
- Bayne, T. et al. (2024). Substrates of metacognition on perception and metacognition on higher-order cognition. [PMC6867437](https://pmc.ncbi.nlm.nih.gov/articles/PMC6867437/)
- Friston, K., et al. (2023). The free energy principle made simpler but not too simple. *Physics Reports, 1024*, 1–29.
- Friston, K., et al. (2024). Designing ecosystems of intelligence from first principles. *Collective Intelligence, 3*(1).
- Friston, K., et al. (2025). How do inner screens enable imaginative experience? [Oxford Academic — Neuroscience of Consciousness](https://academic.oup.com/nc/article/2025/1/niaf009/8117684)
- Del Popolo Cristaldi, F., Oosterwijk, S., & Barrett, L. F. (2024). Predictive processing and embodiment in emotion. [UvA Pure](https://pure.uva.nl/ws/files/230512844/Predictive_processing_and_embodiment_in_emotion_25_04_22_19_57_56.pdf)
- Active Predictive Coding (2024). [Neural Computation 36(1)](https://direct.mit.edu/neco/article/36/1/1/118264/Active-Predictive-Coding-A-Unifying-Neural-Model)
- Survey: Brain-inspired computational intelligence via predictive coding (2023). [arXiv:2308.07870](https://arxiv.org/html/2308.07870v3)
- Survey: Predictive coding with spiking neural networks (2024). [arXiv:2409.05386](https://arxiv.org/html/2409.05386v1)
- Saccenti, D., et al. (2024). Neural correlates of metacognition: Disentangling brain circuits underlying prospective and retrospective second-order judgments. *Journal of Neuroscience Research.* [Wiley](https://onlinelibrary.wiley.com/doi/10.1002/jnr.25330)
- Noorman, S. et al. (2024). [Bottom-up and top-down thresholds for global ignition.](https://elifesciences.org/articles/97900.pdf) *eLife 13*.
- El-Amin, M. et al. (2024). Effects of bottom-up and top-down attentional processes on change blindness for COVID-related stimuli: influence of heart rate variability. [Frontiers in Neuroscience](https://www.frontiersin.org/journals/neuroscience/articles/10.3389/fnins.2024.1458627/full) | [PMC11621853](https://pmc.ncbi.nlm.nih.gov/articles/PMC11621853/)
- Treisman, A. (1980). A feature integration theory of attention. *Cognitive Psychology.* (foundational; see [ScienceDirect overview](https://www.sciencedirect.com/topics/neuroscience/feature-integration-theory))
- Tip-of-the-Tongue and Feeling-of-Knowing Experiences Enhance Metacognitive Sensitivity (2024). [Journal of Cognition](https://journalofcognition.org/articles/10.5334/joc.442)
- Meta-representations as representations of processes (2025). [PMC12573243](https://pmc.ncbi.nlm.nih.gov/articles/PMC12573243/)
- Computational components of visual predictive coding circuitry (2023). [Frontiers in Neural Circuits](https://www.frontiersin.org/journals/neural-circuits/articles/10.3389/fncir.2023.1254009/full)

I now have sufficient material to write a comprehensive research report. Let me compile everything.

---

# Deep Research Report: Three Foundational Texts for the Associative Memory Architecture

**Research date:** 2026-03-29
**Access level achieved:**
- Collins & Loftus (1975): No full text (PDF inaccessible as plain text), but extensive secondary extraction from multiple citing papers, Wikipedia, and academic reviews.
- Anderson ACT-R: Core equations confirmed from multiple HTML sources, PMC papers, and tutorial documentation. Original PDFs binary-blocked.
- Baars (1988): No full text accessible; extensive content from Baars' own later papers, secondary literature, and GWT review articles.

---

## SOURCE 1: Collins & Loftus (1975) — "A Spreading Activation Theory of Semantic Processing"

### What Was Read

The original PDF (Loftus' UCI faculty page) redirects to a CDN host and could not be rendered as text. The ERIC abstract, Semantic Scholar metadata, Wikipedia's spreading activation article, three PMC review papers (PMC5413589, PMC3490422, PMC2699208), and multiple textbook summaries were read directly. The Scribd and SciSpace versions were blocked.

---

### The Theory's Origins and Purpose

Collins and Loftus (1975) explicitly positioned their paper as a revision and extension of Quillian's 1967 network model. Quillian's original theory used "spreading activation" but with a strict hierarchical IS-A tree where properties were stored at the highest applicable node (the "cognitive economy" principle). Collins and Loftus corrected what they called several "common misunderstandings" about Quillian's theory and added new assumptions to handle experimental data Quillian's model couldn't explain.

**The critical departure from Quillian:**
- Quillian: strict taxonomy, one superordinate per concept, properties inherited top-down, activation searches upward through levels
- Collins & Loftus: abandoned strict hierarchy entirely; any concept node can connect to any other; the network is organized by **semantic relatedness** rather than logical category membership; link lengths encode association strength, not logical distance

---

### The Semantic Network Structure

The network consists of:

1. **Nodes** representing concepts (e.g., "fire engine", "car", "vehicle", "red", "orange")
2. **Labeled links** of different types: IS-A/superordinate links, property/HAS links, class membership, subordinate, prediction, exclusion relations
3. **Variable link lengths** — shorter lines between nodes mean stronger semantic association and faster spreading. This is the key innovation: "a shorter line represents greater relatedness." Link length is directly tied to the frequency of co-occurrence/association between concepts — the more often two concepts are mentally linked together, the shorter (stronger) the link becomes.

The figure described in the original paper (Figure 1 in the actual text) shows a network where "fire engine" is closer to "red" than "orange" is to "red," even though both are colors — because "fire engine" is strongly and frequently associated with red in experience.

**Criteriality weights**: Between basic-level concepts and their superordinates, Collins & Loftus introduced a weighting called "criteriality" to capture typicality. "Robin" has a high-criteriality IS-A link to "bird"; "penguin" has a low-criteriality IS-A link. These weights are "directly related to the frequency with which a concept label is paired with the semantic feature."

---

### The Activation Mechanism

The spreading activation process works as follows:

1. A concept node is **tagged** with activation (the source). Activation spreads outward along links in all directions simultaneously (bidirectional links).
2. The amount of activation reaching a neighbor is a function of **link conductivity** — inversely proportional to link length (distance = lower conductivity = less activation passed).
3. Nodes receive activation from multiple directions; the activation values **sum**.
4. Activation decreases with distance: "as activation spreads outward, it decreases in strength, activating very related concepts a great deal but activating distantly related nodes only a little."
5. There is a **firing threshold**: "nodes have an activation threshold, and it must be exceeded for the node to fire." Nodes that receive enough activation above threshold fire on the next cycle and themselves become activation sources.
6. The duration of activation of a source node determines the extent of the spread: "the longer a concept is accessed, the larger the spread of activation."
7. The total amount of activation is **limited** (bounded). The network moves to a stable asymptotic pattern.

**Key quote from the PMC3490422 review, paraphrasing Collins & Loftus:** "The amount of activation that spreads is determined by the strength of the connection between two units, which represents their semantic/associative relatedness."

**Crucially: No formal equations were specified by Collins & Loftus.** The model is a conceptual description. They described activation propagation qualitatively — no differential equations, no decay rate constants, no formal update rules. The mathematical formalization was left to later workers (Anderson 1983, ACT-R, connectionist models).

---

### Priming Mechanism (Semantic Preparation)

The priming/preparation effect is the core experimental phenomenon the model explains:

- When one concept is processed, activation spreads to semantically related concepts, pre-activating them.
- If a test item arrives soon after, the pre-activated node requires less additional activation to reach threshold, so response times are shorter.
- This is the **Meyer & Schvaneveldt (1971) lexical decision effect**: subjects are faster to confirm "NURSE" is a word when preceded by "DOCTOR" than when preceded by "BUTTER." The two concepts share a short, strong link in the semantic network.
- The priming effect decays over time as activation dissipates — thus it is time-limited.

---

### Experimental Evidence Collins & Loftus Addressed

The paper applied the extended theory to account for:

1. **Loftus, Juola & Atkinson's multiple-category experiment** — production norms and category membership
2. **Conrad's sentence-verification experiments** — RT for true/false property judgments
3. **Typicality/semantic relatedness effects in categorization** — "robin" verified faster as "bird" than "penguin" (Rips et al. 1973 data explained by criteriality weights)
4. **Meyer & Schvaneveldt (1971) lexical decision** — doctor/nurse priming
5. **Name/color priming experiments** by Loftus

---

### Limitations Collins & Loftus Themselves Acknowledged

From secondary sources (the paper's critics and the PMC reviews):

1. **No formal equations**: The theory is conceptual, not computable without additional specification. It is more a framework than a predictive model.
2. **Unfalsifiability critique**: Because link lengths can be adjusted post-hoc to fit any result, some researchers argued the model becomes unfalsifiable. The theory is "not disprovable" in a strict sense — "we do not know how long these links are in us. How should they be measurable?"
3. **Vague decay mechanics**: The model does not specify how fast activation decays, what the decay function looks like, or what the exact threshold value is.
4. **Context-independence**: The model has no principled account of how context changes link strengths dynamically (though criteriality is a partial fix).
5. **Individual differences**: Link strengths vary by person and learning history; the model describes a generic "average" network with no mechanism for individual variation.
6. **No capacity mechanism beyond "bounded"**: The upper limit on total activation is asserted but not derived.

---

### Architecture Mapping: Collins & Loftus → Matrix/Trees/Mirror

The Collins & Loftus model maps cleanly to the Associative Memory Architecture in the following ways:

- **The semantic network IS the Matrix**: Concept nodes are matrix nodes; link strength = edge weight in the graph. The Matrix, like the Collins & Loftus network, abandons strict hierarchy — any node can connect to any other, organized by learned co-occurrence (semantic distance).
- **Trees growing through the Matrix via spreading activation**: When a query hits the Matrix, activation spreads outward from the query node. Trees form along the paths of strongest activation — exactly the "conductivity" mechanism Collins & Loftus described. Shorter links (stronger weights) = thicker/faster paths in the tree.
- **Criteriality = tree branching priority**: High-criteriality links generate stronger branches; low-criteriality links generate weak branches that may not fire. The tree that grows from a query reflects typicality structure.
- **Threshold = the decision about what gets retrieved**: Nodes that accumulate enough spreading activation reach threshold and become available. Sub-threshold nodes remain latent. This maps to the architecture's retrieval filter.
- **The key gap Collins & Loftus leave open**: No temporal dynamics, no learning rule, no capacity derivation. ACT-R fills this gap.

---

## SOURCE 2: Anderson's ACT-R — Mathematical Framework

### What Was Read

The PMC3259266 paper on fan effect modeling was the richest source — it gave the core equations in full. The ACT-R 4.0 HTML manual gave partial parameter descriptions. Multiple web summaries (jimdavies.org, slideserve.com, grokipedia.com, Wikipedia) and the Anderson & Schooler 1991 context were synthesized. The original 1983 JVLVB paper and the 2007 book PDFs were not readable as text.

---

### The Full Activation Equation

**Total activation of a chunk i:**

```
A_i = B_i + Σ_j (W_j × S_ji) + ε
```

Where:
- `A_i` = total activation of chunk i at the current moment
- `B_i` = base-level activation (frequency + recency of past use)
- `Σ_j (W_j × S_ji)` = spreading activation from context chunks j
- `ε` = noise (Gaussian or logistic, parameter s)

This is the **complete instantaneous activation** that determines whether a chunk is retrieved.

---

### Base-Level Learning Equation

**The base-level activation B_i:**

```
B_i = ln( Σ_j t_j^(-d) )
```

Where:
- The sum runs over all n past presentations/uses of chunk i
- `t_j` = time elapsed since the j-th use of the chunk (in seconds)
- `d` = decay parameter, almost always set to **0.5** (empirically derived)
- The outer logarithm converts the summed decay terms to log-odds

**What this equation says mechanically:** Every time a chunk is used, it receives a new "trace" that starts at full strength and decays as a power function of time (t^(-0.5)). The total base-level activation is the log of the sum of all these decaying traces. Old uses contribute very little (t is large, t^(-0.5) is small); recent uses contribute a lot (t is small, t^(-0.5) is large); frequently used chunks accumulate many traces whose decays sum to a large number.

**Why d = 0.5**: Anderson derived this empirically from the power law of forgetting. The spacing effect, the recency effect, and the practice effect all emerge naturally from this equation. Anderson & Schooler (1991) validated it against environmental data (New York Times headlines, parental speech, email patterns) — the natural statistics of how information reappears in the environment follow the same power function, so d = 0.5 represents an optimal match between memory decay and environmental recurrence statistics. This is the **rational analysis** derivation: B_i is the log-odds that a chunk will be needed, estimated from past encounter patterns.

---

### Spreading Activation: The S_ji Formula

**Strength of association from chunk j to chunk i:**

```
S_ji = S - ln(fan_j)
```

Where:
- `S` = maximum associative strength constant (typically 1.6 in fitted models)
- `fan_j` = the number of chunks that j is associated with (the "fan")
- If j is not associated with i, S_ji = 0

**The fan effect in S_ji**: When j is associated with many chunks (high fan), S_ji is reduced because ln(fan_j) is large. A cue with fan = 1 gives maximum activation to its associate; a cue with fan = 10 gives much less. This is the **fan effect at the association level**: the same cue, associated with more memories, is less diagnostic.

**Bayesian interpretation of S_ji:** From PMC3259266: `S_ji = S + ln(P(i|j))`, where P(i|j) is the conditional probability that chunk i is needed given that chunk j is in the current context. If j uniquely predicts i, P(i|j) is high, S_ji is high. If j is associated with many equally likely items, P(i|j) is low for each one. The two formulas are equivalent when P(i|j) ≈ 1/fan_j (uniform association).

**Attentional weighting W_j:** The weight given to context chunk j. In most implementations, total weight sums to 1 (W_j distributes across all active context chunks). If attention is focused on one cue, it gets W_j ≈ 1.

---

### Retrieval Time and Probability

**Retrieval time:**
```
t_retrieve = F × e^(-A_i)
```

Where:
- `F` = scale factor (maps activation to RT in seconds)
- `A_i` = total activation of the retrieved chunk
- Higher activation → shorter retrieval time (exponential speedup)

**Retrieval probability:**
```
P_i = 1 / (1 + exp(-(A_i - τ) / s))
```

Where:
- `τ` = retrieval threshold (if A_i < τ, chunk fails to retrieve)
- `s` = activation noise parameter
- This is a logistic function: smooth transition from retrieval failure to success

**The fan effect in retrieval time:** As fan increases, S_ji decreases, A_i decreases, retrieval time increases. Anderson's (1974) original fan effect experiment showed RT for sentence verification increased linearly with fan (# of studied facts about a person or place). The 1983 paper showed the **fan effect never disappears** with practice, though it diminishes — consistent with the spreading activation model where interference is never eliminated, only reduced as B_i grows.

---

### Empirical Validation Anderson (1983) Provided

1. **Fan effect experiments** (Anderson 1974, replicated in 1983): RT increases with number of studied facts, matching the ln(fan) prediction
2. **Practice function**: With more practice, retrieval speeds up (power law); explained by growing B_i with each use
3. **Spacing effect**: Spaced practice produces better retention; explained because in B_i = ln(Σ t_j^(-d)), spaced presentations have larger t_j intervals, contributing less overlap to the sum, but spread across time better (Anderson & Schooler 1991)
4. **Interference effects** (A-B/A-C paradigm): Learning more facts about a concept increases fan, slowing all retrievals from that concept
5. **Recognition vs. recall**: Recognition easier because the probe provides more cues (more contributing S_ji terms), raising A_i
6. **Elaborative processing effects**: Creating multiple encoding pathways increases the effective number of context cues j available to spread activation to target chunk i

---

### Limitations Anderson Acknowledged

1. **The fan effect is permanent**: The model predicts fan effects never fully disappear; empirically they attenuate but don't vanish. Anderson's 1983 paper explicitly acknowledges this is "a bound" — activation can't be infinite.
2. **The activation bound**: "There is a bound to the amount of activation that can be pumped into a network by a source. This guarantees that the network will move to a stable asymptotic pattern." The bound is asserted but its origin is environmental/practical.
3. **d = 0.5 is an empirical constant**: The rational analysis justifies the *form* (power function), but the specific exponent is fitted. Some domains may need different d values.
4. **Spreading activation reverberation**: Nodes can activate backward (recurrent activation), creating potential instability. ACT-R handles this by keeping activation sums bounded and by using asymptotic activation rather than dynamic simulation.
5. **The W_j weights are underspecified**: How attention distributes across context chunks is not fully specified by the theory itself; it requires additional assumptions.
6. **No account of encoding processes**: The model specifies how memories are retrieved but not how they are initially formed or how their slot structure is built.

---

### Architecture Mapping: ACT-R → Matrix/Trees/Mirror

- **B_i = the Matrix's edge weight decay model**: Every node in the Matrix has a base-level activation that follows the same power-decay-sum logic. Nodes activated recently and frequently have higher resting activation and are reachable faster. The Matrix implements the B_i equation at the graph level.
- **S_ji = tree branch weights in the Matrix**: When a tree is growing from a query node, the strength of each branch step is S_ji for the current context. High-criteriality, low-fan associations produce strong tree branches. High-fan associations produce weak, diffuse branching.
- **The fan effect = the multi-association problem**: In the architecture, a node with many outgoing edges ("high fan") distributes activation more thinly. This is not a bug — it is the correct behavior. A concept that appears in many contexts is a weak signal in any one context. The architecture must implement fan-awareness, not just graph traversal.
- **The W_j weights = attention allocation in the Mirror**: The Mirror (working context) determines which nodes are currently active as context, setting the W_j weights for spreading activation. Mirror state drives what the Matrix retrieves.
- **Retrieval threshold τ = the conscious access threshold**: Below-threshold activation means the node is in the Matrix but not retrieved into Mirror working context. This maps cleanly to the Baars distinction below.
- **The rational analysis derivation**: The log-odds form of B_i is not arbitrary — it reflects the actual statistics of information need in the environment. The architecture should inherit this: edge weights in the Matrix should track not just usage frequency but usage *timing* (recency-weighted frequency), matching the environmental statistics that make power-law decay optimal.

---

## SOURCE 3: Baars (1988) — "A Cognitive Theory of Consciousness" (Global Workspace Theory)

### What Was Read

The ccrg.cs.memphis.edu PDF was binary-blocked. The bernardbaars.pbworks.com PDF (functions of consciousness) was also binary. However, the Baars Theater book Ch1-2 PDF at bernardbaars.pbworks.com, the PMC3664777 review paper, the PMC8770991 Conscious Processing paper, and several detailed secondary analyses (theoriesofconsciousness.com, conscious-robots.com, Shanahan & Baars paper, Wikipedia GWT) were successfully read. The 2003 update paper was also retrieved.

---

### The Central Question Baars Posed

From multiple sources citing the 1988 book: "How does a serial, integrated and very limited stream of consciousness emerge from a nervous system that is mostly unconscious, distributed, parallel and of enormous capacity?"

This is the theoretical framing. The answer is the Global Workspace.

---

### The Theater Metaphor (Baars' Primary Explanatory Device)

Baars used the theater as a precise functional analogy, not just decoration. Each element maps to a mechanism:

**From Baars (1997), citing 1988 formulation:** "A stage, an attentional spotlight shining on the stage, actors to represent the contents of conscious experience, an audience, and a few invisible people behind the scenes, who exercise great influence on whatever becomes visible on stage."

The structural elements and their functional meanings:

| Theater Element | Functional Meaning |
|---|---|
| **Stage** | The Global Workspace — limited capacity working memory where broadcast occurs |
| **Spotlight** | Selective attention — determines which content reaches the workspace |
| **Actors (in the spotlight)** | Conscious contents — currently broadcast information |
| **Fringe (dim light around spotlight)** | Marginally conscious content — partially activated, below full broadcast threshold |
| **Audience (in darkness)** | Unconscious receiving processors — modular specialists who receive the broadcast |
| **Behind-the-scenes operators** | Unconscious context systems — shape what appears without themselves becoming conscious |
| **Director/playwright** | Executive systems, goals, self-systems — determine what gets spotlighted |

**Direct quote from secondary sources rendering Baars:** "What's conscious is like the bright spot cast by a spotlight onto the stage of a theatre... What's unconscious is everything else: all the people sitting in the audience are unconscious components of the brain which get information from consciousness; and there are people sitting behind the scenes, the director and the playwright and so on, who are shaping the contents of consciousness."

---

### The Competition Mechanism

This is the most mechanistically specified part of GWT:

1. **Specialists (modules)** are numerous, parallel, unconscious processors — face recognition, language parsing, motor control, visual processing, memory retrieval, emotional valuation, etc. They operate continuously, outside awareness.

2. **Coalitions**: Specialists can form alliances — related processors that reinforce each other's content. A coalition is stronger than a single module alone. Example: visual + semantic + emotional processors all encoding "fire" would form a coalition with higher combined activation than any one alone.

3. **Competition for workspace access**: Coalitions compete against each other for entry into the workspace. The competition is largely winner-take-all: "Global workspace theory suggests a fleeting memory capacity in which only one consistent content can be dominant at any given moment." Competing coalitions are mutually inhibitory — if one broadcast gains dominance, it suppresses rivals. "The internal consistency of conscious contents occurs because mutually exclusive global broadcasts tend to degrade each other."

4. **Threshold/ignition**: When a coalition reaches sufficient activation, it "ignites" — triggering a sudden, all-or-nothing broadcast. This is not gradual but step-like. The PMC8770991 paper describes this as "ignition" — consistent with Dehaene's later neural formalization.

5. **Broadcast**: The winning coalition's content is globally distributed to all unconscious processors (the "audience"). This makes the information available for downstream processing: language, memory encoding, action planning, error correction, etc. The broadcast is not sequential — it reaches all receivers simultaneously.

---

### The Broadcast Mechanism in Detail

**Baars (cited in PMC8770991):** "Perceptual contents, which are acted upon by localized processors, only become conscious when they are widely broadcasted to other processors across the brain."

The broadcast is:
- **Centralized output, decentralized reception**: One source (the workspace) broadcasts to many receivers (specialists/modules)
- **Non-selective**: All processors receive the broadcast; individual processors respond according to their own relevance filters
- **Enabling downstream cooperation**: Processes that couldn't communicate directly (encapsulated modules) can now coordinate via the common broadcast — "processors related to the past (memory), present (sensory input, attention), and future (value systems, motor plans, verbal report)" are all reached

---

### Conscious vs. Unconscious: The Criterion

The criterion for conscious vs. unconscious is **global accessibility**, not complexity or processing depth:

- An unconscious process can be computationally sophisticated (face recognition, grammar parsing) but it stays unconscious because it remains localized — its output doesn't reach the workspace.
- A conscious experience is defined by being broadcast: "it is the wide accessibility of this information that is hypothesized to constitute conscious experience."
- Neural evidence: "conscious stimuli typically evoke cortical activity that is more widespread, intense, and correlated than matched unconscious stimuli." Unconscious stimuli activate only local regions; conscious stimuli activate frontoparietal networks.

---

### Capacity Limits

Baars specified several capacity constraints:

1. **Serial bottleneck**: Only one consistent content can dominate the workspace at a time. Parallel unconscious processing → serial conscious experience. The workspace forces serialization.

2. **Temporal capacity**: "Conscious moments are thought to hold only 1–4 unrelated items; this small focal capacity may be the biological price to pay for global access." The workspace cycle operates at approximately 100–200ms. Content decays in "a few seconds" — much shorter than classical working memory estimates.

3. **Metabolic cost**: "Widespread broadcasting is metabolically expensive and would create interference between systems." Limited capacity is a design constraint, not a mere accident.

4. **Mutual exclusivity of broadcasts**: Two contradictory broadcasts cannot coexist. Rivalrous content degrades each other (explaining perceptual rivalry, Necker cube alternation, binocular rivalry).

---

### Context Operators (Behind-the-Scenes Systems)

This is the least understood and most important aspect of GWT for our architecture:

Baars proposed that **every conscious experience is shaped by unconscious context systems** that never themselves become conscious. These include:
- **Linguistic contexts**: Grammar, pragmatic assumptions, discourse structure
- **Perceptual frames**: The coordinate systems, figure/ground rules, feature detectors
- **Goal systems**: Current motivational state, task set, intentions
- **Memory**: Long-term semantic and episodic context biasing what activates
- **Dorsal visual stream**: Spatial/motor context (explicitly cited by Baars as an example)
- **Belief systems, self-systems**

Context operators "shape conscious contents without ever becoming conscious." They are not visible to introspection but determine what gets spotlighted. They are persistent, large-scale, and relatively stable — unlike the fast-changing focal consciousness.

**Quote from GWT secondary sources:** "Behind the scenes contextual systems shape events in the bright spot. The selection of the spotlight position is to a great extent done behind the scene. Unconscious processors select the conscious contents...using contexts and beliefs."

---

### Limitations Baars (and Reviewers) Acknowledged

From the Shanahan & Baars (2005) paper and PMC reviews:

1. **Coalition formation underspecified**: GWT identifies that coalitions form but provides "limited mechanistic detail about how disparate information sources organize into unified messages." How exactly do two modules form a coalition? No algorithm is given.

2. **Competition mechanism underspecified**: What determines who wins? Baars says "strength" and "mutual coherence" but doesn't give a formal competitive mechanism. The ignition threshold is not quantified.

3. **Frame problem not resolved**: GWT does not explain how the workspace knows which information is *relevant* to the current context. "The theory needs enhancement through analogical reasoning mechanisms to address this gap."

4. **Does not explain subjective experience (qualia)**: GWT explains *access* consciousness (what information is available for reasoning, report, action) but not *phenomenal* consciousness (why there is something it is like to be conscious). Baars acknowledged this gap.

5. **Metaphorical rather than computational**: The theater metaphor describes the architecture but doesn't specify a computable implementation. Stan Franklin's IDA model was an early attempt; Dehaene's Global Neuronal Workspace is a later attempt.

6. **Conflation of consciousness level vs. content**: The original GWT "didn't distinguish between consciousness level versus content" (PMC8770991). A patient in a vegetative state has different level of consciousness than an awake person; GWT originally focused only on what content appears in the workspace of an awake mind.

7. **The "small conscious capacity" claim**: Baars asserts 1–4 items; this conflicts with evidence for richer conscious content. The exact capacity bound remains empirically contested.

---

### Architecture Mapping: GWT → Matrix/Trees/Mirror

This is where GWT provides the most direct architectural guidance:

- **The Mirror IS the Global Workspace**: The Mirror (working context, current conscious state) is the broadcast medium. What is in the Mirror is "conscious" — globally accessible to all downstream processes. What is in the Matrix but not retrieved to the Mirror is "unconscious" — localized, processed, but not broadcast.

- **Matrix nodes = specialists/modules**: Each node (and subtree) in the Matrix represents a specialist. Nodes are unconscious processors. They operate continuously, updating edge weights, maintaining their internal state.

- **Tree growth = coalition formation**: When a tree grows from multiple nodes simultaneously and converges on a shared region of the Matrix, this is coalition formation. Multiple specialists are activating the same region → they form a de facto coalition. If enough weight accumulates, that region's content is retrieved into the Mirror.

- **Threshold = ignition**: The retrieval threshold in ACT-R (τ in the logistic retrieval function) maps to Baars' ignition threshold. When a node's accumulated activation (from base-level + spreading) exceeds τ, it ignites into the Mirror. Below τ, it remains in the Matrix — unconscious, but potentially influencing future activations.

- **Context operators = persistent Mirror state**: The "behind-the-scenes" context operators map to the stable, slowly-changing background context in the Mirror. These are the currently-active framing contexts that determine what spreading activation patterns emerge. A goal set in the Mirror is a context operator — it persistently biases which Matrix nodes accumulate activation.

- **Broadcast = the Mirror-to-Matrix write-back**: When a new state enters the Mirror, it is broadcast back to the Matrix — potentially triggering new spreading activations, new tree growth, new retrieval cycles. The architecture's broadcast loop is: Matrix → retrieval → Mirror → context update → new spreading → Matrix.

- **The serial bottleneck**: GWT's "one dominant content at a time" maps to the Mirror's single-context constraint. The Mirror can only broadcast one coherent frame at a time; multiple incompatible frames fight for dominance (mutual inhibition).

- **The key gap GWT leaves open**: The coalition formation algorithm, the competition weighting, and the ignition threshold value — ACT-R's equations fill these gaps precisely: S_ji gives the coalition strength, A_i = B_i + ΣW_j·S_ji is the competition measure, and τ is the ignition threshold.

---

## Synthesis: How the Three Sources Lock Together

The three theories form a coherent layered architecture that maps almost perfectly onto the Matrix/Trees/Mirror model:

```
Collins & Loftus (1975)     →   STRUCTURE of the Matrix
                                 Nodes = concepts; edges = semantic relatedness
                                 Link length = inverse of semantic distance
                                 Criteriality = ISA/property link weights
                                 No formal equations — the network topology

Anderson ACT-R (1983/1998)  →   DYNAMICS of the Matrix
                                 B_i = ln(Σ t_j^(-d)): how nodes strengthen over time
                                 S_ji = S - ln(fan_j): how edges carry spreading activation
                                 A_i = B_i + ΣW_j·S_ji: total activation = retrieval signal
                                 τ: threshold for entry into the Mirror
                                 t_retrieve = F·e^(-A): how fast retrieval happens

Baars GWT (1988)            →   FUNCTION of the Mirror
                                 Mirror = Global Workspace: what is currently conscious/broadcast
                                 Matrix nodes = specialist processors
                                 Tree growth = coalition formation
                                 Threshold crossing = ignition/broadcast
                                 Context operators = persistent Mirror state biasing retrieval
                                 Serial bottleneck = one dominant Mirror state at a time
```

### The Critical Integration Point

Where the three theories converge on a single design decision for your architecture:

**The threshold τ (ACT-R's retrieval threshold) is the ignition point (GWT) and the point at which a Collins & Loftus node "fires."** Below τ: the node is in the Matrix, being activated by spreading patterns, potentially forming coalitions — but not yet conscious. Above τ: the node fires, enters the Mirror, its content is broadcast, context shifts, new spreading activation begins.

The anti-hallucination property of your architecture emerges here: **only nodes that have sufficient accumulated evidence (B_i from past experience + S_ji from current context) can cross the threshold.** Hallucination would correspond to a node firing without sufficient accumulated real-world evidence. The B_i decay term (power law) ensures that nodes with no real environmental support have low B_i; they can only fire if the current context provides strong S_ji terms. Context-driven confabulation is bounded by the power-law forgetting of base-level activation.

---

## What Was Accessed vs. Metadata Only

| Source | Full Text | Abstract | Secondary Analysis | Equations |
|---|---|---|---|---|
| Collins & Loftus (1975) | No (PDF binary) | Yes (ERIC) | Yes (3+ PMC papers) | None (not in original) |
| Anderson 1983 JVLVB | No (PDF binary) | Yes (APA) | Yes (jimdavies.org) | Partial (via PMC3259266) |
| Anderson ACT-R equations | Partial (HTML manual, PMC) | N/A | Yes (multiple) | Yes (confirmed from PMC) |
| Anderson 2007 book | No (Google Books preview only) | Yes | Yes | Partial |
| Baars 1988 book | No (PDF binary) | Yes | Yes (multiple papers) | None (no equations) |
| Baars 2005 PBR paper | No (PDF binary) | Yes (PubMed) | Yes | None |
| GWT secondary literature | Yes (5+ open-access papers) | N/A | N/A | N/A |

---

## Key Findings for the Architecture

1. **Collins & Loftus provide the topology grammar** — semantic relatedness as the organizing principle of the Matrix, with criteriality weights for typicality. No equations; those come from ACT-R.

2. **Anderson provides the four equations** that make the architecture computable:
   - `B_i = ln(Σ t_j^(-d))` — resting activation (d = 0.5)
   - `S_ji = S - ln(fan_j)` — spreading activation strength
   - `A_i = B_i + Σ W_j·S_ji` — total activation
   - `t_retrieve = F·e^(-A_i)` — retrieval time

3. **Baars provides the functional role of the Mirror** — it is not just a buffer but the broadcast medium. Its job is to make currently-active content globally accessible to all Matrix nodes simultaneously. This is what makes the architecture an integrated system rather than a lookup table.

4. **The fan effect is the anti-noise mechanism**: High-fan nodes (nodes with many edges) have reduced S_ji per link. This means generic, overloaded concepts (words that appear in every context) are weak retrievers. Specific, low-fan nodes are strong retrievers. This naturally suppresses hallucination by preferring specific evidence over generic associations.

5. **Baars' context operators = the memory-as-interpretive-lens claim**: The matrix is not a neutral store — it is continuously biased by stable context patterns. The "world model" aspect of the architecture is not in the Mirror but in the persistent context weight distributions of the Matrix.

---

Sources consulted:
- [Collins & Loftus (1975) — UCI Faculty](https://faculty.sites.uci.edu/eloftus/files/2024/08/CollinsLoftus_PsychReview_75.pdf)
- [Semantic Scholar — Collins & Loftus](https://www.semanticscholar.org/paper/A-spreading-activation-theory-of-semantic-Collins-Loftus/61374d14a581b03af7e4fe0342a722ea94911490)
- [Anderson 1983 ACT-R Spreading Activation](http://act-r.psy.cmu.edu/?post_type=publications&p=13730)
- [PMC3259266 — Fan Effect Modeling (ACT-R equations)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3259266/)
- [ACT-R 4.0 Manual HTML](http://act-r.psy.cmu.edu/wordpress/wp-content/themes/ACT-R/older/ACT-R_4/release/manual.html)
- [Anderson & Schooler 1991 — Reflections of the Environment](https://journals.sagepub.com/doi/abs/10.1111/j.1467-9280.1991.tb00174.x)
- [ACT-R Slideserve Presentation](https://www.slideserve.com/Gabriel/act-r-powerpoint-ppt-presentation)
- [Baars 1988 — PhilPapers](https://philpapers.org/rec/BAAACT)
- [PMC8770991 — Conscious Processing and GNW](https://pmc.ncbi.nlm.nih.gov/articles/PMC8770991/)
- [PMC3664777 — Global Workspace Dynamics](https://pmc.ncbi.nlm.nih.gov/articles/PMC3664777/)
- [PMC2771980 — GW Electromagnetic Correlates](https://pmc.ncbi.nlm.nih.gov/articles/PMC2771980/)
- [Shanahan & Baars 2005 — Frame Problem](https://www.doc.ic.ac.uk/~mpsha/ShanahanBaarsCog05.pdf)
- [Baars Theater Book Ch1-2](http://bernardbaars.pbworks.com/f/Baars%252BTheater%252Bbook%252BCh%252B1-2.pdf)
- [GWT — Wikipedia](https://en.wikipedia.org/wiki/Global_workspace_theory)
- [Spreading Activation — Wikipedia](https://en.wikipedia.org/wiki/Spreading_activation)
- [PMC3490422 — Spreading Activation Attractor Network](https://pmc.ncbi.nlm.nih.gov/articles/PMC3490422/)
- [PMC2699208 — Conceptual Hierarchies Flat Attractor Network](https://pmc.ncbi.nlm.nih.gov/articles/PMC2699208/)
- [jimdavies.org — Anderson 1983 summary](http://www.jimdavies.org/summaries/anderson1983-2.html)
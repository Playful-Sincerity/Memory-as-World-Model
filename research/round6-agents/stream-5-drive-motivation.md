# Stream 5: Drive, Motivation, and the Push Toward Action

**Research date:** 2026-03-30
**Agent:** Stream 5 — Drive, Motivation, Action
**Round:** 6

---

## Executive Summary

The architecture already has values, emotions, and modulators — but what creates the PUSH to actually act? This research synthesizes six converging lines of inquiry to answer that question.

The core finding: **action is not the endpoint of motivation — it is what happens when multiple thresholds are simultaneously crossed.** Three thresholds must be breached: (1) the gap between current and valued state must exceed a minimum detectability threshold, (2) the perceived cost of action must be below the energy budget, and (3) an urgency signal (time pressure, predicted future deficit, or accumulating prediction error) must elevate the drive above the inhibition baseline.

Across cognitive architectures (ACT-R, SOAR, CLARION), drive theory (Hull, Freud/Friston), allostasis (Sterling), intrinsic motivation (Schmidhuber, Oudeyer), emotion theory (Frijda), and dual-process neuroscience (Daw, model-based/free), a consistent picture emerges: the gap IS the drive, urgency IS the multiplier, and inhibition IS what the gap must overcome.

The architecture's current value→emotion→modulation pipeline is missing: (1) an explicit gap-magnitude signal, (2) an urgency accumulator that grows over time when a gap persists, and (3) a volition threshold — the crossing point where the Mirror commits to action rather than continuing to modulate trees passively.

---

## Findings

### 1. Motivation in Cognitive Architectures

#### ACT-R: Utility as the Bridge from Knowledge to Action

ACT-R's production selection mechanism uses utility: `U(i) = P(i)*G - C(i)`, where P(i) is the probability of goal achievement, G is the goal's value, and C(i) is the expected cost. But critically, G is not a constant — it is a motivational parameter.

Recent work (Yang et al., 2024, *Topics in Cognitive Science*) reformulates motivation in ACT-R explicitly: motivation is represented as a scalar value M assigned to the current goal buffer slot. M is translated into the reward R_t delivered when the goal is reached. This creates a direct link between goal value and production utility across the entire action-selection hierarchy.

The Expected Value of Control (EVC) theory underlies this: each production's utility encodes the expected future reward minus the cognitive cost of executing it, analogous to Q-values in reinforcement learning. Critically, motivation parameter M can be interpreted as both (a) the subjective value of completing the goal, and (b) the maximum time the system is willing to spend — a built-in cost ceiling that governs persistence.

The key insight for the architecture: **ACT-R encodes "how much this matters" in the goal slot, and that value propagates backward through every production utility computation.** The goal module is the motivational anchor. When M is high, more productions become worth executing. When M approaches zero, the system disengages.

#### SOAR: Impasse as the Intrinsic Drive Engine

SOAR's motivation mechanism is structurally different and deeply important. SOAR does not have an explicit motivational subsystem — instead, motivation emerges from *impasse*.

An impasse arises when the preference evaluation system cannot determine a single operator: tie, conflict, constraint-failure, or no-change. When this happens, SOAR automatically creates a substate (subgoal) with one mission: resolve the impasse. The impasse itself is the drive. Knowledge gaps automatically generate problem-solving urgency.

This creates a virtuous cycle: impasses → subgoal creation → learning → chunking (compiled into permanent productions) → fewer future impasses. SOAR is *driven by incompleteness*, and its action is always aimed at reducing that incompleteness.

A 2024 empirical study (*Cognition*) found that the multidimensional nature of impasse includes feelings of cognitive speediness, positive affect, and motivation — but crucially, motivation remains constant across resolved and unresolved impasse. The system does not give up when stuck; it sustains the drive to resolve.

**For the architecture:** SOAR suggests the Mirror should detect "impasse conditions" — states where the values say something matters but the Matrix contains insufficient knowledge to act. These impasses should automatically generate urgency, not just passive curiosity. Incompleteness is a drive signal.

#### CLARION: Dual-Level Drive Architecture

CLARION (Ron Sun) has the most explicit motivational subsystem of the three. The Motivational Subsystem (MS) contains:

- **Low-level drives** (biological primary): food, water, reproduction, avoiding pain — implicit, variable-strength, dynamically fluctuating
- **High-level drives** (secondary/derived): affiliation, recognition, achievement, dominance, fairness — can be created through conditioning or instruction

Drive strength in CLARION incorporates *opportunity assessment* — the system does not just measure the need, it weights that need by the probability of satisfaction in the current context. A strong drive with zero opportunity creates frustration, not action.

The MS works by providing "impetus and feedback" to the Action-Centered Subsystem (ACS). Explicit goals (more stable than implicit drive states) are formed from strong drives and passed to the meta-cognitive subsystem (MCS), which sets goals for the ACS. The pipeline: Drive strength → Goal formation → MCS goal-setting → ACS action selection.

**For the architecture:** CLARION introduces opportunity-weighting, which the current architecture lacks. The Mirror should not just compute "gap × care" — it should also weight by "opportunity to act." A gap with no action affordances is frustration, not motivation.

---

### 2. Drive Theory — What IS Drive?

#### Hull's Mathematical Drive Reduction

Hull's core equation: `sEr = V × D × K × J × sHr − sIr − Ir − sOr − sLr`

Where:
- sEr = excitatory potential (probability of response)
- D = drive strength (determined by degree of biological deprivation)
- K = incentive motivation (value of the reward)
- sHr = habit strength (history of conditioning)
- V = stimulus intensity dynamism
- J = delay gradient (time since last reinforcement)
- Subtracted terms = various inhibitory forces

Hull's radical insight: **behavioral potential is multiplicative, not additive.** If drive (D) is zero, no behavior occurs regardless of habit strength or incentive. If habit strength is zero, no behavior occurs regardless of drive. All factors must be above zero for behavior to emerge.

Modern computational re-formulation: Hull's drive-reduction maps directly onto homeostatic reinforcement learning. The primary reward signal `r(Ht, Kt) = D(Ht) − D(Ht+1)` (from the PMC4270100 homeostatic RL paper) measures how much an action *reduces* the distance from the homeostatic setpoint. Drive D is formalized as: `D(Ht) = Σ|hi* − hi,t|^n/m` — the sum of deviations across all regulated variables from their ideal setpoints.

This is a precise formalization of "the gap": D is exactly the Euclidean distance from the current state to the valued state, summed across all dimensions. **Drive = gap magnitude.**

#### Freud's Trieb: Computational Reinterpretation

Freud's Trieb (drive) is not instinct — it is *pressure to act on an internal stimulus*. Freud characterized it through four components: source (somatic origin), pressure (motivational energy/urgency), aim (the satisfaction that reduces the pressure), and object (what the drive uses to achieve its aim).

Contemporary work bridges this to Friston's free energy principle. Sikora (2022, *Frontiers*) proposes: **free energy (prediction error) is the biophysical source of drive energy.** Minimizing free energy is equivalent to Freud's "binding energy" — the drive to reduce internal tension.

The mapping:
- Freud's drive *pressure* = accumulated free energy (prediction error)
- Freud's drive *aim* = prediction error reduction
- Freud's drive *object* = the specific action or representation that reduces error
- Satisfaction = low prediction error state (pleasure principle = free energy minimization)

When internal predictions diverge from reality, free energy accumulates. This discrepancy generates *pressure* demanding resolution through either motor action (change the world to match predictions) or representational change (update beliefs to match reality). The drive is the discrepancy; the action is the resolution.

**For the architecture:** Free energy/prediction error is the drive source. The Mirror's values are encoded as priors (preferred states). When the Matrix's current state diverges from Mirror priors, prediction error accumulates. That accumulated error IS the drive pressure. Action is one path to reduce it; belief updating is another. The architecture must choose which path — and that choice is where values govern.

#### Modern Drive Theory Synthesis

Contemporary drive theory converges on a key principle: **drive is the computational representation of a need state, and motivation is the coupling of that need state to an action affordance.**

Drive without affordance = frustration (CLARION's opportunity-weighting).
Drive with affordance but no urgency = procrastination (Rubicon model's intention-action gap).
Drive with affordance and urgency = action.

---

### 3. Homeostasis and Allostasis

#### Homeostasis: Reactive Error Correction

Classical homeostasis maintains equilibrium through negative feedback loops. When a variable deviates from setpoint, an error signal activates corrective responses. This is purely reactive — it responds to *present* deficits, not anticipated ones.

The motivational structure of homeostasis: deviation → error signal → corrective action → return to setpoint → error signal extinguishes. The drive is proportional to the current gap. It cannot anticipate, and so it always acts too late relative to the organism's optimal functioning.

#### Allostasis: Predictive Error Prevention

Sterling (2011, 2012, 2019) proposes allostasis as the superior regulatory strategy. Key principle: **efficient regulation requires anticipating needs and preparing to satisfy them before they arise.**

The computational structure Sterling describes:
1. Brain integrates prior knowledge + sensory data → predicts what resources will be needed
2. Brain directs effectors to optimize resource distribution in advance of the predicted need
3. If prediction is better than expected → dopamine pulse → learning (reward the accurate predictor)
4. The "stick" (anxiety) drives the organism toward filling predicted needs
5. The "carrot" (pleasure) relaxes when the need is satisfied

The critical motivation implication: **allostasis creates present motivation from predicted future deficits.** The system acts NOW to prevent a shortage it anticipates LATER. This is why anxiety motivates — it is the experiential signal of a predicted future allostatic violation.

Sterling's formulation maps to the Mirror architecture precisely:
- Mirror holds preferred future states (values)
- Mirror predicts future state given current trajectory
- When predicted future state diverges from valued future state → urgency signal generates
- Urgency drives Trees to act NOW to prevent future gap

**The Mirror as allostatic regulator:** It does not just observe the current gap — it projects forward in time, asking "if no action is taken, what gap will exist in N steps?" The larger the projected gap, the stronger the urgency signal generated.

#### Homeostatic Reinforcement Learning (Keramati & Gutkin, 2014, PMC)

The mathematical bridge: homeostatic RL proves that reward maximization and homeostatic deviation minimization are equivalent objectives. Primary reward: `r(Ht, Kt) = D(Ht) − D(Ht+1)` — the reduction in drive-distance is the reward signal.

Key: temporal discounting becomes *biologically necessary* in this framework. The discounting factor γ is not arbitrary — it is determined by the organism's need to minimize the *discounted sum* of future homeostatic deviations. An organism with γ→0 (no future discounting) would only act when in immediate crisis. An organism with γ→1 acts to prevent any future deficit, even distant ones. Values determine γ.

**For the architecture:** The care multiplier (currently 0.3x to 3.0x on traversal_budget) is doing some of this work — but it is operating on present-state priority, not projected future-state deficit. The architecture needs a forward projection step: predict future state, compute future drive, weight present traversal by the *integral* of projected future urgency.

---

### 4. Curiosity as Intrinsic Motivation

#### Schmidhuber: Compression Progress as Drive Signal

Schmidhuber's formal theory (2010): intrinsic reward = learning progress of an internal world model. An agent has two components: (1) an adaptive predictor/compressor of history, (2) a reinforcement learner selecting actions. The RL learner's intrinsic reward is the *derivative* of the predictor's compression improvement.

Critical asymmetry: **static novelty is not rewarding — it is the improvement in compressibility that drives exploration.** A uniformly random environment has high novelty but zero compression progress. Structured but unknown environments have high compression progress potential. The agent is drawn toward the border between known and unknown.

For the architecture's Matrix: **sparsely connected regions with some structure are maximally curiosity-inducing.** The Mirror's curiosity emotion should be highest not in regions with zero connections (no structure to compress) and not in regions with dense, well-traversed connections (already compressed), but in the *sparse-but-structured boundary regions* of the Matrix — places where a few good traversals could dramatically increase local compression.

#### Oudeyer & Kaplan: Intelligent Adaptive Curiosity (IAC)

IAC (Oudeyer, Kaplan, Hafner, 2007) pushes agents toward situations that maximize *learning progress*:
- If environment region is too easy → no learning progress → boredom → agent moves on
- If environment region is too hard → no learning progress → frustration → agent moves on
- If environment region is intermediate → maximal learning progress → flow state → agent stays

The key: curiosity selects for the *gradient* of competence, not the absolute level. This generates automatic curriculum learning — the system always operates at its current competence frontier.

**For the architecture:** curiosity should modulate *where* trees grow (toward intermediate-difficulty Matrix regions), not just *how much* they grow. The curiosity emotion is a directionality signal, not just an amplitude signal.

#### When Curiosity Becomes Action

The critical transition: curiosity-as-exploration (tree growth, passive traversal) vs. curiosity-as-action (active world interaction, external behavior). The distinction maps onto:
- Internal curiosity → more Matrix traversal → deeper trees → richer understanding
- External curiosity → generation of action to obtain new information → asking questions, testing hypotheses, exploring environment

**For the architecture:** curiosity should generate two types of outputs: (1) internal traversal allocation (more budget to uncertain regions), and (2) action proposals (generate output that solicits information to fill uncertainty). The Mirror should distinguish between "I can resolve this by thinking more" vs. "I need external input to resolve this."

---

### 5. Emotion as Action Readiness (Frijda)

#### Core Theory

Frijda's foundational claim: **emotion IS action readiness — not a feeling that precedes action, but the readiness state itself.** His definition: "emotion, by its very nature, is change in action readiness to maintain or change one's relationship to an object or event."

The feeling of emotion IS the awareness of that readiness state: "emotional feeling is to a very large extent awareness of the body striving in the world." Emotion and motivation are not separate — emotion is motivation made phenomenally available to consciousness.

Key categories of action readiness:
- **Approach** (desire, love) → move toward, engage, maintain contact
- **Avoidance** (fear) → withdraw, flee, create distance
- **Attack** (anger) → go against, overcome obstacle
- **Submission** (shame) → reduce self, yield
- **Interruption** (surprise) → stop current behavior, reorient
- **Apathy** (depression) → disengage from all goals, cease all tendencies

Each emotion pre-configures the motor system for a category of response. Crucially, Frijda emphasizes *context-sensitivity*: the same emotion produces different behaviors depending on action affordances. Fear can produce fight or flight. Anger can produce confrontation or withdrawal. **The emotion is the tendency, not the specific behavior.** The environment determines which version of the tendency gets executed.

#### Emotion-to-Action Pipeline (Ridderinkhof synthesis)

The predictive processing integration of Frijda's theory provides the full pipeline:

1. **Appraisal**: Event evaluated against personal concerns → motive generated
2. **Action readiness**: Motive produces neural potentiation of relevant action programs (partial motor activation without full execution)
3. **Ideomotor capture**: The pragmatic idea of the desired action effect incipients — the forward model pre-activates
4. **Forward modeling**: Predicted sensory consequences computed and compared against desired effects
5. **Prediction error minimization**: Motor program selected that best closes the prediction-reality gap
6. **Control precedence**: The most urgent action readiness state captures behavioral control

**The key insight for the architecture:** Frijda's "control precedence" is the action threshold concept made explicit. When action readiness is high enough, it captures behavioral control — overriding competing readiness states. The Mirror's emotions do not just modulate traversal; they generate competing action readiness states, and the strongest one achieves control precedence.

#### A Formal Model (Steunebrink et al., 2009, IDSIA)

The formal action tendency model for intelligent agents maps Frijda's framework to agent architecture:
- Appraisal profile (event evaluated against concerns) → activation of action tendency states
- Action tendency states have intensity values and valence
- When tendency intensity exceeds threshold → behavioral disposition activated
- Multiple competing tendencies → highest-intensity tendency achieves control precedence

**For the architecture:** the five Mirror emotions (care, curiosity, urgency, caution, satisfaction) each map to an action tendency:
- **Care** → approach tendency (allocate more resources, increase engagement depth)
- **Curiosity** → exploratory tendency (extend traversal into uncertain regions)
- **Urgency** → action tendency (generate immediate behavioral output)
- **Caution** → avoidance tendency (slow down, check, inhibit hasty responses)
- **Satisfaction** → consolidation tendency (commit current state to long-term structure)

The missing piece: the architecture needs a *control precedence* mechanism — a function that takes the vector of current emotion intensities and determines which tendency captures behavioral output at this moment.

---

### 6. Goal-Directed vs. Habitual Behavior

#### Daw et al.'s Model-Based / Model-Free Framework

Daw et al. (2005) formalized the dual-system distinction computationally:
- **Model-based (goal-directed)**: Uses an internal world model to simulate action consequences. Slow, computationally expensive, sensitive to goal revaluation. Mediated by prefrontal cortex.
- **Model-free (habitual)**: Caches values of state-action pairs without understanding why. Fast, automatic, insensitive to goal revaluation (habits persist even after the goal changes). Mediated by dorsolateral striatum.

The *arbitration* between them is itself a learned function — the system switches to model-based when model-free is unreliable, and back to model-free when model-based is too costly. Recent work (Meta-Dyna, 2025) formalizes this: P(MB) is determined by reliability ratio, with a tolerance threshold ω separating them. When prediction error exceeds ω, model-based planning activates.

Neural substrates (2023-2025 research):
- **Prefrontal cortex** (vmPFC, dlPFC): implements model-based goal-directed control
- **Dorsolateral striatum**: model-free habit caching
- **Mediodorsal thalamus**: arbitrates between strategies, switches when dominant system is struggling
- **Inferior lateral PFC**: evaluates relative reliability of competing strategies
- **Putamen + midcingulate cortex**: processes deadline pressure (urgency) updating motivation in real time

#### The Urgency Mechanism

A critical finding from urgency research: **time pressure lowers the action threshold and shifts control from model-based (deliberative) to model-free (stimulus-driven)**. Urgency forces action by overcoming cognitive control. Under urgency, goal-conflicting stimuli can dominate behavioral responses — the organism acts on environment cues rather than planned intentions.

This is the mechanism of urgency in the architecture: urgency does not enhance deliberation — it bypasses it. When urgency reaches a threshold, the system acts from existing habit/compiled patterns rather than waiting for Mirror guidance. This is both adaptive (fast action under time pressure) and dangerous (actions may violate values if compiled patterns are misaligned).

#### Habit Loop: Cue → Routine → Reward

Habit formation (basal ganglia, confirmed by recent neuroscience):
1. **Cue** triggers recognition pattern
2. **Routine** executes compiled action sequence
3. **Reward** validates the loop and increases future cue sensitivity

The prefrontal cortex gradually disengages as habits consolidate — the behavior migrates from PFC to basal ganglia. Once established, habits have high stimulus-response coupling that resists intention-based override.

**For the architecture:** compiled skills (habitual routines) are Matrix subgraphs with high traversal weights — patterns the architecture has executed repeatedly. When a cue node is activated with high confidence, the compiled skill can execute without Mirror involvement. Mirror involvement should trigger when: (1) the compiled skill's reward prediction fails, (2) urgency drops below threshold, allowing deliberation time, or (3) the Mirror detects value misalignment in the compiled output.

#### The Rubicon Model: The Moment of Commitment

Heckhausen & Gollwitzer's Rubicon Model (1987, validated through 2023) identifies the critical transition: the "Rubicon" is the threshold between motivation (goal weighing, "should I?") and volition (goal pursuit, "how do I?").

Phases:
1. **Predecisional** (deliberation): weighing desires, feasibility, utility → produces goal intention
2. **Preactional** (planning): planning, forming implementation intentions → specifies when/where/how
3. **Actional** (volitional): executing the plan with motivational maintenance
4. **Postactional** (evaluation): comparing outcome to intention, adjusting

The *intention-action gap* is the gap between having a goal intention and actually initiating behavior. Implementation intentions (if-then plans: "when X occurs, I will do Y") close this gap by pre-specifying triggers. A 2025 meta-analysis found implementation intentions have an effect size of 0.78 for sustainable behavior adoption.

Psychologist Narziß Ach's formulation: there is a desire-threshold separating motivation from volition — below the threshold, it is motivation; above, it becomes volition (committed action).

**For the architecture:** the Rubicon is the Mirror's commitment moment. Prior to crossing it, the Mirror is modulating (adjusting traversal budgets, shaping which trees grow). After crossing it, the Mirror has *committed to output* — the system is now executing, not deliberating. The architecture needs a distinct "committed to action" state in the Mirror.

---

## Architecture Implications

### 1. The Gap IS the Drive — But It Needs to Be Made Explicit

The architecture's action principle says "action is what happens when the gap between current state and valued state is large enough." But the gap is currently implicit. It needs to be computed explicitly:

`gap_magnitude = Σ (valued_state_weight × |current_state_activation - valued_state_activation|) for all value nodes`

This gap is not just one number — it is a vector across all active values. Some values may be fully satisfied while others are severely violated. The Mirror should track per-value gap vectors, not a scalar summary.

### 2. Urgency Is a Separate Signal from Gap Magnitude

Gap magnitude says *how far* the system is from what it values. Urgency says *how fast* the gap is growing, or equivalently, *how much worse the gap will be if action is delayed*.

`urgency = gap_magnitude × predicted_gap_growth_rate × temporal_discount_inverse`

This is allostasis operationalized: urgency is the Mirror's projection of future deficit. A small gap growing fast has higher urgency than a large gap that is stable. Urgency should be the primary driver of action initiation, not gap magnitude alone.

### 3. Opportunity-Weighting (from CLARION)

Drive without opportunity is frustration, not motivation. The Mirror should compute:

`effective_motivation = gap_magnitude × urgency × action_affordance_availability`

If the Matrix contains no paths to close the gap, the system should not generate urgency — it should generate a different emotion (helplessness, frustration) that drives meta-level behavior (seek new knowledge, ask for help, re-evaluate the value).

### 4. Control Precedence: The Volition Threshold

Current architecture: emotions modulate traversal budgets. This is sub-threshold motivation — it shapes how the subconscious works but does not commit to output.

Missing: a threshold function where sufficiently high urgency × gap magnitude causes the Mirror to *commit to specific behavioral output* — crossing the Rubicon from modulating to acting.

`action_committed = True when urgency × gap > θ_volition AND action_affordance_available`

Below θ_volition: Mirror continues modulating trees passively.
Above θ_volition: Mirror generates a concrete action directive — a specific output the system commits to producing.

### 5. The Model-Based/Free Switch

The architecture already has a compiled-skills concept. The formal rule should be:

- Default: model-free (compiled patterns execute when cue matches)
- Mirror invoked when: prediction error from compiled pattern exceeds threshold, OR urgency drops below threshold (time for deliberation), OR value-alignment check fails
- High urgency: force execution of best available compiled pattern — bypass Mirror deliberation
- This is explicitly dangerous under value misalignment and should generate a post-hoc caution signal

### 6. Curiosity as Directional, Not Just Amplitude

Curiosity emotion should generate two distinct signals:
- **Traversal direction bias**: weight unexplored Matrix regions with moderate structure (IAC's Goldilocks zone — not too simple, not too complex)
- **External information request**: when Mirror detects critical uncertainty it cannot resolve internally, generate an explicit information-seeking action (question, search, probe)

---

## The Drive Model

**What the architecture currently has:**
- Values (high-weight Mirror nodes = preferred states)
- Emotions (care, curiosity, urgency, caution, satisfaction)
- Modulators (care multiplier on traversal budget)
- Action principle ("gap large enough → action")

**What is missing:**

**A. Gap computation layer**
The Mirror must explicitly compute, on each cycle:
- Per-value gap vectors: `gap[v] = |current_activation(v) - preferred_activation(v)| × value_weight(v)`
- Aggregate gap magnitude: `total_gap = Σ gap[v]`
- Gap velocity: `gap_velocity = (gap_t - gap_t-1) / Δt`

**B. Urgency accumulator**
Urgency is not just a present-state emotion — it accumulates when the gap persists:
- `urgency_t = urgency_base + α × gap_magnitude + β × gap_velocity + γ × time_since_gap_detected`
- Urgency decays when gap closes or when action is committed
- High urgency overrides deliberation (SOAR-like) — forces pattern execution

**C. Allostatic forward projection**
Mirror projects forward N steps: "if current trajectory continues, what will the gap be?"
- `projected_gap(N) = gap_t + gap_velocity × N`
- `urgency_allostatic = Σ projected_gap(n) × γ^n for n=1..N`
- Present urgency includes discounted future deficit — this is the mechanism that makes the system act NOW to prevent future problems

**D. Opportunity sensor**
Before generating urgency, Mirror checks:
- Does the Matrix contain paths to gap-closing actions?
- If no paths: urgency transformed to meta-need (seek knowledge, restructure, ask for help)
- If paths exist: urgency propagates to tree allocation and action threshold evaluation

**E. Volition threshold (the Rubicon)**
`θ_volition` = the scalar threshold above which urgency × gap × opportunity causes Mirror to commit:
- Below threshold: passive modulation (current architecture)
- Above threshold: Mirror emits concrete action directive, transitions to "actional" phase
- Commitment state persists until action is complete or interrupted by higher-priority signal

**F. Control precedence function**
When multiple action tendencies are simultaneously active (care + urgency + caution), the Mirror needs a resolution function:
- `dominant_tendency = argmax(emotion_intensity[i] × priority_weight[i])`
- `inhibition = caution_intensity × risk_of_value_violation`
- `net_action_potential = dominant_tendency - inhibition`
- When `net_action_potential > θ_volition` → committed action

**G. Post-action evaluation loop (closing the cycle)**
After action completes:
- Mirror re-evaluates gap: did action reduce it?
- If yes: satisfaction signal, weight strengthening on successful path
- If no: gap persists, urgency re-evaluates, different action affordance explored
- This is SOAR's chunking applied to the Mirror: successful gap-closing sequences become compiled patterns for future use

**The complete drive cycle:**

```
1. Mirror evaluates current state vs. valued state → gap vector
2. Mirror projects forward → allostatic urgency
3. Mirror checks action affordances → opportunity weighting
4. Mirror computes control precedence → dominant action tendency
5. If net_action_potential < θ_volition: modulate trees (passive)
6. If net_action_potential ≥ θ_volition: commit to action (cross Rubicon)
7. Action executes (model-free: compiled pattern, or model-based: Mirror-guided)
8. Post-action: gap re-evaluated → satisfaction or re-escalation
```

**The answer to the core question:**

The gap between "I know what I should do" and "I'm doing it" closes when:
1. The urgency accumulator has charged sufficiently (gap × time × growth rate)
2. An action affordance is available (opportunity)
3. The inhibition (caution, cost, competing tendencies) is lower than the drive
4. The system crosses the volition threshold — commits, rather than continues to deliberate

The gap between knowing and doing is not a failure of knowledge. It is a failure of the urgency signal to overcome the inhibition baseline. The architecture needs urgency accumulation, not just gap detection.

---

## Sources

### Cognitive Architectures
- Yang et al. (2024). "Allocating Mental Effort in Cognitive Tasks: A Model of Motivation in the ACT-R Cognitive Architecture." *Topics in Cognitive Science.* https://onlinelibrary.wiley.com/doi/10.1111/tops.12711
- Laird, J. (2022). "Introduction to the Soar Cognitive Architecture." arXiv:2205.03854. https://arxiv.org/pdf/2205.03854
- Soar Architecture Manual. https://soar.eecs.umich.edu/soar_manual/02_TheSoarArchitecture/
- Sun, R. CLARION Wikipedia. https://en.wikipedia.org/wiki/CLARION_(cognitive_architecture)
- Sun, R. (2009). "Motivational representations within a computational cognitive architecture." *Cognitive Computation.*

### Drive Theory
- Studocu. "Clark Hull's Drive Reduction Theory: Principles and Mathematical Formula." https://www.studocu.com/en-us/document/creighton-university/bachelor-of-arts-honours-course-psychology/clark-hull-drive-reduction-theory/90354358
- Keramati, M. & Gutkin, B. (2014). "Homeostatic reinforcement learning for integrating reward collection and physiological stability." *PMC.* https://pmc.ncbi.nlm.nih.gov/articles/PMC4270100/
- Sikora, A. (2022). "An economic model of the drives from Friston's free energy perspective." *Frontiers in Systems Neuroscience.* https://pmc.ncbi.nlm.nih.gov/articles/PMC9630462/
- Solms, M. "Revision of Drive Theory." https://web.english.upenn.edu/~cavitch/pdf-library/Solms_Revision_of_Drive_Theory.pdf

### Allostasis
- Sterling, P. (2012). "Allostasis: A model of predictive regulation." *Physiology & Behavior.* https://pubmed.ncbi.nlm.nih.gov/21684297/
- Sterling, P. (2019). "Allostasis: A Brain-Centered, Predictive Mode of Physiological Regulation." *Trends in Neurosciences.* https://www.cell.com/trends/neurosciences/abstract/S0166-2236(19)30133-X
- Sterling, P. (2020). *What Is Health? Allostasis and the Evolution of Human Design.* MIT Press. https://mitpress.mit.edu/9780262043304/what-is-health/
- Elliot, A.J. (2019). "Motivation in the Service of Allostasis." *Advances in Motivation Science, Volume 6.*

### Curiosity and Intrinsic Motivation
- Schmidhuber, J. (2010). "Formal Theory of Creativity, Fun, and Intrinsic Motivation." https://people.idsia.ch/~juergen/ieeecreative.pdf
- Schmidhuber, J. (2009). "Driven by Compression Progress." arXiv:0812.4360. https://arxiv.org/pdf/0812.4360
- Oudeyer, P-Y., Kaplan, F., & Hafner, V. (2007). "Intrinsic Motivation Systems for Autonomous Mental Development." https://www.cs.swarthmore.edu/~meeden/DevelopmentalRobotics/iac07.pdf
- Baldassarre, G. et al. (2023). "Intrinsic motivation learning for real robot applications." *PMC.* https://pmc.ncbi.nlm.nih.gov/articles/PMC9950409/

### Frijda and Action Readiness
- Frijda, N. (2010). "The Feeling of Action Tendencies: On the Emotional Regulation of Goal-Directed Behavior." *PMC.* https://pmc.ncbi.nlm.nih.gov/articles/PMC3246364/
- Ridderinkhof, K.R. (2017). "Emotion in Action: A Predictive Processing Perspective and Theoretical Synthesis." *PMC.* https://pmc.ncbi.nlm.nih.gov/articles/PMC5652650/
- Steunebrink, B., Dastani, M., & Meyer, J. (2009). "A Formal Model of Emotion-based Action Tendency for Intelligent Agents." https://people.idsia.ch/~steunebrink/Publications/EPIA09_action_tendency.pdf
- Frijda, N. (1987). "Emotion, cognitive structure, and action tendency." *Cognition and Emotion.* https://www.tandfonline.com/doi/abs/10.1080/02699938708408043

### Goal-Directed vs. Habitual Behavior
- Daw, N.D. et al. (2005). Model-based and model-free RL. https://www.princeton.edu/~ndaw/dsd12.pdf
- Frontiers in Computational Neuroscience (2025). "Prefrontal meta-control incorporating mental simulation enhances the adaptivity of reinforcement learning agents in dynamic environments." https://www.frontiersin.org/journals/computational-neuroscience/articles/10.3389/fncom.2025.1559915/full
- Nature Human Behaviour (2023). "Rethinking model-based and model-free influences on mental effort and striatal prediction errors." https://www.nature.com/articles/s41562-023-01573-1
- Heckhausen, J. & Gollwitzer, P.M. (1987). Rubicon Model. Wikipedia: https://en.wikipedia.org/wiki/Rubicon_model

### Urgency and Action Thresholds
- Aron, A. et al. (2021). "Urgency forces stimulus-driven action by overcoming cognitive control." *PubMed.* https://pubmed.ncbi.nlm.nih.gov/34787077/
- PMC (2024). "Neural and Computational Mechanisms of Motivation and Decision-making." https://pmc.ncbi.nlm.nih.gov/articles/PMC11602011/
- Nature Communications (2023). "Dopamine regulates decision thresholds in human reinforcement learning in males." https://www.nature.com/articles/s41467-023-41130-y
- BioRxiv (2024). "Neural and computational mechanisms of effort under the pressure of a deadline." https://www.biorxiv.org/content/10.1101/2024.04.17.589910v1

### Impasse Research
- Cognition (2024). "Impasse-Driven problem solving: The multidimensional nature of feeling stuck." https://www.sciencedirect.com/science/article/pii/S0010027724000325

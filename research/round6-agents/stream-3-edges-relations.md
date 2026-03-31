# Stream 3: Edges, Relations, and the Semantics of Connection

## Executive Summary

Relations are not mere connectors — they are first-class semantic entities whose meaning can be partially independent of their endpoints. This is the central finding across six bodies of research. Cognitive science (Halford, Gentner) shows that human intelligence critically depends on representing relations as distinct from the objects they connect, and that analogical reasoning requires relations *between* relations (second-order structure). Knowledge graph research (TransE through QuatE and beyond) encodes each relation as a geometric *operation* (translation, rotation, scaling) rather than a label — the relation IS the transformation. Hypergraph research demonstrates that n-ary relationships captured atomically preserve semantic content that binary decomposition destroys. Category theory (ologs, CT for AI) offers a morphism-first ontology where arrows are as fundamental as objects, composition is enforced, and analogies become commutative diagrams. Philosophy confirms that external relations carry genuine information not reducible to their relata.

For the Associative Memory Architecture: edges should be first-class entities with layered semantic content (geometry + natural language meaning + role metadata), capable of participating in higher-order relationships. The bipartite storage pattern — edges as nodes in a separate layer — is the practical implementation path.

---

## Findings

### 1. Relational Reasoning in Cognitive Science

**Halford's Relational Complexity Theory** (Halford, Wilson & Phillips, 1998; _Behavioral and Brain Sciences_) defines cognitive complexity in terms of relation arity — the number of arguments a relation takes simultaneously. A binary relation (e.g., "larger-than") has two slots; a quaternary relation has four. The central empirical finding: adult human working memory is limited to processing roughly one quaternary relation at a time. Children develop through progressively higher relation arities with age.

The decisive architectural implication is what Halford calls the **binding problem**: representing a relation requires simultaneously holding all its arguments in active state and binding them to the relation's roles. This is computationally different from representing an entity. Relations are not merely labeled edges — they are structured slots that must be instantiated together. The complexity is intrinsic to the relation's arity, not to the entities it connects.

Halford's work, extended via category theory by Steven Phillips, connects to systematicity: the fact that if a system can process `LOVE(John, Mary)` it can also process `LOVE(Mary, John)`. This isn't a coincidence — it follows from the categorical structure of how relations compose. Relations must be separable from their arguments; you can't have systematicity if the relation's meaning is fused into the specific entity pair.

**Key implication for the architecture**: Relations need role-aware slots, not just endpoints. An edge from A to B along relation R should record *which role A plays in R* and *which role B plays in R*. The same relation can instantiate with different entity pairs, and this re-use is computationally meaningful.

**Phillips & Wilson's synthesis (2014, _PLOS One_)** demonstrated that Gentner's G-systematicity (prefer systems of higher-order connected relations over isolated ones) and Fodor's F-systematicity (certain capacities imply related capacities) both derive from the same category-theoretic universal construction. Systematicity is the optimal solution, not an architectural accident.

---

### 2. Knowledge Graph Embeddings

The KG embedding literature has converged on a powerful insight: **a relation is best modeled as a geometric operation on entity representations**, not as an entity-like vector in its own right.

**TransE (Bordes et al., 2013)**: Relation r is a translation vector. For a valid triple (h, r, t): h + r ≈ t. Simple and interpretable — the relation is a displacement in embedding space. Limitation: cannot model one-to-many, many-to-one, or symmetric relations without collapse.

**RotatE (Sun et al., 2019)**: Relation r is a rotation in the complex plane. For valid (h, r, t): h ∘ r = t (Hadamard product with unit-modulus complex r). Euler's identity grounds this: r = e^(iθ) represents a rotation by angle θ. This elegantly handles symmetry (θ = π), antisymmetry (θ ≠ -θ), inversion (r⁻¹), and composition (rotations compose). RotatE achieves MRR ~0.79 on FB15K-237; TP-RotatE (2025, combining path rules with rotations) pushes to MRR 0.827 on FB15K.

**ComplEx (Trouillon et al., 2016)**: Uses complex-valued embeddings with Hermitian dot products. A relation becomes a complex matrix acting on entity embeddings. Handles asymmetry that DistMult (real-valued) cannot.

**QuatE (Zhang et al., 2019)**: Uses quaternion algebra (Hamilton product ⊗). Relations are quaternion rotations in 4D hypercomplex space, enabling richer semantic matching between head and tail. The additional degrees of freedom in quaternion multiplication can capture patterns complex numbers cannot.

**CompoundE (2022+)**: Generalizes all of the above by combining translation, rotation, and scaling as compound operations. Any relation type can be represented in the unified framework.

**What does this mean for the meaning of a relation?** In RotatE, the semantic content of "is-capital-of" IS the rotation angle — the operation that, when applied to a country embedding, produces a city embedding. The relation encodes a transformation between two regions of semantic space. This is a profound insight: relations are not labels but *change operators* in a semantic geometry. Two relations that are compositionally related (e.g., "parent-of" composed with "sibling-of" = "uncle-of") will have geometrically composable representations in RotatE.

**Hyper-relational embeddings (2023-2025)**: Standard KGE models handle binary triples. For n-ary facts (e.g., "Einstein won the Nobel Prize in Physics in 1921 while at the ETH"), qualifier pairs are needed. Models like StarE, NaLP, HyTransformer represent the main triple plus qualifier key-value pairs. The key finding (from the 2025 survey on HKGE models): no current model fully resolves the tension between capturing long-range graph dependencies AND preserving qualifier semantics without information compression. The FormerGNN direction — maintaining separate embedding matrices for qualifiers and main triples, then jointly predicting — is the current frontier.

**Survey coverage**: A comprehensive 2024 ACM Computing Surveys paper (Cao et al., 2024) provides the canonical taxonomy: translation-based, rotation-based, semantic matching (bilinear), and neural models. The 2024 arXiv paper (2410.14733) reviews from a representation spaces perspective.

---

### 3. Hypergraph Architectures

Standard graphs represent binary relationships: one edge, two nodes. A **hyperedge** connects any number of nodes — it IS the higher-order relationship, not a decomposition of it.

**Why hyperedges outperform binary decomposition for semantics**: Consider "Male hypertensive patients with serum creatinine 115–133 μmol/L receive mild-elevation diagnosis." This is a single fact connecting four entities. Decomposed into binary triples, it fragments into disconnected edges whose joint meaning is lost. A single hyperedge atomically preserves the full semantic unit.

HyperGraphRAG (2025, arXiv:2503.21322) demonstrated this empirically: 26,902 hyperedges vs. 5,632 binary relations for the same corpus (5x expressiveness). Medical F1 improved +12.75, legal F1 +13.70 over binary-graph RAG. Each hyperedge stores a natural language description alongside the connected entities.

**Traversal with hyperedges**: The key architectural shift is **two-stage message passing**: nodes → hyperedges → nodes. Information doesn't flow node-to-node directly; it flows through the hyperedge as an intermediary. This is more than an efficiency trick — the hyperedge becomes the *locus of shared context* for all its member nodes. In memory traversal terms: reaching a hyperedge activates all its connected nodes simultaneously.

**Storage pattern**: HyperGraphRAG uses a **bipartite graph** where both entities and hyperedges are nodes, with edges only between entity-nodes and hyperedge-nodes. This gives O(deg(v)) lookups in both directions. The adjacency matrix has block structure M = [0, I; I^T, 0] where I is the incidence matrix.

**AllSet (Chien et al., 2021)**: The most general hypergraph neural network framework. Uses two multiset functions — one aggregating node features into hyperedge representations, one aggregating hyperedge representations back to nodes — adaptively learned. Proven to generalize all MPNN frameworks. This is the theoretical foundation for implementing spreading activation in a hypergraph.

**HGNN taxonomy (2025 survey, arXiv:2503.07959)**: Five categories — convolutional (HGCNs), attention (HGATs), recurrent (HGRNs), autoencoder (HGAEs), generative (DHGGMs). HyperGCN uses spectral theory; HGNN-AS adds self-attention. Computational challenge: spectral methods require eigen-decomposition of the hypergraph Laplacian, expensive for large graphs; spatial methods are more efficient but less expressive.

**When hyperedges are essential vs. optional**: When the relationship has inherent higher-order semantics (medical diagnoses, multi-author attributions, chemical reactions, group events) — use hyperedges. When relationships are genuinely binary — standard edges suffice. The key test: does decomposing the n-ary fact into binary triples require introducing artificial intermediate nodes, and does that introduction lose meaning?

---

### 4. Analogical Reasoning / Structure-Mapping

Gentner's **Structure-Mapping Theory (SMT, 1983; _Cognitive Science_ 7:155-170)** is the foundational and still canonical account. Its core claim is exactly what the architecture's recent insight anticipated: **analogies map relations, not attributes, and they preferentially map systems of higher-order relations**.

**The systematicity principle**: When mapping an analogy from base to target, people prefer to import connected *systems* of relations rather than isolated relations, even if the isolated relations are more surface-similar. "The solar system is like an atom" works because both instantiate REVOLVES-AROUND(x, y) + ATTRACTS(y, x) + MORE-MASSIVE(y, x) as a connected relational system. This systematicity constraint is selection criterion operating on higher-order structure.

**Second-order relations in SMT**: First-order predicates take objects as arguments: LARGER-THAN(sun, planet). Second-order predicates take propositions as arguments: CAUSE[ATTRACTS(sun, planet), ORBITS(planet, sun)]. Gentner (1983) explicitly distinguishes these and argues that it is the second-order relations (like CAUSE) that drive analogical systematicity. The 1997 handbook chapter formalizes: "higher-order predicates that constrain lower-order predicates are central to analogical alignment."

**SME (Structure-Mapping Engine)**: The computational implementation of SMT. It finds structurally consistent correspondences between base and target graphs by identifying "kernels" (small consistent matches) and merging them into structurally consistent mappings. The systematicity bias is implemented as a preference for larger, more deeply connected match structures.

**What the architecture needs to support SMT**:
1. Predicates (edges) must be typed and distinguishable as first-order vs. second-order
2. Edges must be able to take other edges (propositions) as arguments — i.e., hyperedges connecting edge-nodes, not just entity-nodes
3. The "systematicity score" of a match is determined by connected higher-order structure depth
4. Re-representation is sometimes needed: the same fact may need multiple relational framings

**Phillips' category theory unification (2014)**: Both kinds of systematicity derive from **universal constructions** in category theory — specifically, products (capturing shared structure across domains) and their universal property (the most general structure that subsumes both). This means analogical reasoning is not a separate cognitive module but the same operation as systematic composition, just applied across domains.

**MMA (Mathematical Model for Analogy, Correa-Tellez et al., 2017; _PLOS Computational Biology_)**: Formalizes analogy as F-homomorphisms between domains with different symbol systems. Key insight: analogy works even when the surface representations are non-isomorphic, because what is preserved is the *operational structure* (how elements combine), not the elements themselves. This is implemented via term translations F: Π → Ψ that coordinate symbolic rule systems.

---

### 5. The Semantics of "Between"

**Do relations carry meaning independently of their relata?**

The Stanford Encyclopedia of Philosophy article on Relations presents the full philosophical landscape. The key tension:

**Realist view (Russell, Armstrong, Lewis)**: External relations are genuine additions to the world. "Heavier-than(Earth, Moon)" is not derivable from the intrinsic properties of Earth and Moon considered separately — it requires the relation itself as an additional fact. This is the **external relations** position. Russell: "Relations are indispensable to scientific discourse, making eliminativism methodologically implausible."

**Reductionist view**: Internal relations supervene on the intrinsic natures of their relata. The relation "taller-than" between two people follows from their heights — it adds no new being. Armstrong: internal relations are "necessitated by the intrinsic natures" of their relata.

**Bradley's regress**: If a relation R connects entities a and b, then R must be related to a and b — but this requires a new relation R' relating R to a and b, and so on infinitely. The standard resolution (Bertrand Russell, fact-based approaches) is that the *bearing* of a relation is primitive — it cannot be further analyzed as itself requiring a relation. **Architectural lesson**: you cannot analyze relations all the way down to entities; at some level the relation-hood must be taken as primitive.

**The "categorematic" independence question**: Syncategorematic terms lack independent meaning (e.g., "and", "of"). Categorematic terms have independent meaning. Are relations categorematic? The philosophical consensus is: yes for external relations, no for purely internal ones. "Larger-than" has independent meaning that is not fully captured by either "large" or "than" separately. The relation is a genuine semantic unit.

**Computational implications**: You cannot fully reduce a relation to its endpoints. The relation type carries information about the *nature of the connection* — its direction, modality, causal force, temporal structure. A relation that is stored only as a label on an edge loses this depth. A relation that is stored as an entity with its own properties (description, type, causal direction, strength) preserves it.

**The "between" as operational**: The KG embedding literature arrived at this independently: in RotatE, the relation IS the geometric operation between head and tail embeddings. It is not derived from the endpoints — it transforms them. This is the computational analog of external relations in philosophy: the relation carries real semantic content that is not in the entities.

---

### 6. Category Theory in Knowledge Representation

**Category theory offers the most principled foundation for edges-as-entities.** In a category, morphisms (arrows) are co-primary with objects. You cannot have a category with only objects — the arrows define the structure.

**Ologs (Spivak & Kent, 2012; _PLOS One_; arXiv:1102.1889)**: An olog is a category where objects (boxes) are types labeled with noun phrases and arrows are *aspects* — functional relationships. "A person — [has] → a birth year." The key property: aspects are functions, not mere relations. Each source-instance maps to exactly one target-instance. Commutative diagrams express equivalences: "A person's employer's address = a person's work address." This is expressively richer than any graph notation because path equivalences are enforced as constraints.

**Functorial semantics**: An olog is "grounded" when a functor maps from the olog to **Set** (the category of sets and functions), assigning actual instances to each type and actual function-tables to each aspect. This is simultaneously a schema and a query interface. Alignment between two ologs is a functor between them — systematically mapping types to types and aspects to aspects, enabling automated knowledge translation.

**Morphisms vs. graph edges**: Graph edges have no composition constraints. Category theory *requires* composition: if f: A→B and g: B→C then g∘f: A→C must exist and be valid. This enforces that relations compose consistently — a powerful constraint for a knowledge system. It also enables **path equivalence**: two paths from A to C may be declared identical, which is impossible in a plain graph.

**Bicategories of relations (Patterson, 2017; arXiv:1706.00526)**: Extends ologs to use Rel (the category of sets and *relations*, not just functions) as the semantics target. This handles partial, non-functional knowledge — more realistic for real-world knowledge representation. In Rel, morphisms R: X→Y are subsets of X×Y, and composition is relational composition. This is a bicategory (two levels of morphisms: relations between objects, and morphisms between relations), which can naturally represent second-order structure.

**Categorial compositionality in cognition (Phillips & Wilson, 2010; _PLOS Computational Biology_)**: Proves that the systematicity of human cognition — the fact that it is simultaneously productive (can compose arbitrary new thoughts) and systematic (can apply cognitive operations to all structurally similar inputs) — requires a categorical structure. Specifically, it requires that the representations of cognitive capacities form functors between categories. This is not merely a metaphor; it is a formal derivation.

**Category theory for AI (2021-2024; cats.for.ai, Springer 2024)**: Applied CT is being used for: gradient-based learning (backprop as functor), GNNs (graph convolution as natural transformation), probabilistic programming, and automatic differentiation. The Topos Institute (Spivak, Fong) is the primary research hub. The 2024 Springer chapter "Category Theory for Artificial General Intelligence" surveys applications to AGI architectures.

**CT vs. graph theory as foundation**: Graph theory provides structure but no composition constraints, no identity requirement, no functorial semantics. CT provides all of these. For a memory architecture whose correctness depends on the consistency of relational inference, CT is the stronger foundation — but it is also more restrictive. The practical recommendation: use graph theory for implementation (efficient traversal, storage) and CT as the *semantic constraint layer* (what composition must be valid, what path equivalences hold).

---

## Architecture Implications

### 1. Edges Must Be First-Class Entities

Both cognitive science (Halford's binding requirement, Gentner's second-order relations) and computational practice (hyperedge-as-node, HyperGraphRAG's bipartite model, reification in RDF-star) converge on this. An edge that is only a connection between two nodes cannot:
- Be a target of another edge (required for second-order relations)
- Carry its own full semantic content (description, type, strength, provenance)
- Participate in analogical mapping as a structural element
- Be traversed to via spreading activation independently of its endpoints

**Implementation**: Store edges as nodes in a separate layer (the bipartite model). Every relationship (A)-[r]->(B) becomes: (A) ——incidence——> (r) ——incidence——> (B), where r is a proper node with its own properties.

### 2. Edge Properties Should Be Layered

Based on current findings, the minimal rich edge model needs:

| Layer | Properties | Purpose |
|-------|-----------|---------|
| **Geometry** | weight (PMI / co-occurrence strength), direction (asymmetric by default) | Traversal, spreading activation |
| **Type** | episodic / semantic / causal / affordance / analogical / temporal | Selective activation filtering |
| **Meaning** | Natural language description (stored string), role labels for each endpoint | Interpretability, LLM interface |
| **Embedding** | Geometric embedding (RotatE-style rotation vector or CompoundE compound operation) | Learned traversal, similarity |
| **Order** | first-order (connects entities) vs. second-order (connects edges/propositions) | Analogical reasoning |
| **Arity** | unary / binary / n-ary (hyperedge) | Structural integrity |
| **Provenance** | source episode, confidence, decay parameters | Episodic grounding |

### 3. Relations Have Their Own Geometry

The KG embedding literature's core insight should be adopted: each *relation type* has an associated geometric operation (currently best modeled as a rotation in complex/quaternion space). This is not just for machine learning — it represents what the relation *does* semantically. "Causes" is a different operation from "enables" from "is-part-of." These operations compose: "causes" ∘ "causes" = "transitively-causes." Storing the operation type alongside the English description gives the architecture dual access: symbolic (the label) and geometric (the transformation).

### 4. Spreading Activation Over Typed Edges

The Hindsight memory graph (2026) demonstrates the right pattern for spreading activation through typed edges: assign type-based multipliers (causal edges: 2.0×, enables: 1.5×, temporal: 1.0×), and only traverse edges whose weight clears a minimum threshold. Budget-constrained frontier exploration (max nodes per round-trip) maintains predictable performance.

For the Matrix, this means: when a Tree grows through the Matrix via spreading activation, it should follow edge types selectively based on the reasoning task. Causal chains for explanation; temporal edges for narrative reconstruction; semantic edges for concept expansion; analogical edges (second-order) for creative retrieval.

### 5. Hyperedges for Episodic Memory

Episodic memories are inherently n-ary: "Einstein lectured at Princeton in 1933 about general relativity after fleeing Germany." This is a single episodic unit connecting at least 6 entities. Decomposed into binary triples, its coherence is lost. The episodic layer of the Matrix should use hyperedges, stored in the bipartite model, with the hyperedge node carrying the full episodic description as natural language.

### 6. Second-Order Edges Enable Analogy

For analogical reasoning, the architecture needs edges whose endpoints are themselves edges (not entities). "The relationship between Sun and Earth is structurally similar to the relationship between nucleus and electron" is an edge connecting two edges. In the bipartite model, this is natural: since edges are nodes, any node can be connected to any other node — including edge-nodes.

The SME algorithm's key move — finding maximal structurally consistent mappings between relational graphs — can be implemented as a subgraph matching query in the Matrix, preferring matches with deeper second-order relational structure (following the systematicity principle).

---

## Edge Design Recommendations

**Core proposal: the Associative Memory edge is a first-class entity with five layers.**

```
Edge {
  // Identity
  id: uuid

  // Geometry (traversal)
  weight: float          // PMI-derived co-occurrence strength, 0.0–1.0
  direction: enum        // unidirectional | bidirectional | inverse
  decay_rate: float      // temporal decay constant

  // Type (selective traversal)
  type: enum             // semantic | episodic | causal | affordance |
                         // temporal | analogical | categorical
  order: enum            // first_order | second_order | higher_order
  arity: int             // 2 for binary, n for hyperedge

  // Meaning (interpretability + LLM interface)
  description: string    // "causes", "is_part_of", "occurred_before"
  source_role: string    // "agent", "subject", "antecedent"
  target_role: string    // "patient", "object", "consequent"

  // Embedding (learned geometry, optional)
  operation_vector: vector  // RotatE-style rotation in complex/quaternion space

  // Provenance
  source_episode_id: uuid
  confidence: float
  created_at: timestamp
  last_activated: timestamp
}
```

**Composition rule**: For edges of type `causal` or `semantic`, composition must be valid. If edge(A→B, type=causal) and edge(B→C, type=causal) exist, the system can derive edge(A→C, type=causal, weight=w1*w2, order=second_order). This enables implicit transitivity without storing all derived edges.

**Analogical edge type**: When the Mirror (consciousness tree) identifies a structural correspondence between two relational patterns, it creates an `analogical` edge connecting the two edge-nodes. This is a second-order edge in the hypergraph. The analogical edge's description stores the mapping ("both instantiate REVOLVES-AROUND with ATTRACTS as the governing relation").

**Do NOT reduce to a single edge representation**: The temptation to unify all edge types into one schema risks losing the selectivity that makes typed traversal efficient. Keep type-based multipliers in the spreading activation algorithm. Keep first-order vs. second-order as explicit flags.

**For the bipartite implementation**: Every edge becomes a node in a dedicated EdgeLayer of the Matrix. Incidence links (thin, unweighted, undirected) connect edge-nodes to their endpoint nodes. The edge-node carries all semantic content. This adds one hop to traversal (node → edge → node instead of node → node) but unlocks full second-order access with no architectural changes.

---

## Sources

### Cognitive Science
- Halford, Wilson & Phillips (1998). "Processing capacity defined by relational complexity." _Behavioral and Brain Sciences_. https://pubmed.ncbi.nlm.nih.gov/10191879/
- Gentner, D. (1983). "Structure-Mapping: A Theoretical Framework for Analogy." _Cognitive Science_ 7:155-170. https://groups.psych.northwestern.edu/gentner/papers/Gentner83.2b.pdf
- Gentner & Maravilla (2018). "Analogical Reasoning." _Stevens' Handbook of Experimental Psychology and Cognitive Neuroscience_. https://groups.psych.northwestern.edu/gentner/papers/GentnerMaravilla_2018-Handbook.pdf
- Phillips, S. (2014). "Analogy, Cognitive Architecture and Universal Construction." _PLOS One_. https://pmc.ncbi.nlm.nih.gov/articles/PMC3934878/
- Phillips & Wilson (2010). "Categorial Compositionality: A Category Theory Explanation for the Systematicity of Human Cognition." _PLOS Computational Biology_. https://pmc.ncbi.nlm.nih.gov/articles/PMC2908697/
- Correa-Tellez et al. (2017). "Towards a category theory approach to analogy." _PLOS Computational Biology_. https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005683
- What is category theory to cognitive science? (2022). _Frontiers in Psychology_. https://pmc.ncbi.nlm.nih.gov/articles/PMC9716143/

### Knowledge Graph Embeddings
- Cao et al. (2024). "Knowledge Graph Embedding: A Survey from the Perspective of Representation Spaces." _ACM Computing Surveys_. https://dl.acm.org/doi/10.1145/3643806
- arXiv:2410.14733 (2024). "Knowledge Graph Embeddings: A Comprehensive Survey on Capturing Relation." https://arxiv.org/pdf/2410.14733
- PMC12111306 / TP-RotatE (2025). https://pmc.ncbi.nlm.nih.gov/articles/PMC12111306/
- Understanding HKGE models (2025). arXiv:2508.03280. https://arxiv.org/html/2508.03280

### Hypergraph Architectures
- Yang & Xu (2025). "Recent Advances in Hypergraph Neural Networks." arXiv:2503.07959. https://arxiv.org/html/2503.07959v1
- HyperGraphRAG (2025). arXiv:2503.21322. https://arxiv.org/html/2503.21322v1
- Generalizing Hyperedge Expansion (2024). arXiv:2411.06191. https://arxiv.org/html/2411.06191v1
- Hyperbolic Hypergraph Neural Networks (2024). arXiv:2412.12158. https://arxiv.org/abs/2412.12158

### Spreading Activation in Memory Graphs
- Hindsight (2026). "How We Built Time-Aware Spreading Activation for Memory Graphs." https://hindsight.vectorize.io/blog/2026/03/12/spreading-activation-memory-graphs

### Category Theory
- Spivak & Kent (2012). "Ologs: A Categorical Framework for Knowledge Representation." _PLOS One_. https://pmc.ncbi.nlm.nih.gov/articles/PMC3269434/
- Patterson (2017). "Knowledge Representation in Bicategories of Relations." arXiv:1706.00526. https://arxiv.org/pdf/1706.00526
- Category Theory for AGI (2024). Springer. https://link.springer.com/chapter/10.1007/978-3-031-65572-2_13
- cats.for.ai — Categories for AI research hub. https://cats.for.ai/

### Philosophy of Relations
- Stanford Encyclopedia of Philosophy: Relations. https://plato.stanford.edu/entries/relations/
- Internet Encyclopedia of Philosophy: Universals. https://iep.utm.edu/universa/

### Reification / Edges-as-Entities
- Meta-Property Graphs (2024). arXiv:2410.13813. https://arxiv.org/html/2410.13813v1
- RDF-star / RDF 1.2 (2024). https://niklasl.github.io/rdf-docs/presentations/RDF-reifiers-1/graphs.html
- Reification in KGs — TrustGraph. https://trustgraph.ai/guides/key-concepts/graph-reification/

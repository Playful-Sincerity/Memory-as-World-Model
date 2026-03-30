# Consolidation

Aligned with the Three Planes architecture (see architecture.md).

## The Principle

Consolidation maintains the matrix. It runs between active cognition — when no trees are actively growing, or in dedicated background cycles. It's the agent's "sleep."

Trees modify the matrix during cognition (reconsolidation — see traversal.md). Consolidation goes deeper: reviewing what happened, extracting patterns, strengthening what matters, decaying what doesn't, and creating meta-memories about the process itself.

## What Consolidation Does

1. **Strengthens** edges that were traversed frequently across trees
2. **Weakens** edges that weren't (decay)
3. **Promotes** repeated episodic patterns to semantic nodes
4. **Merges** near-duplicate memories
5. **Prunes** dead edges and fully decayed nodes from the matrix
6. **Discovers** new associations between disconnected regions
7. **Creates meta memories** (mirror plane) about cognition patterns
8. **Reassesses priority** for nodes based on recent access patterns

## Consolidation Cycles

| Cycle | Frequency | What It Does | Value System Role |
|-------|-----------|-------------|-------------------|
| Micro | After each interaction | Encode new nodes, Hebbian edges, update activation | Care determines encoding depth |
| Evening | Daily | Review day's nodes, extract patterns, promote, decay | Priority determines consolidation attention |
| Weekly | Weekly | Cross-day patterns, cluster analysis, discover connections | High-care regions get deeper analysis |
| Monthly | Monthly | Deep graph analysis, semantic rewrites, growth assessment | Mirror creates meta-memories about cognitive patterns |

## Episodic → Semantic Promotion

When the same knowledge appears in 3+ episodic memories, consolidate into semantic:

```python
def promote_to_semantic(
    matrix: MemoryGraph,
    episodes: list[MemoryNode],
    value_system: ValueSystem,
) -> MemoryNode:
    """
    Multiple episodic memories about the same thing
    → one semantic node that captures the generalized knowledge.

    The episodic nodes don't disappear. They decay naturally
    now that their content is captured in a semantic node.
    Priority from the value system determines how thorough
    the extraction is.
    """
    # Priority of the cluster determines extraction depth
    cluster_priority = max(
        value_system.compute_priority(ep.id) for ep in episodes
    )

    if cluster_priority > 0.7:
        # Deep extraction — rich semantic node
        shared_knowledge = llm_extract_pattern(episodes, depth="thorough")
    else:
        # Quick extraction — minimal semantic node
        shared_knowledge = llm_extract_pattern(episodes, depth="brief")

    semantic = matrix.create_node(
        content=shared_knowledge,
        node_type="semantic",
        importance=max(ep.importance for ep in episodes),
        source="consolidation",
    )

    # Connect to source episodes
    for ep in episodes:
        matrix.create_edge(
            source_id=semantic.id,
            target_id=ep.id,
            formation="consolidation",
            weight=0.8,
        )

    # Inherit edges — semantic node becomes reachable from
    # everything the episodes were connected to
    for ep in episodes:
        for edge in matrix.get_edges(ep.id):
            if edge.target_id not in [e.id for e in episodes]:
                matrix.create_edge(
                    source_id=semantic.id,
                    target_id=edge.target_id,
                    formation="consolidation",
                    weight=edge.weight * 0.7,
                )

    return semantic
```

## Mirror Memory Creation

After each significant cognitive cycle, the mirror plane creates meta-memories:

```python
def create_mirror_memories(
    matrix: MemoryGraph,
    completed_trees: list[Tree],
):
    """
    The mirror observes what just happened and creates meta-memories.
    These are regular nodes with node_type="meta" — same graph substrate.

    Meta-memories enable self-awareness:
    - "I traversed deeply into architecture and found useful connections"
    - "I had to direct-jump to a topic I've never explored before"
    - "Two spawned trees discovered the same node independently"
    - "I pruned a branch too early — a phantom kept nagging me"
    """
    for tree in completed_trees:
        # What was the traversal pattern?
        depth = max_depth_reached(tree)
        breadth = len(tree.rendered_nodes)
        jumps = count_direct_jumps(tree)
        overlaps = tree.overlap_nodes

        # Create meta-memory about this cognitive episode
        meta_content = summarize_cognition(
            tree_type=tree.tree_type,
            depth=depth,
            breadth=breadth,
            direct_jumps=jumps,
            overlaps=overlaps,
            phantom_count=len(tree.phantom_traces),
        )

        meta_node = matrix.create_node(
            content=meta_content,
            node_type="meta",
            importance=0.3,  # Meta-memories start low importance
            source="mirror",
        )

        # Connect meta-memory to the nodes it describes
        for node_id in tree.rendered_nodes[:5]:  # Top 5 most active
            matrix.create_edge(
                source_id=meta_node.id,
                target_id=node_id,
                formation="consolidation",
                weight=0.3,
            )
```

Over time, the mirror region of the matrix builds up a rich model of HOW the agent thinks — which topics trigger deep traversal, where direct jumps are common (knowledge gaps), what gets pruned too early. This self-knowledge is available to future trees, just like any other memory.

## Cross-Tree Learning

When multiple trees were active in the same session, consolidation checks for emergent patterns:

```python
def consolidate_cross_tree(
    matrix: MemoryGraph,
    session_trees: list[Tree],
):
    """
    If two trees discovered overlapping nodes independently,
    that's a significant connection worth strengthening.
    If two trees explored similar regions without overlapping,
    consolidation checks if they SHOULD be connected.
    """
    for tree_a, tree_b in combinations(session_trees, 2):
        # Overlaps already created edges during cognition (TreeManager)
        # Here we strengthen them as confirmed cross-domain connections
        for node_id in tree_a.overlap_nodes:
            if node_id in tree_b.rendered_nodes:
                # Strengthen all edges connecting the two trees through this node
                strengthen_cross_tree_edges(matrix, tree_a, tree_b, node_id)

        # Check for near-misses: trees that got close but didn't overlap
        near_misses = find_near_miss_nodes(tree_a, tree_b, matrix)
        for node_a, node_b, similarity in near_misses:
            if similarity > NEAR_MISS_THRESHOLD:
                matrix.create_edge(
                    source_id=node_a,
                    target_id=node_b,
                    formation="discovery",
                    weight=similarity * 0.3,
                )
```

## Duplicate Detection & Merging

Similar memories compete (interference theory):

```python
def merge_duplicates(matrix: MemoryGraph, threshold: float = 0.92):
    """
    Find nodes that are nearly identical and merge them.
    Keeps the stronger one, transfers edges from the weaker.
    """
    for node_a, node_b in find_similar_pairs(matrix, threshold):
        stronger = node_a if node_a.base_activation > node_b.base_activation else node_b
        weaker = node_b if stronger == node_a else node_a

        for edge in matrix.get_edges(weaker.id):
            if not matrix.has_edge(stronger.id, edge.target_id):
                matrix.create_edge(
                    source_id=stronger.id,
                    target_id=edge.target_id,
                    formation="merge",
                    weight=edge.weight,
                )

        matrix.archive_node(weaker.id)
```

## Connection Discovery

Finding links between disconnected regions of the matrix:

```python
def discover_connections(matrix: MemoryGraph):
    """
    Look for nodes that SHOULD be connected but aren't —
    similar embeddings with no path between them.
    These are the latent associations that co-occurrence didn't create.
    """
    clusters = matrix.find_weakly_connected_clusters()

    for cluster_a, cluster_b in pairs(clusters):
        best_pair = find_most_similar_across(cluster_a, cluster_b)

        if best_pair.similarity > CONNECTION_DISCOVERY_THRESHOLD:
            matrix.create_edge(
                source_id=best_pair.node_a,
                target_id=best_pair.node_b,
                formation="discovery",
                weight=best_pair.similarity * 0.3,
            )
```

## The ACT-R Decay Function

Applied during consolidation to all nodes in the matrix:

```python
def compute_activation(node: MemoryNode, now: datetime) -> float:
    DECAY_RATE = 0.5

    days_since = max((now - node.created_at).total_seconds() / 86400, 0.01)
    access_sum = days_since ** (-DECAY_RATE)

    for access_time in node.access_times:
        days = max((now - access_time).total_seconds() / 86400, 0.01)
        access_sum += days ** (-DECAY_RATE)

    base = math.log(access_sum) if access_sum > 0 else -10

    importance_bonus = node.importance * 2.0
    retrieval_bonus = math.log(1 + node.access_count) * 0.5

    return base + importance_bonus + retrieval_bonus
```

Nodes below the forgetting threshold are archived — removed from the active matrix but content persists on disk. This is matrix-level pruning, distinct from tree-level pruning:

- **Tree pruning:** removes from active context, stays in matrix. Immediate, reversible.
- **Matrix pruning:** removes from the matrix entirely. Happens during consolidation. Archived for safety.

## Edge Decay

Edges that are never traversed by any tree weaken over time:

```python
def decay_edges(matrix: MemoryGraph, now: datetime):
    """Run during consolidation. Weaken unused edges. Remove dead ones."""
    for edge in matrix.all_edges():
        days_unused = (now - edge.last_traversed).days
        edge.weight *= (1.0 - edge.decay_rate) ** days_unused

        if edge.weight < EDGE_DEATH_THRESHOLD:
            matrix.remove_edge(edge)
```

## Priority-Driven Consolidation

The value system determines how much consolidation attention each region gets:

```
High-priority regions:
  → More replay cycles (deeper analysis)
  → Finer-grained semantic extraction
  → More cross-linking to other regions
  → Slower decay rates

Low-priority regions:
  → Brief consolidation pass
  → Coarse semantic extraction (if any)
  → Standard decay rates
  → Candidates for archival if also low activation
```

This means the matrix evolves unevenly — the regions the agent cares about most become richer, denser, more interconnected. Regions it doesn't care about thin out. Over time, the matrix's topology reflects the agent's values.

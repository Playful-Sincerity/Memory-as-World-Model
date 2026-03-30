# Consolidation

## The Principle

Raw experience must be compressed into lasting knowledge.
Consolidation is how episodic memories (specific events) become semantic knowledge (general understanding).
In the brain, this happens during sleep. For the agent, it happens in dedicated background cycles.

## What Consolidation Does

1. **Strengthens** edges that were used frequently
2. **Weakens** edges that weren't (decay)
3. **Promotes** repeated episodic patterns to semantic nodes
4. **Merges** near-duplicate memories
5. **Prunes** dead edges and fully decayed nodes
6. **Discovers** new associations between previously unconnected regions

## Consolidation Cycles

| Cycle | Frequency | What It Does |
|-------|-----------|-------------|
| Micro | After each interaction | Encode new nodes, create co-occurrence edges, update activation |
| Evening | Daily | Review day's nodes, extract patterns, promote to semantic, decay |
| Weekly | Weekly | Cross-day patterns, cluster analysis, discover distant connections |
| Monthly | Monthly | Deep graph analysis, major semantic rewrites, growth assessment |

## Episodic → Semantic Promotion

When the same knowledge appears in 3+ episodic memories, consolidate:

```python
def promote_to_semantic(
    graph: MemoryGraph,
    episodes: list[MemoryNode],  # Cluster of related episodic nodes
) -> MemoryNode:
    """
    Multiple episodic memories about the same thing
    → one semantic node that captures the generalized knowledge.

    The episodic nodes don't disappear immediately.
    They decay naturally now that their content is captured.
    """
    # Extract the common knowledge across episodes
    shared_knowledge = llm_extract_pattern(episodes)

    # Create semantic node
    semantic = graph.create_node(
        content=shared_knowledge,
        node_type="semantic",
        importance=max(ep.importance for ep in episodes),
        source="consolidation",
    )

    # Connect semantic node to all the source episodes
    for ep in episodes:
        graph.create_edge(
            source_id=semantic.id,
            target_id=ep.id,
            formation="consolidation",
            weight=0.8,
        )

    # Inherit the episodes' edges (the semantic node is now reachable
    # from everything the episodes were connected to)
    for ep in episodes:
        for edge in graph.get_edges(ep.id):
            if edge.target_id not in [e.id for e in episodes]:
                graph.create_edge(
                    source_id=semantic.id,
                    target_id=edge.target_id,
                    formation="consolidation",
                    weight=edge.weight * 0.7,
                )

    return semantic
```

## Duplicate Detection & Merging

Similar memories compete (interference theory):

```python
def merge_duplicates(graph: MemoryGraph, threshold: float = 0.92):
    """
    Find nodes that are nearly identical and merge them.
    Keeps the stronger one, transfers edges from the weaker.
    """
    for node_a, node_b in find_similar_pairs(graph, threshold):
        stronger = node_a if node_a.base_activation > node_b.base_activation else node_b
        weaker = node_b if stronger == node_a else node_a

        # Transfer weaker's unique edges to stronger
        for edge in graph.get_edges(weaker.id):
            if not graph.has_edge(stronger.id, edge.target_id):
                graph.create_edge(
                    source_id=stronger.id,
                    target_id=edge.target_id,
                    formation="merge",
                    weight=edge.weight,
                )

        # Archive weaker node (don't hard delete)
        graph.archive_node(weaker.id)
```

## Connection Discovery

The most creative part of consolidation — finding links between unconnected regions:

```python
def discover_connections(graph: MemoryGraph):
    """
    During consolidation, look for nodes that SHOULD be connected
    but aren't — similar embeddings with no path between them.
    """
    clusters = graph.find_weakly_connected_clusters()

    for cluster_a, cluster_b in pairs(clusters):
        # Find the most similar nodes across clusters
        best_pair = find_most_similar_across(cluster_a, cluster_b)

        if best_pair.similarity > CONNECTION_DISCOVERY_THRESHOLD:
            graph.create_edge(
                source_id=best_pair.node_a,
                target_id=best_pair.node_b,
                formation="discovery",
                weight=best_pair.similarity * 0.3,  # Weak initial — must be reinforced
            )
```

This is how the agent's understanding grows beyond what it's directly experienced — consolidation finds latent connections that co-occurrence alone wouldn't create.

## The ACT-R Decay Function

Applied during consolidation to all nodes:

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

Nodes below the forgetting threshold are archived — not deleted, just removed from the active graph. Their content persists on disk in case they're ever needed (via direct embedding search as fallback).

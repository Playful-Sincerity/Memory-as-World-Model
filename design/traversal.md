# Traversal Engine

## Core Algorithm: Spreading Activation

When input arrives, activation spreads from the current focus through the graph.

### The Activation Function

Based on ACT-R + Collins & Loftus:

```python
def spread_activation(
    graph: MemoryGraph,
    source_nodes: list[str],     # Currently active nodes
    target_embedding: list[float], # What we're trying to reach
    max_depth: int = 5,
    budget_tokens: int = 50000,
) -> list[ActivatedNode]:
    """
    Spread activation from source nodes through the graph.
    Returns nodes activated above threshold, ranked by activation.
    """
    activation = {}

    # Initialize: source nodes start with full activation
    for node_id in source_nodes:
        activation[node_id] = 1.0

    # Spread through graph, depth by depth
    for depth in range(max_depth):
        new_activations = {}

        for node_id, node_activation in activation.items():
            if node_activation < FIRING_THRESHOLD:
                continue

            # Get all edges from this node
            edges = graph.get_edges(node_id)

            # Fan normalization (ACT-R): dilute across connections
            fan = len(edges)
            fan_factor = S_MAX - math.log(max(fan, 1))

            for edge in edges:
                # Activation propagates: parent activation × edge weight × decay × fan
                propagated = (
                    node_activation
                    * edge.weight
                    * SPREADING_DECAY
                    * fan_factor
                )

                target = edge.target_id
                if target in new_activations:
                    new_activations[target] = max(new_activations[target], propagated)
                else:
                    new_activations[target] = propagated

        # Merge new activations
        for node_id, act in new_activations.items():
            if node_id not in activation or act > activation[node_id]:
                activation[node_id] = act

        # Early exit if we've reached the target area
        # (highest-activated node is close to target embedding)
        top_node = max(activation, key=activation.get)
        if cosine_sim(graph.get_embedding(top_node), target_embedding) > 0.9:
            break

    # Filter by threshold, sort by activation
    results = [
        ActivatedNode(id=nid, activation=act)
        for nid, act in activation.items()
        if act >= FIRING_THRESHOLD
    ]
    results.sort(key=lambda x: x.activation, reverse=True)

    return results
```

### Path Discovery

Once activation has spread, find the actual path from focus to target:

```python
def find_path(
    graph: MemoryGraph,
    focus_id: str,
    target_id: str,
    activation_map: dict[str, float],
) -> list[str]:
    """
    Find the strongest path from focus to target,
    guided by activation levels.

    Not shortest path — STRONGEST path (highest minimum edge weight).
    """
    # Modified Dijkstra using negative log weights
    # (maximizes product of weights along path)
    ...
```

### No Path? Direct Jump

If spreading activation doesn't reach the target (no path exists in the graph):

```python
def direct_jump(
    graph: MemoryGraph,
    target_embedding: list[float],
    focus_id: str,
) -> str:
    """
    Fallback: jump directly to nearest node by embedding.
    This is the RAG-like fallback.
    Creates a new edge from focus → target so the path exists next time.
    """
    nearest = graph.nearest_by_embedding(target_embedding)

    # Create the new edge — this jump becomes a future association
    graph.create_edge(
        source_id=focus_id,
        target_id=nearest.id,
        formation="direct_jump",
        weight=0.1,  # Weak initial weight — strengthens with use
    )

    return nearest.id
```

## Multi-Scale Depth

Not every thought needs deep traversal:

| Input Type | Depth | Example |
|-----------|-------|---------|
| Direct recall | 1 hop | "What's Wisdom's email?" |
| Contextual recall | 2-3 hops | "What were we discussing about GDGM?" |
| Creative connection | 4-5 hops | "How does this relate to what we talked about last month?" |
| Deep synthesis | 5+ hops | "What's the pattern across all my projects?" |

Depth adapts based on:
- Whether the target is reached (stop when you get there)
- Token budget (stop when context is full)
- Activation decay (stop when signal is too weak to propagate)

## Edge Strengthening (Hebbian Learning)

After each cognitive cycle:

```python
def strengthen_edges(graph: MemoryGraph, state: ConsciousnessState):
    """
    Neurons that fire together wire together.
    All nodes that were in context together get their edges strengthened.
    New edges created for nodes that were co-active but not yet connected.
    """
    active = state.active_nodes

    for i, node_a in enumerate(active):
        for node_b in active[i+1:]:
            edge = graph.get_edge(node_a, node_b)

            if edge:
                # Strengthen existing edge
                edge.weight = min(1.0, edge.weight + STRENGTHEN_RATE)
                edge.co_occurrence_count += 1
            else:
                # Create new edge from co-occurrence
                graph.create_edge(
                    source_id=node_a,
                    target_id=node_b,
                    formation="co_occurrence",
                    weight=INITIAL_WEIGHT,
                )
```

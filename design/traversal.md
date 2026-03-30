# Traversal Engine

Aligned with the Three Planes architecture (see architecture.md).
A thought is a tree growing within the matrix. Traversal is how it grows.

## Core Concept: Tree Growth

The old model: "spread activation from a focus point, load what activates."
The current model: **a tree grows branches through the matrix, guided by spreading activation, budgeted by care.**

The tree IS the context. When it grows a new branch, that branch becomes part of what the LLM sees. When a branch is pruned (see pruning.md), it leaves the context. Growth and pruning happen continuously as the conversation evolves.

## The Growth Algorithm

```python
def grow_tree(
    matrix: MemoryGraph,
    tree: Tree,
    target_embedding: list[float],   # What the tree is growing toward
    care_level: float,               # From value system — sets budget
    value_system: ValueSystem,       # For priority-aware growth
) -> Tree:
    """
    Grow the tree toward a target in the matrix.
    The tree extends branches from its current tips through association edges.
    Budget is set by care level. Strong edges activate first.
    """
    budget = tree.token_budget  # Already set by TreeManager based on care
    activation = {nid: tree.activation_map.get(nid, 0.0) for nid in tree.rendered_nodes}

    # Growth starts from the tree's current tips
    growth_front = list(tree.tip_ids)

    for depth in range(max_depth_for_care(care_level)):
        new_front = []

        for node_id in growth_front:
            node_activation = activation.get(node_id, 0.0)
            if node_activation < FIRING_THRESHOLD:
                continue

            edges = matrix.get_edges(node_id)

            # Fan normalization (ACT-R): dilute across connections
            fan = len(edges)
            fan_factor = S_MAX - math.log(max(fan, 1))

            for edge in edges:
                propagated = (
                    node_activation
                    * edge.weight
                    * SPREADING_DECAY
                    * fan_factor
                )

                target_id = edge.target_id
                if propagated >= FIRING_THRESHOLD:
                    # This node activates — the tree grows to include it
                    if target_id not in activation or propagated > activation[target_id]:
                        activation[target_id] = propagated
                        new_front.append(target_id)

                        # RECONSOLIDATION: the traversal itself is a write
                        edge.traversal_count += 1
                        edge.last_traversed = now()
                        edge.weight = min(1.0, edge.weight + RECONSOLIDATION_BOOST)

            # Check budget — stop growing if context is full
            if estimate_tokens(tree.rendered_nodes + new_front) > budget:
                break

        # Update tree structure
        tree.rendered_nodes.extend(new_front)
        tree.tip_ids = new_front  # Tips are now the growth front
        growth_front = new_front

        # Early exit: we've reached the target region
        if new_front:
            nearest_to_target = min(
                new_front,
                key=lambda nid: embedding_distance(matrix.get_embedding(nid), target_embedding)
            )
            if embedding_distance(matrix.get_embedding(nearest_to_target), target_embedding) < 0.1:
                break

    tree.activation_map = activation
    return tree


def max_depth_for_care(care_level: float) -> int:
    """Care determines how deep the tree can grow."""
    if care_level > 0.8:
        return 7    # Deep exploration
    elif care_level > 0.5:
        return 4    # Standard traversal
    elif care_level > 0.2:
        return 2    # Shallow
    else:
        return 1    # Minimal — quick surface check
```

## No Path? Direct Jump

If the tree's growth can't reach the target (no association path exists):

```python
def direct_jump(
    matrix: MemoryGraph,
    tree: Tree,
    target_embedding: list[float],
) -> str:
    """
    Fallback: jump directly to nearest node by embedding.
    This is the ONE RAG-like step — finding the entry point.
    Creates a new matrix edge so the path exists next time.
    """
    nearest = matrix.nearest_by_embedding(target_embedding)

    # Create a new edge in the matrix — this jump becomes a future association
    for tip_id in tree.tip_ids:
        matrix.create_edge(
            source_id=tip_id,
            target_id=nearest.id,
            formation="direct_jump",
            weight=0.1,  # Weak — must be reinforced by future co-occurrence
        )

    # The tree now includes this node
    tree.rendered_nodes.append(nearest.id)
    tree.tip_ids = [nearest.id]

    return nearest.id
```

## Multi-Scale Depth (Governed by Care)

Not every thought needs deep traversal. Care level sets the budget:

| Care Level | Depth | Fan-out | Example |
|-----------|-------|---------|---------|
| High (>0.8) | 5-7 hops, broad | Wide — explore many edges | "Tell me everything about this project" |
| Medium (0.5-0.8) | 3-4 hops | Standard | "What do we know about GDGM?" |
| Low (0.2-0.5) | 1-2 hops | Narrow — strongest edges only | "What time is that meeting?" |
| Minimal (<0.2) | 1 hop or skip | Minimal | Background check, routine query |

## Reconsolidation: Every Traversal Is a Write

This is a key insight from the research (largely uninvestigated in AI systems as of 2025).
In biological memory, every act of retrieval modifies the memory. Recalling something doesn't just read it — it strengthens the recall path, weakens competing paths, and can even alter the memory itself.

In this architecture:
- **Every edge traversed by a tree** gets its weight bumped (see growth algorithm above)
- **Every node rendered by a tree** gets its `last_accessed` updated and `access_count` incremented
- **Competing edges** (those connected to a traversed node but NOT traversed) get a small decay nudge

```python
def apply_reconsolidation(matrix: MemoryGraph, tree: Tree):
    """
    After a tree finishes growing, apply reconsolidation effects
    to the matrix based on what was and wasn't traversed.
    """
    traversed_edges = set()

    # Identify which edges the tree actually walked
    for i, node_id in enumerate(tree.rendered_nodes[:-1]):
        next_node = tree.rendered_nodes[i + 1]
        edge = matrix.get_edge(node_id, next_node)
        if edge:
            traversed_edges.add((node_id, next_node))

    # Strengthen traversed edges (already done during growth)
    # Weakly decay competing (non-traversed) edges from rendered nodes
    for node_id in tree.rendered_nodes:
        for edge in matrix.get_edges(node_id):
            if (node_id, edge.target_id) not in traversed_edges:
                edge.weight *= (1.0 - COMPETITION_DECAY)  # Small decay
```

## Hebbian Edge Strengthening (Co-occurrence)

After each cognitive cycle, nodes that were rendered together in the same tree form or strengthen edges:

```python
def strengthen_co_occurrences(matrix: MemoryGraph, tree: Tree):
    """
    Neurons that fire together wire together.
    All nodes rendered in the same tree get their edges strengthened.
    New edges created for co-rendered nodes not yet connected.
    """
    rendered = tree.rendered_nodes

    for i, node_a in enumerate(rendered):
        for node_b in rendered[i+1:]:
            edge = matrix.get_edge(node_a, node_b)

            if edge:
                edge.weight = min(1.0, edge.weight + STRENGTHEN_RATE)
                edge.co_occurrence_count += 1
            else:
                matrix.create_edge(
                    source_id=node_a,
                    target_id=node_b,
                    formation="co_occurrence",
                    weight=INITIAL_WEIGHT,
                )
```

## Parallel Trees

The mirror layer (or the primary tree itself) can spawn additional trees that grow from different roots:

```python
def spawn_tree(
    tree_manager: TreeManager,
    matrix: MemoryGraph,
    root_id: str,
    reason: str,           # Why this tree was spawned
    parent_tree: Tree,
) -> Tree:
    """
    Spawn a new tree from a different root in the matrix.
    Budget is carved from the global pool.
    """
    new_tree = Tree(
        id=generate_id(),
        tree_type="spawned",
        root_id=root_id,
        rendered_nodes=[root_id],
        tip_ids=[root_id],
        parent_tree_id=parent_tree.id,
        created_at=now(),
    )

    # Allocate budget from global pool
    tree_manager.allocate_budget(new_tree, care_level=0.5)  # Default care for spawned
    tree_manager.active_trees.append(new_tree)

    return new_tree
```

When two trees discover they've rendered the same node, that overlap creates new matrix edges between their respective branches — emergent connections that neither tree would have found alone. This is handled by `TreeManager.detect_overlaps()`.

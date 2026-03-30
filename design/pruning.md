# Active Pruning

Aligned with the Three Planes architecture (see architecture.md).

## The Principle

A tree has a budget. As it grows, it can't keep every branch rendered.
Pruning is how the tree manages its budget — shedding branches that are no longer relevant to make room for new growth. Pruning is attention: what's rendered is what the agent is thinking about. Everything else is dark in the matrix but still there.

Pruning does NOT modify the matrix. A pruned branch just stops being rendered. The nodes and edges remain. If the tree grows back toward that region, the branch can re-render.

## How Pruning Works

### Eviction Scoring

Every rendered node gets an eviction score. Higher score = more likely to be evicted.

```python
def compute_eviction_score(
    node_id: str,
    tree: Tree,
    value_system: ValueSystem,
    context: CognitiveContext,
) -> float:
    """
    Eviction score = how expendable is this node right now?

    Two factors:
    1. Distance from active tips (far = expendable)
    2. Priority from value system (high priority = resist eviction)

    This is the key integration with the value system:
    a distant but high-priority node stays. A close but low-priority one can go.
    """
    # Distance: inverse of activation level (low activation = far from tips)
    activation = tree.activation_map.get(node_id, 0.0)
    distance = 1.0 / max(activation, 0.001)

    # Priority: from value system (contextual, dynamic)
    priority = value_system.compute_priority(node_id, context)

    # Eviction score: high distance AND low priority = evict first
    return distance * (1.0 / max(priority, 0.01))
```

### Per-Tree Pruning

Each tree prunes independently within its budget:

```python
def prune_tree(
    tree: Tree,
    matrix: MemoryGraph,
    value_system: ValueSystem,
    context: CognitiveContext,
):
    """
    Prune a tree until it's within budget.
    Evicts highest-scoring nodes. Detaches orphaned branches.
    Leaves phantom traces for pruned branches.
    """
    while tree.tokens_used > tree.token_budget:
        # Score all rendered nodes (except root — never evict the root)
        scores = {
            nid: compute_eviction_score(nid, tree, value_system, context)
            for nid in tree.rendered_nodes
            if nid != tree.root_id
        }

        # Evict the most expendable node
        evict_id = max(scores, key=scores.get)
        tree.rendered_nodes.remove(evict_id)

        # Leave a phantom trace (faint marker for faster re-growth)
        tree.phantom_traces.append(evict_id)

        # Check for branch detachment
        orphaned = find_orphaned_nodes(evict_id, tree, matrix)
        for orphan_id in orphaned:
            tree.rendered_nodes.remove(orphan_id)
            tree.phantom_traces.append(orphan_id)

        # Recalculate token usage
        tree.tokens_used = estimate_tokens(tree.rendered_nodes)
```

### Branch Detachment

When a node is evicted, check if it was the only connection to a sub-branch:

```python
def find_orphaned_nodes(
    evicted_id: str,
    tree: Tree,
    matrix: MemoryGraph,
) -> set[str]:
    """
    Find nodes that are no longer reachable from the tree root
    through remaining rendered nodes. These form a detached branch.
    """
    remaining = set(tree.rendered_nodes)

    reachable = bfs_reachable(
        matrix,
        start=tree.root_id,
        within=remaining,
    )

    orphaned = remaining - reachable - {tree.root_id}
    return orphaned
```

## Phantom Traces

When a branch prunes, it doesn't vanish without a trace. The tree retains a **phantom** — a lightweight marker that says "there was something here."

Phantoms serve two purposes:
1. **Faster re-growth:** If the tree grows back toward a phantom, it can skip the embedding search and go directly to the known node. Re-attachment is faster than first-time discovery.
2. **Awareness of gaps:** The mirror layer can observe phantoms and know "I had something relevant here but let it go." This creates the "tip of the tongue" feeling — knowing you know something without it being in active awareness.

```python
@dataclass
class PhantomTrace:
    node_id: str                     # The pruned node
    pruned_at: datetime
    activation_at_pruning: float     # How active it was when pruned
    tree_id: str                     # Which tree pruned it

    # Phantoms decay too — eventually you forget you forgot
    def is_expired(self, now: datetime) -> bool:
        hours_since = (now - self.pruned_at).total_seconds() / 3600
        return hours_since > PHANTOM_LIFETIME_HOURS
```

## Multi-Tree Budget Management

The global context budget is shared across all active trees via TreeManager.

```
Total budget: 100K tokens (example)

Primary tree:    60K (high care topic)
Spawned tree A:  25K (moderate exploration)
Spawned tree B:  10K (quick check)
Mirror overhead:  5K (meta-observation)
```

When a new tree is spawned, the budget is rebalanced:

```python
def rebalance_budgets(tree_manager: TreeManager):
    """
    Redistribute the global budget across active trees.
    Primary tree always gets the largest share.
    Spawned trees share the remainder, weighted by care.
    """
    total = tree_manager.total_token_budget
    primary = [t for t in tree_manager.active_trees if t.tree_type == "primary"][0]
    spawned = [t for t in tree_manager.active_trees if t.tree_type == "spawned"]

    # Primary gets at least 50%
    primary.token_budget = max(total // 2, total - sum(s.token_budget for s in spawned))

    # Remainder split among spawned trees
    remainder = total - primary.token_budget
    if spawned:
        per_spawned = remainder // len(spawned)
        for s in spawned:
            s.token_budget = per_spawned

    # If any tree is now over budget, prune it
    for tree in tree_manager.active_trees:
        if tree.tokens_used > tree.token_budget:
            prune_tree(tree, ...)
```

## Distance-Proportional Compression

Not all rendered nodes need full detail. Distance from the active tips determines compression:

| Position in Tree | Representation | Token Cost |
|-----------------|---------------|------------|
| Tips (active growth front) | Full verbatim content | High |
| 1 hop from tips | Summary | Medium |
| 2 hops from tips | Truncated summary | Low |
| 3+ hops (near root) | Tags/type only | Minimal |

This means the root (identity core) gets compressed to its essence after the tree grows deep enough. That's correct — your identity shapes the tree's initial direction but doesn't need to occupy the full budget once the branches have grown.

## Graduated Pressure Zones

As total context fills across all trees, pruning becomes more aggressive:

| Zone | Total Usage | Behavior |
|------|------------|----------|
| Normal | < 60% | No pressure. Trees grow freely. |
| Advisory | 60-80% | Compress distant branches. New spawned trees get smaller budgets. |
| Involuntary | 80-95% | Kill lowest-care spawned trees. Primary tree prunes aggressively. |
| Aggressive | > 95% | Only primary tree survives. Only tips + 1-hop remain verbatim. |

## Re-attachment

When a tree's growth reaches a phantom trace, the branch re-attaches:

```python
def check_phantom_reattach(tree: Tree, new_node_id: str):
    """
    When growth reaches a phantom, re-render the pruned branch
    instantly instead of re-discovering it through traversal.
    """
    if new_node_id in [p.node_id for p in tree.phantom_traces]:
        # Fast re-attachment — skip embedding search
        phantom = get_phantom(tree, new_node_id)
        tree.rendered_nodes.append(new_node_id)
        tree.phantom_traces.remove(phantom)
        # The branch is back. No new matrix edges needed.
```

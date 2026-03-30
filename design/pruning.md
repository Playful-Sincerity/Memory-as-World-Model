# Active Pruning

## The Principle

Context is finite. The agent can't hold its entire graph in working memory.
Pruning isn't failure — it's attention. What's in awareness is what's reachable from the current focus. Everything else exists but isn't active.

## How Pruning Works

### Distance-From-Focus Scoring

Every node in active context has a distance score:

```python
def compute_distance(
    node_id: str,
    focus_id: str,
    graph: MemoryGraph,
    activation_map: dict[str, float],
) -> float:
    """
    Distance = inverse of activation from focus.
    High activation = close to focus = stays in context.
    Low activation = far from focus = candidate for eviction.
    """
    return 1.0 / max(activation_map.get(node_id, 0.001), 0.001)
```

### Eviction Policy

When a new node needs to enter context but budget is full:

```
1. Score all active nodes by distance from current focus
2. Evict the most distant node
3. If the evicted node has nodes that are ONLY reachable through it,
   those become candidates too (branch detachment)
4. Evicted nodes remain in the graph — they just leave context
5. If focus shifts back toward them, they reload
```

### Branch Detachment

This is the tree-like behavior. When a node evicts, check if it was the only connection to a subtree:

```python
def detach_branch(
    evicted_id: str,
    active_nodes: set[str],
    graph: MemoryGraph,
) -> set[str]:
    """
    When a node is evicted, find any nodes that are now
    unreachable from the focus through remaining active nodes.
    These form a detached branch — all evicted together.
    """
    # Remove evicted node
    remaining = active_nodes - {evicted_id}

    # Find nodes only reachable through the evicted node
    reachable_from_focus = bfs_reachable(
        graph, focus_id, within=remaining
    )

    orphaned = remaining - reachable_from_focus
    return orphaned  # All of these evict too
```

### Re-attachment

Detached branches aren't gone. They re-attach when:
- Focus shifts toward them (spreading activation reaches them again)
- New input is near them in embedding space
- A newly traversed edge connects to them

This is the "breathing" quality — the context tree grows and shrinks as focus moves.

## Distance-Proportional Compression

Not all nodes in context need full detail:

| Distance from Focus | Representation | Token Cost |
|--------------------|---------------|------------|
| Focus node | Full verbatim content | High |
| 1 hop | Lightly compressed | Medium |
| 2 hops | Heavy compression (gist) | Low |
| 3+ hops | One-line summary only | Minimal |

```python
def compress_for_context(
    node: MemoryNode,
    hops_from_focus: int,
) -> str:
    """Return node content at appropriate compression level."""
    if hops_from_focus == 0:
        return node.content                    # Full content
    elif hops_from_focus == 1:
        return node.summary                    # Summary field
    elif hops_from_focus == 2:
        return truncate(node.summary, 100)     # Truncated summary
    else:
        return f"[{node.node_type}: {', '.join(node.tags)}]"  # Tags only
```

## Graduated Pressure (from Pichay research)

As context fills, eviction becomes more aggressive:

| Zone | Context Usage | Behavior |
|------|-------------|----------|
| Normal | < 60% | No pressure. Load freely. |
| Advisory | 60-80% | Compress distant nodes. Warn before loading large content. |
| Involuntary | 80-95% | Evict weakest branches. Only load high-activation nodes. |
| Aggressive | > 95% | Hard eviction. Only focus node + 1-hop remain verbatim. |

## Edge Decay (Background)

Edges that are never traversed weaken over time:

```python
def decay_edges(graph: MemoryGraph, now: datetime):
    """Run periodically. Weaken unused edges. Remove dead ones."""
    for edge in graph.all_edges():
        days_unused = (now - edge.last_traversed).days
        edge.weight *= (1.0 - edge.decay_rate) ** days_unused

        if edge.weight < EDGE_DEATH_THRESHOLD:
            graph.remove_edge(edge)  # Association forgotten
```

This prevents the graph from growing unboundedly. Associations that were created but never reinforced naturally fade — just like human memory.

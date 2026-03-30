# Data Model

Aligned with the Three Planes architecture (see architecture.md).

## Memory Node

A node in the matrix. Most are dark — only lit up when a tree renders them.

```python
@dataclass
class MemoryNode:
    id: str                          # Unique node ID
    content: str                     # The memory itself (linguistic)
    embedding: list[float]           # Vector representation

    # Typing
    node_type: str                   # episodic | semantic | meta
    modality: str                    # text | image | audio | sensor

    # Meta nodes (mirror plane) — memories ABOUT cognition
    # node_type="meta" for things like:
    # "I traversed X→Y through Z and it led to a useful insight"
    # "I tend to branch deeply on topics about architecture"
    # "I pruned that branch too early last time"
    # Meta nodes live in the same matrix as all other nodes.
    # They ARE the mirror — not a separate module.

    # Temporal
    created_at: datetime
    last_accessed: datetime
    access_count: int

    # Activation (ACT-R)
    base_activation: float           # B(i) = ln(Σ t(j)^(-0.5))
    importance: float                # Initial encoding importance
    protected: bool                  # Immune to decay (formative memories)

    # Content pointer (hippocampal indexing)
    # Node is lightweight index; full content stored separately
    content_ref: str | None          # Path to full content if compressed
    summary: str                     # Always present — the "gist"

    # Metadata
    source: str                      # How this memory was created
    tags: list[str]                  # Semantic tags for metamemory
```

## Association Edge

Edges are the intelligence. How things relate is a learned, experiential model.
Every traversal is a write (reconsolidation) — accessing an edge modifies it.

```python
@dataclass
class AssociationEdge:
    source_id: str
    target_id: str

    # Weight (the core of the system)
    weight: float                    # Strength of association (0.0 - 1.0)

    # How it formed
    formation: str                   # co_occurrence | traversal | consolidation | discovery | direct_jump
    formed_at: datetime

    # Hebbian learning (reconsolidation — every access is a write)
    co_occurrence_count: int         # Times these were in context together
    traversal_count: int             # Times this edge was walked by any tree
    last_traversed: datetime

    # Decay
    decay_rate: float                # Per-day decay when not used

    # The association's meaning (linguistic — interpretable)
    description: str | None          # WHY these are connected (optional, discovered)
```

## Tree

A tree is active cognition — a currently-rendered subset growing within the matrix.
The tree IS the context. What's rendered = what the LLM sees.

```python
@dataclass
class Tree:
    id: str                          # Unique tree ID
    tree_type: str                   # primary | spawned | consolidation

    # Structure
    root_id: str                     # The node this tree grew from
    rendered_nodes: list[str]        # All nodes currently rendered by this tree
    tip_ids: list[str]               # Current growth tips (most active branches)
    phantom_traces: list[str]        # Node IDs of pruned branches (faint markers)

    # Budget (shared across all active trees via TreeManager)
    token_budget: int                # This tree's allocated share
    tokens_used: int                 # Currently consumed by rendered nodes

    # Growth state
    activation_map: dict[str, float] # Current activation levels for rendered nodes
    created_at: datetime
    last_grown: datetime

    # Relationship to other trees
    parent_tree_id: str | None       # If spawned, which tree spawned it
    overlap_nodes: list[str]         # Nodes shared with other active trees


@dataclass
class TreeManager:
    """
    Manages all active trees. Owns the global context budget.
    The agent IS this system — trees are its active thoughts.
    """
    active_trees: list[Tree]
    total_token_budget: int          # Global budget across all trees
    tokens_allocated: int            # Sum of all tree budgets

    def allocate_budget(self, tree: Tree, care_level: float):
        """Budget per tree scales with care level."""
        base = self.total_token_budget // max(len(self.active_trees), 1)
        tree.token_budget = int(base * care_level)

    def detect_overlaps(self):
        """
        When two trees render the same node, they've discovered
        a connection. Create new matrix edges between their branches.
        """
        ...

    def merge_trees(self, tree_a: Tree, tree_b: Tree) -> Tree:
        """
        When trees overlap significantly, merge into one.
        Shared nodes become the junction point.
        """
        ...
```

## Storage

### SQLite Schema

```sql
-- Memory nodes (the matrix)
CREATE TABLE nodes (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    summary TEXT NOT NULL,
    node_type TEXT NOT NULL,          -- episodic | semantic | meta
    modality TEXT DEFAULT 'text',
    created_at TEXT NOT NULL,
    last_accessed TEXT,
    access_count INTEGER DEFAULT 0,
    base_activation REAL DEFAULT 0.0,
    importance REAL DEFAULT 0.5,
    protected BOOLEAN DEFAULT FALSE,
    content_ref TEXT,
    source TEXT,
    tags TEXT                         -- JSON array
);

-- Association edges (the connections — the intelligence)
CREATE TABLE edges (
    source_id TEXT NOT NULL,
    target_id TEXT NOT NULL,
    weight REAL NOT NULL DEFAULT 0.1,
    formation TEXT NOT NULL,
    formed_at TEXT NOT NULL,
    co_occurrence_count INTEGER DEFAULT 1,
    traversal_count INTEGER DEFAULT 0,
    last_traversed TEXT,
    decay_rate REAL DEFAULT 0.01,
    description TEXT,
    PRIMARY KEY (source_id, target_id),
    FOREIGN KEY (source_id) REFERENCES nodes(id),
    FOREIGN KEY (target_id) REFERENCES nodes(id)
);

-- Embeddings (separate for performance)
CREATE TABLE embeddings (
    node_id TEXT PRIMARY KEY,
    vector BLOB NOT NULL,             -- Serialized float array
    model TEXT NOT NULL,              -- Which embedding model
    computed_at TEXT NOT NULL,
    FOREIGN KEY (node_id) REFERENCES nodes(id)
);

-- Active trees (ephemeral — rebuilt each session, persisted for crash recovery)
CREATE TABLE trees (
    id TEXT PRIMARY KEY,
    tree_type TEXT NOT NULL,          -- primary | spawned | consolidation
    root_id TEXT NOT NULL,
    rendered_node_ids TEXT,           -- JSON array
    tip_ids TEXT,                     -- JSON array
    phantom_trace_ids TEXT,           -- JSON array
    token_budget INTEGER DEFAULT 0,
    tokens_used INTEGER DEFAULT 0,
    parent_tree_id TEXT,
    created_at TEXT NOT NULL,
    last_grown TEXT,
    FOREIGN KEY (root_id) REFERENCES nodes(id)
);

-- Indexes
CREATE INDEX idx_edges_source ON edges(source_id);
CREATE INDEX idx_edges_target ON edges(target_id);
CREATE INDEX idx_edges_weight ON edges(weight DESC);
CREATE INDEX idx_nodes_type ON nodes(node_type);
CREATE INDEX idx_nodes_activation ON nodes(base_activation DESC);
CREATE INDEX idx_trees_type ON trees(tree_type);
```

## Design Decisions

**Why SQLite over Neo4j for v1:**
- Zero infrastructure. Single file.
- Fast enough for early graph sizes (thousands of nodes)
- WAL mode for concurrent read/write
- Upgrade path to Neo4j/FalkorDB when graph outgrows SQLite

**Why lightweight nodes (hippocampal indexing):**
- Full memory content can be large (conversation transcripts, documents)
- Node table stays small and fast to scan
- Summary field always present for quick context assembly
- content_ref points to full content on disk when needed

**Why edges are bidirectional by default:**
- If ice cream connects to motorcycles, motorcycles connect to ice cream
- Weight can differ by direction (asymmetric associations)
- Implemented as two rows in the edges table

**Why trees are ephemeral:**
- Trees exist during active cognition. Between sessions, only the matrix persists.
- On session start, a new primary tree grows from the identity core.
- Tree table exists for crash recovery and for the mirror to observe active trees.
- The matrix is the durable layer. Trees are the active layer.

**Why meta nodes are not special:**
- A meta node has `node_type="meta"` but is otherwise identical to any node.
- It lives in the same matrix, forms edges the same way, gets traversed the same way.
- The mirror is not a module — it's a region of the graph that happens to be about cognition itself.
- This means self-awareness scales naturally: more meta nodes = richer self-perception.

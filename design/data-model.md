# Data Model

## Memory Node

```python
@dataclass
class MemoryNode:
    id: str                          # Unique node ID
    content: str                     # The memory itself (linguistic)
    embedding: list[float]           # Vector representation

    # Typing
    node_type: str                   # episodic | semantic
    modality: str                    # text | image | audio | sensor

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

```python
@dataclass
class AssociationEdge:
    source_id: str
    target_id: str

    # Weight (the core of the system)
    weight: float                    # Strength of association (0.0 - 1.0)

    # How it formed
    formation: str                   # co_occurrence | traversal | consolidation | explicit
    formed_at: datetime

    # Hebbian learning
    co_occurrence_count: int         # Times these were in context together
    traversal_count: int             # Times this edge was walked
    last_traversed: datetime

    # Decay
    decay_rate: float                # Per-day decay when not used

    # The association's meaning (linguistic — interpretable)
    description: str | None          # WHY these are connected (optional, discovered)
```

## Consciousness State

```python
@dataclass
class ConsciousnessState:
    # Where the agent currently "is"
    focus_node_id: str               # Primary focus node
    active_nodes: list[str]          # All nodes currently in context

    # The active context tree
    loaded_paths: list[list[str]]    # Paths currently loaded (node ID sequences)

    # Budget
    token_budget: int                # Total available
    tokens_used: int                 # Currently consumed

    # History (for Hebbian learning)
    recent_co_occurrences: list[tuple[str, str]]  # Pairs in context this cycle
```

## Storage

### SQLite Schema (Primary)

```sql
-- Memory nodes
CREATE TABLE nodes (
    id TEXT PRIMARY KEY,
    content TEXT NOT NULL,
    summary TEXT NOT NULL,
    node_type TEXT NOT NULL,          -- episodic | semantic
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

-- Association edges
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

-- Consciousness state (single row, updated each cycle)
CREATE TABLE consciousness (
    id INTEGER PRIMARY KEY DEFAULT 1,
    focus_node_id TEXT,
    active_node_ids TEXT,             -- JSON array
    tokens_used INTEGER DEFAULT 0,
    updated_at TEXT
);

-- Indexes for fast traversal
CREATE INDEX idx_edges_source ON edges(source_id);
CREATE INDEX idx_edges_target ON edges(target_id);
CREATE INDEX idx_edges_weight ON edges(weight DESC);
CREATE INDEX idx_nodes_type ON nodes(node_type);
CREATE INDEX idx_nodes_activation ON nodes(base_activation DESC);
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

"""CSGIGraph: graph data structure for skeleton representation."""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from typing import Any, List, Tuple


class NumpySafeEncoder(json.JSONEncoder):
    """JSON encoder that handles numpy int/float types."""

    def default(self, obj: Any) -> Any:
        # Handle numpy integer types
        try:
            import numpy as np

            if isinstance(obj, (np.integer,)):
                return int(obj)
            if isinstance(obj, (np.floating,)):
                return float(obj)
            if isinstance(obj, np.ndarray):
                return obj.tolist()
        except ImportError:
            pass
        return super().default(obj)


def _to_native(obj: Any) -> Any:
    """Recursively convert numpy types to native Python types."""
    try:
        import numpy as np

        if isinstance(obj, (np.integer,)):
            return int(obj)
        if isinstance(obj, (np.floating,)):
            return float(obj)
        if isinstance(obj, np.ndarray):
            return obj.tolist()
    except ImportError:
        pass

    if isinstance(obj, dict):
        return {_to_native(k): _to_native(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return [_to_native(item) for item in obj]
    return obj


@dataclass
class CSGINode:
    """A node in the skeleton graph."""

    id: int
    x: int
    y: int
    degree: int = 0

    def __post_init__(self) -> None:
        self.id = int(self.id)
        self.x = int(self.x)
        self.y = int(self.y)
        self.degree = int(self.degree)


@dataclass
class CSGIEdge:
    """An edge in the skeleton graph."""

    id: int
    u: int
    v: int
    points: List[Tuple[int, int]] = field(default_factory=list)

    def __post_init__(self) -> None:
        self.id = int(self.id)
        self.u = int(self.u)
        self.v = int(self.v)
        self.points = [(int(x), int(y)) for x, y in self.points]


@dataclass
class CSGIGraph:
    """Complete skeleton graph for a letter."""

    letter: str
    name: str
    nodes: List[CSGINode]
    edges: List[CSGIEdge]
    adjacency: str = "8-neighborhood"
    release_id: str = ""

    def to_dict(self) -> dict:
        """Convert to a plain dict with all values as native Python types."""
        data = {
            "csgi_version": "1.0",
            "letter": self.letter,
            "name": self.name,
            "adjacency": self.adjacency,
            "release": self.release_id,
            "stats": {
                "node_count": len(self.nodes),
                "edge_count": len(self.edges),
            },
            "nodes": [
                {
                    "id": int(n.id),
                    "x": int(n.x),
                    "y": int(n.y),
                    "degree": int(n.degree),
                }
                for n in self.nodes
            ],
            "edges": [
                {
                    "id": int(e.id),
                    "u": int(e.u),
                    "v": int(e.v),
                    "points": [[int(x), int(y)] for x, y in e.points],
                }
                for e in self.edges
            ],
        }
        return data

    def to_json(self, indent: int = 2) -> str:
        """Serialize to JSON string, safe for numpy types."""
        data = self.to_dict()
        return json.dumps(data, indent=indent, ensure_ascii=False, cls=NumpySafeEncoder)

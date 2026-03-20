"""Injectivity verifier: all 28 codex vectors must be unique."""

from ..core.master_table import MASTER_TABLE


class InjectivityVerifier:
    def verify(self) -> bool:
        vecs = [tuple(e.vector) for e in MASTER_TABLE.all_entries()]
        return len(set(vecs)) == len(vecs)

    def collision_pairs(self):
        seen = {}
        collisions = []
        for e in MASTER_TABLE.all_entries():
            k = tuple(e.vector)
            if k in seen:
                collisions.append((seen[k], e.char))
            else:
                seen[k] = e.char
        return collisions

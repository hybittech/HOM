"""Mod-4 Gate theorem (Theorem 11.4.1)."""

from ..core.master_table import MASTER_TABLE


class Mod4Gate:
    def check(self, h) -> dict:
        v = list(h.vector) if hasattr(h, "vector") else h
        th = v[0]
        mod = th % 4
        return {"theta": th, "mod4": mod, "possibly_closed": mod == 0, "definitely_open": mod != 0}

    def check_all(self) -> list:
        return [{"char": e.char, **self.check(e)} for e in MASTER_TABLE.all_entries()]

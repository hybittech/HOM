"""Network-level guard filter: reject malformed hybit packets in O(1)."""

from ..core.guards import guard_check


def filter_packet(data: bytes) -> bool:
    if len(data) < 18:
        return False
    return guard_check(list(data[:18]))

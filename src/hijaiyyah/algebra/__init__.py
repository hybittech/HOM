"""
Bab II: Sistem Operasi Metrik-Vektorial Hijaiyah.

  vektronometry      — VTM (Bab II-A)
  normivektor        — NMV (Bab II-B)
  aggregametric      — AGM (Bab II-C)
  intrametric        — ITM (Bab II-D)
  exometric          — EXM (Bab II-E)

Backward-compatible aliases are provided for the old names.
"""

from . import vektronometry  # noqa: F401
from . import normivektor  # noqa: F401
from . import aggregametric  # noqa: F401
from . import intrametric  # noqa: F401
from . import exometric  # noqa: F401

# ── Backward-compatible aliases (v1.0 → v1.2) ──
from . import vektronometry as vectronometry  # noqa: F401
from . import normivektor as differential  # noqa: F401
from . import aggregametric as integral  # noqa: F401
from . import intrametric as geometry  # noqa: F401
from . import exometric as exomatrix_analysis  # noqa: F401

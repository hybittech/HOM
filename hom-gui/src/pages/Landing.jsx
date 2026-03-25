import { Link } from 'react-router-dom';
import HijaiyyahScene from '../components/HijaiyyahScene';
import FormulaBlock from '../components/FormulaBlock';
import GlassPanel from '../components/GlassPanel';

const stats = [
  { label: 'Letters', value: '28', sub: 'Canonical Hijaiyyah' },
  { label: 'Dimensions', value: '18', sub: 'Integer Vector Space' },
  { label: 'Tests', value: '1,611', sub: 'All PASS · 0 FAIL' },
  { label: 'ROM', value: '252', sub: 'Bytes (nibble-packed)' },
];

const operations = [
  {
    code: 'VTM',
    name: 'Vektronometry',
    tagline: 'Composition Metrics',
    color: 'hom-accent',
    borderColor: 'border-hom-accent/30',
    bgColor: 'bg-hom-accent/5',
    textColor: 'text-hom-accent',
    glowColor: 'shadow-glow',
    question: 'What is a letter made of?',
    identity: 'r_N + r_K + r_Q = 1',
    description:
      'Vektronometry measures the internal composition of each letter — what proportion is dots (N), lines (K), and curves (Q). It decomposes every letter vector into four orthogonal subspaces (Θ, N, K, Q) and verifies the Pythagorean decomposition theorem. The compositional profile uniquely characterizes each letter\'s geometric DNA.',
    capabilities: [
      'Primitive ratio analysis: rN, rK, rQ per letter',
      'Turning ratio decomposition: rU + rρ = 1',
      'Pythagorean norm decomposition across 4 subspaces',
      'Compositional angle α = arctan(AQ / AK)',
      'Loop ratio measurement for closed-path letters',
      'Cosine similarity between any two letters (always ≥ 0)',
    ],
    example: 'Letter ب: rN=0.333, rK=0.333, rQ=0.333 → Balanced (equal parts dot, line, curve)',
  },
  {
    code: 'NMV',
    name: 'Normivektor',
    tagline: 'Norm-Difference Diagnostics',
    color: 'hom-gold',
    borderColor: 'border-hom-gold/30',
    bgColor: 'bg-hom-gold/5',
    textColor: 'text-hom-gold',
    glowColor: 'shadow-glow-gold',
    question: 'How do two letters differ?',
    identity: '‖Δ‖² = ΔΘ² + ‖ΔN‖² + ‖ΔK‖² + ‖ΔQ‖²',
    description:
      'Normivektor computes the structured difference between any two letters — not just "how much" they differ (scalar distance), but precisely "where" the difference lies (which geometric layer). The norm of the difference vector decomposes into four orthogonal contributions, enabling layer-by-layer diagnostics. This is discrete finite difference, not continuous calculus.',
    capabilities: [
      'Total difference operator Δ(h₁, h₂) ∈ ℤ¹⁴',
      'Per-layer decomposition: Θ, N, K, Q contributions',
      'Nuqṭah gradient ∇N: tracks dot-change patterns',
      'Discovery: 8/9 dot-variants differ only in ascender zone (Na)',
      'Second-order difference Δ² (acceleration detection)',
      'Turning budget gradient ∇Q U = (0, 1, 1, 1, 4) — constant',
    ],
    example: 'ح → خ: 100% difference in N-layer (one dot added above). Zero leakage to K or Q layers.',
  },
  {
    code: 'AGM',
    name: 'Aggregametric',
    tagline: 'Structured String Accumulation',
    color: 'hom-green',
    borderColor: 'border-hom-green/30',
    bgColor: 'bg-hom-green/5',
    textColor: 'text-hom-green',
    glowColor: 'shadow-glow-green',
    question: 'What is the total codex of a word?',
    identity: 'Σ_uv = Σ_u + Σ_v',
    description:
      'Aggregametric accumulates codex vectors across strings (words, sentences) with a critical guarantee: all algebraic identities from Chapter I are preserved at the string level. Guards G1–G4, turning decomposition, and non-negativity of ρ survive aggregation. This is discrete accumulation, not continuous integration — the notation uses Σ, not ∫.',
    capabilities: [
      'Fundamental Additivity Theorem: Σ(uv) = Σ(u) + Σ(v)',
      'Anagram Invariance: permutations yield identical codex',
      'Full identity preservation: Θ̂ = U + ρ on strings',
      'Cumulative trajectory S_k(w) encodes letter ordering',
      'String centroid v̄(w) = (1/n)·Σ_w — "average letter"',
      'Energy bound: Σ_w Φ ≥ 2n (minimum energy per letter)',
    ],
    example: '"بسم": Σ_w Θ̂=10, Σ_w U=6, Σ_w ρ=4 → 10=6+4 ✓ (identity preserved)',
  },
  {
    code: 'ITM',
    name: 'Intrametric',
    tagline: 'Internal Distance Geometry',
    color: 'hom-purple',
    borderColor: 'border-hom-purple/30',
    bgColor: 'bg-hom-purple/5',
    textColor: 'text-hom-purple',
    glowColor: '',
    question: 'How far apart are two letters?',
    identity: 'd² = ‖h₁‖² + ‖h₂‖² − 2⟨h₁,h₂⟩',
    description:
      'Intrametric establishes a formal metric space (ℋ₂₈, d₂) on the alphabet — with rigorously verified axioms (identity requires injectivity from Chapter I), diameter, centroid, and nearest neighbors all explicitly characterized. The metric captures visual similarity: the closest letter pairs (d₂=1) are exactly the dot-variant pairs that look most alike.',
    capabilities: [
      'Three metrics: Euclidean d₂, Manhattan d₁, Hamming dH',
      'Full metric space axioms M1–M4 verified (M1 needs injectivity!)',
      'Gram Matrix G = M₁₄·M₁₄ᵀ ∈ ℕ₀²⁸ˣ²⁸, rank = 14',
      'Diameter = √70 ≈ 8.367, uniquely achieved by (ا, هـ)',
      'All 6 nearest-neighbor pairs at d₂=1 are dot-variants',
      'Alif (ا) is orthogonal to all 27 other letters',
    ],
    example: 'ا ⊥ all others (support disjoint). Nearest pairs: ح↔خ, ص↔ض, ط↔ظ (all d₂=1)',
  },
  {
    code: 'EXM',
    name: 'Exometric',
    tagline: 'External Consistency Audit',
    color: 'hom-red',
    borderColor: 'border-hom-red/30',
    bgColor: 'bg-hom-red/5',
    textColor: 'text-hom-red',
    glowColor: '',
    question: 'Is the data internally consistent?',
    identity: 'R1–R5 ; Φ(h) > ‖v₁₄(h)‖²',
    description:
      'Exometric builds a 5×5 constrained matrix (Letter Exomatrix) for each letter and validates it against five interlocking audit relations R1–R5. A single data corruption triggers an average of 2.3 cascading failures — providing redundant detection with location information. The Frobenius Energy Index Φ(h) is strictly greater than the codex norm for all 28 letters.',
    capabilities: [
      'Letter Exomatrix ℰ(h): 5×5 matrix with 15 degrees of freedom',
      'Five audit relations R1–R5 (140 total checks: 28×5)',
      'Cascading failure analysis: 1 corruption → ~2.3 failures',
      'Frobenius Energy Φ(h) = ‖ℰ(h)‖²F',
      'Strict Energy-Norm Inequality: Φ > ‖v₁₄‖² for all 28 letters',
      'Unique reconstruction: ℰ(h₁) = ℰ(h₂) ⟹ h₁ = h₂',
    ],
    example: 'Corrupt Qc(هـ) from 2→3: R1 FAIL + R4 FAIL + R5 FAIL (3 cascading failures detected)',
  },
];

export default function Landing() {
  return (
    <div className="space-y-16">
      {/* ═══════════════ HERO ═══════════════ */}
      <section className="relative min-h-[70vh] flex flex-col md:flex-row items-center justify-between pt-10 pb-20">
        <div className="absolute inset-0 -z-10">
          <HijaiyyahScene />
        </div>
        <div className="relative z-10 max-w-xl flex-1">
          <div className="mb-4 flex items-center gap-3">
            <span className="text-[10px] font-mono px-2 py-1 rounded-full bg-hom-accent/10 text-hom-accent border border-hom-accent/20">
              HM-28-v1.2-HC18D
            </span>
            <span className="text-[10px] font-mono px-2 py-1 rounded-full bg-hom-green/10 text-hom-green border border-hom-green/20">
              1,611 PASS · 0 FAIL
            </span>
          </div>

          <h1 className="text-4xl md:text-6xl font-bold leading-tight mb-4">
            <span className="neon-text">Hijaiyyah</span>
            <br />
            <span className="text-hom-text">Mathematics</span>
          </h1>

          <p className="text-hom-muted text-sm md:text-base leading-relaxed mb-4 max-w-lg">
            A formal mathematical system mapping 28 canonical Hijaiyyah letters
            to 18-dimensional integer vectors through four discrete geometric
            invariants — establishing{' '}
            <span className="text-hom-gold font-semibold">hybit</span> as the
            third computational paradigm.
          </p>

          <FormulaBlock
            tex="h \in \mathcal{H}_{28} \xrightarrow{\text{Measure}} \mathbf{H}(h) \xrightarrow{\text{Map}} v_{18}(h) \in \mathbb{N}_0^{18} \xrightarrow{\text{Name}} h^*"
            display
          />

          <div className="flex flex-wrap gap-3 mt-6">
            <Link
              to="/explorer"
              className="px-5 py-2.5 rounded-lg bg-hom-accent text-black font-semibold text-sm hover:shadow-glow transition-all"
            >
              Explore Letters →
            </Link>
            <Link
              to="/lab"
              className="px-5 py-2.5 rounded-lg border border-hom-border text-hom-text text-sm hover:border-hom-accent/50 transition-all"
            >
              Open Lab
            </Link>
            <a
              href="https://github.com/hybittech/HOM"
              target="_blank"
              rel="noopener noreferrer"
              className="px-5 py-2.5 rounded-lg border border-hom-border text-hom-muted text-sm hover:border-hom-gold/50 hover:text-hom-gold transition-all flex items-center gap-2"
            >
              <svg className="w-4 h-4" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z" />
              </svg>
              GitHub
            </a>
          </div>
        </div>
        
        {/* Right Column: Logo */}
        <div className="relative z-10 w-full md:w-1/2 flex justify-center md:justify-end mt-12 md:mt-0">
          <img
            src={import.meta.env.BASE_URL + 'logo.png'}
            alt="الرياضيات الهجائية"
            className="w-[300px] md:w-[450px] lg:w-[550px] h-auto drop-shadow-[0_0_30px_rgba(212,175,55,0.4)] animate-[pulse_6s_ease-in-out_infinite]"
          />
        </div>
      </section>

      {/* ═══════════════ STATS ═══════════════ */}
      <section className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {stats.map((s) => (
          <GlassPanel key={s.label} glow>
            <div className="text-3xl font-bold neon-text font-mono">
              {s.value}
            </div>
            <div className="text-sm text-hom-text mt-1">{s.label}</div>
            <div className="text-[10px] text-hom-muted mt-0.5">{s.sub}</div>
          </GlassPanel>
        ))}
      </section>

      {/* ═══════════════ PARADIGM ═══════════════ */}
      <section>
        <GlassPanel
          title="Three Computational Paradigms"
          badge="Proven VF — Birkhoff Variety Analysis"
          glow="gold"
        >
          <FormulaBlock
            tex="\text{bit} \;\oplus\; \text{qubit} \;\oplus\; \text{hybit} \;=\; \text{three fundamental paradigms}"
            display
          />
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-6">
            {[
              {
                name: 'Bit',
                struct: '\\mathbb{F}_2',
                desc: 'Field (2 elements)',
                domain: 'Boolean logic, switching',
                validation: 'None',
                color: 'text-hom-muted',
              },
              {
                name: 'Qubit',
                struct: '\\mathbb{C}^2',
                desc: 'Hilbert Space (continuous)',
                domain: 'Quantum simulation',
                validation: 'Partial, destructive',
                color: 'text-hom-purple',
              },
              {
                name: 'Hybit',
                struct: '\\mathcal{V} \\subset \\mathbb{N}_0^{18}',
                desc: 'Constrained Monoid (discrete)',
                domain: 'Structured data + audit',
                validation: 'Full, O(1), non-destructive',
                color: 'text-hom-gold',
              },
            ].map((p) => (
              <div
                key={p.name}
                className="text-center p-5 rounded-xl bg-hom-bg/50 border border-hom-border/30"
              >
                <div className={`text-xl font-bold ${p.color}`}>{p.name}</div>
                <div className="my-2">
                  <FormulaBlock tex={p.struct} />
                </div>
                <div className="text-xs text-hom-text">{p.desc}</div>
                <div className="text-[10px] text-hom-muted mt-2">
                  Domain: {p.domain}
                </div>
                <div className="text-[10px] text-hom-muted">
                  Validation: {p.validation}
                </div>
              </div>
            ))}
          </div>
          <div className="mt-4 text-center text-[10px] text-hom-muted">
            Mutually irreducible: Hybit ↛ Bit, Hybit ↛ Qubit, Bit ↛ Hybit
            (Theorems 3.8.1–3.8.3)
          </div>
        </GlassPanel>
      </section>

      {/* ═══════════════ FIVE OPERATIONS — DETAILED ═══════════════ */}
      <section>
        <div className="mb-6">
          <h2 className="text-2xl font-bold">
            Metrik-Vektorial Operations System
          </h2>
          <p className="text-sm text-hom-muted mt-1">
            Five formal operations built on three pillars:{' '}
            <span className="text-hom-accent">Vector</span> +{' '}
            <span className="text-hom-gold">Norm</span> +{' '}
            <span className="text-hom-green">Metric</span> — each answering a
            fundamentally different question about letter structure.
          </p>
        </div>

        <div className="space-y-6">
          {operations.map((op, idx) => (
            <GlassPanel
              key={op.code}
              className={`border-l-2 ${op.borderColor}`}
            >
              <div className="grid grid-cols-1 lg:grid-cols-[280px_1fr] gap-6">
                {/* Left: Identity Card */}
                <div className={`p-4 rounded-xl ${op.bgColor} space-y-3`}>
                  <div className="flex items-center gap-3">
                    <span
                      className={`text-2xl font-mono font-bold ${op.textColor}`}
                    >
                      {op.code}
                    </span>
                    <span className="text-[10px] font-mono px-2 py-0.5 rounded-full bg-hom-panel border border-hom-border/30 text-hom-muted">
                      II-{String.fromCharCode(65 + idx)}
                    </span>
                  </div>
                  <div className="text-lg font-semibold text-hom-text">
                    {op.name}
                  </div>
                  <div className={`text-xs font-medium ${op.textColor}`}>
                    {op.tagline}
                  </div>
                  <div className="glow-line" />
                  <div className="text-[11px] text-hom-muted italic">
                    "{op.question}"
                  </div>
                  <div className="mt-2">
                    <div className="text-[10px] text-hom-muted mb-1">
                      Key Identity:
                    </div>
                    <code
                      className={`text-xs font-mono ${op.textColor} block p-2 rounded bg-hom-bg/50`}
                    >
                      {op.identity}
                    </code>
                  </div>
                </div>

                {/* Right: Description + Capabilities */}
                <div className="space-y-4">
                  <p className="text-sm text-hom-text/90 leading-relaxed">
                    {op.description}
                  </p>

                  <div>
                    <div className="text-[10px] text-hom-muted font-semibold uppercase tracking-wider mb-2">
                      Capabilities
                    </div>
                    <ul className="space-y-1.5">
                      {op.capabilities.map((cap, i) => (
                        <li
                          key={i}
                          className="flex items-start gap-2 text-xs text-hom-text/80"
                        >
                          <span className={`mt-0.5 ${op.textColor}`}>▸</span>
                          <span>{cap}</span>
                        </li>
                      ))}
                    </ul>
                  </div>

                  <div
                    className={`text-[11px] font-mono p-3 rounded-lg ${op.bgColor} border ${op.borderColor}`}
                  >
                    <span className="text-hom-muted">Example: </span>
                    <span className="text-hom-text/80">{op.example}</span>
                  </div>
                </div>
              </div>
            </GlassPanel>
          ))}
        </div>

        {/* Operations Flow Diagram */}
        <GlassPanel className="mt-6" title="Operations Flow" badge="Architecture">
          <div className="text-center font-mono text-xs text-hom-muted leading-relaxed">
            <pre className="inline-block text-left">
{`         ┌───────────────────┐
         │   VEKTRONOMETRY   │ ← Measures composition
         │      (VTM)        │
         └─────────┬─────────┘
                   │
     ┌─────────────┴──────────────┐
     │                            │
     ▼                            ▼
┌────────────┐            ┌──────────────┐
│ NORMIVEKTOR│            │AGGREGAMETRIC │
│   (NMV)    │            │    (AGM)     │
│ Differences│            │ String sums  │
└─────┬──────┘            └──────┬───────┘
      │                          │
      └────────────┬─────────────┘
                   ▼
         ┌───────────────────┐
         │   INTRAMETRIC     │ ← Maps distances
         │      (ITM)        │
         └─────────┬─────────┘
                   │
                   ▼
         ┌───────────────────┐
         │    EXOMETRIC      │ ← Validates everything
         │      (EXM)        │
         └───────────────────┘`}
            </pre>
          </div>
        </GlassPanel>
      </section>

      {/* ═══════════════ VERIFICATION ═══════════════ */}
      <section>
        <GlassPanel
          title="1,380-Check Verification Framework"
          badge="ALL PASS"
          glow="green"
        >
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-center">
            {[
              { bab: 'Bab I', checks: 658, label: 'Foundation', sub: 'Guards · Injectivity · Mod-4' },
              { bab: 'Bab II', checks: 683, label: 'Metrik-Vektorial', sub: 'VTM · NMV · AGM · ITM · EXM' },
              { bab: 'Bab III', checks: 39, label: 'Hybit Pipeline', sub: 'Closure · Theorems · Pipeline' },
            ].map((b) => (
              <div
                key={b.bab}
                className="p-5 rounded-xl bg-hom-bg/50 border border-hom-green/10"
              >
                <div className="text-3xl font-bold text-hom-green font-mono">
                  {b.checks}
                </div>
                <div className="text-sm text-hom-text mt-1">{b.bab}</div>
                <div className="text-xs text-hom-muted">{b.label}</div>
                <div className="text-[10px] text-hom-muted/60 mt-1">{b.sub}</div>
              </div>
            ))}
          </div>
          <div className="mt-4 text-center">
            <span className="font-mono text-sm text-hom-green">
              1,380 PASS · 0 FAIL · 0 SKIP
            </span>
          </div>
          <div className="mt-2 text-center text-[10px] text-hom-muted">
            Full test suite: 1,611 passed · 0 skipped · 0 failed in ~46s
          </div>
        </GlassPanel>
      </section>

      {/* ═══════════════ DOWNLOAD & RUN ═══════════════ */}
      <section>
        <div className="mb-6">
          <h2 className="text-2xl font-bold">Download & Run</h2>
          <p className="text-sm text-hom-muted mt-1">
            HOM is open for audit. Clone the repository, install, and run
            locally.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Repository Card */}
          <GlassPanel glow>
            <div className="flex items-center gap-3 mb-4">
              <svg
                className="w-8 h-8 text-hom-text"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z" />
              </svg>
              <div>
                <div className="text-sm font-semibold">GitHub Repository</div>
                <div className="text-[10px] text-hom-muted">
                  Full source code, tests, documentation
                </div>
              </div>
            </div>
            <a
              href="https://github.com/hybittech/HOM"
              target="_blank"
              rel="noopener noreferrer"
              className="block w-full text-center px-4 py-3 rounded-lg bg-hom-accent/10 border border-hom-accent/30 text-hom-accent font-mono text-sm hover:bg-hom-accent/20 transition-all"
            >
              github.com/hybittech/HOM
            </a>
            <div className="mt-4 space-y-2 text-xs text-hom-muted">
              <div className="flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-hom-green" />
                Python 3.11+ backend — 1,611 tests
              </div>
              <div className="flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-hom-accent" />
                React + Three.js frontend — this GUI
              </div>
              <div className="flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-hom-gold" />
                24 pipeline components defined
              </div>
            </div>
          </GlassPanel>

          {/* Quick Start Card */}
          <GlassPanel>
            <div className="text-sm font-semibold mb-4">
              Quick Start — Run Locally
            </div>

            <div className="space-y-4">
              {/* Step 1 */}
              <div>
                <div className="text-[10px] text-hom-accent font-semibold uppercase tracking-wider mb-1">
                  Step 1 — Clone
                </div>
                <code className="block p-3 rounded-lg bg-hom-bg border border-hom-border/30 font-mono text-xs text-hom-text">
                  git clone https://github.com/hybittech/HOM.git
                </code>
              </div>

              {/* Step 2 */}
              <div>
                <div className="text-[10px] text-hom-gold font-semibold uppercase tracking-wider mb-1">
                  Step 2 — Install & Run (Python Backend)
                </div>
                <code className="block p-3 rounded-lg bg-hom-bg border border-hom-border/30 font-mono text-xs text-hom-text whitespace-pre">
{`cd HOM
pip install -e ".[dev]"
pytest tests/test_full_verification.py -v
# → 1,380 passed`}
                </code>
              </div>

              {/* Step 3 */}
              <div>
                <div className="text-[10px] text-hom-green font-semibold uppercase tracking-wider mb-1">
                  Step 3 — Run GUI (Frontend)
                </div>
                <code className="block p-3 rounded-lg bg-hom-bg border border-hom-border/30 font-mono text-xs text-hom-text whitespace-pre">
{`npm install
npm run dev
# → Open http://localhost:5173/HOM/`}
                </code>
              </div>

              {/* Step 4 */}
              <div>
                <div className="text-[10px] text-hom-purple font-semibold uppercase tracking-wider mb-1">
                  Step 4 — Run Full HOM Application
                </div>
                <code className="block p-3 rounded-lg bg-hom-bg border border-hom-border/30 font-mono text-xs text-hom-text whitespace-pre">
{`python -m hijaiyyah
# → Opens HOM GUI (Tkinter-based scientific environment)`}
                </code>
              </div>
            </div>
          </GlassPanel>
        </div>

        {/* Prerequisites */}
        <GlassPanel className="mt-4" title="Prerequisites">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            {[
              { name: 'Python', version: '3.11+', check: 'python --version' },
              { name: 'Node.js', version: '18+', check: 'node --version' },
              { name: 'pip', version: '22+', check: 'pip --version' },
              { name: 'npm', version: '9+', check: 'npm --version' },
            ].map((req) => (
              <div
                key={req.name}
                className="p-3 rounded-lg bg-hom-bg/50 border border-hom-border/20 text-center"
              >
                <div className="text-sm font-semibold text-hom-text">
                  {req.name}
                </div>
                <div className="text-hom-accent text-xs font-mono">
                  {req.version}
                </div>
                <div className="text-[9px] text-hom-muted mt-1 font-mono">
                  {req.check}
                </div>
              </div>
            ))}
          </div>
        </GlassPanel>

        {/* Alternative Access */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
          <a
            href="https://github.com/hybittech/HOM/archive/refs/heads/main.zip"
            target="_blank"
            rel="noopener noreferrer"
            className="glass p-4 text-center hover:border-hom-accent/40 transition-all"
          >
            <div className="text-lg mb-1">📦</div>
            <div className="text-xs font-semibold">Download ZIP</div>
            <div className="text-[10px] text-hom-muted">
              No Git required
            </div>
          </a>
          <a
            href="https://codespaces.new/hybittech/HOM"
            target="_blank"
            rel="noopener noreferrer"
            className="glass p-4 text-center hover:border-hom-green/40 transition-all"
          >
            <div className="text-lg mb-1">☁️</div>
            <div className="text-xs font-semibold">GitHub Codespaces</div>
            <div className="text-[10px] text-hom-muted">
              Run in browser — no local install
            </div>
          </a>
          <a
            href="https://hybittech.github.io/HOM/#/"
            target="_blank"
            rel="noopener noreferrer"
            className="glass p-4 text-center hover:border-hom-gold/40 transition-all"
          >
            <div className="text-lg mb-1">🌐</div>
            <div className="text-xs font-semibold">Live Demo</div>
            <div className="text-[10px] text-hom-muted">
              This page — already running
            </div>
          </a>
        </div>
      </section>

      {/* ═══════════════ FOOTER CTA ═══════════════ */}
      <section className="text-center py-8">
        <div className="glow-line mb-8" />
        <FormulaBlock
          tex="\boxed{\text{bit} \;\oplus\; \text{qubit} \;\oplus\; \text{hybit}}"
          display
        />
        <p className="text-sm text-hom-muted mt-4 max-w-md mx-auto">
          Three paradigms. Three optimal domains. Five metrik-vektorial
          operations. One pipeline. One ecosystem.
        </p>
        <div className="mt-6 flex justify-center gap-4">
          <Link
            to="/explorer"
            className="px-6 py-2.5 rounded-lg bg-hom-accent text-black font-semibold text-sm hover:shadow-glow transition-all"
          >
            Start Exploring →
          </Link>
          <a
            href="https://github.com/hybittech/HOM"
            target="_blank"
            rel="noopener noreferrer"
            className="px-6 py-2.5 rounded-lg border border-hom-border text-hom-muted text-sm hover:text-hom-gold hover:border-hom-gold/50 transition-all"
          >
            View Source on GitHub
          </a>
        </div>
        <div className="mt-12 flex justify-center">
          <div className="font-mono text-[10px] md:text-xs text-hom-muted leading-tight text-left border border-hom-border/30 p-6 rounded-xl bg-hom-bg/50 backdrop-blur-sm shadow-glow-gold/5 max-w-full overflow-hidden">
            <pre className="whitespace-pre overflow-x-auto">
{`╔══════════════════════════════════════════════════════════════╗
║       AUTHOR SIGNATURE                                       ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Signed:     Firman Arief Hidayatullah                       ║
║             Author Matematika Hijaiyyah                      ║
║  Release:    HM-28-v1.2-HC18D                                ║
║  Seal:       VERIFIED & SEALED                               ║
║  Framework:  1.380/1.380 PASS — 0 FAIL                       ║
║                                                              ║
║  © 2026 (HMCL)                                               ║
║  Hijaiyyah Mathematics Computational Laboratory              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝`}
            </pre>
            <div className="mt-4 text-center border-t border-hom-border/20 pt-4">
              <span className="text-hom-muted">Contact: </span>
              <a 
                href="mailto:hybittechnology@gmail.com" 
                className="text-hom-gold hover:text-hom-accent transition-colors font-semibold"
              >
                hybittechnology@gmail.com
              </a>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}

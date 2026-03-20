<div align="center">

# **HOM Architecture**
## Hijaiyyah Operating Machine — System Architecture Document

### Version 1.0.0 · HM-28-v1.0-HC18D · 2026

</div>

---

## Daftar Isi

- [1. Ringkasan Arsitektur](#1-ringkasan-arsitektur)
- [2. Prinsip Desain](#2-prinsip-desain)
- [3. Diagram Layer](#3-diagram-layer)
- [4. Layer L0 — Fondasi Data](#4-layer-l0--fondasi-data)
- [5. Layer L1 — Bahasa Formal](#5-layer-l1--bahasa-formal)
- [6. Layer L2 — Arsitektur Instruksi](#6-layer-l2--arsitektur-instruksi)
- [7. Layer L3 — Model Mesin](#7-layer-l3--model-mesin)
- [8. Layer L4 — Prosesor Target](#8-layer-l4--prosesor-target)
- [9. Layer L5 — Mesin Virtual](#9-layer-l5--mesin-virtual)
- [10. Layer L6 — Keamanan](#10-layer-l6--keamanan)
- [11. Layer L7 — Format Pertukaran Data](#11-layer-l7--format-pertukaran-data)
- [12. GUI — HOM Interface](#12-gui--hom-interface)
- [13. Algebra Engine](#13-algebra-engine)
- [14. Integrity Engine](#14-integrity-engine)
- [15. CSGI Pipeline](#15-csgi-pipeline)
- [16. Alur Data](#16-alur-data)
- [17. Dependency Map](#17-dependency-map)
- [18. Status Komponen](#18-status-komponen)
- [19. Konvensi dan Standar](#19-konvensi-dan-standar)
- [20. Roadmap Arsitektur](#20-roadmap-arsitektur)

---

## 1. Ringkasan Arsitektur

HOM (Hijaiyyah Operating Machine) adalah implementasi perangkat lunak utama
dari **Matematika Hijaiyyah**. Ia berfungsi sebagai:

1. **mesin komputasi formal** untuk codex 18D,
2. **lingkungan kerja ilmiah** untuk analisis huruf dan string,
3. **runtime bahasa HC** dan mesin virtual HCVM,
4. **platform verifikasi** untuk teorema dan audit formal,
5. dan **antarmuka terpadu** yang menyatukan seluruh komponen.

Secara arsitektural, HOM disusun dalam **delapan layer fungsional (L0–L7)**
ditambah satu **lapisan GUI** dan tiga **engine pendukung** (algebra,
integrity, CSGI).

### Identitas Rilis

| Field | Nilai |
|---|---|
| Release | HM-28-v1.0-HC18D-B84D025 |
| Version | 1.0.0 |
| Dataset | 28 huruf × 18 dimensi |
| ROM | 252 bytes |
| SHA-256 | `f82d385917ffe32ae2b5711409b1341e...` |

---

## 2. Prinsip Desain

Seluruh arsitektur HOM dibangun di atas enam prinsip berikut.

### 2.1 Separation of Concerns

| Layer | Tanggung Jawab |
|---|---|
| `core/` | data formal, codex, guard |
| `algebra/` | operasi matematika Bab II |
| `language/` | lexer, parser, evaluator HC |
| `gui/` | tampilan dan interaksi pengguna |

Setiap layer hanya boleh bergantung pada layer di bawahnya,
**tidak pernah ke atas**.

### 2.2 GUI Does Not Compute

GUI hanya bertugas:
- menampilkan hasil,
- menerima input,
- dan memanggil service/engine.

GUI **tidak boleh** menghitung matematika secara langsung.

### 2.3 Integer-Only Core

Seluruh data codex inti disimpan sebagai `ℕ₀` (integer tak-negatif).
Tidak ada floating-point pada layer data inti. Floating-point
hanya boleh muncul pada:
- display conversion (`Θ°`, `Θ_rad`),
- rasio turunan (`r_N`, `r_K`, `r_Q`),
- dan norma/jarak (`‖h‖`).

### 2.4 Deterministic Pipeline

```
dataset-seal yang sama + protokol yang sama = hasil yang sama
```

Setiap komputasi harus **reprodusibel** di mesin mana pun.

### 2.5 Testable Without GUI

Setiap modul di bawah `gui/` harus dapat diuji secara independen.
Artinya:
- `core/master_table.py` bisa diuji tanpa membuka window,
- `algebra/vectronometry.py` bisa dipanggil dari pytest,
- `theorems/test_suite.py` bisa dijalankan headless.

### 2.6 One Tab = One File

Setiap tab GUI ditempatkan di file terpisah:

```
gui/tabs/
    letter_explorer.py
    theorems.py
    string_integral.py
    ...
```

Ini memastikan modularitas dan kemudahan pemeliharaan.

---

## 3. Diagram Layer

### 3.1 Stack Utama

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│                      HOM GUI                            │
│                                                         │
│   ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│   │ Letter   │ │ Theorems │ │ String   │ │ Audit    │ │
│   │ Explorer │ │ Verifier │ │ Codex    │ │ Console  │ │
│   └──────────┘ └──────────┘ └──────────┘ └──────────┘ │
│   ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│   │ Five     │ │ Codex    │ │ HC IDE   │ │ H-ISA    │ │
│   │ Fields   │ │ Geometry │ │          │ │ Machine  │ │
│   └──────────┘ └──────────┘ └──────────┘ └──────────┘ │
│   ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│   │ Bytecode │ │ HCVM     │ │ CSGI     │ │ Release  │ │
│   │ Inspect  │ │ Console  │ │ Process  │ │ Console  │ │
│   └──────────┘ └──────────┘ └──────────┘ └──────────┘ │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│                   SERVICE LAYER                         │
│                                                         │
│   ┌─────────────┐  ┌─────────────┐  ┌───────────────┐ │
│   │ Algebra     │  │ Integrity   │  │ Theorem       │ │
│   │ Engine      │  │ Engine      │  │ Engine        │ │
│   └─────────────┘  └─────────────┘  └───────────────┘ │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│              LANGUAGE + RUNTIME LAYER                    │
│                                                         │
│   ┌──────────┐  ┌──────────┐  ┌──────────────────────┐ │
│   │ HC       │  │ H-ISA    │  │ HCVM                 │ │
│   │ Language │  │ Machine  │  │ Virtual Machine      │ │
│   │ (L1)     │  │ (L2)     │  │ (L5)                 │ │
│   └──────────┘  └──────────┘  └──────────────────────┘ │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│              SECURITY + EXCHANGE LAYER                   │
│                                                         │
│   ┌──────────┐  ┌──────────┐  ┌──────────────────────┐ │
│   │ HGSS     │  │ HC18DC   │  │ Release              │ │
│   │ (L6)     │  │ (L7)     │  │ Manager              │ │
│   └──────────┘  └──────────┘  └──────────────────────┘ │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│              SKELETON + EXTRACTION LAYER                 │
│                                                         │
│   ┌──────────────────────────────────────────────────┐  │
│   │ CSGI: Skeletonizer → Contractor → Graph → JSON  │  │
│   └──────────────────────────────────────────────────┘  │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│                    CORE LAYER (L0)                       │
│                                                         │
│   ┌──────────────────────────────────────────────────┐  │
│   │ Master Table · CodexEntry · Hybit · Guards       │  │
│   │ Checksum · ROM · Dataset · Constants             │  │
│   └──────────────────────────────────────────────────┘  │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│                  DATA SEAL LAYER                         │
│                                                         │
│   ┌──────────────────────────────────────────────────┐  │
│   │ HM-28-v1.0-HC18D                                │  │
│   │ 28 letters × 18 dimensions                       │  │
│   │ ROM: 252 bytes · SHA-256: f82d3859...            │  │
│   └──────────────────────────────────────────────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 3.2 Alur Vertikal Ringkas

```
Dataset Seal (data/hm28.json + hm28.rom)
        │
        ▼
Core (master_table, codex, guards)
        │
        ├──► Algebra (vect, diff, intg, geom, exo)
        ├──► Integrity (inject, audit, seal)
        ├──► Theorems (mod4, decomp, pyth, energy)
        ├──► CSGI (skeleton → graph → codex)
        │
        ▼
Language (HC lexer → parser → evaluator)
        │
        ├──► H-ISA (opcodes → machine)
        ├──► HCVM (runtime → bytecode)
        │
        ▼
Security (HGSS) + Exchange (HC18DC)
        │
        ▼
GUI (HOM tabs → display)
```

---

## 4. Layer L0 — Fondasi Data

### 4.1 Lokasi

```
src/hijaiyyah/core/
```

### 4.2 Komponen

| File | Fungsi |
|---|---|
| `master_table.py` | Tabel induk 28×18; sumber kebenaran |
| `codex_entry.py` | Dataclass untuk satu entri huruf |
| `codex.py` | Operasi dasar codex14/codex18 |
| `hybit.py` | Tipe hybit formal |
| `guards.py` | Validasi struktural G1–G4 |
| `checksum.py` | Fungsi checksum internal |
| `rom.py` | Packing/unpacking ROM 252 byte |
| `dataset.py` | Loader dan validator dataset |
| `constants.py` | Alfabet H28, slot names, mapping |

### 4.3 Invariant Layer L0

Saat `MasterTable` dimuat, ia **wajib** memvalidasi:

```
✓ jumlah entri = 28
✓ setiap vektor panjang = 18
✓ A_N = Na + Nb + Nd            (untuk 28/28)
✓ A_K = Kp + Kx + Ks + Ka + Kc  (untuk 28/28)
✓ A_Q = Qp + Qx + Qs + Qa + Qc  (untuk 28/28)
✓ ρ = Θ̂ − U ≥ 0                (untuk 28/28)
✓ Ks > 0 ⇒ Qc ≥ 1              (topology guard)
✓ Kc > 0 ⇒ Qc ≥ 1              (topology guard)
```

Jika satu saja gagal, master table **menolak dimuat**.

### 4.4 Format Data

| File | Format | Lokasi |
|---|---|---|
| `hm28.json` | JSON canonical | `data/` |
| `hm28.csv` | CSV tabular | `data/` |
| `hm28.rom` | Binary nibble-packed | `data/` |
| `hm28_manifest.json` | JSON manifest + SHA-256 | `data/` |

### 4.5 SHA-256 Seal

```
f82d385917ffe32ae2b5711409b1341e90934c52172ae9d0fa68888e3b9c51c8
```

Setiap perubahan byte pada dataset menghasilkan hash berbeda
dan menggugurkan identitas rilis.

---

## 5. Layer L1 — Bahasa Formal

### 5.1 Lokasi

```
src/hijaiyyah/language/
```

### 5.2 Komponen

| File | Fungsi |
|---|---|
| `tokens.py` | Definisi TokenType dan Token |
| `lexer.py` | Tokenizer HC v1.0 |
| `parser.py` | Recursive-descent parser |
| `ast_nodes.py` | Definisi AST |
| `grammar.py` | EBNF referensi |
| `evaluator.py` | Evaluator + standard library |
| `builtins.py` | Built-in functions |

### 5.3 Fitur Bahasa HC

```
Deklarasi:    let x: int = 10;
              let mut total: hybit = zero();
              const PI: float = 3.1416;

Fungsi:       fn name(params) -> type { ... }

Kontrol:      if / else / match / while / for

Literal:      42, 3.14, true, "string", 'ب'

Operator:     + - * / % == != < > <= >= && || !

Method:       h.theta(), h.guard(), h.norm2()

Module:       hm::vectronometry::norm2(h)
```

### 5.4 Standard Library Modules

```
hm::vectronometry    — rasio, norm, inner product, cosine
hm::differential     — delta, decomposition, gradient
hm::integral         — string integral, centroid, trajectory
hm::geometry         — distance, nearest, diameter, gram
hm::exomatrix        — build, audit, phi, reconstruct
```

### 5.5 Alur Eksekusi

```
Source Code (.hc)
      │
      ▼
   Lexer → Token Stream
      │
      ▼
   Parser → AST
      │
      ▼
   Evaluator → Result
      │
      ├──► println() output
      ├──► codex computation
      └──► guard verification
```

---

## 6. Layer L2 — Arsitektur Instruksi

### 6.1 Lokasi

```
src/hijaiyyah/hisa/
```

### 6.2 Komponen

| File | Fungsi |
|---|---|
| `opcodes.py` | Definisi opcode dan instruction word |
| `registers.py` | Register file model |
| `machine.py` | Eksekutor instruksi |
| `compiler.py` | HC → H-ISA bytecode |
| `assembler.py` | Assembly text → instruction word |

### 6.3 Format Instruction Word

```
32-bit fixed-width:
[OP:8][DST:4][S1:4][S2:4][IMM:12]
```

| Field | Bit | Fungsi |
|---|---|---|
| OP | 31–24 | Opcode (256 kemungkinan) |
| DST | 23–20 | Register tujuan |
| S1 | 19–16 | Source register 1 |
| S2 | 15–12 | Source register 2 |
| IMM | 11–0 | Immediate value (12-bit) |

### 6.4 Register Model

```
18 General Purpose Registers (R0–R17)
 4 Codex Registers (H0–H3)
 1 Program Counter (PC)
 1 Status Register (FLAGS: GUARD/ZERO/OVR)
```

### 6.5 Operasi Asli

| Mnemonic | Fungsi |
|---|---|
| `CLOAD` | Muat codex 18D dari ROM/memori |
| `CADD` | Penjumlahan vektor codex |
| `VCHK` | Verifikasi guard G1–G4 |
| `VDIST` | Hitung jarak Euclidean |
| `VRHO` | Hitung residu ρ = Θ̂ − U |
| `CHASH` | Hash deterministik atas codex |
| `CSIGN` | Tanda tangan digital artefak |

---

## 7. Layer L3 — Model Mesin

### 7.1 Identitas

**CMM-18C** (Codex Multidimensional Machine — 18 Cube)

### 7.2 Konsep

CMM-18C adalah model abstrak mesin yang mendefinisikan:
- bagaimana vektor 18D diproses sebagai state komputasi,
- bagaimana transisi state terjadi melalui instruksi H-ISA,
- dan bagaimana operasi Bab II dieksekusi pada level mesin.

### 7.3 Status

**SPECIFIED** — model sudah didefinisikan, implementasi melalui HCVM/H-ISA.

---

## 8. Layer L4 — Prosesor Target

### 8.1 Identitas

**HCPU** (Hijaiyyah Core Processing Unit)

### 8.2 Konsep

Arsitektur prosesor khusus yang dirancang untuk memproses codex 18D
secara native. Target:
- register file 18D,
- ALU integer paralel,
- lookup ROM 252 byte onboard,
- guard checker hardware.

### 8.3 Status

**DESIGNED** — arsitektur dipetakan, target FPGA/Verilog masa depan.

### 8.4 Jalur Realisasi

```
Fase 1: Soft-HCPU on FPGA
Fase 2: ASIC (jangka panjang)
```

---

## 9. Layer L5 — Mesin Virtual

### 9.1 Lokasi

```
hcvm.py (standalone)
src/hijaiyyah/gui/tabs/hcvm.py (GUI integration)
```

### 9.2 Fungsi

HCVM (Hijaiyyah Codex Virtual Machine) menjalankan:
- script HC/HL-18E,
- bytecode H-ISA,
- built-in commands,
- dan operasi codex.

### 9.3 Built-in Commands

```
EMIT(...)         — output ke console
AGGREGATE(text)   — hitung codex string
COD18(char)       — load codex huruf
VERIFY_CHECKSUM() — validasi guard
VERIFY_MOD4()     — cek Mod-4
DECOMPOSE()       — tampilkan U, ρ
SEAL()            — hitung dataset seal
```

### 9.4 Status

**OPERATIONAL** — dapat dijalankan mandiri atau dari GUI.

---

## 10. Layer L6 — Keamanan

### 10.1 Lokasi

```
src/hijaiyyah/crypto/
```

### 10.2 Komponen

| File | Fungsi |
|---|---|
| `hashing.py` | SHA-256 dan hash deterministik |
| `signing.py` | Tanda tangan artefak |
| `certificate.py` | Release certificate |
| `guard_filter.py` | Penolakan data invalid |

### 10.3 HGSS (Hijaiyyah Guarded Signature System)

HGSS menggabungkan dua lapisan:

#### Lapisan 1 — Guard (validasi struktural)

```
G1: ρ = Θ̂ − U ≥ 0
G2: A_N = Na + Nb + Nd
G3: A_K = Kp + Kx + Ks + Ka + Kc
G4: A_Q = Qp + Qx + Qs + Qa + Qc
```

Kompleksitas: O(1) per unit. Tidak memerlukan kunci atau sertifikat.

#### Lapisan 2 — Signature (integritas kriptografis)

- hash artefak,
- tanda tangan rilis,
- verifikasi manifest.

### 10.4 Catatan Penting

```
Guard ≠ kriptografi penuh.

Guard = first-line structural validation.
HGSS  = crypto + guard combined.

Untuk autentikasi, kerahasiaan, dan non-repudiation:
mekanisme kriptografis tersendiri tetap diperlukan.
```

---

## 11. Layer L7 — Format Pertukaran Data

### 11.1 Identitas

**HC18DC** (Hijaiyyah Codex 18-Dimensional Canonical)

### 11.2 Fungsi

Format serialisasi dan pertukaran codex 18D yang:
- kanonik,
- deterministik,
- hashable,
- dan lintas platform.

### 11.3 Prinsip

```
1. UTF-8 encoding
2. NFC normalization sebelum compare
3. No duplicate keys dalam JSON
4. Canonical ordering (RFC 8785 / JCS)
5. SHA-256 sebagai digest
```

### 11.4 Format yang Didukung

| Format | Kegunaan |
|---|---|
| JSON | pertukaran data umum |
| CSV | inspeksi tabel |
| ROM binary | embedding ke hardware |
| Manifest JSON | metadata rilis |

### 11.5 Status

**SPECIFIED** — kerangka format sudah ada, standardisasi lanjutan
masih dibutuhkan.

---

## 12. GUI — HOM Interface

### 12.1 Lokasi

```
src/hijaiyyah/gui/
    app.py
    theme.py
    state.py
    tabs/
        letter_explorer.py
        master_table.py
        theorems.py
        string_integral.py
        audit.py
        five_fields.py
        geometry.py
        ide.py
        hisa_machine.py
        bytecode.py
        hcvm.py
        csgi.py
        export.py
        release.py
    widgets/
        summary_panel.py
        result_table.py
        detail_view.py
```

### 12.2 Tab Registry

| Tab | Ikon | Fungsi |
|---|---|---|
| Letter Explorer | ✦ | Profil lengkap per huruf |
| Master Table | ▦ | Tabel 28×18 interaktif |
| Theorems | ∴ | Verifikasi formal 13 tes |
| String Codex | ∑ | Analisis integral string |
| Audit Console | ✓ | Dashboard integritas |
| Five Fields | ⬡ | Analitik Bab II |
| Codex Geometry | △ | Jarak, neighbors, Gram |
| HC IDE | ⌨ | Editor + evaluator HC |
| H-ISA Machine | ⚙ | CPU state viewer |
| Bytecode | ⬡ | Decoder real-time |
| HCVM | ⚙ | VM console |
| CSGI | 🕸 | Skeleton pipeline |
| Export | ⬡ | JSON/CSV/manifest |
| Release | ⚙ | Identitas rilis |

### 12.3 Prinsip GUI

```
1. GUI tidak menghitung — memanggil service layer
2. Setiap tab = satu file
3. Summary + detail pattern di setiap tab
4. Output bukan hanya text dump — structured views
5. Export tersedia di setiap tab yang relevan
```

---

## 13. Algebra Engine

### 13.1 Lokasi

```
src/hijaiyyah/algebra/
```

### 13.2 Modul

| File | Bab | Fungsi Utama |
|---|---|---|
| `vectronometry.py` | II-A | rasio, norm, inner product, cosine, Pythagorean |
| `differential.py` | II-B | delta, decomposition, gradient, second diff |
| `integral.py` | II-C | string integral, centroid, trajectory |
| `geometry.py` | II-D | distance, nearest, diameter, Gram matrix |
| `exomatrix_analysis.py` | II-E | build, audit, phi, reconstruct |

### 13.3 Rumus Kunci per Modul

#### Vectronometry

```
r_N + r_K + r_Q = 1                    (Identitas Primitif)
r_U + r_ρ = 1                          (Identitas Turning)
‖h‖² = ‖Π_Θ‖² + ‖Π_N‖² + ‖Π_K‖² + ‖Π_Q‖²  (Pythagorean)
```

#### Differential

```
‖Δ‖² = Δ_Θ² + ‖Δ_N‖² + ‖Δ_K‖² + ‖Δ_Q‖²   (Dekomposisi)
∇_Q U = (0, 1, 1, 1, 4)                      (Gradien U)
```

#### Integral

```
∫_{uv} = ∫_u + ∫_v                          (Aditivitas)
∫_w Θ = ∫_w U + ∫_w ρ                       (Konsistensi)
```

#### Geometry

```
d₂² = ‖h₁‖² + ‖h₂‖² − 2⟨h₁,h₂⟩            (Polarisasi)
diam(H₂₈) = √70                             (Release fact)
```

#### Exomatrix

```
Φ(h) > ‖v₁₄(h)‖²                           (Energy inequality)
E(h₁) = E(h₂) ⟹ h₁ = h₂                   (Rekonstruksi)
```

---

## 14. Integrity Engine

### 14.1 Lokasi

```
src/hijaiyyah/integrity/
src/hijaiyyah/theorems/
```

### 14.2 Pemeriksaan yang Tersedia

| Kategori | Pemeriksaan |
|---|---|
| **Structural** | Guard G1–G4, ρ ≥ 0, checksum |
| **Claims** | Injectivity, rank M₁₄, rank M |
| **Theorems** | Mod-4, Pythagorean, decomposition |
| **Exomatrix** | R1–R5 (5 × 28 = 140 checks) |
| **Energy** | Φ > ‖v₁₄‖² (28 checks) |
| **Release** | SHA-256, manifest, sync |

### 14.3 Hasil Verifikasi Rilis

```
Theorem tests:        13/13 PASS
Guard checks (G1–G4): 28/28 PASS
Audit (R1–R5):        140/140 PASS
Injectivity:          378/378 unique pairs
Diameter:             √70 ≈ 8.367 VERIFIED
Energy inequality:    28/28 strict Φ > ‖v₁₄‖²
```

---

## 15. CSGI Pipeline

### 15.1 Lokasi

```
src/hijaiyyah/skeleton/
```

### 15.2 Alur Pipeline

```
Glyph Image (PNG)
      │
      ▼
Binarization (threshold)
      │
      ▼
Dot Separation (nuqṭah exclusion)
      │
      ▼
Zhang-Suen Thinning
      │
      ▼
Skeleton S(h) ⊂ ℤ²
      │
      ▼
Graph Construction Γ(h) = (V, E)
      │
      ├── 8-neighborhood adjacency
      ├── endpoint/junction classification
      └── edge polyline extraction
      │
      ▼
Graph Contraction
      │
      ▼
CSGI JSON Output
```

### 15.3 Parameter Terkunci (Rilis v1.0)

| Parameter | Nilai |
|---|---|
| Adjacency | 8-neighborhood |
| Thinning | Zhang-Suen |
| τ_dot_area | 15% luas komponen terbesar |
| φ_corner | 60° |
| τ_prune | 3 px |
| kink_enabled | false |

---

## 16. Alur Data

### 16.1 Dari Huruf ke Codex

```
Huruf h ∈ H₂₈
      │
      ├──[CSGI]──► skeleton → graph → components
      │
      ├──[core]──► N(h), K(h), Q(h), Θ̂(h)
      │
      ├──[core]──► A_N, A_K, A_Q, U, ρ
      │
      └──[core]──► v₁₄(h) → v₁₈(h) = hybit
```

### 16.2 Dari Codex ke Analisis

```
v₁₈(h)
      │
      ├──[algebra/vect]──► rasio, norm, cosine
      │
      ├──[algebra/diff]──► delta, gradient
      │
      ├──[algebra/intg]──► string codex, centroid
      │
      ├──[algebra/geom]──► distance, neighbors
      │
      └──[algebra/exo]───► exomatrix, phi, audit
```

### 16.3 Dari Codex ke Teknologi

```
v₁₈(h)
      │
      ├──[language/HC]──► program → evaluator → result
      │
      ├──[hisa]────────► bytecode → machine
      │
      ├──[hcvm]────────► script → VM → output
      │
      ├──[crypto]──────► hash → signature → seal
      │
      └──[gui/HOM]─────► display → interaction
```

---

## 17. Dependency Map

### 17.1 Aturan Dependency

```
core/          ← tidak import siapa pun
algebra/       ← import core/
integrity/     ← import core/
theorems/      ← import core/, algebra/
language/      ← import core/, algebra/
hisa/          ← import core/
skeleton/      ← import core/
crypto/        ← import core/
net/           ← import core/, crypto/
release/       ← import core/, crypto/
gui/           ← import semua (layer teratas)
```

### 17.2 Diagram Dependency

```
                    ┌─────┐
                    │ GUI │
                    └──┬──┘
           ┌───────────┼───────────┐
           │           │           │
     ┌─────┴─────┐ ┌───┴───┐ ┌────┴────┐
     │ Language  │ │ HISA  │ │ Theorems│
     └─────┬─────┘ └───┬───┘ └────┬────┘
           │           │          │
     ┌─────┴───────────┴──────────┴─────┐
     │            Algebra               │
     └────────────────┬─────────────────┘
                      │
     ┌────────────────┼──────────────────┐
     │                │                  │
┌────┴─────┐  ┌───────┴───────┐  ┌──────┴──────┐
│Integrity │  │   Skeleton    │  │   Crypto    │
└────┬─────┘  └───────┬───────┘  └──────┬──────┘
     │                │                 │
     └────────────────┼─────────────────┘
                      │
               ┌──────┴──────┐
               │    CORE     │
               └──────┬──────┘
                      │
               ┌──────┴──────┐
               │ Dataset Seal│
               └─────────────┘
```

---

## 18. Status Komponen

### 18.1 Status per Layer (2026)

| Layer | Komponen | Status |
|---|---|---|
| L0 | Master Table | **SEALED** |
| L0 | CSGI | **OPERATIONAL** |
| L1 | HC Language | **OPERATIONAL** |
| L1 | HL-18E | **SPECIFIED** |
| L2 | H-ISA | **OPERATIONAL** |
| L3 | CMM-18C | **SPECIFIED** |
| L4 | HCPU | **DESIGNED** |
| L5 | HCVM | **OPERATIONAL** |
| L6 | HGSS | **OPERATIONAL** |
| L7 | HC18DC | **SPECIFIED** |
| GUI | HOM | **OPERATIONAL** |

### 18.2 Definisi Status

| Status | Arti |
|---|---|
| **SEALED** | data final, tidak berubah untuk rilis ini |
| **OPERATIONAL** | berjalan dan dapat dipakai |
| **SPECIFIED** | spesifikasi ada, implementasi sedang/belum penuh |
| **DESIGNED** | arsitektur dipetakan, belum diimplementasi |

### 18.3 Status Agregat

```
OPERATIONAL:  6 dari 11
SPECIFIED:    3 dari 11
DESIGNED:     1 dari 11
SEALED:       1 dari 11
```

---

## 19. Konvensi dan Standar

### 19.1 File dan Modul

| Konvensi | Aturan |
|---|---|
| Encoding | UTF-8 |
| Line ending | LF |
| Max line | 100 karakter |
| Docstring | Google style |
| Type hints | wajib pada function signature |
| Import | stdlib → third-party → internal |

### 19.2 Penamaan

| Objek | Konvensi | Contoh |
|---|---|---|
| File | `snake_case` | `master_table.py` |
| Class | `PascalCase` | `MasterTable` |
| Function | `snake_case` | `get_by_char()` |
| Constant | `UPPER_SNAKE` | `H28_ALPHABET` |
| Private | `_prefix` | `_load()` |

### 19.3 Testing

```
Framework:     pytest
Lokasi:        tests/
Konvensi nama: test_*.py
Coverage:      pytest --cov=hijaiyyah
```

### 19.4 Git

```
Branch utama:  main (stable), dev (active)
Commit format: [module] short description
Tag format:    v1.0.0
```

---

## 20. Roadmap Arsitektur

### 20.1 Fase 1 — Konsolidasi (2026)

```
✓ Master Table sealed
✓ Algebra engine operational
✓ HC Language operational
✓ HOM GUI operational
□ Refactor GUI → service layer
□ Benchmark formal
□ Test coverage > 80%
```

### 20.2 Fase 2 — Standardisasi (2027–2028)

```
□ HC Language specification final
□ HC vs HL-18Q separation complete
□ HC18DC format standardized
□ HCVM production-grade
□ CI/CD pipeline full
□ Documentation complete
```

### 20.3 Fase 3 — Hardware dan Skalabilitas (2029–2030)

```
□ HCPU softcore on FPGA
□ H-ISA benchmark published
□ Network protocol operational
□ Web interface (hybit-web)
□ Multi-platform deployment
```

### 20.4 Fase 4 — Ekosistem (2030+)

```
□ HCPU ASIC
□ Standar terbuka
□ Ekosistem pengembang
□ Produk industri
□ Kurikulum pendidikan formal
```

---

## Catatan Akhir

Dokumen ini adalah **living document** yang akan diperbarui
seiring perkembangan HOM. Setiap perubahan arsitektural
yang signifikan harus:

1. didokumentasikan di sini,
2. dicatat di `CHANGELOG.md`,
3. dan di-review sebelum merge ke `main`.

---

<div align="center">

**HOM — Hijaiyyah Operating Machine**

*Core Computational System for Hijaiyyah Mathematics*

© 2026 Hijaiyyah Mathematics Computational Laboratory (HMCL)

</div>

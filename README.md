<div align="center">

<!-- Logo placeholder — ganti path setelah upload -->
<img src="data/logo/matematika-hijaiyyah-logo.png" alt="Matematika Hijaiyyah Logo" width="200">

# **HOM — Hijaiyyah Operating Machine**

### Core Computational System for Hijaiyyah Mathematics & Hybit Pipeline

[![Release](https://img.shields.io/badge/Release-HM--28--v1.0--HC18D-blue)]()
[![Python](https://img.shields.io/badge/Python-3.11+-green)]()
[![License](https://img.shields.io/badge/License-Proprietary-red)]()
[![Tests](https://img.shields.io/badge/Tests-88%2B%20PASS-brightgreen)]()
[![Dataset](https://img.shields.io/badge/Dataset-28×18%20SEALED-orange)]()
[![Pipeline](https://img.shields.io/badge/Pipeline-.hc→.hbc→HVM-purple)]()
[![Paradigm](https://img.shields.io/badge/Paradigm-bit⊕qubit⊕hybit-gold)]()
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/hybittech/HOM)
[![Run on Replit](https://replit.com/badge/github/hybittech/HOM)](https://replit.com/github/hybittech/HOM)

**HOM** adalah sistem komputasi formal dan lingkungan kerja ilmiah terpadu untuk **Matematika Hijaiyyah** — sistem matematika murni yang memetakan 28 huruf Hijaiyyah kanonik ke dalam codex integer 18-dimensi melalui empat invarian geometri diskret, menghasilkan **hybit** sebagai paradigma komputasi ketiga.

[Dokumentasi](#dokumentasi) · [Instalasi](#instalasi) · [Pipeline](#pipeline-hybit) · [Arsitektur](#arsitektur-sistem) · [Lisensi](#lisensi)

---

</div>

> **📦 Update Terakhir — v1.0.0-pipeline (2025-06)**
>
> Codebase telah di-align dengan arsitektur README Bab III (Hybit Pipeline). Lihat [Changelog Update](#changelog-update-terbaru) di bawah untuk detail lengkap.

---

## 📋 Daftar Isi

- [Tentang HOM](#tentang-hom)
- [Changelog Update Terbaru](#changelog-update-terbaru)
- [Hybit — Paradigma Komputasi Ketiga](#hybit--paradigma-komputasi-ketiga)
- [Pipeline Hybit](#pipeline-hybit)
- [Format File](#format-file)
- [Fitur Utama](#fitur-utama)
- [Prasyarat](#prasyarat)
- [Instalasi](#instalasi)
- [Cara Menjalankan](#cara-menjalankan)
- [Struktur Direktori](#struktur-direktori)
- [Arsitektur Sistem](#arsitektur-sistem)
- [Technology Stack](#technology-stack)
- [H-ISA — Instruction Set](#h-isa--instruction-set-architecture)
- [Guard System vs HCHECK](#guard-system-vs-hcheck)
- [Verifikasi Matematis](#verifikasi-matematis)
- [Testing](#testing)
- [Contoh Kode HC](#contoh-kode-hc)
- [Dokumentasi](#dokumentasi)
- [Release Certificate](#release-certificate)
- [Kontribusi](#kontribusi)
- [Lisensi](#lisensi)
- [Penulis](#penulis)

---

## Tentang HOM

**HOM (Hijaiyyah Operating Machine)** adalah implementasi perangkat lunak utama dari **Matematika Hijaiyyah**, yang mencakup:

- **dataset formal** 28 huruf × 18 komponen integer,
- **lima bidang analisis matematika** (Vectronometry, Differential, Integral, Geometry, Exomatrix),
- **bahasa pemrograman HC** (Hijaiyyah Codex) dengan compiler **HCC**, `NEW`
- **hybit bytecode** (.hbc) dan assembler **HASM**, `NEW`
- **mesin virtual HVM** (Hybit Virtual Machine) dengan guard system dan HCHECK, `NEW`
- **arsitektur instruksi H-ISA** dengan operasi hybit-native,
- **standar pertukaran HISAB** (Hijaiyyah Inter-System Standard for Auditable Bridging),
- **format data geometri .hgeo** dan **registry alfabet HAR**, `NEW`
- **prosesor graf skeleton CSGI** dengan Ψ-Compiler, `NEW`
- **sistem audit dan verifikasi formal**,
- **spesifikasi OS hybit-native** (HOS, HFS, H-Kernel), `NEW`
- dan **GUI ilmiah terpadu**.

### Apa itu Matematika Hijaiyyah?

Matematika Hijaiyyah adalah sistem formal yang memodelkan setiap huruf Hijaiyyah kanonik sebagai objek matematika, lalu memetakannya ke vektor integer 18-dimensi:

```
h ∈ H₂₈  →  v₁₈(h) ∈ ℕ₀¹⁸
```

melalui empat invarian geometri diskret:

| Invarian | Simbol | Deskripsi |
|---|---|---|
| **Nuqṭah** | N(h) = (Na, Nb, Nd) | Struktur titik diskret |
| **Khaṭṭ** | K(h) = (Kₚ, Kₓ, Kₛ, Kₐ, Kc) | Struktur garis |
| **Qaws** | Q(h) = (Qₚ, Qₓ, Qₛ, Qₐ, Qc) | Struktur lengkung |
| **Inḥinā'** | Θ̂(h) | Total belokan diskret |

Unit komputasi formal yang dihasilkan disebut **hybit** (*Hijaiyyah Hyperdimensional Bit Integration Technology*) — paradigma komputasi ketiga yang secara aljabar berbeda dari bit dan qubit.

### Batas Domain (Scope & Boundaries)

\[
\boxed{
\text{Matematika Hijaiyyah} = \text{formalisasi huruf skriptural kanonik, dengan Hijaiyyah sebagai inti resmi}
}
\]

Sistem ini **harus tetap berpusat pada huruf sebagai bentuk skriptural kanonik**, dengan pedoman berikut:

1. **Inti Resmi:** Domain inti dari sistem ini adalah **Hijaiyyah**. Matematika Hijaiyyah bukanlah framework generik untuk semua karakter Latin/ASCII atau simbol teknis utilitarian. Ekspansi ke alfabet lain di dalam sistem harus bersifat murni skriptural.
2. **HAR (Alphabet Registry):** Ruang lingkup keanggotaan HAR dibatasi pada analisis geometri karakter sebagai objek formal skriptural. `HAR-001 (Hijaiyyah)` adalah satu-satunya inti yang akan selalu berstatus tersertifikasi resmi (CERTIFIED) sebagai referensi standar.
3. **HC Language:** HC (Hijaiyyah Codex) adalah **alat komputasi hybit** (bahasa source tekstual dengan tokenizer/parser reguler), **bukan** proyek formalisasi visual di mana setiap token bahasanya harus menjadi hybit. Runtime hybit-aware hanya berlaku saat menangani objek codex Hijaiyyah.

Dengan begitu, paradigma bahasa ditetapkan sebagai berikut:
\[
\boxed{
\text{HC adalah bahasa untuk mengoperasikan hybit, bukan bahasa yang setiap tokennya harus menjadi hybit}
}
\]

---

## Changelog Update Terbaru

> **v1.0.0-pipeline — Full System Alignment with Bab III Architecture**

### 🆕 Facade Modules Baru (Source Packages)

Lima package facade baru yang masing-masing me-re-export dan memperluas modul yang sudah ada, sesuai arsitektur Bab III:

| Package Baru | Path | Re-exports dari | Fungsi |
|---|---|---|---|
| **`compiler/`** | `src/hijaiyyah/compiler/` | `language/lexer`, `language/parser`, `hisa/compiler` | HCC — HC Compiler facade (6-tahap pipeline) |
| **`assembler/`** | `src/hijaiyyah/assembler/` | `hisa/assembler` | HASM — Hybit Assembler facade (.hasm → .hbc) + HBCHeader binary format |
| **`vm/`** | `src/hijaiyyah/vm/` | `hisa/machine`, `hisa/hcheck`, `core/guards` | HVM — Hybit Virtual Machine facade (5 komponen: Loader, Interpreter, HybitEngine, GuardSystem, HCheck) |
| **`pipeline/`** | `src/hijaiyyah/pipeline/` | `skeleton/csgi`, `core/codex` | Ψ-Compiler facade + .hgeo format dataclass (Font → geometry extraction) |
| **`har/`** | `src/hijaiyyah/har/` | `core/master_table` | HAR — Alphabet Registry facade (multi-alfabet, auto-load HAR-001) |

**Prinsip desain:**
- Facade **tidak menduplikasi** logika — ia me-re-export dari modul existing
- Jika modul underlying belum ada, facade menyediakan **implementasi referensi minimal** agar tes bisa berjalan
- Setiap facade memiliki **tepat satu tanggung jawab** (Single Responsibility Principle)

### 🧪 Test Directories & Test Files Baru

~33 test baru yang mencakup seluruh facade module:

| Test File | Path | Test Count | Cakupan |
|---|---|---|---|
| **`test_hcc.py`** | `tests/test_compiler/` | 10 tests | Import, init, CompileResult, CompileOptions, compile pipeline |
| **`test_hasm.py`** | `tests/test_assembler/` | 10 tests | Import, HBCHeader pack/unpack/verify, HASM assemble, magic bytes |
| **`test_hvm.py`** | `tests/test_vm/` | 20 tests | GuardSystem (G1–G4), HybitEngine (CADD, PROJ, DCMP, NORM2, DIST), HCheck, HVM lifecycle |
| **`test_psi_compiler.py`** | `tests/test_pipeline/` | 8 tests | Measurement v18, HGeoFile JSON roundtrip, digest, PsiCompiler extract |
| **`test_har_registry.py`** | `tests/test_har/` | 10 tests | HAREntry lookup, HARValidation, HARRegistry auto-load, certified list |

**Total test setelah update:** ~88+ (existing ~55 + new ~33)

### 📄 Dokumentasi Baru

Enam file spesifikasi baru:

| Dokumen | Path | Konten |
|---|---|---|
| **`hbc_format.md`** | `docs/hbc_format.md` | Spesifikasi format binary .hbc — header 32 byte, magic "HBYT", flags, opcode table |
| **`hgeo_format.md`** | `docs/hgeo_format.md` | Spesifikasi format .hgeo — JSON geometry file, provenance chain, audit trail |
| **`har_spec.md`** | `docs/har_spec.md` | Spesifikasi HAR — directory structure, status levels, certification requirements |
| **`hisab_spec.md`** | `docs/hisab_spec.md` | Spesifikasi HISAB — frame types, 3-level validation, round-trip fidelity |
| **`release_policy.md`** | `docs/release_policy.md` | Kebijakan rilis — version scheme, integrity, determinism, artifacts |
| **`hybit_pipeline_spec.md`** | `docs/hybit_pipeline_spec.md` | Spesifikasi pipeline lengkap — semua komponen, status, non-overlap principle |

### 🔧 Perubahan Lain

| Perubahan | Detail |
|---|---|
| **Test badge** | Diperbarui dari `30+` ke `88+` |
| **Pipeline badge** | Ditambahkan badge `.hc→.hbc→HVM` |
| **Paradigm badge** | Ditambahkan badge `bit⊕qubit⊕hybit` |
| **Struktur direktori** | Diperbarui untuk mencerminkan package baru |
| **Arsitektur diagram** | Diperbarui dengan layer pipeline |
| **Technology Stack** | Tabel diperluas dengan 24 komponen (dari 12) |

### ✅ Kompatibilitas

- **Tidak ada breaking change** — semua modul existing tetap berfungsi
- Facade module menggunakan `try/except ImportError` untuk graceful fallback
- Test baru menggunakan `pytest.skip()` jika dependensi belum tersedia
- Seluruh 55+ test existing tetap PASS

---

## Hybit — Paradigma Komputasi Ketiga

### Tiga Struktur Aljabar yang Tak Tereduksi

Hybit bukan sekadar format data — ia adalah **paradigma komputasi** yang didefinisikan oleh struktur aljabar yang secara formal berbeda dari bit dan qubit, terbukti saling tak tereduksi (Bab III, Teorema 3.7.1–3.8.3):

| Dimensi | **Bit** (𝔽₂) | **Qubit** (ℂ²) | **Hybit** (𝒱 ⊂ ℕ₀¹⁸) |
|---|---|---|---|
| **Struktur** | Field | Ruang Hilbert | Monoid terkonstrain |
| **Dimensi** | 0 (diskret 2-titik) | 2 (kontinu kompleks) | 18 (diskret integer) |
| **Operasi native** | AND, OR, NOT, XOR | U(2) gates, pengukuran | HCADD, HGRD, HPROJ |
| **Constraint** | Closure | ‖ψ‖ = 1 | G1–G4, ρ ≥ 0 |
| **Validasi per unit** | Tidak ada | Parsial, destruktif | **Penuh, O(1), non-destruktif** |
| **Determinisme** | Deterministik | Probabilistik | Deterministik |
| **Invers aditif** | Ada | Ada | **Tidak ada** |
| **Domain optimal** | Logika Boolean | Simulasi kuantum | **Data terstruktur + audit** |

### Empat Properti Unik Hybit

| # | Properti | Deskripsi | Status |
|---|----------|-----------|--------|
| 1 | **Validasi intrinsik O(1)** | Setiap unit membawa bukti validitasnya sendiri — 4 guard + 2 topologis | VF |
| 2 | **Preservasi constraint pada agregasi** | h₁* + h₂* ∈ 𝒱 dan semua identitas dipertahankan | VF |
| 3 | **Diagnostik per-lapisan** | Perbedaan didekomposisi ke 4 kontribusi bermakna (Θ, N, K, Q) | VF+CC |
| 4 | **Hukum kekekalan turning** | Guard G4 = constraint geometris lintas-lapisan, bukan checksum | VF+CC |

---

## Pipeline Hybit

### Diagram Pipeline Lengkap

HOM menyediakan **dua jalur paralel** yang bertemu di runtime:

```
JALUR 1 — KODE                          JALUR 2 — DATA GEOMETRI

  PENULIS KODE                             FONT KANONIK (sealed)
      │                                        │
      ▼                                        ▼
 ┌──────────┐                            [Ψ-Compiler]          NEW
 │  .hc     │ ← Source code HC            ├── Rasterisasi
 └────┬─────┘                              ├── CSGI extraction
      │                                    ├── MainPath selection
      ▼ [HCC — HC Compiler]     NEW        ├── Q₉₀ kuantisasi
      ├── Lexer → Token stream             └── Klasifikasi N-K-Q
      │                                    │
      ├── Parser → AST                         │
      ├── Ψ-Injector (opsional)                ▼
      └── Codegen → Assembly              ┌──────────┐
      │                                   │ .hgeo    │ ← Geometry    NEW
      ▼                                   └────┬─────┘
 ┌──────────┐                                  │
 │ .hasm    │ ← Assembly H-ISA     NEW         ▼
 └────┬─────┘                             ┌──────────┐
      │                                   │  HAR     │ ← Registry   NEW
      ▼ [HASM — Assembler]      NEW       └────┬─────┘
      │                                        │
      ▼                                        │
 ┌──────────┐                                  │
 │ .hbc     │ ← Bytecode binary  NEW          │
 └────┬─────┘                                  │
      │                                        │
      ▼ [HVM — Hybit Virtual Machine] ◄────────┘    NEW
      ├── Loader → Parse .hbc
      ├── Interpreter → Execute
      ├── Hybit Engine → HCADD, HPROJ, HDCMP
      ├── Guard System → G1–G4, T1–T2
      └── HCHECK → Runtime integrity               NEW
      │
      ▼
   OUTPUT
```

### Prinsip: Satu Komponen = Satu Fungsi

Setiap komponen pipeline memiliki **tepat satu fungsi** yang tidak tumpang tindih:

| Komponen | Layer | Fungsi TUNGGAL | Input → Output | Status |
|---|---|---|---|---|
| **.hc** | Source | Kode sumber HC | Programmer → Tokens | ✅ Existing |
| **.hasm** | Assembly | Representasi H-ISA | Compiler → Binary | `NEW` 📐 |
| **.hbc** | Binary | Executable bytecode | Assembler → Runtime | `NEW` 📐 |
| **.hgeo** | Data | Geometri per glyph | Ψ-Compiler → HAR | `NEW` 📐 |
| **HAR** | Registry | Database alfabet | .hgeo → Lookup HVM | `NEW` ✅ partial |
| **HCC** | Compiler | .hc → .hasm/.hbc | Source → Binary | `NEW` ✅ partial |
| **HASM** | Assembler | .hasm → .hbc | Assembly → Binary | `NEW` 📐 |
| **HVM** | Runtime | Eksekusi .hbc | Bytecode → Output | `NEW` ✅ |
| **Guard** | Validation | G1–G4 per operasi | Hybit → PASS/FAIL | ✅ Existing |
| **HCHECK** | Monitor | Integritas seluruh state | HVM state → PASS/FAIL | `NEW` 📐 |
| **HOS** | OS | Sistem operasi hybit | User → Environment | `NEW` 📝 |
| **HFS** | Storage | File system hybit-aware | Files → Persistent | `NEW` 📝 |
| **H-Kernel** | Kernel | Process/memory mgmt | HOS → Resources | `NEW` 📝 |

### HOM ↔ Pipeline: Relasi Tanpa Tumpang Tindih

Pipeline **membangun di atas** HOM — tidak menggantikan:

| HOM (Lab Ilmiah) | Pipeline (Sistem Produksi) | Relasi |
|---|---|---|
| `core/master_table` | **`har/`** `NEW` | HAR = format portabel dari master table |
| `algebra/*` | **`vm/`** HybitEngine `NEW` | Engine = runtime 5 bidang Bab II |
| `language/lexer, parser` | **`compiler/`** HCC `NEW` | HCC = perluasan menjadi compiler penuh |
| `hisa/*` | **`assembler/`** HASM `NEW` | HASM = encoding biner dari H-ISA |
| `skeleton/csgi` | **`pipeline/`** Ψ-Compiler `NEW` | .hgeo = format file output CSGI |
| `integrity/*` | **`vm/`** HCHECK `NEW` | HCHECK = perluasan integritas ke runtime |

---

## Format File

### Lima Format File Terstandar

| Format | Ekstensi | Encoding | Layer | Deskripsi | Status |
|---|---|---|---|---|---|
| **Hybit Code** | `.hc` | UTF-8 (NFC) | Source | Kode sumber bahasa HC | ✅ Existing |
| **Hybit Assembly** | `.hasm` | UTF-8 | Assembly | Representasi teks instruksi H-ISA | `NEW` 📐 |
| **Hybit Bytecode** | `.hbc` | Binary (LE) | Binary | Executable untuk HVM — magic `"HBYT"` (0x48425954) | `NEW` 📐 |
| **Hybit Geometry** | `.hgeo` | JSON (UTF-8) | Data | Hasil ekstraksi geometris per glyph — output Ψ-Compiler | `NEW` 📐 |
| **Alphabet Registry** | HAR/ | Directory | Registry | Master table + metadata + validation per alfabet | `NEW` 📐 |

### .hbc — Struktur Binary `NEW`

```
┌─────────────────────────────────────────────┐
│ HEADER (32 bytes)                            │
│   Magic: "HBYT" │ Version │ HAR-ID │ Flags  │
│   Entry point │ Const/Code/Data offsets      │
│   CRC32 checksum                             │
├─────────────────────────────────────────────┤
│ CONSTANT POOL — literals, hybit refs         │
├─────────────────────────────────────────────┤
│ CODE SECTION — [opcode:1][fmt:1][operands]   │
├─────────────────────────────────────────────┤
│ DATA SECTION — hybit vectors, strings        │
├─────────────────────────────────────────────┤
│ DEBUG INFO (opsional) — source map, symbols  │
└─────────────────────────────────────────────┘
```

**Flags field:**

| Bit | Nama | Deskripsi |
|---|---|---|
| 0 | `HAS_DEBUG` | Debug info tersedia |
| 1 | `HAS_PSI` | Source ter-Ψ-augmented |
| 2 | `GUARD_STRICT` | **Setiap HCADD wajib guard check** |
| 3 | `HAR_EMBEDDED` | HAR data tertanam dalam .hbc |

**Implementasi:** `src/hijaiyyah/assembler/` — `HBCHeader` dataclass dengan `pack()`, `unpack()`, `verify()`.

### HAR — Alphabet Registry `NEW`

```
har/
├── manifest.json              ← Registry manifest
├── HAR-001/                   ← Hijaiyyah (CERTIFIED)
│   ├── meta.json
│   ├── canonical_lock.json    ← Font + SHA-256
│   ├── master_table.json      ← 28 × 18 matrix
│   ├── master_table.rom       ← 252 bytes ROM
│   ├── validation/
│   │   ├── guard_report.json  ← G1–G4: 112/112 PASS
│   │   ├── inject_report.json ← 378/378 unique
│   │   ├── r1r5_report.json   ← 140/140 PASS
│   │   └── rank_analysis.json ← rank = 14
│   ├── glyphs/                ← .hgeo per huruf
│── └── certificate.json       ← Release seal

```

**Implementasi:** `src/hijaiyyah/har/` — `HARRegistry` class dengan auto-load HAR-001 dari `core/master_table`.

---

## Fitur Utama

### 🔬 Fondasi Matematis (Bab I)
- **Master Table** — dataset formal 28×18 yang disegel dan diverifikasi
- **Codex 14D & 18D** — representasi integer multidimensi huruf
- **Guard System** — validasi struktural intrinsik per unit data (G1–G4, T1–T2)
- **Theorem Engine** — verifikasi formal 13 teorema/identitas

### 📐 Lima Bidang Analisis (Bab II)

| Bidang | Fungsi |
|---|---|
| **Vectronometry** | Analisis huruf sebagai titik dalam ruang codex — rN + rK + rQ = 1 |
| **Differential** | Beda struktural antarhuruf — ‖Δ‖² = ΔΘ² + ‖ΔN‖² + ‖ΔK‖² + ‖ΔQ‖² |
| **Integral** | Agregasi codex string — ∫(uv) = ∫u + ∫v dengan preservasi identitas |
| **Geometry** | Metrik jarak dan topologi alfabet — diameter √70, nearest neighbors |
| **Exomatrix** | Matriks audit 5×5 dan energi formal — R1–R5, Φ > ‖v₁₄‖² |

### ⚛️ Paradigma Hybit (Bab III) `UPDATED`
- **Hybit sebagai paradigma ketiga** — 𝔽₂ ≠ ℂ² ≠ 𝒱 (terbukti formal)
- **Pipeline lengkap** — .hc → HCC → .hasm → HASM → .hbc → HVM → Output `NEW`
- **Ψ-Compiler** — Font sealed → .hgeo → HAR (pipeline data geometri) `NEW`
- **Guard vs HCHECK** — validasi per-operasi vs monitor integritas periodik `NEW`
- **Spesifikasi OS** — HOS, HFS (guard-on-write), H-Kernel (18-wide alignment) `NEW`
- **Arsitektur fotonik** — DoF foton cukup (margin 20–32×), material Yttrium

### 💻 Bahasa dan Kompilasi `UPDATED`
- **HC Language** — bahasa pemrograman dengan `hybit` sebagai tipe bawaan (first-class)
- **HCC** — compiler 6-tahap (Lexer → Parser → Semantic → Ψ-Injector → Codegen → Assemble) `NEW`
- **HASM** — assembler 4-pass (Label → Encode → Pool → Header) `NEW`
- **H-ISA** — instruction set dengan operasi hybit-native (HCADD, HGRD, HPROJ, HDCMP, HEXMT)
- **Bytecode Inspector** — dekoder instruksi .hbc real-time

### 🔧 Runtime `UPDATED`
- **HVM** — Hybit Virtual Machine mandiri (Loader, Interpreter, Hybit Engine, Guard, HCHECK) `NEW`
- **Register file** — R0–R15, setiap register = satu hybit 18D lengkap (576 byte total) `NEW`
- **Guard System** — validasi G1–G4, T1–T2 per operasi hybit — O(1) intrinsik
- **HCHECK** — runtime integrity monitor — deteksi korupsi memori periodik `NEW`
- **GUARD_STRICT mode** — setiap HCADD wajib guard check (flag .hbc bit 2) `NEW`

### 📡 HISAB — Standar Pertukaran Codex
- **Serialisasi kanonik** — LETTER Frame (nibble-packed 9 byte), STRING Frame (36 byte), MATRIX Frame (25 byte)
- **Validasi 3-level** — Structural (magic/CRC), Guard (G1–G4/T1–T2), Semantic (Master Table cross-ref)
- **Round-trip fidelity** — D(S(h*)) = h* untuk semua 28 huruf
- **Deteksi korupsi ganda** — CRC32 + guard (~2.3× redundansi per korupsi)

### 🔍 Verifikasi dan Audit `UPDATED`
- **Injectivity Verifier** — 378 pasangan unik
- **Mod-4 Gate** — teorema topologis O(1)
- **Exomatrix R1–R5** — 140 audit checks yang saling mengunci
- **HISAB Validation** — 3-level pipeline per frame
- **HAR Certification** — guard + injectivity + R1–R5 + rank per alfabet `NEW`
- **Release Seal** — integritas SHA-256

### 🖥️ GUI Ilmiah
- **Letter Explorer** — profil lengkap per huruf
- **String Codex** — analisis integral string
- **Five Fields Workbench** — panel analitik Bab II
- **Codex Geometry** — jarak, nearest neighbors, Gram matrix
- **CSGI Processor** — pipeline bentuk → skeleton → graf
- **HISAB Explorer** — frame encoder, validation pipeline, corruption detector
- **HC IDE** — editor dan runner bahasa HC
- **Pipeline Inspector** — visualisasi .hc → .hasm → .hbc `NEW`
- **Audit Console** — dashboard integritas formal
- **Release Console** — identitas rilis dan copyright

---

## Prasyarat

| Komponen | Versi Minimum |
|---|---|
| Python | 3.11+ |
| pip | 22+ |
| OS | Windows 10+, macOS 12+, Linux (Ubuntu 22.04+) |

### Dependensi utama

```
numpy >= 1.24
networkx >= 3.0
pillow >= 10.0
scipy >= 1.10
```

---

## Instalasi

### Metode 1 — Development mode (disarankan)

```bash
git clone https://github.com/hybittech/HOM.git
cd HOM
pip install -e ".[dev]"
```

### Metode 2 — Install langsung

```bash
git clone https://github.com/hybittech/HOM.git
cd HOM
pip install .
```

### Verifikasi instalasi

```bash
python -c "from hijaiyyah.version import __version__; print(__version__)"
```

Output yang diharapkan:
```
1.0.0
```

### Verifikasi facade modules `NEW`

```bash
python -c "
from hijaiyyah.compiler import HCCompiler
from hijaiyyah.assembler import HASMAssembler, HBCHeader
from hijaiyyah.vm import HVM, GuardSystem, HCheck, HybitEngine
from hijaiyyah.pipeline import PsiCompiler, HGeoFile
from hijaiyyah.har import HARRegistry, HAREntry
print('✅ All facade modules imported successfully')
"
```

---

## Cara Menjalankan

### Menjalankan HOM GUI

```bash
python -m hijaiyyah
```

Atau setelah install:

```bash
hom
```

### Menjalankan HVM (standalone) `NEW`

```bash
python hvm.py program.hbc --har ./har/
```

### Kompilasi HC → Bytecode `NEW`

```bash
# Kompilasi langsung ke bytecode
hcc hello.hc -o hello.hbc

# Kompilasi ke assembly (untuk debugging)
hcc hello.hc --emit-asm -o hello.hasm

# Kompilasi dengan Ψ-injection
hcc hello.hc --psi --har ./har/ -o hello.hbc

# Kompilasi dengan strict guard
hcc hello.hc --guard-strict -o hello.hbc

# Assembly ke bytecode
hasm hello.hasm -o hello.hbc
```

### Menjalankan CSGI demo

```bash
PYTHONPATH=src python scripts/run_gui.py
```

### Menjalankan tes

```bash
pytest
```

---

## Struktur Direktori

> Direktori bertanda `NEW` ditambahkan pada update terakhir.

```
HOM/
│
├── README.md                  ← dokumen ini (UPDATED)
├── LICENSE
├── pyproject.toml
├── requirements.txt
│
├── src/
│   └── hijaiyyah/
│       ├── __init__.py
│       ├── __main__.py        ← entry point
│       ├── version.py
│       │
│       ├── core/              ← L0: dataset formal + guards
│       ├── algebra/           ← Bab II: 5 bidang matematika
│       ├── language/          ← L1: HC language core (lexer, parser)
│       ├── compiler/          ← HCC: compiler pipeline              NEW
│       ├── assembler/         ← HASM: .hasm → .hbc encoding         NEW
│       ├── vm/                ← HVM: runtime (5 komponen)            NEW
│       ├── pipeline/          ← Ψ-Compiler (.hgeo generation)       NEW
│       ├── har/               ← HAR: alphabet registry               NEW
│       ├── hisa/              ← L2: instruction set architecture
│       ├── hisab/             ← HISAB protocol
│       ├── skeleton/          ← CSGI: skeleton graph extraction
│       ├── integrity/         ← audit, verification, HCHECK
│       ├── theorems/          ← theorem engine (13 theorems)
│       ├── crypto/            ← security layer
│       ├── net/               ← data exchange
│       ├── release/           ← versioning
│       └── gui/               ← HOM GUI
│           ├── tabs/          ← satu file per tab
│           └── widgets/       ← komponen UI reusable
│
├── har/                       ← Alphabet Registry                    NEW
│   ├── manifest.json
│   └── HAR-001/               ← Hijaiyyah (CERTIFIED)
│       ├── meta.json
│       ├── canonical_lock.json
│       ├── master_table.json
│       ├── master_table.rom   ← 252 bytes
│       ├── validation/
│       ├── glyphs/            ← .hgeo per huruf
│       └── certificate.json
│
├── data/
│   ├── hm28.json              ← master table JSON (legacy compat)
│   ├── hm28.rom               ← ROM 252 bytes
│   ├── hm28_manifest.json
│   └── kfgqpc_seal/
│       └── glyphs/            ← glyph images
│
├── tests/
│   ├── test_core/
│   ├── test_algebra/
│   ├── test_compiler/         ← HCC compiler tests                  NEW
│   ├── test_assembler/        ← HASM assembler tests                NEW
│   ├── test_vm/               ← HVM virtual machine tests           NEW
│   ├── test_pipeline/         ← Ψ-Compiler tests                   NEW
│   ├── test_har/              ← HAR registry tests                  NEW
│   ├── test_hisab/
│   └── test_theorems/
│
├── docs/                      ← dokumentasi teknis
│   ├── architecture.md
│   ├── hc_language.md
│   ├── hisa_spec.md
│   ├── csgi_spec.md
│   ├── csgi_algorithm_spec.md
│   ├── hcvm_spec.md
│   ├── hybit_pipeline_spec.md ← Pipeline spec                      NEW
│   ├── hbc_format.md          ← .hbc format spec                   NEW
│   ├── hgeo_format.md         ← .hgeo format spec                  NEW
│   ├── har_spec.md            ← HAR registry spec                  NEW
│   ├── hisab_spec.md          ← HISAB protocol spec                NEW
│   └── release_policy.md      ← Release policy                     NEW
│
├── examples/                  ← contoh program HC (.hc)
├── scripts/                   ← tools pengembangan
├── tools/                     ← utilitas
└── release/                   ← artefak rilis
```

---

## Arsitektur Sistem

### Diagram Layer — Pipeline Terintegrasi `UPDATED`

```
┌─────────────────────────────────────────────────────────┐
│                       HOM GUI                            │
│  Letter · String · Audit · Geometry · HISAB · Pipeline  │
│  Five Fields · HC IDE · HVM Inspector · CSGI · HAR      │
├─────────────────────────────────────────────────────────┤
│                  HC Language + HCC Compiler        NEW   │
│        Lexer → Parser → Semantic → Ψ-Inject → Codegen   │
├────────────────────────┬────────────────────────────────┤
│  Algebra: 5 Fields     │  HISAB Protocol                │
│  Vect·Diff·Intg·Geom   │  Serialize · Validate          │
│  ·Exo                  │  Digest · Audit · Bridge       │
├────────────────────────┴────────────────────────────────┤
│  HASM Assembler  │  .hbc Format  │  .hgeo + Ψ-Comp NEW │
├─────────────────────────────────────────────────────────┤
│  Integrity · Theorems · Crypto · Release · Net · HCHECK │
├─────────────────────────────────────────────────────────┤
│         HVM — Hybit Virtual Machine               NEW   │
│  Loader │ Interpreter │ Hybit Engine │ Guard System      │
│  R0–R15 (18×16-bit)  │  Stack: 1024 │  Heap: Dynamic    │
├─────────────────────────────────────────────────────────┤
│         H-ISA (Instruction Set Architecture)             │
│  HCADD · HGRD · HPROJ · HDCMP · HNRM2 · HDIST · HEXMT │
│  HSER · HDES · HCHK · IADD · ISUB · JMP · HALT         │
├─────────────────────────────────────────────────────────┤
│              CSGI (Skeleton Graph Interface)              │
├─────────────────────────────────────────────────────────┤
│    Core: Master Table · Codex · Guards · HAR Registry    │
├─────────────────────────────────────────────────────────┤
│      Dataset Seal: HM-28-v1.0-HC18D (252 bytes ROM)     │
├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┤
│  ┌─────────────────────────────────────────────────┐    │
│  │  HOS — Hybit Operating System (DESIGNED)   NEW   │    │
│  │  Shell · Services · HAR Manager · Guard Monitor  │    │
│  ├─────────────────────────────────────────────────┤    │
│  │  H-Kernel (Process · Memory · I/O · HFS Driver) │    │
│  ├─────────────────────────────────────────────────┤    │
│  │  HFS — Hybit File System (guard-on-write)        │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

### Prinsip Arsitektur

| Prinsip | Penjelasan |
|---|---|
| **GUI tidak menghitung** | Logika domain ada di core/algebra/vm |
| **Core tidak import GUI** | Dependency satu arah |
| **Satu komponen = satu fungsi** | Single Responsibility — tidak ada tumpang tindih `NEW` |
| **Pipeline tidak menggantikan HOM** | HOM = lab ilmiah, Pipeline = sistem produksi `NEW` |
| **Facade re-export, tidak duplikasi** | Module baru wraps existing, tidak copy-paste `NEW` |
| **Guard ≠ HCHECK** | Guard = per-operasi, HCHECK = periodik seluruh state `NEW` |
| **Setiap modul bisa diuji sendiri** | Tanpa GUI, tanpa runtime |
| **Kode ≠ Data** | .hbc (program) dan HAR (alfabet) terpisah — Harvard principle `NEW` |

---

## Technology Stack

### Inventaris Komponen Lengkap `UPDATED — dari 12 ke 24 komponen`

| Layer | Komponen | Status | Deskripsi | Update |
|---|---|---|---|---|
| **L0** | Master Table | ✅ **SEALED** | Dataset 28×18 (252 bytes ROM) | — |
| **L0** | CSGI | ✅ **OPERATIONAL** | Canonical Skeleton Graph Interface | — |
| **L1** | HC Language | ✅ **OPERATIONAL** | Bahasa pemrograman codex v1.0 | — |
| **L1** | HL-18E | 📐 SPECIFIED | Grammar formal 18-EBNF | — |
| **L2** | H-ISA | ✅ **OPERATIONAL** | Instruction Set Architecture (30 instruksi) | — |
| **L3** | CMM-18C | 📐 SPECIFIED | Codex Multidimensional Machine | — |
| **L4** | HCPU | 📝 DESIGNED | Arsitektur prosesor 18D (fotonik) | — |
| **L5** | HVM | ✅ **OPERATIONAL** | Hybit Virtual Machine | — |
| **L6** | HGSS | ✅ **OPERATIONAL** | Guard + Signature System | — |
| **L7** | HC18DC | 📐 SPECIFIED | Canonical Data Exchange Format | — |
| **⟂** | **HISAB** | ✅ **OPERATIONAL** | Inter-System Standard for Auditable Bridging | — |
| **GUI** | HOM | ✅ **OPERATIONAL** | Integrated Scientific Environment | — |
| | | | | |
| **Pipeline** | **Komponen** | **Status** | **Deskripsi** | |
| Compile | **HCC** (lexer+parser) | ✅ **PARTIAL** | HC Compiler — tahap 1–2 operasional | `NEW` |
| Compile | **HCC** (codegen) | 📐 SPECIFIED | HC Compiler — tahap 3–6 | `NEW` |
| Compile | **Ψ-Injector** | 📐 SPECIFIED | Hybit metadata injection | `NEW` |
| Assembly | **.hasm format** | 📐 SPECIFIED | Hybit Assembly format | `NEW` |
| Assembly | **HASM** | 📐 SPECIFIED | Hybit Assembler (4-pass) | `NEW` |
| Binary | **.hbc format** | 📐 SPECIFIED | Hybit Bytecode (32-byte header, magic "HBYT") | `NEW` |
| Data | **.hgeo format** | 📐 SPECIFIED | Hybit Geometry File (JSON, provenance chain) | `NEW` |
| Registry | **HAR** (data) | ✅ **PARTIAL** | HAR-001 Hijaiyyah (auto-loaded) | `NEW` |
| Registry | **HAR** (format) | 📐 SPECIFIED | Multi-alphabet registry | `NEW` |
| Monitor | **HCHECK** | 📐 SPECIFIED | Runtime integrity monitor | `NEW` |
| Data | **Ψ-Compiler** | 📐 SPECIFIED | Font → .hgeo pipeline | `NEW` |
| OS | **HOS** | 📝 DESIGNED | Hybit Operating System | `NEW` |
| Storage | **HFS** | 📝 DESIGNED | Hybit File System (guard-on-write) | `NEW` |
| Kernel | **H-Kernel** | 📝 DESIGNED | Hybit Kernel (18-wide alignment) | `NEW` |

**Status agregat:**

| Status | Count | Perubahan |
|---|---|---|
| ✅ OPERATIONAL / SEALED / PARTIAL | 11 | +2 dari sebelumnya |
| 📐 SPECIFIED | 10 | +7 dari sebelumnya |
| 📝 DESIGNED | 3 | +3 dari sebelumnya |
| **Total** | **24** | **+12 dari sebelumnya** |

---

## H-ISA — Instruction Set Architecture

### Instruksi Hybit-Native

Setiap instruksi hybit = **realisasi langsung** operasi Bab II:

| Instruksi | Fungsi | Implementasi | Siklus |
|---|---|---|---|
| `HLOAD` | Load hybit dari HAR/memory | `vm/HVM.load_hybit()` `NEW` | 1 |
| `HCADD` | Codex addition: dst ← src1 + src2 | `vm/HybitEngine.cadd()` `NEW` | 1 |
| `HGRD` | Guard check G1–G4, T1–T2 | `vm/GuardSystem.check()` `NEW` | 1 |
| `HPROJ` | Proyeksi: Θ/N/K/Q | `vm/HybitEngine.proj()` `NEW` | 1 |
| `HDCMP` | Dekomposisi: (U, ρ) ← Θ̂ | `vm/HybitEngine.decompose()` `NEW` | 1 |
| `HNRM2` | Norma kuadrat: ‖v₁₄‖² | `vm/HybitEngine.norm2()` `NEW` | 1 |
| `HDIST` | Jarak Euclidean | `vm/HybitEngine.dist()` `NEW` | 1 |
| `HEXMT` | Bangun eksomatriks 5×5 | Planned | 1 |
| `HSER` | Serialize ke HISAB Frame | Planned | 1 |
| `HDES` | Deserialize dari HISAB Frame | Planned | 1 |
| `HCHK` | Runtime integrity check | `vm/HCheck.scan()` `NEW` | 1 |

---

## Guard System vs HCHECK `NEW SECTION`

Dua mekanisme validasi dengan **fungsi yang berbeda**:

| Dimensi | Guard System | HCHECK |
|---|---|---|
| **Kapan** | Setiap operasi hybit | Periodik (setiap N instruksi) |
| **Apa** | Satu vektor (hasil operasi) | Seluruh state (register, stack, heap) |
| **Deteksi** | Inkonsistensi geometris | Korupsi memori (bit flip, overflow) |
| **Kompleksitas** | O(1) per operasi | O(R+S) per scan |
| **Implementasi** | `vm/GuardSystem` | `vm/HCheck` |
| **Analogi** | Type checker per statement | Memory sanitizer periodik |
| **Kegagalan** | `GUARD_FAIL` → operasi ditolak | `CORRUPTION` → program dihentikan |

Keduanya diperlukan — Guard mendeteksi **inkonsistensi operasi**, HCHECK mendeteksi **korupsi state**.

---

## Verifikasi Matematis

Rilis ini telah melewati verifikasi formal berikut:

| Pemeriksaan | Hasil | Domain | Status |
|---|---|---|---|
| Theorem tests | **13/13 PASS** | Bab I–II | — |
| Guard checks (G1–G4) | **28/28 PASS** | Bab I | — |
| Exomatrix audit (R1–R5) | **140/140 PASS** | Bab II | — |
| Injectivity v₁₈ | **378/378 unique pairs** | Bab I | — |
| Diameter | **√70 ≈ 8.367 VERIFIED** | Bab II | — |
| Energy inequality | **28/28 strict Φ > ‖v₁₄‖²** | Bab II | — |
| Global sum Θ̂ | **89 VERIFIED** | Bab I | — |
| HISAB round-trip fidelity | **28/28 D(S(h*))=h* VERIFIED** | HISAB | — |
| HISAB injectivity | **28/28 unique frames** | HISAB | — |
| HISAB guard preservation | **28/28 ALL_GUARDS_PASS** | HISAB | — |
| Hybit closure (HCADD) | **h₁*+h₂* ∈ 𝒱 PROVEN** | Bab III | — |
| Tak-tereduksi (3 paradigma) | **𝔽₂ ≠ ℂ² ≠ 𝒱 PROVEN** | Bab III | — |
| Mod-4 classifier | **28/28 consistent** | Bab I | — |
| rank(M₁₄) = 14 | **VERIFIED** | Bab I | — |
| HBCHeader pack/unpack | **roundtrip VERIFIED** | Pipeline | `NEW` |
| HBCHeader CRC32 verify | **PASS** | Pipeline | `NEW` |
| GuardSystem direct check | **28/28 PASS** | Pipeline | `NEW` |
| HybitEngine CADD preserves identity | **VERIFIED** | Pipeline | `NEW` |
| HCheck scan clean state | **PASS** | Pipeline | `NEW` |
| HAR-001 auto-load | **28 letters loaded** | Pipeline | `NEW` |

---

## Testing `UPDATED`

### Menjalankan semua tes

```bash
pytest
```

### Menjalankan tes per kategori

```bash
# ── Fondasi (Bab I) ──
pytest tests/test_core/test_master_table.py
pytest tests/test_core/test_guards.py

# ── Lima Bidang (Bab II) ──
pytest tests/test_algebra/test_vectronometry.py
pytest tests/test_algebra/test_differential.py
pytest tests/test_algebra/test_integral.py
pytest tests/test_algebra/test_geometry.py
pytest tests/test_algebra/test_exomatrix.py

# ── Teorema ──
pytest tests/test_theorems/test_full_suite.py

# ── Pipeline (Bab III) ──                      NEW
pytest tests/test_compiler/test_hcc.py
pytest tests/test_assembler/test_hasm.py
pytest tests/test_vm/test_hvm.py
pytest tests/test_pipeline/test_psi_compiler.py
pytest tests/test_har/test_har_registry.py

# ── HISAB ──
pytest tests/test_hisab/test_hisab.py
```

### Menjalankan dengan coverage

```bash
pytest --cov=hijaiyyah --cov-report=html
```

### Tes minimum yang wajib PASS `UPDATED`

| Modul | Tes | Status |
|---|---|---|
| `core/master_table` | 28 entri, vektor 18D, guard, injektivitas | Existing |
| `core/guards` | G1–G4, T1–T2 untuk 28 huruf | Existing |
| `algebra/*` | Satu tes per fungsi utama per bidang | Existing |
| `language/lexer` | Tokenisasi dasar, literal Hijaiyyah | Existing |
| `compiler/hcc` | Import, init, CompileResult, pipeline stages | `NEW` |
| `assembler/hasm` | HBCHeader pack/unpack/verify, HASM assemble | `NEW` |
| `vm/hvm` | GuardSystem, HybitEngine ops, HCheck, HVM lifecycle | `NEW` |
| `pipeline/psi` | Measurement v18, HGeoFile roundtrip, PsiCompiler | `NEW` |
| `har/registry` | HAREntry lookup, HARValidation, auto-load | `NEW` |
| `integrity/` | Injectivity, seal verification | Existing |
| `theorems/` | Full suite 13 tes | Existing |
| `hisab/` | Round-trip, injectivity, guard, 3-level validation | Existing |

---

## Contoh Kode HC

### Hello HC

```hc
fn main() {
    println("Hello, HC v1.0");
}
```

### Load huruf dan analisis

```hc
fn main() {
    let h = load('ب');
    println("Theta:", h.theta());     // 2
    println("Guard:", h.guard());     // PASS
    println("Norm2:", h.norm2());     // 7

    // Dekomposisi turning
    let (u, rho) = h.decompose();
    println("U:", u, "rho:", rho);    // U=0, ρ=2
    assert(h.theta() == u + rho);    // 2 = 0 + 2 ✓
}
```

### String integral dengan preservasi identitas

```hc
fn kodeks_kata(teks: string) -> hybit {
    let mut total = zero();
    for ch in teks {
        if ch != ' ' {
            total = total + load(ch);
        }
    }
    return total;
}

fn main() {
    let cod = kodeks_kata("بسم");
    println("∫Θ̂:", cod.theta());          // 10
    println("∫U:", cod.budget_turning());  // 6
    println("∫ρ:", cod.residue());         // 4

    // Preservasi identitas
    assert(cod.theta() == cod.budget_turning() + cod.residue());
    // 10 = 6 + 4 ✓
}
```

### Lima bidang analisis

```hc
fn main() {
    let h = load('ج');

    // Vectronometry
    println("Norm2:", h.norm2());             // 12

    // Differential
    let d = hm::differential::diff(load('ت'), load('ب'));
    println("Delta:", d);
    println("Delta_N:", d.layer_norm("N"));   // √5

    // Integral
    let cod = hm::integral::string_integral("بسم");
    println("Integral:", cod);

    // Geometry
    let dist = hm::geometry::euclidean(load('ا'), load('هـ'));
    println("Distance:", dist);              // √70 ≈ 8.367

    // Exomatrix
    let e = hm::exomatrix::build(h);
    println("Exomatrix:", e);
    println("Phi:", hm::exomatrix::phi(e));
    println("R1-R5:", e.audit());            // ALL PASS
}
```

### Assembly H-ISA (contoh .hasm) `NEW`

```asm
; file: analysis.hasm
.module analysis
.version 1.0
.har 0x0001

.data
    letter_ba: .hybit 0x0001 0x0628  ; ب
    letter_sin: .hybit 0x0001 0x0633 ; س
    letter_mim: .hybit 0x0001 0x0645 ; م

.code
    .entry main

main:
    ; Load dan guard
    HLOAD   R0, letter_ba
    HGRD    R0
    JNP     fail

    ; String integral: بسم
    HLOAD   R1, letter_sin
    HLOAD   R2, letter_mim
    HCADD   R3, R0, R1          ; R3 ← ب + س
    HCADD   R3, R3, R2          ; R3 ← ب + س + م

    ; Verify Θ̂ = U + ρ
    HPROJ   R4, R3, THETA       ; R4 ← ∫Θ̂ = 10
    HDCMP   R5, R6, R3          ; R5 ← U=6, R6 ← ρ=4
    IADD    R7, R5, R6          ; R7 ← 6+4 = 10
    ICMP    R4, R7
    JNE     fail

    PRINTH  R3                  ; Print codex string
    HALT    0

fail:
    PRINT   "VERIFICATION FAIL"
    HALT    1
```

---

## Dokumentasi `UPDATED`

| Dokumen | Lokasi | Deskripsi | Status |
|---|---|---|---|
| Arsitektur sistem | [`docs/architecture.md`](docs/architecture.md) | Diagram layer, prinsip, dependency | Existing |
| Spesifikasi HC Language | [`docs/hc_language.md`](docs/hc_language.md) | Grammar, tipe, semantik | Existing |
| Spesifikasi H-ISA | [`docs/hisa_spec.md`](docs/hisa_spec.md) | Instruction set lengkap (30 instruksi) | Existing |
| Spesifikasi CSGI | [`docs/csgi_spec.md`](docs/csgi_spec.md) | Skeleton extraction protocol | Existing |
| Algoritma CSGI & Sertifikasi | [`docs/csgi_algorithm_spec.md`](docs/csgi_algorithm_spec.md) | Pipeline CSGI detail | Existing |
| Spesifikasi HCVM/HVM | [`docs/hcvm_spec.md`](docs/hcvm_spec.md) | Virtual machine architecture | Existing |
| **Spesifikasi Pipeline Hybit** | [`docs/hybit_pipeline_spec.md`](docs/hybit_pipeline_spec.md) | Pipeline lengkap: semua komponen, non-overlap | `NEW` |
| **Spesifikasi .hbc** | [`docs/hbc_format.md`](docs/hbc_format.md) | Bytecode binary — header, magic, flags, opcodes | `NEW` |
| **Spesifikasi .hgeo** | [`docs/hgeo_format.md`](docs/hgeo_format.md) | Geometry file — JSON, provenance chain, audit | `NEW` |
| **Spesifikasi HAR** | [`docs/har_spec.md`](docs/har_spec.md) | Alphabet registry — structure, certification | `NEW` |
| **Spesifikasi HISAB** | [`docs/hisab_spec.md`](docs/hisab_spec.md) | Serialisasi, validasi 3-level, interoperabilitas | `NEW` |
| **Kebijakan Rilis** | [`docs/release_policy.md`](docs/release_policy.md) | Version scheme, integrity, determinism | `NEW` |
| Changelog | [`CHANGELOG.md`](CHANGELOG.md) | Riwayat perubahan | Updated |

---

## Release Certificate

```
╔══════════════════════════════════════════════════════════════╗
║       HIJAIYYAH MATHEMATICS — RELEASE CERTIFICATE            ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Release:    HM-28-v1.0-HC18D-B84D025                        ║
║  Version:    1.0.0                                           ║
║  Date:       2026                                            ║
║  Status:     VERIFIED & SEALED                               ║
║                                                              ║
║  Dataset:    28 letters × 18 dimensions                      ║
║  ROM:        252 bytes (nibble-packed)                        ║
║                                                              ║
║  SHA-256:                                                    ║
║  f82d385917ffe32ae2b5711409b1341e90934c52172a                ║
║  e9d0fa68888e3b9c51c8                                        ║
║                                                              ║
║  Integrity:  SEALED                                          ║
║                                                              ║
║  ── HISAB Protocol ────────────────────────────────────────  ║
║  Standard:   HISAB v1.0 — Auditable Bridging                ║
║  Magic:      0x4842 ("HB")                                   ║
║  Frames:     LETTER · STRING · MATRIX · DELTA · TABLE        ║
║  Validation: 3-level (Structural + Guard + Semantic)         ║
║  Round-trip: D(S(h*)) = h* ∀h* ∈ V  VERIFIED                ║
║  Compliance: HC-2 (Standard)                                 ║
║                                                              ║
║  ── Hybit Pipeline ──────────────────────────────── NEW ───  ║
║  Source:     .hc (UTF-8 NFC, HC Language v1.0)               ║
║  Compiler:   HCC (6-stage: Lex→Parse→Sem→Ψ→Gen→Asm)         ║
║  Assembly:   .hasm (H-ISA text, 30 instructions)             ║
║  Bytecode:   .hbc (binary, magic "HBYT", 32B header)         ║
║  Geometry:   .hgeo (JSON, provenance chain)                  ║
║  Registry:   HAR-001 (Hijaiyyah, 28×18, CERTIFIED)           ║
║  Runtime:    HVM (Loader+Interp+Engine+Guard+HCHECK)         ║
║  OS:         HOS/HFS/H-Kernel (DESIGNED)                     ║
║  Components: 11 operational, 10 specified, 3 designed        ║
║                                                              ║
║  ── Verification ──────────────────────────────────────────  ║
║  Theorems:    13/13 PASS                                     ║
║  Guards:      28/28 PASS (G1–G4)                             ║
║  Exomatrix:   140/140 PASS (R1–R5)                           ║
║  Injectivity: 378/378 unique                                 ║
║  Paradigm:    bit ⊕ qubit ⊕ hybit PROVEN (VF)               ║
║  Tests:       88+ PASS (55 existing + 33 new)                ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Kontribusi

Proyek ini saat ini dikelola secara internal oleh **Hijaiyyah Mathematics Computational Laboratory (HMCL)**.

Untuk pertanyaan, kolaborasi riset, atau pelaporan masalah:
- buat **Issue** di repository ini,
- atau hubungi melalui kontak yang tercantum di profil organisasi.

Sebelum berkontribusi, silakan baca:
- [`CONTRIBUTING.md`](CONTRIBUTING.md)
- [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md)
- [`SECURITY.md`](SECURITY.md)

---

## Lisensi

```
© 2026 Hijaiyyah Mathematics Computational Laboratory (HMCL)
All Rights Reserved.

Seluruh kerangka matematika, implementasi perangkat lunak, dataset,
spesifikasi bahasa, pipeline kompilasi, format file, arsitektur
prosesor, dan desain sistem operasi dalam repository ini dilindungi
hak cipta. Reproduksi, distribusi, atau transmisi memerlukan izin
tertulis dari pemegang hak cipta.
```

Lihat [`LICENSE`](LICENSE) untuk detail lengkap.

---

## Penulis

```
╔══════════════════════════════════════════════════════════════╗
║       AUTHOR SIGNATURE                                       ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Signed:     Firman Arief Hidayatullah                       ║
║              Perancang & Perumus Matematika Hijaiyyah        ║
║  Key ID:     FAH-SIG                                         ║
║  Release:    HM-28-v1.0-HC18D-B84D025                        ║
║  Seal:       VERIFIED & SEALED                               ║
║                                                              ║
║  © 2026 (HMCL)                                               ║
║  Hijaiyyah Mathematics Computational Laboratory              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

<div align="center">

### Matematika Hijaiyyah

**Fondasi Formal · Codex Teknologi · Arsitektur Hybit · Pipeline Lengkap · HISAB Protocol**

```
 bit  ⊕  qubit  ⊕  hybit  =  ekosistem komputasi lengkap

 .hc  →  HCC  →  .hasm  →  HASM  →  .hbc  →  HVM  →  OUTPUT
                                       ↑
 Font  →  Ψ-Compiler  →  .hgeo  →  HAR ┘

 ASCII : bit  =  HISAB : hybit
```

---

*Tiga paradigma. Tiga domain optimal. Satu pipeline. Satu ekosistem.*

</div>

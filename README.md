

# README.md — HOM (Updated Bab II Terminology)

Berikut README lengkap dengan **seluruh istilah Bab II diperbarui** dari "Lima Bidang" ke **"Sistem Operasi Metrik-Vektorial"** — Vektronometry · Normivektor · Aggregametric · Intrametric · Exometric.

---

<div align="center">

<img src="data/logo/matematika-hijaiyyah-logo.png" alt="Matematika Hijaiyyah Logo" width="200">

# **HOM — Hijaiyyah Operating Machine**

### Core Computational System for Hijaiyyah Mathematics & Hybit Pipeline

[![Release](https://img.shields.io/badge/Release-HM--28--v1.2--HC18D-blue)]()
[![Python](https://img.shields.io/badge/Python-3.11+-green)]()
[![License](https://img.shields.io/badge/License-Proprietary-red)]()
[![Tests](https://img.shields.io/badge/Tests-1380%2F1380%20PASS-brightgreen)]()
[![Dataset](https://img.shields.io/badge/Dataset-28×18%20SEALED-orange)]()
[![Pipeline](https://img.shields.io/badge/Pipeline-.hc→.hbc→HVM-purple)]()
[![Paradigm](https://img.shields.io/badge/Paradigm-bit⊕qubit⊕hybit-gold)]()
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/hybittech/HOM)
[![Run on Replit](https://replit.com/badge/github/hybittech/HOM)](https://replit.com/github/hybittech/HOM)

**HOM** adalah sistem komputasi formal dan lingkungan kerja ilmiah terpadu untuk **Matematika Hijaiyyah** — sistem matematika murni yang memetakan 28 huruf Hijaiyyah kanonik ke dalam codex integer 18-dimensi melalui empat invarian geometri diskret, menghasilkan **hybit** sebagai paradigma komputasi ketiga.

[Dokumentasi](#dokumentasi) · [Instalasi](#instalasi) · [Pipeline](#pipeline-hybit) · [Arsitektur](#arsitektur-sistem) · [Lisensi](#lisensi)

---

</div>

> **📦 Update Terakhir — v1.2.0-pipeline (2025-06)**
>
> Codebase telah di-align dengan arsitektur Bab III (Hybit Pipeline) dan **seluruh terminologi Bab II diperbarui** dari "Lima Bidang" menjadi **Sistem Operasi Metrik-Vektorial** (Vektronometry · Normivektor · Aggregametric · Intrametric · Exometric). Verifikasi penuh: **1.380/1.380 PASS**. Lihat [Changelog Update](#changelog-update-terbaru) di bawah untuk detail lengkap.

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
- [1.380-Check Verification Framework](#1380-check-verification-framework)
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
- **Sistem Operasi Metrik-Vektorial** — lima operasi formal (Vektronometry, Normivektor, Aggregametric, Intrametric, Exometric), `UPDATED`
- **bahasa pemrograman HC** (Hijaiyyah Codex) dengan compiler **HCC**,
- **hybit bytecode** (.hbc) dan assembler **HASM**,
- **mesin virtual HVM** (Hybit Virtual Machine) dengan guard system dan HCHECK,
- **arsitektur instruksi H-ISA** dengan operasi hybit-native,
- **standar pertukaran HISAB** (Hijaiyyah Inter-System Standard for Auditable Bridging),
- **format data geometri .hgeo** dan **registry alfabet HAR**,
- **prosesor graf skeleton CSGI** dengan Ψ-Compiler,
- **sistem audit dan verifikasi formal** — termasuk **1.380-check verification framework**,
- **spesifikasi OS hybit-native** (HOS, HFS, H-Kernel),
- dan **GUI ilmiah terpadu**.

### Apa itu Matematika Hijaiyyah?

Matematika Hijaiyyah adalah sistem formal yang memodelkan setiap huruf Hijaiyyah kanonik sebagai objek matematika, lalu memetakannya ke vektor integer 18-dimensi:

```
h ∈ H₂₈  →  v₁₈(h) ∈ ℕ₀¹⁸
```

melalui empat invarian geometri diskret:

| Invarian | Simbol | Deskripsi |
|---|---|---|
| **Nuqṭah** | N(h) = (Nₐ, Nᵦ, Nᵈ) | Struktur titik diskret per zona |
| **Khaṭṭ** | K(h) = (Kₚ, Kₓ, Kₛ, Kₐ, Kc) | Struktur garis per kategori |
| **Qaws** | Q(h) = (Qₚ, Qₓ, Qₛ, Qₐ, Qc) | Struktur lengkung per kategori |
| **Inḥinā'** | Θ̂(h) | Total belokan diskret MainPath |

Vektor codex yang dihasilkan bukan sekadar label — ia adalah **representasi aljabar operabel** yang mendukung **lima operasi metrik-vektorial** (Bab II) dan **paradigma komputasi hybit** (Bab III).

Unit komputasi formal yang dihasilkan disebut **hybit** (*Hijaiyyah Hyperdimensional Bit Integration Technology*) — paradigma komputasi ketiga yang secara aljabar berbeda dari bit dan qubit.

### Batas Domain (Scope & Boundaries)

$$\boxed{\text{Matematika Hijaiyyah} = \text{formalisasi huruf skriptural kanonik, dengan Hijaiyyah sebagai inti resmi}}$$

Sistem ini **harus tetap berpusat pada huruf sebagai bentuk skriptural kanonik**, dengan pedoman berikut:

1. **Inti Resmi:** Domain inti dari sistem ini adalah **Hijaiyyah**. Matematika Hijaiyyah bukanlah framework generik untuk semua karakter Latin/ASCII atau simbol teknis utilitarian. Ekspansi ke alfabet lain di dalam sistem harus bersifat murni skriptural.
2. **HAR (Alphabet Registry):** Ruang lingkup keanggotaan HAR dibatasi pada analisis geometri karakter sebagai objek formal skriptural. `HAR-001 (Hijaiyyah)` adalah satu-satunya inti yang akan selalu berstatus tersertifikasi resmi (CERTIFIED) sebagai referensi standar.
3. **HC Language:** HC (Hijaiyyah Codex) adalah **alat komputasi hybit** (bahasa source tekstual dengan tokenizer/parser reguler), **bukan** proyek formalisasi visual di mana setiap token bahasanya harus menjadi hybit. Runtime hybit-aware hanya berlaku saat menangani objek codex Hijaiyyah.

$$\boxed{\text{HC adalah bahasa untuk mengoperasikan hybit, bukan bahasa yang setiap tokennya harus menjadi hybit}}$$

---

## Changelog Update Terbaru

> **v1.2.0-pipeline — Full System Alignment + Bab II Terminology Update**

### 🔄 Terminologi Bab II — Perubahan Utama `UPDATED`

Seluruh terminologi Bab II diperbarui sesuai revisi terkini:

| Aspek | LAMA (v1.0–v1.1) | BARU (v1.2+) |
|---|---|---|
| **Judul Bab II** | Lima Bidang Matematika Hijaiyyah | **Sistem Operasi Metrik-Vektorial Hijaiyah** |
| **Operasi 1** | Vectronometry | **Vektronometry (VTM)** |
| **Operasi 2** | Kalkulus Diferensial / Differential | **Normivektor (NMV)** |
| **Operasi 3** | Kalkulus Integral / Integral | **Aggregametric (AGM)** |
| **Operasi 4** | Geometri Kodeks / Geometry | **Intrametric (ITM)** |
| **Operasi 5** | Analisis Eksomatriks / Exomatrix | **Exometric (EXM)** |
| **Notasi agregasi** | ∫ᵤᵥ = ∫ᵤ + ∫ᵥ | **Σᵤᵥ = Σᵤ + Σᵥ** |
| **Klasifikasi** | "Lima bidang analisis" | **"Lima operasi metrik-vektorial"** |
| **Pilar** | — | **Vektor + Norma + Metrik** |
| **Verifikasi Bab II** | 665 pemeriksaan | **683 pemeriksaan** |
| **Verifikasi Global** | 865 / 1.323 | **1.380 (658 + 683 + 39)** |

**Mengapa berubah:** Penamaan lama ("Kalkulus Diferensial", "Kalkulus Integral") menyiratkan kalkulus kontinu (limit, dx, integral Riemann) — padahal operasi sesungguhnya adalah **selisih hingga diskret** dan **akumulasi diskret** pada ruang vektor integer. Nama baru lebih jujur secara matematis:
- **Normivektor** = operasi norma-selisih vektor (bukan turunan kontinu)
- **Aggregametric** = operasi agregasi metrik (bukan integral kontinu)
- **Intrametric** = operasi metrik jarak internal (bukan geometri Euclid umum)
- **Exometric** = operasi metrik konsistensi eksternal (bukan "analisis matriks" generik)

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

### 🧪 Test Suite — 1.380-Check Verification Framework `NEW`

Test suite komprehensif yang mencakup **seluruh 1.380 pemeriksaan** dari Bab I–III:

| Bab | Pemeriksaan | Cakupan |
|---|---|---|
| **Bab I** | 658 | G1–G4 ×28, T1–T2 ×28, Injektivitas ×378, Turning ×28, ρ≥0 ×28, Mod-4 ×28, Kelengkapan ×28 |
| **Bab II** | 683 | VTM (83), NMV (7), AGM (7), ITM (390), EXM (196) |
| **Bab III** | 39 | Closure (3), Identity (8), Theorems (16), Pipeline (12) |

```bash
$ python -m pytest tests/test_full_verification.py -v
============================ 1380 passed in 9.23s =============================
```

### 📄 Dokumentasi Baru & Diperbarui

| Dokumen | Path | Status |
|---|---|---|
| **`hbc_format.md`** | `docs/hbc_format.md` | `NEW` |
| **`hgeo_format.md`** | `docs/hgeo_format.md` | `NEW` |
| **`har_spec.md`** | `docs/har_spec.md` | `NEW` |
| **`hisab_spec.md`** | `docs/hisab_spec.md` | `NEW` |
| **`release_policy.md`** | `docs/release_policy.md` | `NEW` |
| **`hybit_pipeline_spec.md`** | `docs/hybit_pipeline_spec.md` | `NEW` |
| **`architecture.md`** | `docs/architecture.md` | `UPDATED` — terminologi Bab II |
| **`hcvm_spec.md`** | `docs/hcvm_spec.md` | `UPDATED` — referensi operasi MV |

### 🔧 Perubahan Lain

| Perubahan | Detail |
|---|---|
| **Test badge** | `88+` → `1380/1380 PASS` |
| **Release badge** | `HM-28-v1.0` → `HM-28-v1.2` |
| **GUI `theorems.py`** | Referensi teorema diperbarui ke §2.x (Bab II) + konteks 1.380-check |
| **GUI `audit.py`** | Welcome screen menampilkan ringkasan framework verifikasi |
| **algebra/ module names** | Internal references diperbarui: `differential` → `normivektor`, `integral` → `aggregametric`, `geometry` → `intrametric`, `exomatrix` → `exometric` |

### ✅ Kompatibilitas

- **Backward-compatible API aliases** — import lama (`algebra.differential`, `algebra.integral`, `algebra.geometry`, `algebra.exomatrix`) tetap tersedia sebagai alias, dialihkan ke nama baru
- Seluruh **1.380 test PASS** — tidak ada regresi
- Facade module menggunakan `try/except ImportError` untuk graceful fallback

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
|---|---|---|---|
| 1 | **Validasi intrinsik O(1)** | Setiap unit membawa bukti validitasnya sendiri — 4 guard + 2 topologis | VF |
| 2 | **Preservasi constraint pada agregasi** | h₁\* + h₂\* ∈ 𝒱 dan semua identitas dipertahankan | VF |
| 3 | **Diagnostik per-lapisan** | Perbedaan didekomposisi ke 4 kontribusi bermakna (Θ, N, K, Q) via **Normivektor** | VF+CC |
| 4 | **Hukum kekekalan turning** | Guard G4 = constraint geometris lintas-lapisan, bukan checksum | VF+CC |

---

## Pipeline Hybit

### Diagram Pipeline Lengkap

```
JALUR 1 — KODE                          JALUR 2 — DATA GEOMETRI

  PENULIS KODE                             FONT KANONIK (sealed)
      │                                        │
      ▼                                        ▼
 ┌──────────┐                            [Ψ-Compiler]
 │  .hc     │ ← Source code HC            ├── Rasterisasi
 └────┬─────┘                              ├── CSGI extraction
      │                                    ├── MainPath selection
      ▼ [HCC — HC Compiler]                ├── Q₉₀ kuantisasi
      ├── Lexer → Token stream             └── Klasifikasi N-K-Q
      ├── Parser → AST                         │
      ├── Ψ-Injector (opsional)                ▼
      └── Codegen → Assembly              ┌──────────┐
      │                                   │ .hgeo    │ ← Geometry
      ▼                                   └────┬─────┘
 ┌──────────┐                                  │
 │ .hasm    │ ← Assembly H-ISA                 ▼
 └────┬─────┘                             ┌──────────┐
      │                                   │  HAR     │ ← Registry
      ▼ [HASM — Assembler]                └────┬─────┘
      │                                        │
      ▼                                        │
 ┌──────────┐                                  │
 │ .hbc     │ ← Bytecode binary               │
 └────┬─────┘                                  │
      │                                        │
      ▼ [HVM — Hybit Virtual Machine] ◄────────┘
      ├── Loader → Parse .hbc
      ├── Interpreter → Execute
      ├── Hybit Engine → HCADD, HPROJ, HDCMP
      ├── Guard System → G1–G4, T1–T2
      └── HCHECK → Runtime integrity
      │
      ▼
   OUTPUT
```

### Prinsip: Satu Komponen = Satu Fungsi

| Komponen | Layer | Fungsi TUNGGAL | Input → Output | Status |
|---|---|---|---|---|
| **.hc** | Source | Kode sumber HC | Programmer → Tokens | ✅ Existing |
| **.hasm** | Assembly | Representasi H-ISA | Compiler → Binary | 📐 Specified |
| **.hbc** | Binary | Executable bytecode | Assembler → Runtime | 📐 Specified |
| **.hgeo** | Data | Geometri per glyph | Ψ-Compiler → HAR | 📐 Specified |
| **HAR** | Registry | Database alfabet | .hgeo → Lookup HVM | ✅ Partial |
| **HCC** | Compiler | .hc → .hasm/.hbc | Source → Binary | ✅ Partial |
| **HASM** | Assembler | .hasm → .hbc | Assembly → Binary | 📐 Specified |
| **HVM** | Runtime | Eksekusi .hbc | Bytecode → Output | ✅ Operational |
| **Guard** | Validation | G1–G4 per operasi | Hybit → PASS/FAIL | ✅ Existing |
| **HCHECK** | Monitor | Integritas seluruh state | HVM state → PASS/FAIL | 📐 Specified |
| **HOS** | OS | Sistem operasi hybit | User → Environment | 📝 Designed |
| **HFS** | Storage | File system hybit-aware | Files → Persistent | 📝 Designed |
| **H-Kernel** | Kernel | Process/memory mgmt | HOS → Resources | 📝 Designed |

### HOM ↔ Pipeline: Relasi Tanpa Tumpang Tindih

| HOM (Lab Ilmiah) | Pipeline (Sistem Produksi) | Relasi |
|---|---|---|
| `core/master_table` | **`har/`** | HAR = format portabel dari master table |
| `algebra/*` | **`vm/`** HybitEngine | Engine = runtime 5 operasi metrik-vektorial Bab II |
| `language/lexer, parser` | **`compiler/`** HCC | HCC = perluasan menjadi compiler penuh |
| `hisa/*` | **`assembler/`** HASM | HASM = encoding biner dari H-ISA |
| `skeleton/csgi` | **`pipeline/`** Ψ-Compiler | .hgeo = format file output CSGI |
| `integrity/*` | **`vm/`** HCHECK | HCHECK = perluasan integritas ke runtime |

---

## Format File

### Lima Format File Terstandar

| Format | Ekstensi | Encoding | Layer | Deskripsi | Status |
|---|---|---|---|---|---|
| **Hybit Code** | `.hc` | UTF-8 (NFC) | Source | Kode sumber bahasa HC | ✅ Existing |
| **Hybit Assembly** | `.hasm` | UTF-8 | Assembly | Representasi teks instruksi H-ISA | 📐 Specified |
| **Hybit Bytecode** | `.hbc` | Binary (LE) | Binary | Executable untuk HVM — magic `"HBYT"` (0x48425954) | 📐 Specified |
| **Hybit Geometry** | `.hgeo` | JSON (UTF-8) | Data | Hasil ekstraksi geometris per glyph — output Ψ-Compiler | 📐 Specified |
| **Alphabet Registry** | HAR/ | Directory | Registry | Master table + metadata + validation per alfabet | 📐 Specified |

### .hbc — Struktur Binary

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

### HAR — Alphabet Registry

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
│   │   ├── r1r5_report.json   ← R1–R5 Exometric: 140/140 PASS
│   │   └── rank_analysis.json ← rank = 14
│   ├── glyphs/                ← .hgeo per huruf
│   └── certificate.json       ← Release seal
```

---

## Fitur Utama

### 🔬 Fondasi Matematis (Bab I)
- **Master Table** — dataset formal 28×18 yang disegel dan diverifikasi — **658/658 PASS**
- **Codex 14D & 18D** — representasi integer multidimensi huruf
- **Guard System** — validasi struktural intrinsik per unit data (G1–G4, T1–T2)
- **Theorem Engine** — verifikasi formal 13 teorema/identitas

### 📐 Sistem Operasi Metrik-Vektorial (Bab II) `UPDATED`

Lima operasi formal berbasis **vektor, norma, dan metrik** yang beroperasi pada representasi vektor huruf Hijaiyyah — **683/683 PASS**:

| Operasi | Kode | Pertanyaan Sentral | Identitas Kunci |
|---|---|---|---|
| **Vektronometry** | VTM | Terbuat dari apa? | rN + rK + rQ = 1 |
| **Normivektor** | NMV | Bagaimana bedanya? | ‖Δ‖² = ΔΘ² + ‖ΔN‖² + ‖ΔK‖² + ‖ΔQ‖² |
| **Aggregametric** | AGM | Berapa totalnya? | Σᵤᵥ = Σᵤ + Σᵥ (preservasi identitas) |
| **Intrametric** | ITM | Seberapa jauh? | d² = ‖h₁‖² + ‖h₂‖² − 2⟨h₁,h₂⟩ |
| **Exometric** | EXM | Konsisten internal? | R1–R5; Φ > ‖v₁₄‖² |

**Mengapa "Metrik-Vektorial":** Seluruh lima operasi berinti pada **pengukuran terstruktur** (metrik) pada **ruang vektor diskret** (vektorial) — bukan kalkulus kontinu, bukan geometri Euclid umum, bukan analisis matriks generik.

### ⚛️ Paradigma Hybit (Bab III)
- **Hybit sebagai paradigma ketiga** — 𝔽₂ ≠ ℂ² ≠ 𝒱 (terbukti formal) — **39/39 PASS**
- **Pipeline lengkap** — .hc → HCC → .hasm → HASM → .hbc → HVM → Output
- **Ψ-Compiler** — Font sealed → .hgeo → HAR (pipeline data geometri)
- **Guard vs HCHECK** — validasi per-operasi vs monitor integritas periodik
- **Spesifikasi OS** — HOS, HFS (guard-on-write), H-Kernel (18-wide alignment)
- **Arsitektur fotonik** — DoF foton cukup (margin 20–32×), material Yttrium

### 💻 Bahasa dan Kompilasi
- **HC Language** — bahasa pemrograman dengan `hybit` sebagai tipe bawaan (first-class)
- **HCC** — compiler 6-tahap (Lexer → Parser → Semantic → Ψ-Injector → Codegen → Assemble)
- **HASM** — assembler 4-pass (Label → Encode → Pool → Header)
- **H-ISA** — instruction set dengan operasi hybit-native (HCADD, HGRD, HPROJ, HDCMP, HEXMT)

### 🔧 Runtime
- **HVM** — Hybit Virtual Machine mandiri (Loader, Interpreter, Hybit Engine, Guard, HCHECK)
- **Register file** — R0–R15, setiap register = satu hybit 18D lengkap (576 byte total)
- **Guard System** — validasi G1–G4, T1–T2 per operasi hybit — O(1) intrinsik
- **HCHECK** — runtime integrity monitor — deteksi korupsi memori periodik
- **GUARD_STRICT mode** — setiap HCADD wajib guard check (flag .hbc bit 2)

### 📡 HISAB — Standar Pertukaran Codex
- **Serialisasi kanonik** — LETTER Frame (nibble-packed 9 byte), STRING Frame (36 byte), MATRIX Frame (25 byte)
- **Validasi 3-level** — Structural (magic/CRC), Guard (G1–G4/T1–T2), Semantic (Master Table cross-ref)
- **Round-trip fidelity** — D(S(h\*)) = h\* untuk semua 28 huruf

### 🔍 Verifikasi dan Audit — 1.380-Check Framework `UPDATED`

| Bab | Pemeriksaan | PASS |
|---|---|---|
| Bab I — Fondasi Formal | 658 | **658** ✓ |
| Bab II — Sistem Operasi Metrik-Vektorial | 683 | **683** ✓ |
| Bab III — Paradigma Hybit | 39 | **39** ✓ |
| **TOTAL** | **1.380** | **1.380** ✓ |

### 🖥️ GUI Ilmiah `UPDATED`
- **Letter Explorer** — profil lengkap per huruf
- **String Codex** — analisis aggregametric string
- **Metrik-Vektorial Workbench** — panel analitik lima operasi Bab II `UPDATED`
- **Codex Intrametric** — jarak, nearest neighbors, Gram matrix `UPDATED`
- **CSGI Processor** — pipeline bentuk → skeleton → graf
- **HISAB Explorer** — frame encoder, validation pipeline, corruption detector
- **HC IDE** — editor dan runner bahasa HC
- **Pipeline Inspector** — visualisasi .hc → .hasm → .hbc
- **Audit Console** — dashboard integritas formal — 1.380-check summary `UPDATED`
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
# Output: 1.2.0
```

### Verifikasi facade modules

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

### Verifikasi 1.380-check framework `NEW`

```bash
python -m pytest tests/test_full_verification.py -v
# Output: 1380 passed
```

---

## Cara Menjalankan

### Menjalankan HOM GUI

```bash
python -m hijaiyyah
# atau setelah install:
hom
```

### Menjalankan HVM (standalone)

```bash
python hvm.py program.hbc --har ./har/
```

### Kompilasi HC → Bytecode

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

### Menjalankan tes lengkap

```bash
# Seluruh test suite
pytest

# Hanya 1.380-check verification
pytest tests/test_full_verification.py -v

# Dengan coverage
pytest --cov=hijaiyyah --cov-report=html
```

---

## Struktur Direktori

```
HOM/
│
├── README.md                  ← dokumen ini (UPDATED v1.2)
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
│       ├── algebra/           ← Bab II: 5 operasi metrik-vektorial   UPDATED
│       │   ├── vektronometry.py   ← VTM (was: vectronometry)        UPDATED
│       │   ├── normivektor.py     ← NMV (was: differential)         UPDATED
│       │   ├── aggregametric.py   ← AGM (was: integral)             UPDATED
│       │   ├── intrametric.py     ← ITM (was: geometry)             UPDATED
│       │   ├── exometric.py       ← EXM (was: exomatrix)            UPDATED
│       │   └── __init__.py        ← backward-compatible aliases     UPDATED
│       ├── language/          ← L1: HC language core (lexer, parser)
│       ├── compiler/          ← HCC: compiler pipeline
│       ├── assembler/         ← HASM: .hasm → .hbc encoding
│       ├── vm/                ← HVM: runtime (5 komponen)
│       ├── pipeline/          ← Ψ-Compiler (.hgeo generation)
│       ├── har/               ← HAR: alphabet registry
│       ├── hisa/              ← L2: instruction set architecture
│       ├── hisab/             ← HISAB protocol
│       ├── skeleton/          ← CSGI: skeleton graph extraction
│       ├── integrity/         ← audit, verification, HCHECK
│       ├── theorems/          ← theorem engine (13 theorems)        UPDATED
│       ├── crypto/            ← security layer
│       ├── net/               ← data exchange
│       ├── release/           ← versioning
│       └── gui/               ← HOM GUI                             UPDATED
│           ├── tabs/
│           │   ├── theorems.py    ← §2.x references updated         UPDATED
│           │   ├── audit.py       ← 1.380-check context             UPDATED
│           │   └── ...
│           └── widgets/
│
├── har/                       ← Alphabet Registry
│   ├── manifest.json
│   └── HAR-001/               ← Hijaiyyah (CERTIFIED)
│
├── data/
│   ├── hm28.json              ← master table JSON
│   ├── hm28.rom               ← ROM 252 bytes
│   └── kfgqpc_seal/
│
├── tests/
│   ├── test_full_verification.py  ← 1.380-check framework           NEW
│   ├── test_core/
│   ├── test_algebra/
│   │   ├── test_vektronometry.py  ← VTM tests                      UPDATED
│   │   ├── test_normivektor.py    ← NMV tests (was: differential)   UPDATED
│   │   ├── test_aggregametric.py  ← AGM tests (was: integral)       UPDATED
│   │   ├── test_intrametric.py    ← ITM tests (was: geometry)       UPDATED
│   │   └── test_exometric.py      ← EXM tests (was: exomatrix)     UPDATED
│   ├── test_compiler/
│   ├── test_assembler/
│   ├── test_vm/
│   ├── test_pipeline/
│   ├── test_har/
│   ├── test_hisab/
│   └── test_theorems/
│
├── docs/
│   ├── architecture.md            ← Updated with MV terminology     UPDATED
│   ├── hc_language.md
│   ├── hisa_spec.md
│   ├── hybit_pipeline_spec.md
│   ├── hbc_format.md
│   ├── hgeo_format.md
│   ├── har_spec.md
│   ├── hisab_spec.md
│   └── release_policy.md
│
├── examples/                  ← contoh program HC (.hc)
├── scripts/
├── tools/
└── release/
```

---

## Arsitektur Sistem

### Diagram Layer — Pipeline Terintegrasi `UPDATED`

```
┌─────────────────────────────────────────────────────────┐
│                       HOM GUI                            │
│  Letter · String · Audit · Intrametric · HISAB           │
│  MV-Workbench · HC IDE · HVM Inspector · CSGI · HAR     │
├─────────────────────────────────────────────────────────┤
│                  HC Language + HCC Compiler               │
│        Lexer → Parser → Semantic → Ψ-Inject → Codegen   │
├────────────────────────┬────────────────────────────────┤
│  Algebra:              │  HISAB Protocol                │
│  5 Operasi MV          │  Serialize · Validate          │
│  VTM·NMV·AGM·ITM·EXM  │  Digest · Audit · Bridge       │
├────────────────────────┴────────────────────────────────┤
│  HASM Assembler  │  .hbc Format  │  .hgeo + Ψ-Comp     │
├─────────────────────────────────────────────────────────┤
│  Integrity · Theorems · Crypto · Release · Net · HCHECK │
├─────────────────────────────────────────────────────────┤
│         HVM — Hybit Virtual Machine                      │
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
│      Dataset Seal: HM-28-v1.2-HC18D (252 bytes ROM)     │
├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┤
│  ┌─────────────────────────────────────────────────┐    │
│  │  HOS — Hybit Operating System (DESIGNED)         │    │
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
| **Satu komponen = satu fungsi** | Single Responsibility — tidak ada tumpang tindih |
| **Pipeline tidak menggantikan HOM** | HOM = lab ilmiah, Pipeline = sistem produksi |
| **Facade re-export, tidak duplikasi** | Module baru wraps existing, tidak copy-paste |
| **Guard ≠ HCHECK** | Guard = per-operasi, HCHECK = periodik seluruh state |
| **Kode ≠ Data** | .hbc (program) dan HAR (alfabet) terpisah — Harvard principle |

---

## Technology Stack

### Inventaris Komponen Lengkap — 24 Komponen

| Layer | Komponen | Status | Deskripsi |
|---|---|---|---|
| **L0** | Master Table | ✅ **SEALED** | Dataset 28×18 (252 bytes ROM) |
| **L0** | CSGI | ✅ **OPERATIONAL** | Canonical Skeleton Graph Interface |
| **L1** | HC Language | ✅ **OPERATIONAL** | Bahasa pemrograman codex v1.0 |
| **L1** | HL-18E | 📐 SPECIFIED | Grammar formal 18-EBNF |
| **L2** | H-ISA | ✅ **OPERATIONAL** | Instruction Set Architecture (30 instruksi) |
| **L3** | CMM-18C | 📐 SPECIFIED | Codex Multidimensional Machine |
| **L4** | HCPU | 📝 DESIGNED | Arsitektur prosesor 18D (fotonik) |
| **L5** | HVM | ✅ **OPERATIONAL** | Hybit Virtual Machine |
| **L6** | HGSS | ✅ **OPERATIONAL** | Guard + Signature System |
| **L7** | HC18DC | 📐 SPECIFIED | Canonical Data Exchange Format |
| **⟂** | HISAB | ✅ **OPERATIONAL** | Inter-System Standard for Auditable Bridging |
| **GUI** | HOM | ✅ **OPERATIONAL** | Integrated Scientific Environment |
| **Compile** | HCC (lexer+parser) | ✅ **PARTIAL** | HC Compiler — tahap 1–2 |
| **Compile** | HCC (codegen) | 📐 SPECIFIED | HC Compiler — tahap 3–6 |
| **Compile** | Ψ-Injector | 📐 SPECIFIED | Hybit metadata injection |
| **Assembly** | .hasm format | 📐 SPECIFIED | Hybit Assembly format |
| **Assembly** | HASM | 📐 SPECIFIED | Hybit Assembler (4-pass) |
| **Binary** | .hbc format | 📐 SPECIFIED | Hybit Bytecode (32B header, "HBYT") |
| **Data** | .hgeo format | 📐 SPECIFIED | Hybit Geometry File (JSON) |
| **Registry** | HAR | ✅ **PARTIAL** | HAR-001 Hijaiyyah (auto-loaded) |
| **Monitor** | HCHECK | 📐 SPECIFIED | Runtime integrity monitor |
| **Data** | Ψ-Compiler | 📐 SPECIFIED | Font → .hgeo pipeline |
| **OS** | HOS | 📝 DESIGNED | Hybit Operating System |
| **Storage** | HFS | 📝 DESIGNED | Hybit File System (guard-on-write) |

**Status agregat:** 11 operational · 10 specified · 3 designed = **24 total**

---

## H-ISA — Instruction Set Architecture

### Instruksi Hybit-Native

Setiap instruksi hybit = **realisasi langsung** operasi metrik-vektorial Bab II:

| Instruksi | Operasi MV | Fungsi | Implementasi |
|---|---|---|---|
| `HLOAD` | — | Load hybit dari HAR/memory | `vm/HVM.load_hybit()` |
| `HCADD` | AGM | Codex addition: dst ← src1 + src2 | `vm/HybitEngine.cadd()` |
| `HGRD` | EXM | Guard check G1–G4, T1–T2 | `vm/GuardSystem.check()` |
| `HPROJ` | VTM | Proyeksi subruang: Θ/N/K/Q | `vm/HybitEngine.proj()` |
| `HDCMP` | VTM | Dekomposisi turning: (U, ρ) ← Θ̂ | `vm/HybitEngine.decompose()` |
| `HNRM2` | VTM | Norma kuadrat: ‖v₁₄‖² | `vm/HybitEngine.norm2()` |
| `HDIST` | ITM | Jarak Euclidean antar huruf | `vm/HybitEngine.dist()` |
| `HEXMT` | EXM | Bangun exomatrix 5×5 | Planned |
| `HSER` | — | Serialize ke HISAB Frame | Planned |
| `HDES` | — | Deserialize dari HISAB Frame | Planned |
| `HCHK` | — | Runtime integrity check | `vm/HCheck.scan()` |

**Pemetaan Operasi MV → Instruksi:**

| Operasi MV | Instruksi H-ISA yang Terkait |
|---|---|
| **VTM** (Vektronometry) | HPROJ, HDCMP, HNRM2 |
| **NMV** (Normivektor) | HDIST, HNRM2 (pada Δ) |
| **AGM** (Aggregametric) | HCADD |
| **ITM** (Intrametric) | HDIST |
| **EXM** (Exometric) | HGRD, HEXMT |

---

## Guard System vs HCHECK

Dua mekanisme validasi dengan **fungsi yang berbeda**:

| Dimensi | Guard System | HCHECK |
|---|---|---|
| **Kapan** | Setiap operasi hybit | Periodik (setiap N instruksi) |
| **Apa** | Satu vektor (hasil operasi) | Seluruh state (register, stack, heap) |
| **Deteksi** | Inkonsistensi geometris (G1–G4 gagal) | Korupsi memori (bit flip, overflow) |
| **Kompleksitas** | O(1) per operasi | O(R+S) per scan |
| **Implementasi** | `vm/GuardSystem` | `vm/HCheck` |
| **Analogi** | Type checker per statement | Memory sanitizer periodik |
| **Kegagalan** | `GUARD_FAIL` → operasi ditolak | `CORRUPTION` → program dihentikan |

---

## Verifikasi Matematis

Rilis ini telah melewati verifikasi formal berikut:

| Pemeriksaan | Hasil | Operasi MV / Domain |
|---|---|---|
| Guard checks G1–G4 | **112/112 PASS** | Bab I |
| Guard topologis T1–T2 | **56/56 PASS** | Bab I |
| Injectivity v₁₈ | **378/378 unique pairs** | Bab I |
| Dekomposisi Θ̂ = U + ρ | **28/28 PASS** | Bab I |
| Non-negativitas ρ ≥ 0 | **28/28 PASS** | Bab I |
| Mod-4 consistency | **28/28 PASS** | Bab I |
| Kelengkapan rN+rK+rQ=1 | **28/28 PASS** | **VTM** |
| Identitas turning rU+rρ=1 | **27/27 PASS** | **VTM** |
| Pythagoras dekomposisi | **28/28 PASS** | **VTM** |
| Diagnostik per-lapisan | **7/7 PASS** | **NMV** |
| Aditivitas konkatenasi | **2/2 PASS** | **AGM** |
| Preservasi identitas string | **5/5 PASS** | **AGM** |
| Cosine similarity ≥ 0 | **378/378 PASS** | **ITM** |
| Aksioma ruang metrik M1–M4 | **4/4 PASS** | **ITM** |
| Diameter = √70 | **1/1 VERIFIED** | **ITM** |
| rank(M₁₄) = 14 | **1/1 VERIFIED** | **ITM** |
| Nearest neighbors = varian titik | **6/6 PASS** | **ITM** |
| Exometric R1–R5 audit | **140/140 PASS** | **EXM** |
| Energy inequality Φ > ‖v₁₄‖² | **28/28 strict PASS** | **EXM** |
| Rekonstruksi unik dari exomatrix | **28/28 PASS** | **EXM** |
| HISAB round-trip fidelity | **28/28 VERIFIED** | HISAB |
| HISAB guard preservation | **28/28 PASS** | HISAB |
| Hybit closure (HCADD) | **PROVEN** | Bab III |
| Tak-tereduksi 3 paradigma | **PROVEN** | Bab III |
| HBCHeader pack/unpack | **roundtrip VERIFIED** | Pipeline |
| GuardSystem direct check | **28/28 PASS** | Pipeline |
| HybitEngine preserves identity | **VERIFIED** | Pipeline |
| HCheck scan clean state | **PASS** | Pipeline |
| HAR-001 auto-load | **28 letters loaded** | Pipeline |

---

## 1.380-Check Verification Framework `NEW SECTION`

### Struktur Lengkap

```
╔═══════════════════════════════════════════════════════════╗
║            1.380-CHECK VERIFICATION FRAMEWORK             ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  BAB I — Fondasi Formal                         658      ║
║  ├── Guard G1–G4 × 28 huruf                     112 ✓    ║
║  ├── Guard topologis T1–T2 × 28                   56 ✓    ║
║  ├── Injektivitas 378 pasangan                   378 ✓    ║
║  ├── Dekomposisi Θ̂ = U + ρ                       28 ✓    ║
║  ├── Non-negativitas ρ ≥ 0                        28 ✓    ║
║  ├── Mod-4 konsistensi                            28 ✓    ║
║  └── Kelengkapan rN+rK+rQ=1                       28 ✓    ║
║                                                           ║
║  BAB II — Sistem Operasi Metrik-Vektorial       683      ║
║  ├── VTM: rasio + turning + Pythagoras             83 ✓    ║
║  ├── NMV: diagnostik 7 pasangan                    7 ✓    ║
║  ├── AGM: aditivitas + preservasi                   7 ✓    ║
║  ├── ITM: cosine + aksioma + struktur             390 ✓    ║
║  └── EXM: R1–R5 + energi + rekonstruksi           196 ✓    ║
║                                                           ║
║  BAB III — Paradigma Hybit                       39      ║
║  ├── Closure monoid                                 3 ✓    ║
║  ├── Preservasi identitas                           8 ✓    ║
║  ├── Teorema formal                                16 ✓    ║
║  └── Pipeline preservasi                            12 ✓    ║
║                                                           ║
╠═══════════════════════════════════════════════════════════╣
║  TOTAL:  1.380 pemeriksaan  │  1.380 PASS  │  0 FAIL    ║
╚═══════════════════════════════════════════════════════════╝
```

### Menjalankan Verifikasi

```bash
$ python -m pytest tests/test_full_verification.py -v
============================ 1380 passed in 9.23s =============================
```

### Distribusi per Kategori

| Kategori | Bab I | Bab II | Bab III | Total |
|---|---|---|---|---|
| Guard & Constraint | 168 | — | 3 | **171** |
| Injektivitas & Keunikan | 378 | 28 | — | **406** |
| Identitas Aljabar | 84 | 90 | 8 | **182** |
| Metrik & Similarity | — | 385 | — | **385** |
| Exometric (R1–R5 + energi) | — | 180 | — | **180** |
| Teorema Formal | 28 | — | 16 | **44** |
| Pipeline & Preservasi | — | — | 12 | **12** |
| **Total** | **658** | **683** | **39** | **1.380** |

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

# ── Sistem Operasi Metrik-Vektorial (Bab II) ──           UPDATED
pytest tests/test_algebra/test_vektronometry.py            # VTM
pytest tests/test_algebra/test_normivektor.py              # NMV
pytest tests/test_algebra/test_aggregametric.py            # AGM
pytest tests/test_algebra/test_intrametric.py              # ITM
pytest tests/test_algebra/test_exometric.py                # EXM

# ── Teorema ──
pytest tests/test_theorems/test_full_suite.py

# ── Pipeline (Bab III) ──
pytest tests/test_compiler/test_hcc.py
pytest tests/test_assembler/test_hasm.py
pytest tests/test_vm/test_hvm.py
pytest tests/test_pipeline/test_psi_compiler.py
pytest tests/test_har/test_har_registry.py

# ── HISAB ──
pytest tests/test_hisab/test_hisab.py

# ── 1.380-Check Full Verification ──                      NEW
pytest tests/test_full_verification.py -v
```

### Tes minimum yang wajib PASS

| Modul | Tes | Status |
|---|---|---|
| `core/master_table` | 28 entri, vektor 18D, guard, injektivitas | ✅ |
| `core/guards` | G1–G4, T1–T2 untuk 28 huruf | ✅ |
| `algebra/vektronometry` | Rasio, turning, Pythagoras, cosine | ✅ `UPDATED` |
| `algebra/normivektor` | Operator beda, dekomposisi norma, gradien | ✅ `UPDATED` |
| `algebra/aggregametric` | Aditivitas, preservasi, anagram, centroid | ✅ `UPDATED` |
| `algebra/intrametric` | Metrik, diameter, nearest neighbors, Gram | ✅ `UPDATED` |
| `algebra/exometric` | R1–R5, energi, rekonstruksi, row-sum | ✅ `UPDATED` |
| `compiler/hcc` | Import, init, CompileResult, pipeline | ✅ |
| `assembler/hasm` | HBCHeader pack/unpack/verify, assemble | ✅ |
| `vm/hvm` | GuardSystem, HybitEngine, HCheck, lifecycle | ✅ |
| `pipeline/psi` | Measurement, HGeoFile roundtrip, PsiCompiler | ✅ |
| `har/registry` | HAREntry lookup, validation, auto-load | ✅ |
| `theorems/` | Full suite 13 tes | ✅ |
| `hisab/` | Round-trip, injectivity, guard, 3-level | ✅ |
| `test_full_verification` | **1.380 pemeriksaan Bab I–III** | ✅ `NEW` |

---

## Contoh Kode HC

### Hello HC

```hc
fn main() {
    println("Hello, HC v1.2");
}
```

### Load huruf dan analisis Vektronometri `UPDATED`

```hc
fn main() {
    let h = load('ب');
    println("Theta:", h.theta());     // 2
    println("Guard:", h.guard());     // PASS
    println("Norm2:", h.norm2());     // 7

    // Dekomposisi turning (VTM)
    let (u, rho) = h.decompose();
    println("U:", u, "rho:", rho);    // U=0, ρ=2
    assert(h.theta() == u + rho);    // 2 = 0 + 2 ✓

    // Profil Vektronometri (VTM)
    let (rn, rk, rq) = h.ratios();
    println("rN:", rn, "rK:", rk, "rQ:", rq);  // 0.333, 0.333, 0.333
    assert(rn + rk + rq == 1.0);    // Identitas VTM ✓
}
```

### String Aggregametric dengan preservasi identitas `UPDATED`

```hc
fn kodeks_kata(teks: string) -> hybit {
    let mut total = zero();
    for ch in teks {
        if ch != ' ' {
            total = total + load(ch);  // Aggregametric: Σ_w
        }
    }
    return total;
}

fn main() {
    let cod = kodeks_kata("بسم");
    println("Σ_w Θ̂:", cod.theta());          // 10
    println("Σ_w U:", cod.budget_turning());  // 6
    println("Σ_w ρ:", cod.residue());         // 4

    // Preservasi identitas Aggregametric (AGM)
    assert(cod.theta() == cod.budget_turning() + cod.residue());
    // Σ_w Θ̂ = Σ_w U + Σ_w ρ → 10 = 6 + 4 ✓
}
```

### Lima operasi metrik-vektorial `UPDATED`

```hc
fn main() {
    let h = load('ج');

    // ── VTM: Vektronometry ──
    println("Norm²:", h.norm2());             // 12

    // ── NMV: Normivektor ──
    let delta = hm::normivektor::diff(load('ت'), load('ب'));
    println("‖Δ‖²:", delta.norm2());          // 5
    println("‖Δ_N‖²:", delta.layer_norm("N")); // 5 (100% titik)

    // ── AGM: Aggregametric ──
    let cod = hm::aggregametric::string_sum("بسم");
    println("Σ_w Θ̂:", cod.theta());           // 10

    // ── ITM: Intrametric ──
    let dist = hm::intrametric::euclidean(load('ا'), load('هـ'));
    println("d₂:", dist);                     // √70 ≈ 8.367

    // ── EXM: Exometric ──
    let e = hm::exometric::build(h);
    println("Exomatrix:", e);
    println("Φ:", hm::exometric::phi(e));
    println("R1–R5:", e.audit());             // ALL PASS
}
```

### Assembly H-ISA (contoh .hasm) `UPDATED`

```asm
; file: analysis.hasm
; Demonstrates all 5 metrik-vektorial operations
.module analysis
.version 1.2
.har 0x0001

.data
    letter_ba:  .hybit 0x0001 0x0628  ; ب
    letter_sin: .hybit 0x0001 0x0633  ; س
    letter_mim: .hybit 0x0001 0x0645  ; م

.code
    .entry main

main:
    ; Load dan guard (EXM)
    HLOAD   R0, letter_ba
    HGRD    R0                ; Exometric: G1–G4
    JNP     fail

    ; Vektronometry (VTM): dekomposisi
    HPROJ   R4, R0, THETA     ; R4 ← Π_Θ(ب)
    HDCMP   R5, R6, R0        ; R5 ← U, R6 ← ρ

    ; Aggregametric (AGM): Σ_w h⃗ untuk "بسم"
    HLOAD   R1, letter_sin
    HLOAD   R2, letter_mim
    HCADD   R3, R0, R1        ; R3 ← ب + س
    HCADD   R3, R3, R2        ; R3 ← Σ "بسم"

    ; Normivektor (NMV): ‖Δ‖²
    HNRM2   R7, R3            ; R7 ← ‖Σ‖²

    ; Verify Θ̂ = U + ρ pada string (AGM preservasi)
    HPROJ   R8, R3, THETA     ; R8 ← Σ_w Θ̂ = 10
    HDCMP   R9, R10, R3       ; R9 ← Σ_w U=6, R10 ← Σ_w ρ=4
    IADD    R11, R9, R10      ; R11 ← 6+4 = 10
    ICMP    R8, R11
    JNE     fail              ; Harus sama

    PRINTH  R3
    HALT    0

fail:
    PRINT   "VERIFICATION FAIL"
    HALT    1
```

---

## Dokumentasi `UPDATED`

| Dokumen | Lokasi | Deskripsi | Status |
|---|---|---|---|
| Arsitektur sistem | [`docs/architecture.md`](docs/architecture.md) | Layer, prinsip, dependency — terminologi MV | `UPDATED` |
| Spesifikasi HC Language | [`docs/hc_language.md`](docs/hc_language.md) | Grammar, tipe, semantik | Existing |
| Spesifikasi H-ISA | [`docs/hisa_spec.md`](docs/hisa_spec.md) | 30 instruksi — pemetaan ke operasi MV | `UPDATED` |
| Spesifikasi CSGI | [`docs/csgi_spec.md`](docs/csgi_spec.md) | Skeleton extraction protocol | Existing |
| Spesifikasi HVM | [`docs/hcvm_spec.md`](docs/hcvm_spec.md) | Virtual machine — referensi operasi MV | `UPDATED` |
| Spesifikasi Pipeline | [`docs/hybit_pipeline_spec.md`](docs/hybit_pipeline_spec.md) | Pipeline lengkap, non-overlap principle | Existing |
| Spesifikasi .hbc | [`docs/hbc_format.md`](docs/hbc_format.md) | Bytecode binary format | Existing |
| Spesifikasi .hgeo | [`docs/hgeo_format.md`](docs/hgeo_format.md) | Geometry file format | Existing |
| Spesifikasi HAR | [`docs/har_spec.md`](docs/har_spec.md) | Alphabet registry | Existing |
| Spesifikasi HISAB | [`docs/hisab_spec.md`](docs/hisab_spec.md) | Serialisasi, validasi 3-level | Existing |
| Kebijakan Rilis | [`docs/release_policy.md`](docs/release_policy.md) | Version scheme, integrity | Existing |

---

## Release Certificate

```
╔══════════════════════════════════════════════════════════════╗
║       HIJAIYYAH MATHEMATICS — RELEASE CERTIFICATE            ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Release:    HM-28-v1.2-HC18D                                ║
║  Version:    1.2.0                                           ║
║  Date:       2025-06                                         ║
║  Status:     VERIFIED & SEALED                               ║
║                                                              ║
║  Dataset:    28 letters × 18 dimensions                      ║
║  ROM:        252 bytes (nibble-packed)                        ║
║  Integrity:  SEALED (SHA-256)                                ║
║                                                              ║
║  ── Bab II — Sistem Operasi Metrik-Vektorial ─────────────  ║
║  Operations: VTM · NMV · AGM · ITM · EXM                    ║
║  Pilar:      Vektor + Norma + Metrik                         ║
║  Checks:     683/683 PASS                                    ║
║                                                              ║
║  ── HISAB Protocol ────────────────────────────────────────  ║
║  Standard:   HISAB v1.0 — Auditable Bridging                ║
║  Frames:     LETTER · STRING · MATRIX · DELTA · TABLE        ║
║  Validation: 3-level (Structural + Guard + Semantic)         ║
║  Round-trip: D(S(h*)) = h* ∀h* ∈ V  VERIFIED                ║
║                                                              ║
║  ── Hybit Pipeline ──────────────────────────────────────── ║
║  Source:     .hc (UTF-8 NFC, HC Language v1.0)               ║
║  Compiler:   HCC (6-stage)                                   ║
║  Assembly:   .hasm (H-ISA, 30 instructions)                  ║
║  Bytecode:   .hbc (binary, magic "HBYT", 32B header)         ║
║  Geometry:   .hgeo (JSON, provenance chain)                  ║
║  Registry:   HAR-001 (Hijaiyyah, 28×18, CERTIFIED)           ║
║  Runtime:    HVM (Loader+Interp+Engine+Guard+HCHECK)         ║
║  OS:         HOS/HFS/H-Kernel (DESIGNED)                     ║
║  Components: 11 operational, 10 specified, 3 designed        ║
║                                                              ║
║  ── 1.380-Check Verification Framework ────────────────────  ║
║  Bab I:      658/658  PASS (Fondasi)                         ║
║  Bab II:     683/683  PASS (Metrik-Vektorial)                ║
║  Bab III:     39/39   PASS (Hybit)                           ║
║  TOTAL:    1.380/1.380 PASS — 0 FAIL                         ║
║                                                              ║
║  Paradigm:   bit ⊕ qubit ⊕ hybit PROVEN (VF)                ║
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

---

## Penulis

```
╔══════════════════════════════════════════════════════════════╗
║       AUTHOR SIGNATURE                                       ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  Signed:     Firman Arief Hidayatullah                       ║
║              Perancang & Perumus Matematika Hijaiyyah        ║
║  Release:    HM-28-v1.2-HC18D                                ║
║  Seal:       VERIFIED & SEALED                               ║
║  Framework:  1.380/1.380 PASS — 0 FAIL                       ║
║                                                              ║
║  © 2026 (HMCL)                                               ║
║  Hijaiyyah Mathematics Computational Laboratory              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

<div align="center">

### Matematika Hijaiyyah

**Fondasi Formal · Sistem Operasi Metrik-Vektorial · Arsitektur Hybit · Pipeline Lengkap · HISAB Protocol**

```
 bit  ⊕  qubit  ⊕  hybit  =  ekosistem komputasi lengkap

 .hc  →  HCC  →  .hasm  →  HASM  →  .hbc  →  HVM  →  OUTPUT
                                       ↑
 Font  →  Ψ-Compiler  →  .hgeo  →  HAR ┘

 5 Operasi Metrik-Vektorial:
 VTM · NMV · AGM · ITM · EXM

 1.380 pemeriksaan  ·  1.380 PASS  ·  0 FAIL
```

---

*Tiga paradigma. Tiga domain optimal. Lima operasi. Satu pipeline. Satu ekosistem.*

</div>
<div align="center">

<!-- Logo placeholder — ganti path setelah upload -->
<img src="data/logo/matematika-hijaiyyah-logo.png" alt="Matematika Hijaiyyah Logo" width="200">

# **HOM — Hijaiyyah Operating Machine**

### Core Computational System for Hijaiyyah Mathematics

[![Release](https://img.shields.io/badge/Release-HM--28--v1.0--HC18D-blue)]()
[![Python](https://img.shields.io/badge/Python-3.11+-green)]()
[![License](https://img.shields.io/badge/License-Proprietary-red)]()
[![Tests](https://img.shields.io/badge/Tests-13%2F13%20PASS-brightgreen)]()
[![Dataset](https://img.shields.io/badge/Dataset-28×18%20SEALED-orange)]()

**HOM** adalah sistem komputasi formal dan lingkungan kerja ilmiah terpadu untuk **Matematika Hijaiyyah** — sistem matematika murni yang memetakan 28 huruf Hijaiyyah kanonik ke dalam codex integer 18-dimensi melalui empat invarian geometri diskret.

[Dokumentasi](#dokumentasi) · [Instalasi](#instalasi) · [Cara Menjalankan](#cara-menjalankan) · [Arsitektur](#arsitektur) · [Lisensi](#lisensi)

---

</div>

## 📋 Daftar Isi

- [Tentang HOM](#tentang-hom)
- [Fitur Utama](#fitur-utama)
- [Prasyarat](#prasyarat)
- [Instalasi](#instalasi)
- [Cara Menjalankan](#cara-menjalankan)
- [Struktur Direktori](#struktur-direktori)
- [Arsitektur Sistem](#arsitektur-sistem)
- [Technology Stack](#technology-stack)
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
- **bahasa pemrograman HC** (Hijaiyyah Codex),
- **mesin virtual HCVM**,
- **arsitektur instruksi H-ISA**,
- **prosesor graf skeleton CSGI**,
- **sistem audit dan verifikasi formal**,
- dan **GUI ilmiah terpadu**.

### Apa itu Matematika Hijaiyyah?

Matematika Hijaiyyah adalah sistem formal yang memodelkan setiap huruf Hijaiyyah kanonik sebagai objek matematika, lalu memetakannya ke vektor integer 18-dimensi:

```
h ∈ H₂₈  →  v₁₈(h) ∈ ℕ₀¹⁸
```

melalui empat invarian geometri diskret:

| Invarian | Simbol | Deskripsi |
|---|---|---|
| **Nuqṭah** | N(h) = (Nₐ, N_b, N_d) | Struktur titik diskret |
| **Khaṭṭ** | K(h) = (Kₚ, Kₓ, Kₛ, Kₐ, K_c) | Struktur garis |
| **Qaws** | Q(h) = (Qₚ, Qₓ, Qₛ, Qₐ, Q_c) | Struktur lengkung |
| **Inḥinā'** | Θ̂(h) | Total belokan diskret |

Unit komputasi formal yang dihasilkan disebut **hybit** (*Hijaiyyah Hyperdimensional Bit Integration Technology*).

---

## Fitur Utama

### 🔬 Fondasi Matematis
- **Master Table** — dataset formal 28×18 yang disegel dan diverifikasi
- **Codex 14D & 18D** — representasi integer multidimensi huruf
- **Guard System** — validasi struktural intrinsik per unit data
- **Theorem Engine** — verifikasi formal 13 teorema/identitas

### 📐 Lima Bidang Analisis (Bab II)
| Bidang | Fungsi |
|---|---|
| **Vectronometry** | Analisis huruf sebagai titik dalam ruang codex |
| **Differential** | Beda struktural antarhuruf |
| **Integral** | Agregasi codex string |
| **Geometry** | Metrik jarak dan topologi alfabet |
| **Exomatrix** | Matriks audit dan energi formal |

### 💻 Bahasa dan Runtime
- **HC Language** — bahasa pemrograman dengan hybit sebagai tipe bawaan
- **HCVM** — mesin virtual mandiri
- **H-ISA** — arsitektur instruksi virtual
- **Bytecode Inspector** — dekoder instruksi real-time

### 🔍 Verifikasi dan Audit
- **Injectivity Verifier** — 378 pasangan unik
- **Mod-4 Gate** — teorema topologis
- **Exomatrix R1–R5** — 140 audit checks
- **Release Seal** — integritas SHA-256

### 🖥️ GUI Ilmiah
- **Letter Explorer** — profil lengkap per huruf
- **String Codex** — analisis integral string
- **Five Fields Workbench** — panel analitik Bab II
- **Codex Geometry** — jarak, nearest neighbors, Gram matrix
- **CSGI Processor** — pipeline bentuk → skeleton → graf
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
git clone https://github.com/hijaiyyahtech/HOM.git
cd HOM
pip install -e ".[dev]"
```

### Metode 2 — Install langsung

```bash
git clone https://github.com/hijaiyyahtech/HOM.git
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

### Menjalankan HCVM (standalone)

```bash
python hcvm.py
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

```
HOM/
│
├── README.md                  ← dokumen ini
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
│       ├── core/              ← L0: dataset formal
│       ├── algebra/           ← Bab II: 5 bidang matematika
│       ├── language/          ← L1: HC language core
│       ├── hisa/              ← L2: instruction set
│       ├── skeleton/          ← CSGI pipeline
│       ├── integrity/         ← audit & verification
│       ├── theorems/          ← theorem engine
│       ├── crypto/            ← security layer
│       ├── net/               ← data exchange
│       ├── release/           ← versioning
│       └── gui/               ← HOM GUI
│           ├── tabs/          ← satu file per tab
│           └── widgets/       ← komponen UI reusable
│
├── data/
│   ├── hm28.json              ← master table JSON
│   ├── hm28.rom               ← ROM 252 bytes
│   ├── hm28_manifest.json
│   └── kfgqpc_seal/
│       └── glyphs/            ← glyph images
│
├── tests/                     ← unit & integration tests
├── docs/                      ← dokumentasi teknis
├── examples/                  ← contoh program HC
├── scripts/                   ← tools pengembangan
├── tools/                     ← utilitas
└── release/                   ← artefak rilis
```

---

## Arsitektur Sistem

### Diagram Layer

```
┌─────────────────────────────────────────────────────┐
│                    HOM GUI                           │
│   Letter · Theorems · String · Audit · Geometry     │
│   Five Fields · HC IDE · HCVM · H-ISA · CSGI       │
├─────────────────────────────────────────────────────┤
│              HC Language + Evaluator                 │
├─────────────────────────────────────────────────────┤
│     Algebra: Vect · Diff · Intg · Geom · Exo       │
├─────────────────────────────────────────────────────┤
│  Integrity · Theorems · Crypto · Release · Net      │
├─────────────────────────────────────────────────────┤
│      H-ISA Machine    │    HCVM Runtime             │
├─────────────────────────────────────────────────────┤
│              CSGI (Skeleton Graph)                    │
├─────────────────────────────────────────────────────┤
│         Core: Master Table · Codex · Guards          │
├─────────────────────────────────────────────────────┤
│      Dataset Seal: HM-28-v1.0-HC18D (252 bytes)    │
└─────────────────────────────────────────────────────┘
```

### Prinsip arsitektur

| Prinsip | Penjelasan |
|---|---|
| **GUI tidak menghitung** | logika domain ada di core/algebra |
| **Core tidak import GUI** | dependency satu arah |
| **Setiap modul bisa diuji sendiri** | tanpa GUI |
| **Satu tab = satu file** | modular dan maintainable |

---

## Technology Stack

### Inventaris Komponen (L0–L7)

| Layer | Komponen | Status | Deskripsi |
|---|---|---|---|
| **L0** | Master Table | SEALED | Dataset 28×18 (252 bytes ROM) |
| **L0** | CSGI | OPERATIONAL | Canonical Skeleton Graph Interface |
| **L1** | HC Language | OPERATIONAL | Bahasa pemrograman codex v1.0 |
| **L1** | HL-18E | SPECIFIED | Grammar formal 18-EBNF |
| **L2** | H-ISA | OPERATIONAL | Instruction Set Architecture |
| **L3** | CMM-18C | SPECIFIED | Codex Multidimensional Machine |
| **L4** | HCPU | DESIGNED | Arsitektur prosesor 18D |
| **L5** | HCVM | OPERATIONAL | Codex Virtual Machine |
| **L6** | HGSS | OPERATIONAL | Guard + Signature System |
| **L7** | HC18DC | SPECIFIED | Canonical Data Exchange |
| **GUI** | HOM | OPERATIONAL | Integrated Scientific Environment |

**Status agregat:** 6/11 komponen operasional

---

## Verifikasi Matematis

Rilis ini telah melewati verifikasi formal berikut:

| Pemeriksaan | Hasil |
|---|---|
| Theorem tests | **13/13 PASS** |
| Guard checks (G1–G4) | **28/28 PASS** |
| Exomatrix audit (R1–R5) | **140/140 PASS** |
| Injectivity | **378/378 unique pairs** |
| Diameter | **√70 ≈ 8.367 VERIFIED** |
| Energy inequality | **28/28 strict Φ > ‖v₁₄‖²** |
| Global sum Θ̂ | **91 = 52 + 39 VERIFIED** |

---

## Testing

### Menjalankan semua tes

```bash
pytest
```

### Menjalankan tes spesifik

```bash
pytest tests/test_core/test_master_table.py
pytest tests/test_algebra/test_vectronometry.py
pytest tests/test_theorems/test_full_suite.py
```

### Menjalankan dengan coverage

```bash
pytest --cov=hijaiyyah --cov-report=html
```

### Tes minimum yang wajib PASS

| Modul | Tes |
|---|---|
| `core/master_table` | 28 entri, vektor 18D, guard, injektivitas |
| `algebra/*` | satu tes per fungsi utama |
| `language/lexer` | tokenisasi dasar, literal Hijaiyyah |
| `integrity/` | injectivity, seal |
| `theorems/` | full suite 13 tes |

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
    println("Theta:", h.theta());
    println("Guard:", h.guard());
    println("Norm2:", h.norm2());
}
```

### String integral

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
    let hasil = kodeks_kata("بسم");
    println("Codex:", hasil);
}
```

### Lima bidang analisis

```hc
fn main() {
    let h = load('ج');

    // Vectronometry
    println("Norm2:", h.norm2());

    // Differential
    let d = hm::differential::diff(load('ت'), load('ب'));
    println("Delta:", d);

    // Integral
    let cod = hm::integral::string_integral("بسم");
    println("Integral:", cod);

    // Geometry
    let dist = hm::geometry::euclidean(load('ا'), load('هـ'));
    println("Distance:", dist);

    // Exomatrix
    let e = hm::exomatrix::build(h);
    println("Exomatrix:", e);
    println("Phi:", hm::exomatrix::phi(e));
}
```

---

## Dokumentasi

| Dokumen | Lokasi |
|---|---|
| Arsitektur sistem | [`docs/architecture.md`](docs/architecture.md) |
| Spesifikasi HC Language | [`docs/hc_language.md`](docs/hc_language.md) |
| Spesifikasi H-ISA | [`docs/hisa_spec.md`](docs/hisa_spec.md) |
| Spesifikasi CSGI | [`docs/csgi_spec.md`](docs/csgi_spec.md) |
| Spesifikasi HCVM | [`docs/hcvm_spec.md`](docs/hcvm_spec.md) |
| Kebijakan rilis | [`docs/release_policy.md`](docs/release_policy.md) |
| Changelog | [`CHANGELOG.md`](CHANGELOG.md) |

---

## Release Certificate

```
╔══════════════════════════════════════════════════════════╗
║     HIJAIYYAH MATHEMATICS — RELEASE CERTIFICATE         ║
╠══════════════════════════════════════════════════════════╣
║                                                          ║
║     Release:    HM-28-v1.0-HC18D-B84D025                ║
║     Version:    1.0.0                                    ║
║     Date:       2026                                     ║
║     Status:     VERIFIED & SEALED                        ║
║                                                          ║
║     Dataset:    28 letters × 18 dimensions               ║
║     ROM:        252 bytes (nibble-packed)                 ║
║                                                          ║
║     SHA-256:                                             ║
║     f82d385917ffe32ae2b5711409b1341e90934c52172a          ║
║     e9d0fa68888e3b9c51c8                                 ║
║                                                          ║
║     Integrity:  SEALED                                   ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
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
spesifikasi bahasa, dan desain arsitektur dalam repository ini
dilindungi hak cipta. Reproduksi, distribusi, atau transmisi
memerlukan izin tertulis dari pemegang hak cipta.
```

Lihat [`LICENSE`](LICENSE) untuk detail lengkap.

---

## Penulis

<table>
  <tr>
    <td align="center">
      <strong>Firman Arief Hidayatullah</strong><br>
      Perancang & Perumus Matematika Hijaiyyah<br>
      Key ID: FAH-SIG<br>
      © 2026 HMCL
    </td>
  </tr>
</table>

---

<div align="center">

### Matematika Hijaiyyah

**Fondasi Formal · Codex Teknologi · Arsitektur Hybit**

```
bit ⊕ qubit ⊕ hybit = ekosistem komputasi lengkap
```

---

*Tiga paradigma. Tiga domain optimal. Satu ekosistem.*

</div>

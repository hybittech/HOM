<div align="center">

# **SPESIFIKASI PIPELINE HYBIT LENGKAP**
## Arsitektur File, Kompilasi, Runtime, dan Sistem Operasi

### Integrasi dengan HOM — Tanpa Tumpang Tindih

**HM-28-v1.0-HC18D · 2026**

</div>

---

## Daftar Isi

- [Bagian 0 — Peta Arsitektur Keseluruhan](#bagian-0--peta-arsitektur-keseluruhan)
- [Bagian 1 — Format File](#bagian-1--format-file)
- [Bagian 2 — Level Kompilasi](#bagian-2--level-kompilasi)
- [Bagian 3 — Level Runtime](#bagian-3--level-runtime)
- [Bagian 4 — Level Extended (OS)](#bagian-4--level-extended-os)
- [Bagian 5 — Ringkasan Relasi Tanpa Tumpang Tindih](#bagian-5--ringkasan-relasi-tanpa-tumpang-tindih)

---

## BAGIAN 0 — PETA ARSITEKTUR KESELURUHAN

---

### 0.1 Masalah yang Diselesaikan

HOM yang sudah ada adalah **laboratorium ilmiah** — ia membuktikan matematika, menjalankan analisis, dan memverifikasi teorema. Tetapi HOM **belum** memiliki:

- Pipeline kompilasi penuh (source → binary)
- Format file standar per tahap
- Runtime mandiri (tanpa Python)
- Sistem operasi hybit-native

Dokumen ini mendefinisikan **seluruh pipeline** dari source code sampai eksekusi — dengan setiap komponen memiliki fungsi tunggal yang tidak tumpang tindih.

---

### 0.2 Diagram Pipeline Lengkap

```
PENULIS KODE
    │
    ▼
 ┌──────────┐
 │  .hc     │ ← Source code (bahasa HC)
 └────┬─────┘
      │
      ▼ [HCC — HC Compiler]
      │   ├── Lexer → Token stream
      │   ├── Parser → AST
      │   ├── Ψ-Injector → Hybit augmentation (opsional)
      │   └── Codegen → Assembly
      │
      ▼
 ┌──────────┐
 │ .hasm    │ ← Assembly (human-readable H-ISA)
 └────┬─────┘
      │
      ▼ [HASM — Assembler]
      │   └── Encode opcode + operand → binary
      │
      ▼
 ┌──────────┐
 │ .hbc     │ ← Bytecode (binary executable)
 └────┬─────┘
      │
      ▼ [HVM — Hybit Virtual Machine]
      │   ├── Loader → Parse .hbc
      │   ├── Interpreter → Execute instructions
      │   ├── Hybit Engine → Operasi native (CADD, PROJ, dll.)
      │   ├── Guard System → Validasi G1–G4 per operasi
      │   └── HCHECK → Runtime integrity monitor
      │
      ▼
   OUTPUT
```

**Pipeline paralel — data geometris:**

```
FONT KANONIK (sealed)
    │
    ▼ [Ψ-Compiler]
    │   ├── Rasterisasi
    │   ├── CSGI extraction
    │   ├── MainPath selection
    │   ├── Q₉₀ kuantisasi
    │   └── Klasifikasi N-K-Q
    │
    ▼
 ┌──────────┐
 │ .hgeo    │ ← Geometry data per glyph
 └────┬─────┘
      │
      ▼ [Assembly]
      │
      ▼
 ┌──────────┐
 │  HAR     │ ← Alphabet Registry (master table + metadata)
 └──────────┘
```

---

### 0.3 Tabel Fungsi — Tanpa Tumpang Tindih

| Komponen | Layer | Fungsi TUNGGAL | Input | Output | BUKAN fungsinya |
|----------|-------|---------------|-------|--------|----------------|
| **.hc** | Source | Kode sumber HC | Programmer | Token stream | Bukan bytecode |
| **.hasm** | Assembly | Representasi assembly | Compiler/programmer | Binary | Bukan source code |
| **.hbc** | Binary | Executable bytecode | Assembler | Runtime execution | Bukan teks |
| **.hgeo** | Data | Geometri glyph | Ψ-Compiler | Master Table / HAR | Bukan executable |
| **HAR** | Registry | Database alfabet | .hgeo + metadata | Lookup untuk HVM | Bukan file tunggal |
| **HCC** | Compiler | .hc → .hasm/.hbc | .hc | .hasm atau .hbc | Bukan runtime |
| **HASM** | Assembler | .hasm → .hbc | .hasm | .hbc | Bukan compiler |
| **HVM** | Runtime | Eksekusi .hbc | .hbc + HAR | Output program | Bukan compiler |
| **HCHECK** | Monitor | Deteksi error runtime | HVM state | PASS/FAIL | Bukan guard (subset) |
| **HOS** | OS | Sistem operasi hybit | User/apps | Managed environment | Bukan HVM |
| **HFS** | Storage | File system hybit | Files | Persistent storage | Bukan registry |
| **H-Kernel** | Core | Kernel runtime | HOS | Process/memory mgmt | Bukan HVM |

---

### 0.4 Relasi dengan HOM yang Sudah Ada

```
HOM (SUDAH ADA)                    PIPELINE BARU
─────────────────                   ─────────────

core/master_table ◄────────────── HAR registry (source data)
algebra/* ◄──────────────────────  HVM hybit engine (runtime ops)
language/lexer, parser ◄────────  HCC compiler (expanded)
hisa/* ◄─────────────────────────  HASM assembler (binary encoding)
skeleton/csgi ◄──────────────────  Ψ-Compiler → .hgeo
integrity/* ◄───────────────────  HCHECK (runtime monitor)
gui/* ────────────────────────►   HOS GUI layer (future)
```

**Prinsip:** Pipeline baru **tidak menggantikan** HOM — ia **membangun di atas** HOM. HOM = laboratorium ilmiah. Pipeline = sistem produksi.

---

## BAGIAN 1 — FORMAT FILE

---

### 1.1 `.hc` — Hybit Code (Source)

**Definisi.**

```
Nama lengkap : Hybit Code
Ekstensi     : .hc
Encoding     : UTF-8 (NFC normalized)
Layer        : SOURCE (human-readable)
Fungsi       : Kode sumber bahasa HC — SATU-SATUNYA input programmer
```

**Apa yang BUKAN .hc:**
- ❌ Bukan bytecode (itu .hbc)
- ❌ Bukan assembly (itu .hasm)
- ❌ Bukan data geometri (itu .hgeo)
- ❌ Bukan konfigurasi (itu .toml/.json)

**Struktur file:**

```
// file: hello.hc
// HC source code — UTF-8, NFC normalized

module hello;

use hm::core::load;
use hm::integral;

fn main() {
    let h = load('ب');
    let theta = h.theta();      // Θ̂ = 2
    let guard = h.guard();      // PASS

    println("Theta:", theta);
    println("Guard:", guard);

    // String integral
    let cod = integral::compute("بسم");
    println("∫Θ̂:", cod.theta());     // 10
    assert(cod.theta() == cod.U() + cod.rho());  // 10 = 6 + 4 ✓
}
```

**Grammar (subset kunci):**

```ebnf
program     = { declaration } ;
declaration = module_decl | use_decl | fn_decl ;
fn_decl     = "fn" IDENT "(" params ")" [ "->" type ] block ;
block       = "{" { statement } "}" ;
statement   = let_stmt | expr_stmt | assert_stmt | return_stmt ;
let_stmt    = "let" [ "mut" ] IDENT [ ":" type ] "=" expr ";" ;
expr        = literal | call | binary | unary | field_access ;
literal     = INT | FLOAT | STRING | CHAR | HYBIT_LITERAL ;

(* Hybit-specific *)
HYBIT_LITERAL = "load" "(" CHAR ")" ;
type          = "int" | "float" | "string" | "hybit" | "bool" ;
```

**Dual representation dalam .hc:**

Setiap karakter source code memiliki:

```
Tok(x) = (ID(x), Ψ(x))
```

- `ID(x)` = Unicode codepoint (untuk parsing)
- `Ψ(x)` = hybit value (untuk audit — opsional, diinjeksikan oleh HCC)

---

### 1.2 `.hasm` — Hybit Assembly

**Definisi.**

```
Nama lengkap : Hybit Assembly
Ekstensi     : .hasm
Encoding     : UTF-8
Layer        : ASSEMBLY (human-readable, low-level)
Fungsi       : Representasi teks dari instruksi H-ISA — bridge antara compiler dan binary
```

**Apa yang BUKAN .hasm:**
- ❌ Bukan source code (itu .hc — .hasm tidak punya `fn`, `let`, `if`)
- ❌ Bukan binary (itu .hbc — .hasm masih teks)
- ❌ Bukan output runtime (itu HVM)

**Relasi dengan HOM:** Memperluas `hisa/*` yang sudah ada dengan format file terstandar.

**Contoh file:**

```asm
; file: hello.hasm
; Hybit Assembly — H-ISA instructions

.module hello
.version 1.0
.har 0x0001        ; HAR-001 = Hijaiyyah

.data
    msg_theta: .string "Theta:"
    msg_guard: .string "Guard:"
    letter_ba: .hybit 0x0001 0x0628    ; HAR-001, Unicode U+0628 (ب)

.code
    .entry main

main:
    ; Load hybit dari HAR
    HLOAD   R0, letter_ba       ; R0 ← v₁₈(ب)

    ; Guard check
    HGRD    R0                  ; Validate G1-G4, T1-T2
    JNP     guard_fail          ; Jump if Not Pass

    ; Extract theta
    HPROJ   R1, R0, THETA       ; R1 ← Π_Θ(R0) = 2

    ; Print
    PRINT   msg_theta
    PRINTI  R1                  ; Print integer 2

    ; String integral
    HLOAD   R2, letter_ba       ; ب
    HLOAD   R3, letter_sin      ; س
    HLOAD   R4, letter_mim      ; م
    HCADD   R5, R2, R3          ; R5 ← ب + س
    HCADD   R5, R5, R4          ; R5 ← ب + س + م

    ; Verify identity
    HPROJ   R6, R5, THETA       ; R6 ← ∫Θ̂ = 10
    HDCMP   R7, R8, R5          ; R7 ← U, R8 ← ρ
    IADD    R9, R7, R8          ; R9 ← U + ρ = 6 + 4 = 10
    ICMP    R6, R9              ; Compare
    JNE     identity_fail       ; Jump if not equal

    HALT    0                   ; Exit success

guard_fail:
    PRINT   "GUARD FAIL"
    HALT    1

identity_fail:
    PRINT   "IDENTITY FAIL"
    HALT    2
```

**Instruction Set (H-ISA — diperluas):**

| Kategori | Instruksi | Operand | Fungsi |
|----------|-----------|---------|--------|
| **Hybit Ops** | `HLOAD` | reg, source | Load hybit dari HAR/memory |
| | `HCADD` | dst, src1, src2 | Codex addition: dst ← src1 + src2 |
| | `HGRD` | reg | Guard check G1–G4, T1–T2 |
| | `HPROJ` | dst, src, layer | Proyeksi: Θ/N/K/Q |
| | `HDCMP` | dst_U, dst_ρ, src | Dekomposisi: (U, ρ) ← Θ̂ |
| | `HNRM2` | dst, src | Norma kuadrat: ‖v₁₄‖² |
| | `HDIST` | dst, src1, src2 | Jarak Euclidean |
| | `HEXMT` | dst, src | Bangun eksomatriks 5×5 |
| | `HSER` | addr, reg | Serialize ke HISAB Frame |
| | `HDES` | reg, addr | Deserialize dari HISAB Frame |
| | `HCHK` | reg | Runtime integrity check |
| **Integer Ops** | `IADD` | dst, src1, src2 | Integer addition |
| | `ISUB` | dst, src1, src2 | Integer subtraction |
| | `IMUL` | dst, src1, src2 | Integer multiplication |
| | `ICMP` | src1, src2 | Compare, set flags |
| **Control Flow** | `JMP` | label | Unconditional jump |
| | `JEQ` | label | Jump if equal |
| | `JNE` | label | Jump if not equal |
| | `JNP` | label | Jump if not pass (guard) |
| | `CALL` | label | Call subroutine |
| | `RET` | | Return |
| | `HALT` | code | Terminate with exit code |
| **I/O** | `PRINT` | string | Print string |
| | `PRINTI` | reg | Print integer |
| | `PRINTH` | reg | Print hybit (formatted) |
| **Memory** | `LOAD` | reg, addr | Load from memory |
| | `STORE` | addr, reg | Store to memory |
| | `PUSH` | reg | Push to stack |
| | `POP` | reg | Pop from stack |

---

### 1.3 `.hbc` — Hybit Bytecode

**Definisi.**

```
Nama lengkap : Hybit Bytecode
Ekstensi     : .hbc
Encoding     : Binary (little-endian)
Layer        : BINARY (machine-readable executable)
Fungsi       : Executable untuk HVM — SATU-SATUNYA format yang HVM terima
```

**Apa yang BUKAN .hbc:**
- ❌ Bukan teks (itu .hc atau .hasm)
- ❌ Bukan data geometri (itu .hgeo)
- ❌ Bukan Python bytecode (itu .pyc)

**Relasi dengan HOM:** Menggantikan representasi in-memory HCVM yang sudah ada dengan format file terstandar dan portabel.

**Struktur binary:**

```
┌─────────────────────────────────────────────┐
│ HEADER (32 bytes)                            │
├─────────────────────────────────────────────┤
│ Magic:        "HBYT" (4 bytes: 0x48425954)  │
│ Version:      uint16 (major.minor)           │
│ HAR-ID:       uint16 (primary alphabet)      │
│ Flags:        uint16 (see below)             │
│ Entry point:  uint32 (offset into code)      │
│ Const offset: uint32 (offset to const pool)  │
│ Code offset:  uint32 (offset to code section)│
│ Code size:    uint32 (bytes)                 │
│ Data offset:  uint32 (offset to data section)│
│ Data size:    uint32 (bytes)                 │
│ Checksum:     uint32 (CRC32 of all above)    │
├─────────────────────────────────────────────┤
│ CONSTANT POOL                                │
│   [type:1][length:2][data:var] × N           │
│   Types: 0x01=int, 0x02=float, 0x03=string  │
│          0x04=hybit, 0x05=har_ref            │
├─────────────────────────────────────────────┤
│ CODE SECTION                                 │
│   [opcode:1][operands:var] × M               │
│   See instruction encoding below             │
├─────────────────────────────────────────────┤
│ DATA SECTION                                 │
│   [hybit vectors, strings, etc.]             │
├─────────────────────────────────────────────┤
│ DEBUG INFO (opsional)                        │
│   [source map, symbol table]                 │
└─────────────────────────────────────────────┘
```

**Flags field:**

| Bit | Nama | Deskripsi |
|-----|------|-----------|
| 0 | `HAS_DEBUG` | Debug info tersedia |
| 1 | `HAS_PSI` | Ψ-augmented source |
| 2 | `GUARD_STRICT` | Setiap HCADD wajib guard check |
| 3 | `HAR_EMBEDDED` | HAR data tertanam dalam .hbc |
| 4–15 | Reserved | |

**Instruction encoding:**

```
Setiap instruksi:
┌──────────┬────────────┬────────────┐
│ Opcode   │ Fmt byte   │ Operands   │
│ (1 byte) │ (1 byte)   │ (0-8 byte) │
└──────────┴────────────┴────────────┘

Opcode table:
  0x01 = HLOAD    (fmt: reg8, source16)
  0x02 = HCADD    (fmt: reg8, reg8, reg8)
  0x03 = HGRD     (fmt: reg8)
  0x04 = HPROJ    (fmt: reg8, reg8, layer4)
  0x05 = HDCMP    (fmt: reg8, reg8, reg8)
  0x06 = HNRM2    (fmt: reg8, reg8)
  0x07 = HDIST    (fmt: reg8, reg8, reg8)
  0x08 = HEXMT    (fmt: reg8, reg8)
  0x09 = HSER     (fmt: addr16, reg8)
  0x0A = HDES     (fmt: reg8, addr16)
  0x0B = HCHK     (fmt: reg8)

  0x10 = IADD     (fmt: reg8, reg8, reg8)
  0x11 = ISUB     (fmt: reg8, reg8, reg8)
  0x12 = IMUL     (fmt: reg8, reg8, reg8)
  0x13 = ICMP     (fmt: reg8, reg8)

  0x20 = JMP      (fmt: offset16)
  0x21 = JEQ      (fmt: offset16)
  0x22 = JNE      (fmt: offset16)
  0x23 = JNP      (fmt: offset16)
  0x24 = CALL     (fmt: offset16)
  0x25 = RET      (fmt: -)
  0x26 = HALT     (fmt: code8)

  0x30 = PRINT    (fmt: const_idx16)
  0x31 = PRINTI   (fmt: reg8)
  0x32 = PRINTH   (fmt: reg8)

  0x40 = LOAD     (fmt: reg8, addr16)
  0x41 = STORE    (fmt: addr16, reg8)
  0x42 = PUSH     (fmt: reg8)
  0x43 = POP      (fmt: reg8)
```

---

### 1.4 `.hgeo` — Hybit Geometry File

**Definisi.**

```
Nama lengkap : Hybit Geometry File
Ekstensi     : .hgeo
Encoding     : JSON (UTF-8, NFC) atau Binary
Layer        : DATA (geometry extraction output)
Fungsi       : Menyimpan hasil ekstraksi geometris glyph — output Ψ-Compiler, input HAR
```

**Apa yang BUKAN .hgeo:**
- ❌ Bukan executable (itu .hbc)
- ❌ Bukan source code (itu .hc)
- ❌ Bukan master table (itu HAR — .hgeo adalah input untuk HAR)
- ❌ Bukan font file (itu .ttf/.otf — .hgeo adalah HASIL ekstraksi dari font)

**Relasi dengan HOM:** Memformalkan output `skeleton/csgi` yang sudah ada menjadi format file terstandar.

**Struktur JSON:**

```json
{
    "hgeo_version": "1.0",
    "har_id": "HAR-001",
    "glyph_id": "U+0628",
    "glyph_name": "ب",

    "canonical_lock": {
        "font": "KFGQPC Hafs Uthmanic Script",
        "font_hash": "sha256:abc123...",
        "resolution_ppem": 256
    },

    "extraction_params": {
        "algorithm": "zhang-suen",
        "adjacency": "8-neighborhood",
        "prune_length": 3,
        "dot_max_area": 50,
        "corner_angle_deg": 60,
        "smooth_window": 3
    },

    "skeleton": {
        "nodes": [
            {"id": 0, "x": 45, "y": 12, "kind": "ENDPOINT"},
            {"id": 1, "x": 120, "y": 89, "kind": "JUNCTION"},
            {"id": 2, "x": 200, "y": 45, "kind": "ENDPOINT"}
        ],
        "edges": [
            {
                "id": 0, "u": 0, "v": 1,
                "polyline": [[45,12], [50,15], [60,25], [80,50], [120,89]],
                "type": "QAWS",
                "subtype": "Qp",
                "pixel_count": 85,
                "curvature_total": 3.14
            },
            {
                "id": 1, "u": 1, "v": 2,
                "polyline": [[120,89], [140,90], [160,85], [200,45]],
                "type": "KHATT",
                "subtype": "Kx",
                "pixel_count": 65,
                "curvature_total": 0.0
            }
        ]
    },

    "dots": [
        {"id": 0, "centroid": [130, 180], "area": 25, "zone": "descender"}
    ],

    "mainpath": {
        "node_sequence": [0, 1, 2],
        "edge_sequence": [0, 1],
        "is_closed": false,
        "total_pixels": 150,
        "score": [150, -1, [0, 0.0], [[45,12],[50,15]]]
    },

    "measurement": {
        "theta_hat": 2,
        "theta_continuous_rad": 3.14,
        "N": [0, 0, 1],
        "K": [0, 1, 0, 0, 0],
        "Q": [1, 0, 0, 0, 0],
        "U": 0,
        "rho": 2,
        "A_N": 1,
        "A_K": 1,
        "A_Q": 1,
        "H_star": 0
    },

    "v18": [2, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0],

    "guard_status": {
        "G1": "PASS",
        "G2": "PASS",
        "G3": "PASS",
        "G4": "PASS",
        "T1": "N/A",
        "T2": "N/A"
    },

    "digest": "sha256:def456..."
}
```

**Pipeline .hgeo:**

```
Font (sealed .ttf) → Ψ-Compiler → .hgeo (per glyph) → HAR Assembly → HAR
```

---

### 1.5 HAR — HISAB Alphabet Registry

**Definisi.**

```
Nama lengkap : HISAB Alphabet Registry
Format       : Direktori terstruktur + manifest
Layer        : REGISTRY (database alfabet)
Fungsi       : Menyimpan master table + metadata per alfabet — SATU-SATUNYA sumber v₁₈ untuk runtime
```

**Apa yang BUKAN HAR:**
- ❌ Bukan file tunggal (itu koleksi terstruktur)
- ❌ Bukan executable (itu data referensi)
- ❌ Bukan font (itu HASIL pengukuran dari font)
- ❌ Bukan .hgeo (itu KUMPULAN .hgeo yang sudah divalidasi + metadata)

**Relasi dengan HOM:** Menggantikan `core/master_table` dan `data/hm28.json` yang sudah ada dengan format portabel dan multi-alfabet.

**Struktur direktori HAR:**

```
har/
├── manifest.json              ← Registry manifest (semua alfabet)
├── HAR-001/                   ← Hijaiyyah
│   ├── meta.json              ← Metadata alfabet
│   ├── canonical_lock.json    ← Font info + SHA-256
│   ├── master_table.json      ← 28 × 18 matrix
│   ├── master_table.rom       ← 252 bytes nibble-packed
│   ├── validation/
│   │   ├── guard_report.json  ← G1–G4: 112/112
│   │   ├── inject_report.json ← 378/378 unique
│   │   ├── r1r5_report.json   ← 140/140
│   │   └── rank_analysis.json ← rank = 14
│   ├── glyphs/
│   │   ├── alif.hgeo          ← .hgeo per huruf
│   │   ├── ba.hgeo
│   │   └── ...
│   └── certificate.json       ← Release certificate + SHA-256
│
├── HAR-002/                   ← Latin Uppercase (future)
│   ├── meta.json
│   ├── canonical_lock.json
│   ├── master_table.json      ← 26 × 18 matrix
│   └── ...
│
└── HAR-010/                   ← HC Programming Core (future)
    ├── meta.json
    ├── canonical_lock.json
    ├── master_table.json      ← ~94 × 18 matrix
    └── ...
```

**manifest.json:**

```json
{
    "har_version": "1.0",
    "registries": [
        {
            "id": "HAR-001",
            "name": "Hijaiyyah",
            "glyph_count": 28,
            "status": "CERTIFIED",
            "certified_date": "2024-01-01",
            "master_table_hash": "sha256:f82d385917ff..."
        },
        {
            "id": "HAR-002",
            "name": "Latin Uppercase",
            "glyph_count": 26,
            "status": "PENDING",
            "certified_date": null,
            "master_table_hash": null
        }
    ]
}
```

---

## BAGIAN 2 — LEVEL KOMPILASI

---

### 2.1 HCC — HC Compiler

**Definisi.**

```
Nama lengkap : HC Compiler
Singkatan    : HCC
Fungsi       : .hc → .hbc (atau .hc → .hasm → .hbc)
Layer        : COMPILATION
```

**Apa yang BUKAN HCC:**
- ❌ Bukan runtime (itu HVM — HCC TIDAK menjalankan kode)
- ❌ Bukan assembler (itu HASM — HCC menghasilkan .hasm, HASM mengubahnya ke .hbc)
- ❌ Bukan Ψ-Compiler (itu pipeline geometri — HCC pipeline bahasa)

**Relasi dengan HOM:** Memperluas `language/lexer` dan `language/parser` yang sudah ada menjadi compiler penuh dengan output terstandar.

**Pipeline HCC:**

```
.hc source
    │
    ▼ [TAHAP 1: LEXER]
    │  Input:  UTF-8 text
    │  Output: Token stream
    │  Fungsi: Memecah teks → token (keyword, identifier, literal, operator)
    │  Dual:   Setiap token mendapat (ID, Ψ) jika flag --psi aktif
    │
    ▼ [TAHAP 2: PARSER]
    │  Input:  Token stream
    │  Output: AST (Abstract Syntax Tree)
    │  Fungsi: Membangun struktur hierarkis dari token
    │  Error:  Syntax error dilaporkan di sini
    │
    ▼ [TAHAP 3: SEMANTIC ANALYZER]
    │  Input:  AST
    │  Output: Annotated AST
    │  Fungsi: Type checking, scope resolution, identifier binding
    │  Error:  Type error, undefined variable dilaporkan di sini
    │
    ▼ [TAHAP 4: Ψ-INJECTOR (opsional)]
    │  Input:  Annotated AST + HAR
    │  Output: Ψ-augmented AST
    │  Fungsi: Menambahkan metadata hybit pada setiap token/identifier
    │  Flag:   --psi (aktifkan), --no-psi (skip)
    │  Catatan: TIDAK mengubah semantik — hanya menambah metadata
    │
    ▼ [TAHAP 5: CODEGEN]
    │  Input:  Annotated AST
    │  Output: .hasm (assembly text)
    │  Fungsi: Mengubah AST → sequence instruksi H-ISA
    │
    ▼ [TAHAP 6: ASSEMBLER (inline)]
    │  Input:  .hasm
    │  Output: .hbc (bytecode binary)
    │  Fungsi: Encode instruksi → binary
    │  Catatan: HCC bisa langsung ke .hbc tanpa file .hasm intermediate
```

**Command line:**

```bash
# Compile langsung ke bytecode
hcc hello.hc -o hello.hbc

# Compile ke assembly (untuk debugging)
hcc hello.hc --emit-asm -o hello.hasm

# Compile dengan Ψ injection
hcc hello.hc --psi --har ./har/ -o hello.hbc

# Compile dengan strict guard (setiap HCADD di-guard)
hcc hello.hc --guard-strict -o hello.hbc
```

**Implementasi referensi:**

```python
class HCCompiler:
    """HC Compiler — .hc → .hbc"""

    def __init__(self, har_path: str = None, psi_mode: bool = False):
        self.lexer = HCLexer()
        self.parser = HCParser()
        self.analyzer = SemanticAnalyzer()
        self.psi_injector = PsiInjector(har_path) if psi_mode else None
        self.codegen = CodeGenerator()
        self.assembler = HASMAssembler()

    def compile(self, source_path: str, output_path: str,
                emit_asm: bool = False) -> CompileResult:
        """Pipeline kompilasi lengkap."""

        # Tahap 1: Lex
        source = read_file(source_path)
        tokens = self.lexer.tokenize(source)

        # Tahap 2: Parse
        ast = self.parser.parse(tokens)

        # Tahap 3: Analyze
        typed_ast = self.analyzer.analyze(ast)

        # Tahap 4: Ψ injection (opsional)
        if self.psi_injector:
            typed_ast = self.psi_injector.inject(typed_ast)

        # Tahap 5: Codegen
        asm_text = self.codegen.generate(typed_ast)

        if emit_asm:
            write_file(output_path, asm_text)
            return CompileResult(success=True, format='hasm')

        # Tahap 6: Assemble
        bytecode = self.assembler.assemble(asm_text)
        write_binary(output_path, bytecode)

        return CompileResult(success=True, format='hbc')
```

---

### 2.2 HASM — Hybit Assembler

**Definisi.**

```
Nama lengkap : Hybit Assembler
Singkatan    : HASM
Fungsi       : .hasm → .hbc (HANYA ini)
Layer        : ASSEMBLY → BINARY
```

**Apa yang BUKAN HASM:**
- ❌ Bukan compiler (itu HCC — HASM tidak memahami HC syntax)
- ❌ Bukan disassembler (itu HDIS — HASM hanya forward direction)
- ❌ Bukan runtime (itu HVM)

**Relasi dengan HOM:** Mengkodifikasikan encoding instruksi yang sudah implicit di `hisa/*`.

**Pipeline HASM:**

```
.hasm text
    │
    ▼ [Pass 1: Label Resolution]
    │  Scan semua label → hitung offset
    │
    ▼ [Pass 2: Instruction Encoding]
    │  Setiap instruksi → opcode + operand bytes
    │
    ▼ [Pass 3: Constant Pool Assembly]
    │  Kumpulkan semua literal → constant pool
    │
    ▼ [Pass 4: Header Generation]
    │  Magic + version + offsets + CRC32
    │
    ▼
.hbc binary
```

---

## BAGIAN 3 — LEVEL RUNTIME

---

### 3.1 HVM — Hybit Virtual Machine

**Definisi.**

```
Nama lengkap : Hybit Virtual Machine
Singkatan    : HVM
Fungsi       : Menjalankan .hbc — SATU-SATUNYA executor bytecode
Layer        : RUNTIME
```

**Apa yang BUKAN HVM:**
- ❌ Bukan compiler (itu HCC)
- ❌ Bukan OS (itu HOS — HVM adalah KOMPONEN di dalam HOS)
- ❌ Bukan Python interpreter (HVM mandiri — tidak bergantung Python di production)

**Relasi dengan HOM:** Memperluas HCVM yang sudah ada menjadi runtime mandiri dengan format file terstandar.

**Arsitektur HVM:**

```
┌─────────────────────────────────────────────────────┐
│                      HVM                             │
│                                                      │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐ │
│  │   LOADER    │  │ INTERPRETER │  │ HYBIT ENGINE │ │
│  │             │  │             │  │              │ │
│  │ Parse .hbc  │→│ Fetch-Decode │→│ HCADD, HGRD  │ │
│  │ Verify hdr  │  │ Execute     │  │ HPROJ, HDCMP │ │
│  │ Load consts │  │ Branch      │  │ HNRM2, HDIST │ │
│  │ Setup entry │  │ Call/Return │  │ HEXMT, HSER  │ │
│  └─────────────┘  └──────┬──────┘  └──────┬───────┘ │
│                          │                 │         │
│  ┌───────────────────────┴─────────────────┘         │
│  │                                                    │
│  │  ┌─────────────┐  ┌──────────────┐                │
│  │  │ GUARD SYSTEM│  │   HCHECK     │                │
│  │  │             │  │              │                │
│  │  │ G1–G4 check │  │ Runtime      │                │
│  │  │ T1–T2 check │  │ integrity    │                │
│  │  │ Per-op or   │  │ monitor      │                │
│  │  │ on-demand   │  │ Corruption   │                │
│  │  │             │  │ detection    │                │
│  │  └─────────────┘  └──────────────┘                │
│  │                                                    │
│  │  ┌─────────────────────────────────┐              │
│  │  │         MEMORY MODEL            │              │
│  │  │                                 │              │
│  │  │  Registers: R0–R15 (18×16-bit) │              │
│  │  │  Stack:     1024 entries        │              │
│  │  │  Heap:      Dynamic             │              │
│  │  │  Constants: From .hbc pool      │              │
│  │  │  HAR:       Loaded at startup   │              │
│  │  └─────────────────────────────────┘              │
│  │                                                    │
│  └────────────────────────────────────────────────────│
└─────────────────────────────────────────────────────┘
```

**Komponen HVM — fungsi masing-masing:**

| Komponen | Fungsi TUNGGAL | Bukan |
|----------|---------------|-------|
| **Loader** | Parse .hbc header, verifikasi magic/CRC, setup memory | Bukan executor |
| **Interpreter** | Fetch-decode-execute loop pada instruksi | Bukan compiler |
| **Hybit Engine** | Eksekusi operasi native hybit (CADD, PROJ, dll.) | Bukan guard |
| **Guard System** | Validasi G1–G4, T1–T2 pada setiap operasi hybit | Bukan HCHECK |
| **HCHECK** | Monitor integritas runtime — deteksi korupsi memori | Bukan guard (lihat §3.2) |

**Implementasi referensi:**

```python
class HVM:
    """Hybit Virtual Machine — .hbc executor."""

    def __init__(self, har_path: str):
        # Memory model
        self.registers = [HybitRegister() for _ in range(16)]  # R0–R15
        self.stack = HybitStack(max_size=1024)
        self.heap = HybitHeap()
        self.constants = []

        # Subsystems
        self.har = HARRegistry(har_path)
        self.guard = GuardSystem()
        self.hcheck = HCheck()
        self.hybit_engine = HybitEngine(self.guard)

        # State
        self.pc = 0  # Program counter
        self.flags = Flags()  # Comparison flags
        self.running = False

    def load(self, hbc_path: str):
        """Load .hbc file into memory."""
        with open(hbc_path, 'rb') as f:
            raw = f.read()

        # Verify header
        header = self._parse_header(raw)
        assert header.magic == 0x48425954, "Invalid magic"
        assert self._verify_crc(raw, header), "CRC mismatch"

        # Load sections
        self.constants = self._parse_constants(raw, header)
        self.code = self._parse_code(raw, header)
        self.data = self._parse_data(raw, header)

        # Set entry point
        self.pc = header.entry_point

        # Load HAR for primary alphabet
        self.har.load(header.har_id)

    def run(self) -> int:
        """Execute loaded bytecode. Returns exit code."""
        self.running = True

        while self.running:
            # HCHECK: periodic integrity scan
            if self.pc % 100 == 0:
                self.hcheck.scan(self.registers, self.stack)

            # Fetch
            instruction = self.code[self.pc]
            self.pc += 1

            # Decode + Execute
            self._execute(instruction)

        return self.exit_code

    def _execute(self, inst):
        """Decode and execute one instruction."""
        match inst.opcode:
            case 0x01:  # HLOAD
                reg, source = inst.operands
                v18 = self.har.lookup(source)
                self.registers[reg].load(v18)

            case 0x02:  # HCADD
                dst, src1, src2 = inst.operands
                result = self.hybit_engine.cadd(
                    self.registers[src1].value,
                    self.registers[src2].value
                )
                if self.flags.guard_strict:
                    status = self.guard.check(result)
                    if not status.passed:
                        self._trap("GUARD_FAIL", status)
                self.registers[dst].load(result)

            case 0x03:  # HGRD
                reg = inst.operands[0]
                status = self.guard.check(self.registers[reg].value)
                self.flags.guard_pass = status.passed

            case 0x04:  # HPROJ
                dst, src, layer = inst.operands
                result = self.hybit_engine.project(
                    self.registers[src].value, layer
                )
                self.registers[dst].load_scalar(result)

            case 0x26:  # HALT
                self.exit_code = inst.operands[0]
                self.running = False
```

---

### 3.2 Guard System vs HCHECK — Perbedaan Presisi

| Aspek | Guard System | HCHECK |
|-------|-------------|--------|
| **Kapan** | Pada setiap operasi hybit (HCADD, HLOAD) | **Periodik** (setiap N instruksi) atau on-demand |
| **Apa yang diperiksa** | G1–G4, T1–T2 pada **satu vektor** | **Seluruh state** HVM (register, stack, heap) |
| **Deteksi** | Inkonsistensi geometris dalam satu operasi | **Korupsi memori** — bit flip, buffer overflow |
| **Kompleksitas** | O(1) per operasi | O(R + S) per scan (R=register, S=stack entries) |
| **Analog** | Type checker (per statement) | Memory sanitizer (periodic scan) |
| **Kegagalan** | GUARD_FAIL → operasi ditolak | CORRUPTION → program dihentikan |

**Implementasi HCHECK:**

```python
class HCheck:
    """Runtime Integrity Monitor — deteksi korupsi memori."""

    def scan(self, registers, stack):
        """
        Scan seluruh state untuk korupsi.

        Berbeda dari Guard System:
        - Guard: "apakah OPERASI INI valid?"
        - HCheck: "apakah SELURUH STATE masih konsisten?"
        """
        failures = []

        # 1. Scan semua register yang berisi hybit
        for i, reg in enumerate(registers):
            if reg.has_hybit:
                passed, errs = guard_check(reg.value)
                if not passed:
                    failures.append(f"R{i}: {errs}")

        # 2. Scan stack entries yang berisi hybit
        for i, entry in enumerate(stack.entries):
            if entry.is_hybit:
                passed, errs = guard_check(entry.value)
                if not passed:
                    failures.append(f"Stack[{i}]: {errs}")

        # 3. Verify HAR integrity
        if not self.verify_har_hash():
            failures.append("HAR: hash mismatch — possible corruption")

        return HCheckResult(
            passed=len(failures) == 0,
            failures=failures
        )
```

---

## BAGIAN 4 — LEVEL EXTENDED (OS)

---

### 4.1 HOS — Hybit Operating System

**Definisi.**

```
Nama lengkap : Hybit Operating System
Singkatan    : HOS
Fungsi       : Sistem operasi yang menjalankan HVM sebagai runtime utama
Layer        : OPERATING SYSTEM
Status       : AT (Aspirational Target)
```

**Apa yang BUKAN HOS:**
- ❌ Bukan HVM (HVM = satu komponen DI DALAM HOS)
- ❌ Bukan HOM (HOM = laboratorium ilmiah; HOS = OS produksi)
- ❌ Bukan Linux/Windows (HOS = OS khusus hybit-native)

**Arsitektur HOS:**

```
┌─────────────────────────────────────────────────────┐
│                    APPLICATIONS                      │
│   .hbc programs │ HC REPL │ HOM Scientific GUI      │
├─────────────────────────────────────────────────────┤
│                    HOS SHELL                         │
│   Command interpreter │ File manager │ Package mgr  │
├─────────────────────────────────────────────────────┤
│                    HOS SERVICES                      │
│   HAR Manager │ HISAB Network │ Guard Monitor       │
├─────────────────────────────────────────────────────┤
│                    HVM (Runtime)                     │
│   Interpreter │ Hybit Engine │ Guard │ HCHECK       │
├─────────────────────────────────────────────────────┤
│                    H-KERNEL                          │
│   Process Mgmt │ Memory Mgmt │ I/O │ HFS Driver    │
├─────────────────────────────────────────────────────┤
│                    HFS (File System)                 │
│   .hc │ .hasm │ .hbc │ .hgeo │ HAR │ HISAB frames  │
├─────────────────────────────────────────────────────┤
│                    HARDWARE / HOST OS                │
│   x86/ARM/RISC-V │ atau HCPU (future)              │
└─────────────────────────────────────────────────────┘
```

---

### 4.2 HFS — Hybit File System

**Definisi.**

```
Nama lengkap : Hybit File System
Singkatan    : HFS
Fungsi       : Menyimpan dan mengorganisir file hybit-aware
Layer        : STORAGE
Status       : AT
```

**Apa yang BUKAN HFS:**
- ❌ Bukan HAR (HAR = registry alfabet; HFS = file system UMUM)
- ❌ Bukan ext4/NTFS (HFS = hybit-aware, bukan general purpose)

**Fitur unik HFS:**

| Fitur | Deskripsi | Tidak ada di ext4/NTFS |
|-------|-----------|----------------------|
| **Guard-on-write** | Setiap file .hbc di-guard saat ditulis | ✓ |
| **HAR indexing** | HAR registry di-index natively | ✓ |
| **HISAB frame storage** | HISAB frames sebagai first-class objects | ✓ |
| **Integrity chain** | SHA-256 chain antar file terkait | ✓ |

---

### 4.3 H-Kernel

**Definisi.**

```
Nama lengkap : Hybit Kernel
Singkatan    : H-Kernel
Fungsi       : Core runtime HOS — process management, memory management
Layer        : KERNEL
Status       : AT
```

**Apa yang BUKAN H-Kernel:**
- ❌ Bukan HVM (HVM = user-space runtime; H-Kernel = kernel-space)
- ❌ Bukan Linux kernel (H-Kernel = hybit-native)

**Komponen H-Kernel:**

| Komponen | Fungsi | Relasi |
|----------|--------|--------|
| **Process Manager** | Menjalankan multiple HVM instances | HVM = satu process |
| **Memory Manager** | Alokasi memori hybit-aware | 18-wide alignment |
| **I/O Manager** | File I/O, network I/O | HFS driver |
| **Guard Daemon** | Background guard monitoring | HCHECK = user-space; Daemon = kernel-space |

---

## BAGIAN 5 — RINGKASAN RELASI TANPA TUMPANG TINDIH

---

### 5.1 Tabel Definitif: Setiap Komponen = Satu Fungsi

```
SOURCE LAYER
    .hc ────────── Source code (programmer menulis ini)
                   BUKAN: assembly, binary, data

COMPILATION LAYER
    HCC ────────── .hc → .hasm/.hbc (compiler)
                   BUKAN: runtime, assembler saja, Ψ-compiler

    HASM ───────── .hasm → .hbc (assembler)
                   BUKAN: compiler, disassembler, runtime

BINARY LAYER
    .hasm ──────── Assembly text (human-readable H-ISA)
                   BUKAN: source code, binary, data

    .hbc ───────── Bytecode binary (machine-readable)
                   BUKAN: source, assembly, data

DATA LAYER
    .hgeo ──────── Geometry extraction per glyph
                   BUKAN: executable, source, master table

    HAR ────────── Alphabet registry (master tables + validation)
                   BUKAN: single file, executable, font

RUNTIME LAYER
    HVM ────────── Execute .hbc (virtual machine)
                   BUKAN: compiler, OS, Python

    Guard ──────── Validate per-operation (G1–G4, T1–T2)
                   BUKAN: HCHECK, CRC, compiler check

    HCHECK ─────── Monitor runtime integrity (periodic scan)
                   BUKAN: Guard, compiler, OS service

OS LAYER (future)
    HOS ────────── Operating system (manages HVM, HFS, services)
                   BUKAN: HVM, HOM, Linux

    HFS ────────── File system (hybit-aware storage)
                   BUKAN: HAR, ext4, memory

    H-Kernel ───── Kernel (process, memory, I/O management)
                   BUKAN: HVM, user-space
```

### 5.2 Diagram Dependency (Siapa Butuh Siapa)

```
.hc ──→ HCC ──→ .hasm ──→ HASM ──→ .hbc ──→ HVM ──→ OUTPUT
                                      ↑         ↑
                                      │         │
Font ──→ Ψ-Compiler ──→ .hgeo ──→ HAR ────────┘
                                      │
                                      │
                                   HISAB ← Bab IV (pertukaran)
                                      │
                                   HISAB Universal ← Bab V (unitisasi)
```

### 5.3 Status Implementasi

| Komponen | Status | Prioritas |
|----------|--------|-----------|
| **.hc** format | **✅ OPERATIONAL** (di HOM) | — |
| **HCC** | **✅ PARTIAL** (lexer+parser di HOM; codegen baru) | **P1** |
| **.hasm** format | **📐 SPECIFIED** (dokumen ini) | P2 |
| **HASM** | **📐 SPECIFIED** | P2 |
| **.hbc** format | **📐 SPECIFIED** (dokumen ini) | P1 |
| **.hgeo** format | **📐 SPECIFIED** (dokumen ini) | P1 |
| **HAR** | **✅ PARTIAL** (HAR-001 data di HOM; format baru) | **P0** |
| **HVM** | **✅ OPERATIONAL** (HCVM di HOM; diperluas) | **P1** |
| **Guard System** | **✅ OPERATIONAL** (di HOM) | — |
| **HCHECK** | **📐 SPECIFIED** (dokumen ini) | P3 |
| **HOS** | **📝 DESIGNED** | P4 |
| **HFS** | **📝 DESIGNED** | P4 |
| **H-Kernel** | **📝 DESIGNED** | P4 |

---

<div align="center">

**SPESIFIKASI PIPELINE HYBIT — v1.0**

*HM-28-v1.0-HC18D · 2026*

© 2026 Hijaiyyah Mathematics Computational Laboratory (HMCL)

</div>

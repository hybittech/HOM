"""
HC v1.0 TOKEN DEFINITIONS
==========================
Canonical source for all token types and the Token dataclass.
The Lexer imports from here — not the other way around.

Release: HM-28-v1.0-HC18D
"""

from __future__ import annotations

from dataclasses import dataclass
from enum import Enum, auto
from typing import Dict, List, Tuple


class TokenType(Enum):
    """All token types recognized by the HC v1.0 lexer."""

    # ── Literals ──────────────────────────────────────────────────
    INTEGER = auto()  # 42
    FLOAT = auto()  # 3.14
    HIJAIYYAH = auto()  # 'ب' or bare ب
    STRING_LIT = auto()  # "double-quoted"

    # ── Arithmetic ────────────────────────────────────────────────
    PLUS = auto()  # +
    MINUS = auto()  # -
    STAR = auto()  # *
    SLASH = auto()  # /
    PERCENT = auto()  # %

    # ── Logical ───────────────────────────────────────────────────
    AMP_AMP = auto()  # &&
    PIPE_PIPE = auto()  # ||
    BANG = auto()  # !

    # ── Comparison ────────────────────────────────────────────────
    EQ = auto()  # ==
    NEQ = auto()  # !=
    LT = auto()  # <
    GT = auto()  # >
    LTE = auto()  # <=
    GTE = auto()  # >=

    # ── Assignment ────────────────────────────────────────────────
    ASSIGN = auto()  # =
    PLUS_EQ = auto()  # +=
    MINUS_EQ = auto()  # -=
    STAR_EQ = auto()  # *=
    SLASH_EQ = auto()  # /=

    # ── Punctuation ───────────────────────────────────────────────
    DOT = auto()  # .
    DOT_DOT = auto()  # ..
    DOT_DOT_EQ = auto()  # ..=
    COMMA = auto()  # ,
    COLON = auto()  # :
    SEMICOLON = auto()  # ;
    HASH = auto()  # #
    QUESTION = auto()  # ?
    ARROW = auto()  # ->
    FAT_ARROW = auto()  # =>
    DCOLON = auto()  # ::
    UNDERSCORE = auto()  # _ (wildcard)

    # ── Delimiters ────────────────────────────────────────────────
    LPAREN = auto()  # (
    RPAREN = auto()  # )
    LBRACE = auto()  # {
    RBRACE = auto()  # }
    LBRACKET = auto()  # [
    RBRACKET = auto()  # ]

    # ── Keywords ──────────────────────────────────────────────────
    KW_LET = auto()
    KW_MUT = auto()
    KW_CONST = auto()
    KW_FN = auto()
    KW_RETURN = auto()
    KW_IF = auto()
    KW_ELSE = auto()
    KW_MATCH = auto()
    KW_FOR = auto()
    KW_IN = auto()
    KW_WHILE = auto()
    KW_BREAK = auto()
    KW_CONTINUE = auto()
    KW_TYPE = auto()
    KW_STRUCT = auto()
    KW_ENUM = auto()
    KW_USE = auto()
    KW_TRY = auto()
    KW_CATCH = auto()
    KW_TRUE = auto()
    KW_FALSE = auto()
    KW_NONE = auto()

    # ── Legacy / Built-in commands ────────────────────────────────
    KW_CODEX = auto()
    KW_INSPECT = auto()
    KW_AUDIT = auto()
    KW_VERIFY = auto()

    # ── Special ───────────────────────────────────────────────────
    IDENTIFIER = auto()
    NEWLINE = auto()
    EOF = auto()
    UNKNOWN = auto()


@dataclass(frozen=True)
class Token:
    """
    Immutable lexical token with source position.

    Attributes:
        type:  TokenType enum value
        value: Raw string content of the token
        line:  1-based line number in source
        col:   1-based column number in source
    """

    type: TokenType
    value: str
    line: int
    col: int

    def __repr__(self) -> str:
        v = repr(self.value) if len(self.value) <= 20 else repr(self.value[:17] + "...")  # type: ignore[misc]
        return f"Token({self.type.name}, {v}, L{self.line}:{self.col})"

    def is_keyword(self) -> bool:
        """Check if this token is any keyword type."""
        name: str = self.type.name  # type: ignore[assignment]
        return name.startswith("KW_")

    def is_literal(self) -> bool:
        """Check if this token is a literal value."""
        return self.type in (
            TokenType.INTEGER,
            TokenType.FLOAT,
            TokenType.STRING_LIT,
            TokenType.HIJAIYYAH,
            TokenType.KW_TRUE,
            TokenType.KW_FALSE,
            TokenType.KW_NONE,
        )

    def is_operator(self) -> bool:
        """Check if this token is an operator."""
        return self.type in (
            TokenType.PLUS,
            TokenType.MINUS,
            TokenType.STAR,
            TokenType.SLASH,
            TokenType.PERCENT,
            TokenType.AMP_AMP,
            TokenType.PIPE_PIPE,
            TokenType.BANG,
            TokenType.EQ,
            TokenType.NEQ,
            TokenType.LT,
            TokenType.GT,
            TokenType.LTE,
            TokenType.GTE,
        )


# ── Keyword lookup table ─────────────────────────────────────────

KEYWORDS: Dict[str, TokenType] = {
    "let": TokenType.KW_LET,
    "mut": TokenType.KW_MUT,
    "const": TokenType.KW_CONST,
    "fn": TokenType.KW_FN,
    "return": TokenType.KW_RETURN,
    "if": TokenType.KW_IF,
    "else": TokenType.KW_ELSE,
    "match": TokenType.KW_MATCH,
    "for": TokenType.KW_FOR,
    "in": TokenType.KW_IN,
    "while": TokenType.KW_WHILE,
    "break": TokenType.KW_BREAK,
    "continue": TokenType.KW_CONTINUE,
    "type": TokenType.KW_TYPE,
    "struct": TokenType.KW_STRUCT,
    "enum": TokenType.KW_ENUM,
    "use": TokenType.KW_USE,
    "try": TokenType.KW_TRY,
    "catch": TokenType.KW_CATCH,
    "true": TokenType.KW_TRUE,
    "false": TokenType.KW_FALSE,
    "none": TokenType.KW_NONE,
    # Legacy
    "codex": TokenType.KW_CODEX,
    "inspect": TokenType.KW_INSPECT,
    "audit": TokenType.KW_AUDIT,
    "verify": TokenType.KW_VERIFY,
}

# ── Operator lookup tables ───────────────────────────────────────

# Multi-character operators (ordered longest-first for greedy matching)
MULTI_CHAR_OPS: List[Tuple[str, TokenType]] = [
    ("..=", TokenType.DOT_DOT_EQ),
    ("..", TokenType.DOT_DOT),
    ("&&", TokenType.AMP_AMP),
    ("||", TokenType.PIPE_PIPE),
    ("==", TokenType.EQ),
    ("!=", TokenType.NEQ),
    ("<=", TokenType.LTE),
    (">=", TokenType.GTE),
    ("->", TokenType.ARROW),
    ("=>", TokenType.FAT_ARROW),
    ("::", TokenType.DCOLON),
    ("+=", TokenType.PLUS_EQ),
    ("-=", TokenType.MINUS_EQ),
    ("*=", TokenType.STAR_EQ),
    ("/=", TokenType.SLASH_EQ),
]

# Single-character operators and delimiters
SINGLE_CHAR_OPS: Dict[str, TokenType] = {
    "+": TokenType.PLUS,
    "-": TokenType.MINUS,
    "*": TokenType.STAR,
    "/": TokenType.SLASH,
    "%": TokenType.PERCENT,
    "!": TokenType.BANG,
    ".": TokenType.DOT,
    "#": TokenType.HASH,
    "?": TokenType.QUESTION,
    "<": TokenType.LT,
    ">": TokenType.GT,
    "=": TokenType.ASSIGN,
    "(": TokenType.LPAREN,
    ")": TokenType.RPAREN,
    "{": TokenType.LBRACE,
    "}": TokenType.RBRACE,
    "[": TokenType.LBRACKET,
    "]": TokenType.RBRACKET,
    ",": TokenType.COMMA,
    ";": TokenType.SEMICOLON,
    ":": TokenType.COLON,
}

# ── String escape map ────────────────────────────────────────────

ESCAPE_MAP: Dict[str, str] = {
    "n": "\n",
    "t": "\t",
    "r": "\r",
    "\\": "\\",
    '"': '"',
    "'": "'",
    "0": "\0",
}

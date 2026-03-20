"""
HC v1.0 Language Module
=======================
Lexer, Parser, Evaluator, and Grammar for the Hijaiyyah Codex Language.
"""

from hijaiyyah.language.tokens import TokenType, Token, KEYWORDS
from hijaiyyah.language.lexer import Lexer, tokenize
from hijaiyyah.language.ast_nodes import (
    ASTNode,
    Program,
    LetStmt,
    ConstStmt,
    FnDecl,
    Block,
    Literal,
    VarRef,
    BinaryExpr,
    MethodCall,
    CallExpr,
    IfExpr,
    ForStmt,
    WhileStmt,
    MatchExpr,
    IndexExpr,
)
from hijaiyyah.language.parser import Parser, ParseError
from hijaiyyah.language.evaluator import HCEvaluator
from hijaiyyah.language.grammar import (
    FORMAL_GRAMMAR,
    SLOT_NAMES,
    LATIN_NAMES,
    GROUP_NAMES,
    HYBIT_METHODS,
    BUILTIN_FUNCTIONS,
    STDLIB_MODULES,
    EXAMPLES,
    EXAMPLE_BY_NAME,
)

__all__ = [
    "TokenType",
    "Token",
    "KEYWORDS",
    "Lexer",
    "tokenize",
    "Parser",
    "ParseError",
    "HCEvaluator",
    "FORMAL_GRAMMAR",
    "SLOT_NAMES",
    "LATIN_NAMES",
    "EXAMPLES",
    "EXAMPLE_BY_NAME",
]

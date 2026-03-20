"""Custom exceptions for the Hijaiyyah Mathematics system."""


class HijaiyyahError(Exception):
    """Base exception for all Hijaiyyah Mathematics errors."""

    pass


class GuardViolation(HijaiyyahError):
    """Raised when a hybit vector fails guard check."""

    pass


class SealMismatch(HijaiyyahError):
    """Raised when dataset SHA-256 does not match expected seal."""

    pass


class EBNFSemanticError(HijaiyyahError):
    """Raised for semantic errors during HC evaluation."""

    pass


class LexerError(HijaiyyahError):
    """Raised for lexical analysis errors."""

    def __init__(self, message: str, line: int = 0, col: int = 0):
        self.line = line
        self.col = col
        super().__init__(f"L{line}:{col}: {message}")


class ParserError(HijaiyyahError):
    """Raised for syntax errors during parsing."""

    def __init__(self, message: str, token=None):
        self.token = token
        if token:
            super().__init__(f"L{token.line}:{token.col}: {message}")
        else:
            super().__init__(message)

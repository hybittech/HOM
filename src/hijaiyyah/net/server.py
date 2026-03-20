"""Minimal HTTP server for hybit API (placeholder)."""


class HCServer:
    def __init__(self, host: str = "127.0.0.1", port: int = 8080):
        self.host = host
        self.port = port

    def run(self):
        print(f"HC Server placeholder: {self.host}:{self.port}")

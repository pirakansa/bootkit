# Rust devcontainer
FROM mcr.microsoft.com/devcontainers/rust:1-bookworm

# ─── 追加パッケージ ──────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# ─── Rust ツールチェーン補足 ──────────────────────────────────────────────────
RUN rustup component add clippy rustfmt rust-analyzer

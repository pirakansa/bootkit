# Python devcontainer
FROM mcr.microsoft.com/devcontainers/python:3-bookworm

# ─── 追加パッケージ ──────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# ─── Python ツール ────────────────────────────────────────────────────────────
RUN pip install --no-cache-dir \
    ruff \
    mypy \
    pytest

# Go devcontainer
FROM mcr.microsoft.com/devcontainers/go:1-bookworm

# ─── 追加パッケージ ──────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

# ─── Go ツール ────────────────────────────────────────────────────────────────
RUN go install golang.org/x/tools/gopls@latest \
    && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

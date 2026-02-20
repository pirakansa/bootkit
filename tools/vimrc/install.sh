#!/usr/bin/env bash
#
# Install .vimrc - personal vim configuration
#
# Requires: vim
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/tools/vimrc/install.sh | bash
#
set -euo pipefail

# ─── Resolve common.sh ───────────────────────────────────────────────────────
BOOTKIT_REPO_RAW="https://raw.githubusercontent.com/pirakansa/bootkit/main"

setup_common() {
  local tmp_common=""
  tmp_common="$(mktemp)"
  if ! curl -fsSL ${BOOTKIT_PROXY:+--proxy "$BOOTKIT_PROXY"} ${BOOTKIT_INSECURE:+-k} -o "$tmp_common" "${BOOTKIT_REPO_RAW}/lib/common.sh"; then
    echo "[error] common.sh のダウンロードに失敗しました。" >&2
    rm -f "$tmp_common"
    exit 1
  fi
  # shellcheck source=../../lib/common.sh
  source "$tmp_common"
  rm -f "$tmp_common"
}

setup_common

# ─── vimrc configuration ─────────────────────────────────────────────────────
TOOL_NAME="vimrc"
VIMRC_PATH="$HOME/.vimrc"

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  info "${TOOL_NAME} のセットアップを開始します..."

  # vim が必要
  require_cmd vim

  # 既存の .vimrc がある場合はスキップ
  if [[ -f "$VIMRC_PATH" ]]; then
    ok "${VIMRC_PATH} は既に存在するためスキップします。"
    return 0
  fi

  # .vimrc を配置
  cat > "$VIMRC_PATH" <<'EOF'
set number
set fenc=utf-8
EOF

  ok "${VIMRC_PATH} を配置しました。"
}

main "$@"

#!/usr/bin/env bash
#
# Install .gitconfig - personal git configuration
#
# Requires: git, vim
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/tools/gitconfig/install.sh | bash
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

# ─── gitconfig configuration ─────────────────────────────────────────────────
TOOL_NAME="gitconfig"
GITCONFIG_PATH="$HOME/.gitconfig"

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  info "${TOOL_NAME} のセットアップを開始します..."

  # git と vim が必要
  require_cmd git vim

  # 既存の .gitconfig がある場合はスキップ
  if [[ -f "$GITCONFIG_PATH" ]]; then
    ok "${GITCONFIG_PATH} は既に存在するためスキップします。"
    return 0
  fi

  # .gitconfig を配置
  cat > "$GITCONFIG_PATH" <<'EOF'
# [user]
# 	email = 
# 	name = 
# 	signingkey = 
[core]
	quotepath = false
	editor = vim
[gpg]
	format = ssh
[commit]
	gpgsign = false
EOF

  ok "${GITCONFIG_PATH} を配置しました。"
}

main "$@"

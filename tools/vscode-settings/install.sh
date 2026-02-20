#!/usr/bin/env bash
#
# Install VS Code settings.json - personal VS Code configuration
#
# Requires: code (VS Code)
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/tools/vscode-settings/install.sh | bash
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

# ─── vscode-settings configuration ───────────────────────────────────────────
TOOL_NAME="vscode-settings"
VSCODE_SETTINGS_DIR="$HOME/.config/Code/User"
VSCODE_SETTINGS_PATH="${VSCODE_SETTINGS_DIR}/settings.json"

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  info "${TOOL_NAME} のセットアップを開始します..."

  # code (VS Code) が必要
  require_cmd code

  # 既存の settings.json がある場合はスキップ
  if [[ -f "$VSCODE_SETTINGS_PATH" ]]; then
    ok "${VSCODE_SETTINGS_PATH} は既に存在するためスキップします。"
    return 0
  fi

  # ディレクトリを作成
  mkdir -p "$VSCODE_SETTINGS_DIR"

  # settings.json を配置
  cat > "$VSCODE_SETTINGS_PATH" <<'EOF'
{
    "github.copilot.chat.localeOverride": "ja",
    "markdown-preview-github-styles.colorTheme": "light",
    "diffEditor.codeLens": true,
    "editor.renderWhitespace": "all",
    "github.copilot.nextEditSuggestions.enabled": true,
    "terminal.integrated.suggest.enabled": false,
    "accessibility.voice.speechLanguage": "ja-JP",
    "http.systemCertificatesNode": true
}
EOF

  ok "${VSCODE_SETTINGS_PATH} を配置しました。"
}

main "$@"

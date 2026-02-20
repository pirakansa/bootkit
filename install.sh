#!/usr/bin/env bash
#
# bootkit - personal tool installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/install.sh | bash -s -- <tool>
#   curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/install.sh | bash -s -- --all
#
set -euo pipefail

BOOTKIT_REPO_RAW="https://raw.githubusercontent.com/pirakansa/bootkit/main"

# ─── Available tools ──────────────────────────────────────────────────────────
TOOLS=(
  codex
)

# ─── Colors (inline for the dispatcher) ──────────────────────────────────────
if [[ -t 1 ]]; then
  RED='\033[0;31m' GREEN='\033[0;32m' CYAN='\033[0;36m'
  BOLD='\033[1m' RESET='\033[0m'
else
  RED='' GREEN='' CYAN='' BOLD='' RESET=''
fi
info()  { printf "${CYAN}${BOLD}[info]${RESET}  %s\n" "$*"; }
error() { printf "${RED}${BOLD}[error]${RESET} %s\n" "$*" >&2; }
ok()    { printf "${GREEN}${BOLD}[ok]${RESET}    %s\n" "$*"; }

# ─── Usage ────────────────────────────────────────────────────────────────────
usage() {
  cat <<EOF
${BOLD}bootkit${RESET} - personal tool installer

${BOLD}Usage:${RESET}
  curl -fsSL .../install.sh | bash -s -- <tool>     特定のツールをインストール
  curl -fsSL .../install.sh | bash -s -- --all       全ツールをインストール
  curl -fsSL .../install.sh | bash -s -- --list      利用可能なツール一覧

${BOLD}利用可能なツール:${RESET}
$(printf "  - %s\n" "${TOOLS[@]}")

${BOLD}環境変数:${RESET}
  BOOTKIT_INSTALL_DIR   インストール先 (default: ~/.local/bin)

EOF
}

# ─── Install a single tool ────────────────────────────────────────────────────
install_tool() {
  local tool="$1"
  local script_url="${BOOTKIT_REPO_RAW}/tools/${tool}/install.sh"

  info "=== ${tool} のインストールを開始 ==="
  local tmp_script=""
  tmp_script="$(mktemp)"
  trap 'rm -f "${tmp_script:-}"' RETURN

  if ! curl -fsSL ${BOOTKIT_PROXY:+--proxy "$BOOTKIT_PROXY"} ${BOOTKIT_INSECURE:+-k} -o "$tmp_script" "$script_url"; then
    error "tools/${tool}/install.sh のダウンロードに失敗しました。"
    return 1
  fi

  bash "$tmp_script"
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  if [[ $# -eq 0 ]]; then
    usage
    exit 0
  fi

  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --list|-l)
      printf "%s\n" "${TOOLS[@]}"
      exit 0
      ;;
    --all|-a)
      info "全ツールをインストールします"
      echo ""
      for tool in "${TOOLS[@]}"; do
        install_tool "$tool"
        echo ""
      done
      ok "全ツールのインストールが完了しました！"
      ;;
    *)
      local tool="$1"
      # Check if tool exists in the list
      local found=false
      for t in "${TOOLS[@]}"; do
        if [[ "$t" == "$tool" ]]; then
          found=true
          break
        fi
      done
      if [[ "$found" != "true" ]]; then
        error "不明なツール: ${tool}"
        error "利用可能なツール: ${TOOLS[*]}"
        exit 1
      fi
      install_tool "$tool"
      ;;
  esac
}

main "$@"

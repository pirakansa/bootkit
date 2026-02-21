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
MANIFEST_BASE_URL="${BOOTKIT_REPO_RAW}/manifests/linux-x64"

# ─── Available tools ──────────────────────────────────────────────────────────
TOOLS=(
  codex
  copilot-cli
  gitconfig
  nodejs
  vimrc
  vscode-settings
)

# ─── Colors (inline for the dispatcher) ──────────────────────────────────────
if [[ -t 1 ]]; then
  RED='\033[0;31m' GREEN='\033[0;32m' CYAN='\033[0;36m'
  YELLOW='\033[0;33m'
  BOLD='\033[1m' RESET='\033[0m'
else
  RED='' GREEN='' CYAN='' YELLOW='' BOLD='' RESET=''
fi
info()  { printf "${CYAN}${BOLD}[info]${RESET}  %s\n" "$*"; }
warn()  { printf "${YELLOW}${BOLD}[warn]${RESET}  %s\n" "$*"; }
error() { printf "${RED}${BOLD}[error]${RESET} %s\n" "$*" >&2; }
ok()    { printf "${GREEN}${BOLD}[ok]${RESET}    %s\n" "$*"; }

require_cmd() {
  local missing=()
  for cmd in "$@"; do
    if ! command -v "$cmd" &>/dev/null; then
      missing+=("$cmd")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    error "必要なコマンドが見つかりません: ${missing[*]}"
    exit 1
  fi
}

check_linux_x64() {
  local os arch
  os="$(uname -s)"
  arch="$(uname -m)"
  if [[ "$os" != "Linux" || "$arch" != "x86_64" ]]; then
    error "現在の bootkit は linux/x86_64 のみ対応です。 (detected: ${os}/${arch})"
    exit 1
  fi
}

manifest_url_for_tool() {
  local tool="$1"
  case "$tool" in
    codex)           echo "${MANIFEST_BASE_URL}/codex.yml" ;;
    copilot-cli)     echo "${MANIFEST_BASE_URL}/copilot-cli.yml" ;;
    gitconfig)       echo "${MANIFEST_BASE_URL}/gitconfig.yml" ;;
    nodejs)          echo "${MANIFEST_BASE_URL}/nodejs.yml" ;;
    vimrc)           echo "${MANIFEST_BASE_URL}/vimrc.yml" ;;
    vscode-settings) echo "${MANIFEST_BASE_URL}/vscode-settings.yml" ;;
    *) return 1 ;;
  esac
}

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
  BOOTKIT_LIB_DIR       ライブラリ配置先 (default: ~/.local/lib)

EOF
}

# ─── Install a single tool ────────────────────────────────────────────────────
install_tool() {
  local tool="$1"
  local manifest_url
  manifest_url="$(manifest_url_for_tool "$tool")"

  info "=== ${tool} のインストールを開始 ==="
  info "マニフェスト: ${manifest_url}"

  if ! ppkgmgr dl --overwrite "$manifest_url"; then
    error "ppkgmgr によるインストールに失敗しました: ${tool}"
    return 1
  fi

  if [[ "$tool" == "nodejs" ]]; then
    info "PATH に以下を追加してください:"
    printf "  ${BOLD}export PATH=\"%s/node/bin:\$PATH\"${RESET}\n" "${BOOTKIT_LIB_DIR:-$HOME/.local/lib}"
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  require_cmd ppkgmgr
  check_linux_x64

  export BOOTKIT_INSTALL_DIR="${BOOTKIT_INSTALL_DIR:-$HOME/.local/bin}"
  export BOOTKIT_LIB_DIR="${BOOTKIT_LIB_DIR:-$HOME/.local/lib}"

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
      info "マニフェスト: ${MANIFEST_BASE_URL}/all.yml"
      ppkgmgr dl --overwrite "${MANIFEST_BASE_URL}/all.yml"
      echo ""
      info "PATH に以下を追加してください:"
      printf "  ${BOLD}export PATH=\"%s:\$PATH\"${RESET}\n" "${BOOTKIT_INSTALL_DIR}"
      printf "  ${BOLD}export PATH=\"%s/node/bin:\$PATH\"${RESET}\n" "${BOOTKIT_LIB_DIR}"
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

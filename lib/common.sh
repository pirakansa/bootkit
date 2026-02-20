#!/usr/bin/env bash
#
# bootkit - common functions
# Sourced by tool install scripts
#
# shellcheck disable=SC2034

# ─── Colors ───────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  RESET='\033[0m'
else
  RED='' GREEN='' YELLOW='' CYAN='' BOLD='' RESET=''
fi

info()  { printf "${CYAN}${BOLD}[info]${RESET}  %s\n" "$*"; }
warn()  { printf "${YELLOW}${BOLD}[warn]${RESET}  %s\n" "$*"; }
error() { printf "${RED}${BOLD}[error]${RESET} %s\n" "$*" >&2; }
ok()    { printf "${GREEN}${BOLD}[ok]${RESET}    %s\n" "$*"; }

# ─── Configuration ────────────────────────────────────────────────────────────
INSTALL_DIR="${BOOTKIT_INSTALL_DIR:-$HOME/.local/bin}"

# ─── Proxy detection ──────────────────────────────────────────────────────────
# curl は http_proxy / https_proxy / HTTPS_PROXY を自動で参照するが、
# 明示的に検出してログ出力 & CURL_PROXY_OPTS に統一する
CURL_PROXY_OPTS=()

setup_proxy() {
  # BOOTKIT_PROXY > https_proxy > HTTPS_PROXY > http_proxy > HTTP_PROXY の順で検出
  local proxy="${BOOTKIT_PROXY:-${https_proxy:-${HTTPS_PROXY:-${http_proxy:-${HTTP_PROXY:-}}}}}"
  if [[ -n "$proxy" ]]; then
    info "プロキシを検出しました: ${proxy}"
    CURL_PROXY_OPTS=(--proxy "$proxy")

    # NO_PROXY / no_proxy が設定されていれば curl の --noproxy に渡す
    local noproxy="${no_proxy:-${NO_PROXY:-}}"
    if [[ -n "$noproxy" ]]; then
      CURL_PROXY_OPTS+=(--noproxy "$noproxy")
    fi
  fi

  # BOOTKIT_INSECURE=1 で証明書検証をスキップ（社内プロキシ等）
  if [[ "${BOOTKIT_INSECURE:-0}" == "1" ]]; then
    warn "証明書検証を無効にしています (BOOTKIT_INSECURE=1)"
    CURL_PROXY_OPTS+=(-k)
  fi
}

# curl のラッパー: プロキシ設定を自動付与
dl() {
  curl -fsSL "${CURL_PROXY_OPTS[@]}" "$@"
}

setup_proxy

# ─── Detect OS ────────────────────────────────────────────────────────────────
detect_os() {
  local os
  os="$(uname -s)"
  case "$os" in
    Linux*)  echo "linux" ;;
    Darwin*) echo "darwin" ;;
    MINGW*|MSYS*|CYGWIN*)
      error "Windows はサポートされていません。WSL をご利用ください。"
      exit 1
      ;;
    *)
      error "未対応の OS です: $os"
      exit 1
      ;;
  esac
}

# ─── Detect Architecture ─────────────────────────────────────────────────────
detect_arch() {
  local arch
  arch="$(uname -m)"
  case "$arch" in
    x86_64|amd64)   echo "x86_64" ;;
    aarch64|arm64)   echo "aarch64" ;;
    armv7l|armhf)    echo "armv7" ;;
    *)
      error "未対応のアーキテクチャです: $arch"
      exit 1
      ;;
  esac
}

# ─── Check required commands ─────────────────────────────────────────────────
require_cmd() {
  local missing=()
  for cmd in "$@"; do
    if ! command -v "$cmd" &>/dev/null; then
      missing+=("$cmd")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    error "必要なコマンドが見つかりません: ${missing[*]}"
    error "インストールしてから再実行してください。"
    exit 1
  fi
}

# ─── Ensure install dir & check PATH ─────────────────────────────────────────
ensure_install_dir() {
  mkdir -p "$INSTALL_DIR"
}

check_path() {
  if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
    echo ""
    warn "${INSTALL_DIR} が PATH に含まれていません。"
    warn "以下をシェルの設定ファイルに追加してください:"
    echo ""
    printf "  ${BOLD}export PATH=\"%s:\$PATH\"${RESET}\n" "$INSTALL_DIR"
    echo ""
  fi
}

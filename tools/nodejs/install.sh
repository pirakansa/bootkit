#!/usr/bin/env bash
#
# Install Node.js
# https://nodejs.org/
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/tools/nodejs/install.sh | bash
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

# ─── Node.js configuration ───────────────────────────────────────────────────
TOOL_NAME="node"
NODE_VERSION="${NODE_VERSION:-v24.13.1}"
LIB_DIR="${BOOTKIT_LIB_DIR:-$HOME/.local/lib}"

# ─── Build download URL ──────────────────────────────────────────────────────
build_node_url() {
  local os arch target

  os="$(detect_os)"
  arch="$(detect_arch)"

  # Linux / WSL
  case "${os}-${arch}" in
    linux-x86_64)    target="linux-x64" ;;
    linux-aarch64)   target="linux-arm64" ;;
    *)
      error "Node.js は ${os}/${arch} をサポートしていません。"
      exit 1
      ;;
  esac

  echo "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-${target}.tar.xz"
}

# ─── Resolve target name ─────────────────────────────────────────────────────
get_node_dir_name() {
  local os arch target

  os="$(detect_os)"
  arch="$(detect_arch)"

  case "${os}-${arch}" in
    linux-x86_64)    target="linux-x64" ;;
    linux-aarch64)   target="linux-arm64" ;;
  esac

  echo "node-${NODE_VERSION}-${target}"
}

# ─── Install ──────────────────────────────────────────────────────────────────
install_node() {
  require_cmd curl tar xz

  local download_url dir_name
  download_url="$(build_node_url)"
  dir_name="$(get_node_dir_name)"

  info "Node.js (${NODE_VERSION}) をインストールします"
  info "ダウンロード中: ${download_url}"

  mkdir -p "$LIB_DIR"
  ensure_install_dir

  # 既にインストール済みならスキップ
  if [[ -d "${LIB_DIR}/${dir_name}" ]]; then
    ok "Node.js (${NODE_VERSION}) は既にインストールされています: ${LIB_DIR}/${dir_name}"
    return 0
  fi

  # ダウンロード & 展開 → ~/.local/lib/node-v24.13.1-linux-x64/
  if ! dl "$download_url" | tar -xJ -C "$LIB_DIR"; then
    error "ダウンロードまたは展開に失敗しました: ${download_url}"
    exit 1
  fi

  if [[ ! -d "${LIB_DIR}/${dir_name}" ]]; then
    error "展開後のディレクトリ '${dir_name}' が見つかりませんでした。"
    exit 1
  fi

  # シンボリックリンク: ~/.local/lib/node → node-v24.13.1-linux-x64
  ln -sfn "${dir_name}" "${LIB_DIR}/node"
  ok "シンボリックリンク: ${LIB_DIR}/node → ${dir_name}"

  ok "Node.js (${NODE_VERSION}) のインストールが完了しました！"
  ok "インストール先: ${LIB_DIR}/node"

  echo ""
  info "PATH に以下を追加してください:"
  printf "  ${BOLD}export PATH=\"%s/node/bin:\$PATH\"${RESET}\n" "$LIB_DIR"

  # Verify
  if command -v node &>/dev/null; then
    echo ""
    info "バージョン確認:"
    node --version 2>/dev/null || true
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────
install_node

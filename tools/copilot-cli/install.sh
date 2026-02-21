#!/usr/bin/env bash
#
# Install copilot-cli - GitHub Copilot CLI
# https://github.com/github/copilot-cli
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/tools/copilot-cli/install.sh | bash
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

# ─── Copilot CLI configuration ───────────────────────────────────────────────
TOOL_NAME="copilot"
COPILOT_CLI_VERSION="${COPILOT_CLI_VERSION:-v0.0.412}"
COPILOT_CLI_REPO="github/copilot-cli"

# ─── Build download URL ──────────────────────────────────────────────────────
build_copilot_cli_url() {
  local os arch target

  os="$(detect_os)"
  arch="$(detect_arch)"

  # Linux / WSL
  case "${os}-${arch}" in
    linux-x86_64)    target="linux-x64" ;;
    linux-aarch64)   target="linux-arm64" ;;
    *)
      error "copilot-cli は ${os}/${arch} をサポートしていません。"
      exit 1
      ;;
  esac

  echo "https://github.com/${COPILOT_CLI_REPO}/releases/download/${COPILOT_CLI_VERSION}/copilot-${target}.tar.gz"
}

# ─── Install ──────────────────────────────────────────────────────────────────
install_copilot_cli() {
  require_cmd curl tar

  local download_url
  download_url="$(build_copilot_cli_url)"

  local os arch target
  os="$(detect_os)"
  arch="$(detect_arch)"
  case "${os}-${arch}" in
    linux-x86_64)    target="linux-x64" ;;
    linux-aarch64)   target="linux-arm64" ;;
  esac

  info "copilot-cli (${COPILOT_CLI_VERSION}) をインストールします"
  info "ダウンロード中: ${download_url}"

  ensure_install_dir

  local tmp_dir=""
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "${tmp_dir:-}"' RETURN

  if ! dl "$download_url" | tar -xz -C "$tmp_dir"; then
    error "ダウンロードまたは展開に失敗しました: ${download_url}"
    exit 1
  fi

  # Archive extracts to: copilot (flat, no subdirectory)
  local extracted="${tmp_dir}/copilot"
  if [[ ! -f "$extracted" ]]; then
    error "アーカイブ内にバイナリ 'copilot' が見つかりませんでした。"
    exit 1
  fi

  mv "$extracted" "${INSTALL_DIR}/${TOOL_NAME}"
  chmod a+x "${INSTALL_DIR}/${TOOL_NAME}"

  ok "copilot-cli (${COPILOT_CLI_VERSION}) のインストールが完了しました！"
  ok "インストール先: ${INSTALL_DIR}/${TOOL_NAME}"

  check_path

  # Verify
  if command -v "$TOOL_NAME" &>/dev/null; then
    echo ""
    info "バージョン確認:"
    "$TOOL_NAME" --version 2>/dev/null || true
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────
install_copilot_cli

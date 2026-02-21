#!/usr/bin/env bash
#
# devcontainer テンプレートをプロジェクトにコピー
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pirakansa/bootkit/main/devcontainers/setup.sh | bash -s -- <template>
#   curl -fsSL .../setup.sh | bash -s -- rust
#   curl -fsSL .../setup.sh | bash -s -- go     [target_dir]
#   curl -fsSL .../setup.sh | bash -s -- --list
#
set -euo pipefail

BOOTKIT_REPO_RAW="https://raw.githubusercontent.com/pirakansa/bootkit/main"

# ─── Available templates ──────────────────────────────────────────────────────
TEMPLATES=(
  rust
  go
  python
)

# ─── Colors ───────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  RED='\033[0;31m' GREEN='\033[0;32m' CYAN='\033[0;36m'
  YELLOW='\033[0;33m' BOLD='\033[1m' RESET='\033[0m'
else
  RED='' GREEN='' CYAN='' YELLOW='' BOLD='' RESET=''
fi
info()  { printf "${CYAN}${BOLD}[info]${RESET}  %s\n" "$*"; }
warn()  { printf "${YELLOW}${BOLD}[warn]${RESET}  %s\n" "$*"; }
error() { printf "${RED}${BOLD}[error]${RESET} %s\n" "$*" >&2; }
ok()    { printf "${GREEN}${BOLD}[ok]${RESET}    %s\n" "$*"; }

# ─── Usage ────────────────────────────────────────────────────────────────────
usage() {
  cat <<EOF
${BOLD}bootkit devcontainer setup${RESET}

${BOLD}Usage:${RESET}
  curl -fsSL .../devcontainers/setup.sh | bash -s -- <template> [target_dir]

${BOLD}引数:${RESET}
  template     テンプレート名 (rust, go, python, ...)
  target_dir   コピー先プロジェクトのルート (default: カレントディレクトリ)

${BOLD}オプション:${RESET}
  --list       利用可能なテンプレート一覧
  --help       このヘルプを表示

${BOLD}利用可能なテンプレート:${RESET}
$(printf "  - %s\n" "${TEMPLATES[@]}")

${BOLD}例:${RESET}
  curl -fsSL .../devcontainers/setup.sh | bash -s -- rust
  curl -fsSL .../devcontainers/setup.sh | bash -s -- go ~/projects/myapp

EOF
}

# ─── Download helper ──────────────────────────────────────────────────────────
dl() {
  curl -fsSL ${BOOTKIT_PROXY:+--proxy "$BOOTKIT_PROXY"} ${BOOTKIT_INSECURE:+-k} "$1"
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  if [[ $# -eq 0 ]]; then
    usage
    exit 1
  fi

  case "${1:-}" in
    --help|-h)
      usage
      exit 0
      ;;
    --list|-l)
      printf "%s\n" "${TEMPLATES[@]}"
      exit 0
      ;;
  esac

  local template="$1"
  local target_dir="${2:-.}"

  # テンプレートの存在確認
  local found=false
  for t in "${TEMPLATES[@]}"; do
    if [[ "$t" == "$template" ]]; then
      found=true
      break
    fi
  done

  if [[ "$found" != "true" ]]; then
    error "不明なテンプレート: ${template}"
    echo ""
    info "利用可能なテンプレート:"
    printf "  - %s\n" "${TEMPLATES[@]}"
    exit 1
  fi

  local devcontainer_dir="${target_dir}/.devcontainer"

  # 既に .devcontainer/ がある場合は確認
  if [[ -d "$devcontainer_dir" ]]; then
    warn ".devcontainer/ が既に存在します: ${devcontainer_dir}"
    if [[ -t 0 ]]; then
      read -rp "上書きしますか? [y/N] " answer
      if [[ ! "$answer" =~ ^[Yy] ]]; then
        info "中断しました。"
        exit 0
      fi
    else
      warn "パイプ実行のため上書きします。"
    fi
  fi

  info "=== devcontainer テンプレート '${template}' のセットアップを開始 ==="

  mkdir -p "$devcontainer_dir"

  # ダウンロードするファイル一覧
  local files=("devcontainer.json" "Dockerfile")
  local base_url="${BOOTKIT_REPO_RAW}/devcontainers/${template}"

  for file in "${files[@]}"; do
    local url="${base_url}/${file}"
    local dest="${devcontainer_dir}/${file}"

    info "ダウンロード中: ${file}"
    if ! dl "$url" > "$dest"; then
      error "ダウンロードに失敗しました: ${url}"
      exit 1
    fi
    ok "${file} → ${dest}"
  done

  echo ""
  ok "devcontainer テンプレート '${template}' のセットアップが完了しました！"
  ok "コピー先: ${devcontainer_dir}"
  echo ""
  info "VS Code で 'Dev Containers: Reopen in Container' を実行してください。"
}

main "$@"

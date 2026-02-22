#!/bin/sh
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Script must be run as root."
    exit 1
fi

echo "Setting up persistence feature..."

PERSIST_ROOT="/usr/local/share/persistence"
TARGET_HOME="${_CONTAINER_USER_HOME:-${_REMOTE_USER_HOME:-}}"

if [ -z "$TARGET_HOME" ]; then
    TARGET_HOME="/root"
fi

is_enabled() {
    case "$(echo "$1" | tr '[:upper:]' '[:lower:]')" in
        1|true|yes|on)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

link_persistence() {
    persist_name="$1"
    relative_target="$2"

    persist_dir="$PERSIST_ROOT/$persist_name"
    target_path="$TARGET_HOME/$relative_target"
    target_parent="$(dirname "$target_path")"

    mkdir -p "$persist_dir"
    mkdir -p "$target_parent"

    if [ -L "$target_path" ]; then
        ln -sfn "$persist_dir" "$target_path"
        return 0
    fi

    if [ -e "$target_path" ]; then
        echo "Skipping existing path: $target_path"
        return 0
    fi

    ln -s "$persist_dir" "$target_path"
}

mkdir -p "$PERSIST_ROOT"

if is_enabled "${CLAUDE:-false}"; then
    link_persistence "claude" ".claude"
fi

if is_enabled "${CODEX:-false}"; then
    link_persistence "codex" ".codex"
fi

if is_enabled "${GEMINI:-false}"; then
    link_persistence "gemini" ".gemini"
    link_persistence "google-vscode-extension" ".cache/google-vscode-extension"
    link_persistence "cloud-code" ".cache/cloud-code"
fi

if is_enabled "${COPILOT_CLI:-false}"; then
    link_persistence "copilot-cli" ".config/copilot"
fi
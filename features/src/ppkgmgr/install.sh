#!/bin/sh
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Script must be run as root."
    # exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to install ppkgmgr."
    # exit 1
    apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    apt-get clean
fi

echo "Installing ppkgmgr..."

curl -fsSL https://raw.githubusercontent.com/pirakansa/ppkgmgr/main/install.sh | bash
$HOME/.local/bin/ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/codex.yml
$HOME/.local/bin/ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/copilot-cli.yml
mv $HOME/.local/bin/* /usr/local/bin/

INSTALL_DIR="/usr/local/share/persistence"
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
fi
#!/bin/bash

set -e

source dev-container-features-test-lib

check "root local bin exists" bash -c "[ -d /root/.local/bin ]"
check "root local bin owner" bash -c "[ \"$(stat -c '%U:%G' /root/.local/bin)\" = \"root:root\" ]"
check "codex symlink exists" bash -c "[ -L /root/.codex ]"
check "codex symlink target" bash -c "[ \"$(readlink /root/.codex)\" = \"/usr/local/share/persistence/codex\" ]"

reportResults

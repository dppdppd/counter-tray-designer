#!/usr/bin/env bash
# Point git at the tracked hooks directory so the pre-commit version stamper
# runs automatically. Run once per clone.
set -e

cd "$(git rev-parse --show-toplevel)"
git config core.hooksPath scripts/hooks
echo "Installed: core.hooksPath = scripts/hooks"
echo "  - pre-commit: stamps the base lib at the CTD project version (1.0.<N>)"
echo "  - pre-push:   stamps every other shipped .scad at its own per-file"
echo "                version (1.<N>) for files included in the push"

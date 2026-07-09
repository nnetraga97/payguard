#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ML_DIR="$ROOT_DIR/ml"
VENV_DIR="$ML_DIR/.venv"

python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/python" -m pip install --upgrade pip
"$VENV_DIR/bin/python" -m pip install -e "$ML_DIR[classical,serving,dev]"

cat <<MSG
ML environment ready.

Activate it with:
  source "$VENV_DIR/bin/activate"

Then run:
  cd "$ML_DIR"
  pytest
  ruff check .
MSG

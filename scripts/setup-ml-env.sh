#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ML_DIR="$ROOT_DIR/ml"
VENV_DIR="$ML_DIR/.venv"

python_version_ok() {
  "$1" - <<'PY'
import sys

version = sys.version_info[:2]
raise SystemExit(0 if (3, 11) <= version < (3, 13) else 1)
PY
}

select_python() {
  local candidates=()

  if [[ -n "${PAYGUARD_ML_PYTHON:-}" ]]; then
    candidates+=("$PAYGUARD_ML_PYTHON")
  else
    candidates+=(python3.12 python3.11 python3)
  fi

  local candidate
  for candidate in "${candidates[@]}"; do
    if command -v "$candidate" >/dev/null 2>&1 && python_version_ok "$candidate"; then
      command -v "$candidate"
      return 0
    fi
  done

  cat >&2 <<'MSG'
No compatible Python interpreter found.

PayGuard ML currently requires Python >=3.11 and <3.13 because the local ML
dependencies may not support newer Python releases yet.

Install Python 3.12 or 3.11, then rerun this script. You can also set:
  PAYGUARD_ML_PYTHON=/path/to/python3.12 ./scripts/setup-ml-env.sh
MSG
  return 1
}

PYTHON_BIN="$(select_python)"

if [[ -x "$VENV_DIR/bin/python" ]] && ! python_version_ok "$VENV_DIR/bin/python"; then
  echo "Removing existing incompatible virtual environment at $VENV_DIR"
  rm -rf "$VENV_DIR"
fi

"$PYTHON_BIN" -m venv "$VENV_DIR"
"$VENV_DIR/bin/python" -m pip install --upgrade pip
"$VENV_DIR/bin/python" -m pip install -e "$ML_DIR[classical,serving,dev]"

cat <<MSG
ML environment ready.

Python:
  $("$VENV_DIR/bin/python" --version)

Activate it with:
  source "$VENV_DIR/bin/activate"

Then run:
  cd "$ML_DIR"
  pytest
  ruff check .
MSG

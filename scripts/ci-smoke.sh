#!/usr/bin/env bash
# Dependency-free smoke check. Extend this script when a real test suite exists.
set -euo pipefail

cd "$(dirname "$0")/.."

fail() {
  echo "smoke: $*" >&2
  exit 1
}

[[ -s README.md ]] || fail "README.md is missing or empty"
[[ -s AGENTS.md ]] || fail "AGENTS.md is missing or empty"
[[ -s .github/workflows/ci.yml ]] || fail ".github/workflows/ci.yml is missing or empty"

grep -q 'scripts/ci-smoke.sh' AGENTS.md \
  || fail "AGENTS.md does not document scripts/ci-smoke.sh"
grep -q 'scripts/ci-smoke.sh' .github/workflows/ci.yml \
  || fail "CI workflow does not run scripts/ci-smoke.sh"

shopt -s nullglob
secrets=()
[[ -f .env ]] && secrets+=(".env")
[[ -f credentials.json ]] && secrets+=("credentials.json")
for f in .env.* *.pem *.key; do
  [[ "$f" == ".env.example" ]] && continue
  secrets+=("$f")
done
if ((${#secrets[@]} > 0)); then
  printf 'smoke: secret-like file: %s\n' "${secrets[@]}" >&2
  fail "refusing to pass while secret-like files are in the repo root"
fi

echo "smoke: ok"

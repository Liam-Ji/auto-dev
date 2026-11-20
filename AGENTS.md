> **给团队：** 这是软件工厂的第一步，仓库里还没有应用代码和依赖。结束工作前请在仓库根目录运行 `bash scripts/ci-smoke.sh`。Lint 和类型检查都还没配置。拿不准的决定写进 PR 描述，不要擅自选技术栈或提交密钥。

# AGENTS.md

Instructions for coding agents (Cursor cloud agents, IDE agents, and others that read this file). Keep this file in sync with the commands that actually exist.

## Project overview

`auto-dev` is the starting repository for the team's software factory. It currently contains agent instructions and a dependency-free CI smoke check. There is no application language, framework, package manager, linter, or type checker yet.

Default branch: `main`.

## Directory layout

```
.
├── AGENTS.md                 # this file
├── README.md                 # one-paragraph pointer for humans
├── scripts/ci-smoke.sh       # the only local/CI check
└── .github/workflows/ci.yml  # pull_request + push to main
```

Do not invent `src/`, lockfiles, or tool configs until the team chooses a stack. When you add them, update this section in the same PR.

## Setup

No install step. Git and Bash are enough:

```bash
git clone https://github.com/Liam-Ji/auto-dev.git
cd auto-dev
bash scripts/ci-smoke.sh
```

There is nothing to cache. When a lockfile arrives (`package-lock.json`, `pnpm-lock.yaml`, `uv.lock`, `Cargo.lock`, `go.sum`, or similar), add an install command here and cache that lockfile in CI.

## Lint, type check, and tests

| Check | Command | Status |
| --- | --- | --- |
| Install | — | Not applicable. No dependencies. |
| Lint | — | Not configured. CI does not run a linter. |
| Type check | — | Not configured. CI does not run a type checker. |
| Tests | `bash scripts/ci-smoke.sh` | Required. This is a file-and-docs smoke check, not an application test suite. |

Run the smoke check from the repository root before you finish. It fails if `README.md`, this file, or the workflow is missing or empty, if this file and CI disagree about the smoke command, or if the repo root contains `.env`, a `.env.*` file other than `.env.example`, `*.pem`, `*.key`, or `credentials.json`.

CI (`.github/workflows/ci.yml`) runs that same command on `pull_request` and on `push` to `main`. Lint and type-check steps are omitted on purpose. The workflow cancels superseded runs and times out after 5 minutes so it stays cheap on GitHub Free.

## Coding conventions

No application code exists yet, so there is no local style to copy. Until there is:

- Prefer a small PR that does one thing.
- Match the formatting of the file you are editing.
- Shell scripts use `bash` with `set -euo pipefail`.
- If you add a real toolchain, extend `scripts/ci-smoke.sh` (or replace its body and update this file in the same PR) so agents still have one command to run.
- Do not reformat or refactor unrelated files to make a check pass.

## Rules for agents

- Keep pull requests small.
- Run `bash scripts/ci-smoke.sh` before finishing. Do not claim success when it fails.
- Do not commit secrets, tokens, `.env` files, or private keys. CI smoke rejects the obvious filenames at the repo root; that check is not a substitute for judgment.
- If you are unsure about product behavior, stack choice, or a failing pre-existing check, say so in the PR description and ask. Do not guess a framework or do a large refactor to force CI green.
- Do not merge a PR unless a person explicitly asks you to.

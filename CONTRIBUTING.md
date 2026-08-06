# Contributing to memtop

Focused bug reports, documentation corrections, tests, and small feature
patches are welcome.

## Development setup

```bash
git clone https://github.com/dydgital9/memtop.git
cd memtop
git switch -c fix/short-description
make check
```

## Before committing

```bash
make check
make lint
git diff --check
git status --short
```

## Commit scope

Keep commits focused. Examples:

```text
fix: validate a command-line edge case
test: cover equals-form options
docs: clarify RSS interpretation
```

## Pull requests

A pull request should explain:

- The problem.
- The behavior before the change.
- The behavior after the change.
- The validation performed.
- Any compatibility effect on table, JSON, or CSV output.

Do not include private process command lines, tokens, or sensitive logs.

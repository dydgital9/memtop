# Repository setup from the command line

This support bundle is intended to be copied over a fresh clone of the live
repository. The existing `memtop` program remains the source of truth.

## 1. Clone

```bash
mkdir -p "$HOME/Desktop/GITCLONES"
cd "$HOME/Desktop/GITCLONES"

git clone https://github.com/dydgital9/memtop.git
cd memtop
```

## 2. Copy the support files

Extract the support ZIP somewhere outside the clone, then copy its contents
into the repository root.

Example:

```bash
bundle_dir="$HOME/Desktop/firefox_downloads/memtop_repo_support"

cp -a "$bundle_dir"/. .
```

The copy intentionally replaces the old `README.md` and keeps the current
tracked `memtop` source.

## 3. Inspect before staging

```bash
git status --short
git diff -- README.md
git diff -- Makefile
git diff -- memtop.1
```

## 4. Validate

```bash
chmod +x memtop tests/smoke.sh scripts/diagnose-man.sh

make check
make lint
make man-clean
```

## 5. Install locally

```bash
make install

command -v memtop
man --where memtop
man memtop
```

## 6. Review Git changes

```bash
git status --short
git diff --check
git diff
```

## 7. Commit

```bash
git add \
    .github \
    .gitignore \
    CHANGELOG.md \
    CONTRIBUTING.md \
    LICENSE \
    Makefile \
    README.md \
    SECURITY.md \
    completions \
    docs \
    memtop.1 \
    scripts \
    tests

git commit -m "docs: complete memtop repository packaging"
```

## 8. Push

```bash
git push origin main
```

If direct pushes to `main` are later disabled, create a branch and use a pull
request instead.

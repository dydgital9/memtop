#!/usr/bin/env bash

set -euo pipefail

PROGRAM=${PROGRAM:-./memtop}
TEMP_DIR=$(mktemp -d)

cleanup()
{
    rm -rf -- "$TEMP_DIR"
}
trap cleanup EXIT

fail()
{
    printf 'smoke test failed: %s\n' "$1" >&2
    exit 1
}

[[ -f $PROGRAM ]] ||
    fail "program not found: $PROGRAM"

bash -n "$PROGRAM"

bash "$PROGRAM" --help >"$TEMP_DIR/help.txt"

grep -q '^Usage:' "$TEMP_DIR/help.txt" ||
    fail 'help output does not contain Usage'

grep -q -- '--no-header' "$TEMP_DIR/help.txt" ||
    fail 'help output does not contain --no-header'

grep -q -- '--hide-self' "$TEMP_DIR/help.txt" ||
    fail 'help output does not contain --hide-self'

bash "$PROGRAM" \
    --num 3 \
    --plain \
    >"$TEMP_DIR/table.txt"

[[ -s $TEMP_DIR/table.txt ]] ||
    fail 'table output is empty'

bash "$PROGRAM" \
    --num=2 \
    --sort=rss \
    --unit=mb \
    --plain \
    >"$TEMP_DIR/equals.txt"

[[ -s $TEMP_DIR/equals.txt ]] ||
    fail 'equals-form options produced no output'

bash "$PROGRAM" \
    --json \
    --num 3 \
    >"$TEMP_DIR/output.json"

if command -v python3 >/dev/null 2>&1
then
    python3 -m json.tool \
        "$TEMP_DIR/output.json" \
        >/dev/null
else
    grep -q '"processes"' "$TEMP_DIR/output.json" ||
        fail 'JSON output is missing the processes key'
fi

bash "$PROGRAM" \
    --csv \
    --num 3 \
    >"$TEMP_DIR/output.csv"

head -n 1 "$TEMP_DIR/output.csv" |
    grep -q '^pid,ppid,pmem,rss_kb,rss,user,command$' ||
    fail 'CSV header is not the documented header'

if bash "$PROGRAM" --num 0 >/dev/null 2>&1
then
    fail '--num 0 unexpectedly succeeded'
fi

if bash "$PROGRAM" --sort invalid >/dev/null 2>&1
then
    fail 'invalid sort unexpectedly succeeded'
fi

if bash "$PROGRAM" --unit invalid >/dev/null 2>&1
then
    fail 'invalid unit unexpectedly succeeded'
fi

bash "$PROGRAM" \
    --watch 0.1 \
    --once \
    --plain \
    --num 1 \
    >"$TEMP_DIR/once.txt"

[[ -s $TEMP_DIR/once.txt ]] ||
    fail '--once output is empty'

printf '%s\n' 'smoke tests passed'

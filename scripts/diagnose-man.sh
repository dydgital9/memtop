#!/usr/bin/env bash

set -u

PROGRAM_NAME="diagnose-man"
PAGE=${1:-./memtop.1}

section()
{
    printf '\n== %s ==\n' "$1"
}

show_var()
{
    local name=$1

    if [[ -v $name ]]
    then
        printf '%-12s = %q\n' "$name" "${!name}"
    else
        printf '%-12s = <unset>\n' "$name"
    fi
}

section "Pager environment"

for name in \
    MANPAGER \
    PAGER \
    LESS \
    LESSOPEN \
    LESSCLOSE \
    GROFF_NO_SGR
do
    show_var "$name"
done

section "Tool versions"

command -v man >/dev/null 2>&1 &&
    man --version | head -n 1

command -v less >/dev/null 2>&1 &&
    less --version | head -n 1

command -v gzip >/dev/null 2>&1 &&
    gzip --version | head -n 1

command -v groff >/dev/null 2>&1 &&
    groff --version | head -n 1

section "Local page"

if [[ -e $PAGE ]]
then
    file "$PAGE"
    printf 'First line: '
    IFS= read -r first_line <"$PAGE"
    printf '%s\n' "$first_line"
else
    printf '%s: page not found: %s\n' \
        "$PROGRAM_NAME" \
        "$PAGE" \
        >&2
fi

section "Installed memtop page"

installed_page=$(man --where memtop 2>/dev/null || true)

if [[ -n $installed_page ]]
then
    printf '%s\n' "$installed_page"
    file "$installed_page" 2>/dev/null || true
else
    printf '%s\n' 'No installed memtop page found by man --where.'
fi

section "Direct groff render"

if command -v groff >/dev/null 2>&1 && [[ -e $PAGE ]]
then
    if groff -mandoc -Tutf8 "$PAGE" >/dev/null
    then
        printf '%s\n' 'PASS: groff rendered the page.'
    else
        printf '%s\n' 'FAIL: groff could not render the page.'
    fi
else
    printf '%s\n' 'SKIP: groff or local page is unavailable.'
fi

section "Clean man pipeline"

if [[ -e $PAGE ]]
then
    if env \
        -u MANPAGER \
        -u PAGER \
        -u LESS \
        -u LESSOPEN \
        -u LESSCLOSE \
        MANPAGER=cat \
        man -l "$PAGE" \
        >/dev/null
    then
        printf '%s\n' \
            'PASS: man rendered the local page with a clean pager environment.'
    else
        printf '%s\n' \
            'FAIL: man failed even with pager variables removed.'
    fi
fi

section "Interactive clean-pager command"

printf '%s\n' \
    "env -u MANPAGER -u PAGER -u LESS -u LESSOPEN -u LESSCLOSE \\" \
    "    man -l \"$PAGE\""

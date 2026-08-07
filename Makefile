PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man/man1
COMPLETIONDIR ?= $(PREFIX)/share/bash-completion/completions

PROGRAM := memtop
MANPAGE := memtop.1
COMPLETION := completions/memtop.bash

.PHONY: all help install uninstall check test lint man man-clean man-check

all: check

help:
	@printf '%s\n' \
	    'make install      Install memtop, man page, and Bash completion' \
	    'make uninstall    Remove installed files' \
	    'make check        Run syntax, smoke, and man-page checks' \
	    'make test         Run smoke tests' \
	    'make lint         Run ShellCheck' \
	    'make man          Open the local manual page' \
	    'make man-clean    Open it with pager overrides removed' \
	    'make man-check    Render the roff page noninteractively'

install:
	rm -f -- "$(DESTDIR)$(MANDIR)/$(MANPAGE).gz"
	install -Dm755 "$(PROGRAM)" \
	    "$(DESTDIR)$(BINDIR)/$(PROGRAM)"
	install -Dm644 "$(MANPAGE)" \
	    "$(DESTDIR)$(MANDIR)/$(MANPAGE)"
	install -Dm644 "$(COMPLETION)" \
	    "$(DESTDIR)$(COMPLETIONDIR)/$(PROGRAM)"
	@printf '%s\n' \
	    "Installed $(DESTDIR)$(BINDIR)/$(PROGRAM)" \
	    "Installed $(DESTDIR)$(MANDIR)/$(MANPAGE)" \
	    "Installed $(DESTDIR)$(COMPLETIONDIR)/$(PROGRAM)"
	@if command -v mandb >/dev/null 2>&1; then \
	    mandb "$(DESTDIR)$(PREFIX)/share/man" >/dev/null 2>&1 || true; \
	fi

uninstall:
	rm -f -- "$(DESTDIR)$(BINDIR)/$(PROGRAM)"
	rm -f -- "$(DESTDIR)$(MANDIR)/$(MANPAGE)"
	rm -f -- "$(DESTDIR)$(MANDIR)/$(MANPAGE).gz"
	rm -f -- "$(DESTDIR)$(COMPLETIONDIR)/$(PROGRAM)"
	@printf '%s\n' \
	    "Removed $(DESTDIR)$(BINDIR)/$(PROGRAM)" \
	    "Removed $(DESTDIR)$(MANDIR)/$(MANPAGE)" \
	    "Removed $(DESTDIR)$(COMPLETIONDIR)/$(PROGRAM)"
	@if command -v mandb >/dev/null 2>&1; then \
	    mandb "$(DESTDIR)$(PREFIX)/share/man" >/dev/null 2>&1 || true; \
	fi

check:
	bash -n "$(PROGRAM)"
	bash -n tests/smoke.sh
	bash -n scripts/diagnose-man.sh
	bash tests/smoke.sh
	@$(MAKE) --no-print-directory man-check

test:
	bash tests/smoke.sh

lint:
	@command -v shellcheck >/dev/null 2>&1 || { \
	    printf '%s\n' \
	        'shellcheck is required for make lint' >&2; \
	    exit 1; \
	}
	shellcheck "$(PROGRAM)" tests/smoke.sh scripts/diagnose-man.sh

man:
	man -l "./$(MANPAGE)"

man-clean:
	env \
	    -u MANPAGER \
	    -u PAGER \
	    -u LESS \
	    -u LESSOPEN \
	    -u LESSCLOSE \
	    man -l "./$(MANPAGE)"

man-check:
	@if command -v groff >/dev/null 2>&1; then \
	    groff -mandoc -Tutf8 "$(MANPAGE)" >/dev/null; \
	    printf '%s\n' 'manual page render check passed'; \
	else \
	    printf '%s\n' \
	        'SKIP: groff is not installed, manual render not checked'; \
	fi

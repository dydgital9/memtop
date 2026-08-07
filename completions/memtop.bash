# Bash completion for memtop.
#
# Installed by the memtop Makefile as:
#
#   ~/.local/share/bash-completion/completions/memtop
#
# This file is intentionally dependency-light and does not require
# _init_completion or other bash-completion helper functions.

_memtop()
{
    local cur prev value
    local opts

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=""

    if (( COMP_CWORD > 0 )); then
        prev=${COMP_WORDS[COMP_CWORD - 1]}
    fi

    opts='
        -n
        --num
        -s
        --sort
        -u
        --unit
        --user
        -f
        --full
        --no-header
        --plain
        --self
        --hide-self
        --tree
        --pid
        --limit-rss
        --json
        --csv
        --log
        -w
        --watch
        --once
        --width
        --reverse
        --summary
        --no-color
        --color
        -h
        --help
        -V
        --version
    '

    # --------------------------------------------------------------
    # Complete values following options that take arguments.
    # --------------------------------------------------------------

    case "$prev" in
        -s|--sort)
            COMPREPLY=(
                $(
                    compgen \
                        -W 'rss pmem' \
                        -- "$cur"
                )
            )
            return
            ;;

        -u|--unit)
            COMPREPLY=(
                $(
                    compgen \
                        -W 'auto kb mb gb' \
                        -- "$cur"
                )
            )
            return
            ;;

        --user)
            COMPREPLY=(
                $(
                    compgen \
                        -u \
                        -- "$cur"
                )
            )
            return
            ;;

        --pid)
            if command -v ps >/dev/null 2>&1; then
                COMPREPLY=(
                    $(
                        compgen \
                            -W "$(
                                ps \
                                    -eo pid= \
                                    2>/dev/null
                            )" \
                            -- "$cur"
                    )
                )
            fi
            return
            ;;

        --log)
            COMPREPLY=(
                $(
                    compgen \
                        -f \
                        -- "$cur"
                )
            )
            return
            ;;

        -n|--num|--limit-rss|-w|--watch|--width)
            # Numeric or size values do not need an invented completion.
            COMPREPLY=()
            return
            ;;
    esac


    # --------------------------------------------------------------
    # Support --option=value completion for options that have a
    # known fixed set of values.
    # --------------------------------------------------------------

    case "$cur" in
        --sort=*)
            value=${cur#--sort=}

            COMPREPLY=(
                $(
                    compgen \
                        -W 'rss pmem' \
                        -- "$value"
                )
            )

            COMPREPLY=(
                "${COMPREPLY[@]/#/--sort=}"
            )

            return
            ;;

        --unit=*)
            value=${cur#--unit=}

            COMPREPLY=(
                $(
                    compgen \
                        -W 'auto kb mb gb' \
                        -- "$value"
                )
            )

            COMPREPLY=(
                "${COMPREPLY[@]/#/--unit=}"
            )

            return
            ;;

        --user=*)
            value=${cur#--user=}

            COMPREPLY=(
                $(
                    compgen \
                        -u \
                        -- "$value"
                )
            )

            COMPREPLY=(
                "${COMPREPLY[@]/#/--user=}"
            )

            return
            ;;

        --pid=*)
            value=${cur#--pid=}

            if command -v ps >/dev/null 2>&1; then
                COMPREPLY=(
                    $(
                        compgen \
                            -W "$(
                                ps \
                                    -eo pid= \
                                    2>/dev/null
                            )" \
                            -- "$value"
                    )
                )

                COMPREPLY=(
                    "${COMPREPLY[@]/#/--pid=}"
                )
            fi

            return
            ;;
    esac


    # --------------------------------------------------------------
    # Default option-name completion.
    # --------------------------------------------------------------

    COMPREPLY=(
        $(
            compgen \
                -W "$opts" \
                -- "$cur"
        )
    )
}

complete \
    -F _memtop \
    memtop

# Bash completion for memtop.
#
# Install to:
#   ~/.local/share/bash-completion/completions/memtop
#
# Or load directly:
#   source ./completions/memtop.bash

_memtop_complete()
{
    local cur prev
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    case "$prev" in
        -s|--sort)
            COMPREPLY=(
                $(compgen -W 'rss pmem' -- "$cur")
            )
            return
            ;;
        -u|--unit)
            COMPREPLY=(
                $(compgen -W 'auto kb mb gb' -- "$cur")
            )
            return
            ;;
        --user)
            COMPREPLY=(
                $(compgen -u -- "$cur")
            )
            return
            ;;
        --pid)
            COMPREPLY=(
                $(compgen -W "$(ps -e -o pid= 2>/dev/null)" -- "$cur")
            )
            return
            ;;
        --log)
            COMPREPLY=(
                $(compgen -f -- "$cur")
            )
            return
            ;;
    esac

    case "$cur" in
        --sort=*)
            local value=${cur#--sort=}
            COMPREPLY=(
                $(compgen -P '--sort=' -W 'rss pmem' -- "$value")
            )
            return
            ;;
        --unit=*)
            local value=${cur#--unit=}
            COMPREPLY=(
                $(compgen -P '--unit=' -W 'auto kb mb gb' -- "$value")
            )
            return
            ;;
        --user=*)
            local value=${cur#--user=}
            COMPREPLY=(
                $(compgen -P '--user=' -u -- "$value")
            )
            return
            ;;
        --log=*)
            local value=${cur#--log=}
            COMPREPLY=(
                $(compgen -P '--log=' -f -- "$value")
            )
            return
            ;;
    esac

    COMPREPLY=(
        $(compgen -W '
            -n --num
            -s --sort
            -u --unit
            --user
            -f --full
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
            -w --watch
            --once
            --width
            --reverse
            --summary
            --no-color
            --color
            -h --help
        ' -- "$cur")
    )
}

complete -F _memtop_complete memtop

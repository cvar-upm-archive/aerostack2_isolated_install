# as2 completion

as2_pkgs=$(${AEROSTACK2_STACK}/scripts/as2.bash --list-format list )

_as2_completion()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    as2_commands='cd build list clean run project'
    opts="--help -h -y --ros2-only --ros1-only"
    
    case $cur in
        -*)
            if [[ ${as2_commands} =~ ${prev} ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
                return 0
            fi
        ;;
        *)
            if [[ ${prev} =~ "as2" ]] ; then
                COMPREPLY=( $(compgen -W "${as2_commands}" ${cur}) )
                return 0
            fi
            if [[ ${prev} =~ 'build' ]] ; then
                COMPREPLY=( $(compgen -W "${as2_pkgs}" ${cur}) )
                return 0
            fi
            if [[ ${prev} =~ 'cd' ]] ; then
                COMPREPLY=( $(compgen -W "${as2_pkgs}" ${cur}) )
                return 0
            fi
        ;;
    esac
}

complete -F _as2_completion as2
complete -F _as2_completion as2.bash

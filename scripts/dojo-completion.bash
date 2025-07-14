#!/bin/bash
# Bash completion for Dirt Claude Dojo
# Source this file to enable tab completion: source scripts/dojo-completion.bash

_dojo_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Main commands
    local commands="init start learn nav browse goto interactive status search path review help"
    
    # If we're completing the first argument (command)
    if [[ ${COMP_CWORD} == 1 ]]; then
        COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
        return 0
    fi
    
    # Command-specific completions
    case "${COMP_WORDS[1]}" in
        nav|browse)
            local topics=$(find foundations -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v "^foundations$" | sort)
            COMPREPLY=($(compgen -W "${topics}" -- ${cur}))
            ;;
        goto|interactive|review)
            local lessons=$(find foundations -name "lesson-*.md" -exec basename {} .md \; 2>/dev/null | sort)
            COMPREPLY=($(compgen -W "${lessons}" -- ${cur}))
            ;;
        learn)
            COMPREPLY=($(compgen -W "cli-basics" -- ${cur}))
            ;;
        search)
            # No completion for search terms
            ;;
        *)
            ;;
    esac
}

# Register completion for both ./dojo-simulator.sh and dojo command
complete -F _dojo_completion ./dojo-simulator.sh
complete -F _dojo_completion dojo

# If user has created a dojo alias or symlink, this will work for that too
if command -v dojo &> /dev/null; then
    complete -F _dojo_completion dojo
fi
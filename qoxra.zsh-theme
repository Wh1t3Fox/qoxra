# From sindresorhus/pure
# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
# terminal codes:
# \e7   => save cursor position
# \e[2A => move cursor 2 lines up
# \e[1G => go to position 1 in terminal
# \e8   => restore cursor position
# \e[K  => clears everything after the cursor on the current line
# \e[2K => clear everything on the current line

prompt_qoxra_git(){
    is_dirty(){
        test -n "$(git status --porcelain --ignore-submodules)"
    }

    ref="$vcs_info_msg_0_"
    if [[ -n "$ref" ]]; then
        if is_dirty; then
            ref="${ref}%{$fg[red]%}✗"
        else
            ref="${ref}%{$fg[green]%}✔ "
        fi

        if [[ "${ref/.../}" == "$ref" ]]; then
            # Branch
            ref="\ue0a0 $ref"
        else
            # Detached
            ref="\u27a6 ${ref/.../}"
        fi
    print -n "%{$fg[white]%}$ref "
fi
}

prompt_qoxra_virtualenv(){
    # python logo
    print -Pn "\ue606 "
}

prompt_qoxra_dir(){

    # pwd in BLUE and only show last 3 dirs
    prompt_qoxra_basedir="%{${fg[blue]}%}%3~ "
    
    # Are we in a virtenv?
    if [[ -n $VIRTUAL_ENV ]]; then
      prompt_qoxra_basedir+="$(prompt_qoxra_virtualenv)"  
    fi
    
    # Is this a git proj?
    #
    prompt_qoxra_basedir+="$(prompt_qoxra_git)"

    prompt_qoxra_basedir+="%{${reset_color}%}"
    print $prompt_qoxra_basedir
}

prompt_qoxra_precmd() {
    vcs_info

    # if root RED else YELLOW
    prompt_qoxra_username="%(!.%{${fg[red]}%}%n.%{${fg[yellow]}%}%n)%{${reset_color}%}"

    # hostname in GREEN
    prompt_qoxra_hostname="%{${fg[green]}%}%m%{${reset_color}%}"


    PROMPT="${prompt_qoxra_username} at ${prompt_qoxra_hostname} in $(prompt_qoxra_dir)» %{${reset_color}%}"
}

prompt_qoxra_setup() {

    export PROMPT_EOL_MARK=''
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    
    prompt_opts=(subst percent)


    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    add-zsh-hook precmd prompt_qoxra_precmd
    
    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' check-for-changes false
    zstyle ':vcs_info:git*' formats '%b'
    zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_qoxra_setup "$@"

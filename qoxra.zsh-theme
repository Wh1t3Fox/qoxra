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

function +vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+='T'
    fi
}

function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    # for git prior to 1.7
    # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "+${ahead}" )

    # for git prior to 1.7
    # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "-${behind}" )

    hook_com[misc]+=${(j:/:)gitstatus}
}

function +vi-git-remotebranch() {
    local remote

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    # The first test will show a tracking branch whenever there is one. The
    # second test, however, will only show the remote branch's name if it
    # differs from the local one.
    if [[ -n ${remote} ]] ; then
    #if [[ -n ${remote} && ${remote#*/} != ${hook_com[branch]} ]] ; then
        hook_com[branch]="${hook_com[branch]} [${remote}]"
    fi
}

prompt_qoxra_git(){
    is_dirty(){
        test -n "$(git status --porcelain --ignore-submodules)"
    }

    ref="$vcs_info_msg_0_"
    if [[ -n "$ref" ]]; then
        if is_dirty; then
            ref="${ref}%{$fg[red]%}✗"
        else
            ref="${ref}%{$fg[green]%}✔"
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
    #prompt_qoxra_basedir+="$(prompt_qoxra_git)"
    prompt_qoxra_basedir+="${vcs_info_msg_0_}"

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
    
    zstyle ':vcs_info:*' enable git svn hg
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:git*' formats "%{$fg[white]%}%s:%b %m%u%c %{${reset_color}%}"
    zstyle ':vcs_info:git*+set-message:*' hooks git-st git-untracked
}

prompt_qoxra_setup "$@"

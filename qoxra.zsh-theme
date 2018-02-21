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


# For the git prompt, use a white @ and blue text for the branch name
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}git:%{$fg[blue]%}"

# Close it all off by resetting the color and styles.
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

# Do nothing if the branch is clean (no changes).
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Add a red ✗ if this branch is dirty.
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗"

# if root RED else YELLOW
QOXRA_USER="%(!.%{${fg[red]}%}%n.%{${fg[yellow]}%}%n)%{${reset_color}%}"

# hostname in GREEN
QOXRA_HOST="%{${fg[green]}%}%m%{${reset_color}%}"

# pwd in BLUE and only show last 3 dirs
QOXRA_DIR="%{${fg[blue]}%}%3~%{${reset_color}%}"

# Put 'em all together
PROMPT="${QOXRA_USER} at ${QOXRA_HOST} in ${QOXRA_DIR} » %{${reset_color}%}"

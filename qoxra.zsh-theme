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


# if root RED else WHITE
PROMPT="%(!.%{${fg[red]}%}%n.%{${fg[white]}%}%n)%{${reset_color}%}"
PROMPT+=" at "
# hostname in GREEN
PROMPT+="%{${fg[green]}%}%m%{${reset_color}%}"
PROMPT+=" in "
# pwd in BLUE and only show last 3 dirs
PROMPT+="%{${fg[blue]}%}%3~%{${reset_color}%}"
PROMPT+=" » %{${reset_color}%}"


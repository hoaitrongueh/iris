#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# >>> Codex installer >>>
export PATH="/home/iris/.local/bin:$PATH"
# <<< Codex installer <<<

# Iris workstation shell: Bash/readline, no framework or authentication changes.
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=20000
HISTFILESIZE=40000
shopt -s histappend checkwinsize
if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi
PS1='\[\e[1;37m\]\u@\h \[\e[0;37m\]\w\[\e[0m\]\n\$ '
alias ll='ls -lah'
alias shortcuts='less ~/arch-setup-report.md'
alias cxx='c++'

export PATH=$PATH:/home/iris/.spicetify
export PATH="$HOME/.local/bin:$PATH"

[[ -r "$HOME/.config/bash/workstation.bash" ]] && source "$HOME/.config/bash/workstation.bash"

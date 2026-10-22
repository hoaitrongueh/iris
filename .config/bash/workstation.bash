# Small Bash additions. Optional utilities activate only when installed.
alias ll='ls -lah'
alias cxx='c++'
alias ..='cd ..'
alias shortcuts='less ~/arch-setup/completion/README.md'
alias croot='cd ~/HAND'
alias ports='ss -tuln'
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }
project() {
    case "${1:-HAND}" in
        HAND|RELIC|PRISM) cd -- "$HOME/${1:-HAND}" ;;
        *) printf 'Use project HAND, RELIC, or PRISM\n' >&2; return 2 ;;
    esac
}
# Git's packaged prompt only inspects the current repository when drawing a prompt.
if [[ -r /usr/share/git/completion/git-prompt.sh ]]; then
    source /usr/share/git/completion/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=1
    PS1='\[\e[1;37m\]\w\[\e[0;37m\]$(__git_ps1 " (%s)")\[\e[0m\]\n\$ '
fi
if command -v zoxide >/dev/null; then eval "$(zoxide init bash)"; fi
if command -v fzf >/dev/null; then
    export FZF_DEFAULT_OPTS='--color=bw --height=40% --layout=reverse --border'
    [[ -r /usr/share/fzf/key-bindings.bash ]] && source /usr/share/fzf/key-bindings.bash
fi
if command -v eza >/dev/null; then alias ll='eza -lah --group-directories-first'; fi
# Terminal file navigation: select a directory, or use ordinary cd without fzf.
cdir() {
    command -v fzf >/dev/null || { printf 'fzf is not installed\n' >&2; return 1; }
    local selected
    selected=$(find "${1:-.}" -maxdepth 4 -type d -not -path '*/.git/*' -print0 2>/dev/null | fzf --read0 --print0 | tr -d '\0') || return
    [[ -n "$selected" ]] && cd -- "$selected"
}

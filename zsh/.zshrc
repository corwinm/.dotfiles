eval "$(ssh-agent -s)" > /dev/null

if [[ "$TERM_PROGRAM" != "vscode" ]]; then
  eval "$(starship init zsh)"
fi

alias lg=lazygit
alias vim=nvim
alias v='nvim'
alias oc=opencode

# Neovim config
alias nvc='nvim ~/.config/nvim'

# Zsh config and reload
function zshrc {
  ${EDITOR:-nvim} ~/.zshrc
  source ~/.zshrc
}

# LS Aliases from ohmyzsh
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list

# VIM Mode
bindkey -v
export KEYTIMEOUT=1

# Use nvim to edit command line in vi mode
export EDITOR='nvim'
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^v' edit-command-line

# Change cursor shape in vi mode
export VI_MODE_SET_CURSOR=true

function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]] ; then
    echo -ne '\e[2 q'  # block cursor
  else
    echo -ne '\e[6 q'  # beam cursor
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[6 q'  # beam cursor
}
zle -N zle-line-init

# Use system clipboard for copy/paste
function vi-yank-clipboard() {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy
}
zle -N vi-yank-clipboard
bindkey -M vicmd 'y' vi-yank-clipboard

# Yank whole line to system clipboard
function yi-yank-line-clipboard() {
  zle vi-yank-line
  echo "$CUTBUFFER" | pbcopy
}
zle -N yi-yank-line-clipboard
bindkey -M vicmd 'Y' yi-yank-line-clipboard

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="--style full --preview 'fzf-preview.sh {}'"

# Set up zoxide
eval "$(zoxide init zsh)"
# Use zoxide for cd
alias cd=z

if [ -f "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
else 
  export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# bun completions
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# deno
[[ -f ~/.deno.sh ]] && source ~/.deno.sh

# go
export PATH="$HOME/go/bin:$PATH"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Alt-s to open fzf prompt to connect to a sesh session
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c -z | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# Local config
[[ -f ~/.zsh_local ]] && source ~/.zsh_local


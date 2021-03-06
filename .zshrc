# alias
alias tmux='tmux -2'

HISTFILE=${HOME}/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000
# シェルのプロセスごとに履歴を共有
setopt share_history
# ヒストリにhistoryコマンドを記録しない
setopt hist_no_store
# 同じ履歴は残さない
setopt hist_ignore_all_dups
# 補完
autoload -Uz compinit
compinit
# sshと同じ補完をする
compdef mosh=ssh

# vcs_infoを右プロンプトに
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%b)'
zstyle ':vcs_info:*' actionformats '(%b|%a)'

function _update_vcs_info_message() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_message
RPROMPT="[%c]%v"

## peco
# ヒストリから検索する
function peco-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
    BUFFER=$(history -n 1 | \
      eval $tac | \
      peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# tmuxのウインドウ切り替え
#function peco-tmux() {
#  local i=$(tmux lsw | awk '/active.$/ {print NR-1}')
#  local f='#{window_index}: #{window_name}#{window_flags} #{pane_current_path}'
#  tmux lsw -F "$f" \
#    | anyframe-selector-auto "" --initial-index $i \
#    | cut -d ':' -f 1 \
#    | anyframe-action-execute tmux select-window -t
#}
#zle -N peco-tmux
#bindkey '^[' peco-tmux

# Refresh zshrc
function refresh-setting(){
  # git pull
  current=$PWD
  git_dir=$(dirname `readlink ~/.zshrc`)
  cd $git_dir
  git pull
  cd $current
  source ~/.zshrc
}

# Delete merged branches
function git_delete-merged-branches(){
  git branch --merged | grep -v '*' | xargs -I % git branch -d %
}

# The next line updates PATH for the Google Cloud SDK.
source '/Users/shinichi/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/shinichi/google-cloud-sdk/completion.zsh.inc'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/shinichi/.sdkman"
[[ -s "/Users/shinichi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/shinichi/.sdkman/bin/sdkman-init.sh"

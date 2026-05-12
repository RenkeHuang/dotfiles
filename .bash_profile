export OMP_NUM_THREADS=1

alias sobash='source ~/.bash_profile | cd -'
alias sobahs='source ~/.bash_profile | cd -'
alias untar='tar -xzf'

alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gs='git status'
alias gr='git restore'
alias gp='git pull --rebase'

# Show git branch in terminal prompt
function git_branch {
  branch="`git branch 2>/dev/null | grep "^\*" | sed -e "s/^\*\ //"`"
  if [ "${branch}" != "" ];then
    if [ "${branch}" = "(no branch)" ];then
      branch="(`git rev-parse --short HEAD`...)"
    fi
    echo "[$branch]"
  fi
}

# Terminal colors
export CLICOLOR=1
export LSCOLORS=FxGxFxdaCxDaDahbadeche
export PS1='\[\033[01;33m\]\u@\h \[\033[01;32m\]\w\[\033[01;32m\]\[\033[1;36m\]$(git_branch) \[\033[00m\]\$ '

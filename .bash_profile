export SCHRODINGER_SRC=/Users/$USER/builds/src
export SCHRODINGER=/Users/$USER/builds/build/master
export SCHRODINGER_LIB=/Users/$USER/builds/software/lib
_is_mac=$(uname -s | grep Darwin)
# Switch between builds:
function select-build() {
    [[ -n "$1" ]] || echo "select-build needs an argument (e.g. select-build 2021-3)"
    if [[ -n "$_is_mac" ]]; then
        export SCHRODINGER=/Users/$USER/builds/build/$1
    else
        export SCHRODINGER_SRC=/scr/$USER/builds/src
        export SCHRODINGER=/scr/$USER/builds/build/$1
        export SCHRODINGER_LIB=/software/lib
    fi
}

export PATH="/Users/huang2/google-cloud-sdk/bin":$PATH

alias ll='ls -lhtr'
alias untar='tar -xzf'
alias arm='env /usr/bin/arch -arm64 /bin/bash --login'
alias intel='env /usr/bin/arch -x86_64 /bin/bash --login'
alias jtlab='$SCHRODINGER/run jupyter lab'
alias jtnb='$SCHRODINGER/run jupyter notebook'
alias gh='/Users/$USER/gh_2.34.0_macOS_arm64/bin/gh'
alias bdg='${SCHRODINGER_SRC}/mmshare/build_tools/buildinger.sh'

alias ssh-pdx-git='ssh pdx-git.schrodinger.com'
alias ssh-desk='ssh nyc-desk-l304.schrodinger.com'

# enter this directory, then run:
# `make unittest TEST_ARGS="PATH/TO/TEST.py" `
alias mmtestpath='cd ${SCHRODINGER}/mmshare*/python/test'
alias run='$SCHRODINGER/run'
alias rma='run $SCHRODINGER/maestro -console'
alias fep_plus='$SCHRODINGER/fep_plus'
alias fep_solubility='$SCHRODINGER/fep_solubility'
alias constant_ph='$SCHRODINGER/constant_ph'
alias ffbuilder='$SCHRODINGER/ffbuilder'
alias stu_extract='$SCHRODINGER/utilities/stu_extract'
alias stu_modify='$SCHRODINGER/utilities/stu_modify --test_skip'
alias jsc='$SCHRODINGER/jsc'
alias sobash='source /Users/$USER/.bash_profile'
alias ipy='$SCHRODINGER/run ipython'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gs='git status'
alias gr='git restore'
alias gp='git pull --rebase'
alias mycommits='git log --author="Renke" --pretty=oneline'
alias activate_vir='source virenv/bin/activate'
# alias check_format="yapf --diff $(git diff --name-only master '*.py')"

sobenv () {
    source ${SCHRODINGER_SRC}/mmshare/build_env;
    export INTEL_LICENSE_FILE="28518@nyc-lic-intel.schrodinger.com"
}

# copy all Python files from mmshare source directory to build directory
makemm () {
    source ${SCHRODINGER_SRC}/mmshare/build_env;
    make -C ${SCHRODINGER}/mmshare-v*/python/scripts install;
    make -C ${SCHRODINGER}/mmshare-v*/python/modules schrodinger_modules;
    make -C ${SCHRODINGER}/mmshare-v*/python/common install;
    if [ $@ ]; then
        make -C ${SCHRODINGER}/mmshare-v*/python/test unittest TEST_ARGS="-v --post_test $@";
    fi
}

build_version () {
    grep MMSHARE_VERSION ${SCHRODINGER_SRC}/mmshare/version.h | awk '{ printf("%03d\n", $3%1000+1) }'
}

function genprof() {
  [[ -n "$1" ]] || echo "genprof needs an argument (e.g. genprof aaa.prof)"
  $SCHRODINGER/run gprof2dot -f pstats $1 | dot -Tpng -o $1.png
}

function format() {
  [[ -n "$1" ]] || echo "format needs an argument (e.g. format aaa.py)"
    yapf -i $1
    echo "yapf finished."
    # isort $1
    flake8 $1
    echo "flake8 finished."
    # pyflakes $1
}

function sync_repo2remote() {
  # Check if the repository name is provided
  if [[ -z "$1" ]]; then
    echo "Error: sync_repo2remote needs one arg specifying repo name (sync_repo2remote mmshare)"
    return 1  # Exit the function with an error status
  fi
  # Find and sync changed files
  for fname in $(git diff master --name-only); do
    fpath="/scr/huang2/builds/src/$1/$fname"
    rsync -avz "$fname" "huang2@nyc-desk-l304.schrodinger.com:'$fpath'"
  done
}

function rsync2desk() {
  if [[ -z "$1" ]]; then
    echo "Error: rsync2desk needs one arg specifying file/dir name (rsync2desk XXX.maegz)"
    return 1  # Exit the function with an error status
  fi
  rsync -avz $1 huang2@nyc-desk-l304.schrodinger.com:"/scr/huang2/$1"
}

function formatall() {
  for fname in $(git diff master --name-only); do
    if [[ $fname == *.py ]]; then
      format $fname
      echo $fname 'is formated.'
      echo  # Insert a blank line
    fi
  done
}

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


#[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

eval "$(/usr/local/bin/brew shellenv)"

# Setting PATH for Python 3.12
# The original version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
# export PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/huang2/mambaforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/huang2/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/Users/huang2/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/Users/huang2/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


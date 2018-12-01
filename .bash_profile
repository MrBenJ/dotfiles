
# ====== NVM ======
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Git branch parser for PS1
function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo "[${BRANCH}${STAT}]"
    else
        echo ""
    fi
}

# Switch cases for dirty git branches
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
        bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
        bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo " ${bits}"
    else
        echo ""
    fi
}

# ====== Docker utilities ======
function removecontainers() {
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
}

function armageddon() {
    removecontainers
    docker network prune -f
    docker rmi -f $(docker images --filter dangling=true -qa)
    docker volume rm $(docker volume ls --filter dangling=true -q)
    docker rmi -f $(docker images -qa)
}

# Additional bash scripts to load in
source ~/git-bash-completion.sh

# ====== Common overrides aliases ======

# Colorize 'ls'
alias ls="ls -G"

# ====== Convenience scripts ======

# Prints out an npm package's run scripts
alias npmscripts="cat ./package.json | jq .scripts"

# Open Jest/Enzyme test coverage reporting
alias opencoverage="open ./coverage/lcov-report/index.html"

# Open the current directory in Sublime Text 3
alias subl="sublime ."

# Open ~/.bash_profile for quick editing/reference
alias editbash="sublime ~/.bash_profile"

# Re-source your ~/.bash_profile for new goodies
alias rebash="source ~/.bash_profile"

# ====== Terminal Colorization ======

# PS1 with Time and coloring
# export PS1="\l_\[$(tput sgr0)\]\[\033[38;5;105m\]\t\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;33m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\] > \[$(tput sgr0)\]"
#
# PS1 with Git Branch in terminal (same for personal machine)
export PS1="\\$\u \[\e[33m\]\`parse_git_branch\`\[\e[m\] \[\e[36m\]\W\[\e[m\] =>  "

# Colors for ls
export LSCOLORS="gxFxcxdxbxegedabagacad"

# fuck
eval $(thefuck --alias fuck)

# ruby rbenv
eval "$(rbenv init -)"

# added by Anaconda3 installer
export PATH="/Users/Ben/anaconda3/bin:$PATH"

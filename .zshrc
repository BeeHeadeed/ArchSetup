# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Path to powerlevel10k theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# List of plugins used
plugins=( git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting )
source $ZSH/oh-my-zsh.sh

# In case a command is not found, try to find the package that has it
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]] ; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Detect the AUR wrapper
if pacman -Qi yay &>/dev/null ; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null ; then
   aurhelper="paru"
fi

auto_sudo() {
  # Usage: auto_sudo <command> [args...]
  if [[ $EUID -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()
    local -a ubuntu=()

    if command -v pacman &>/dev/null; then
        for pkg in "${inPkg[@]}"; do
            if pacman -Si "${pkg}" &>/dev/null ; then
                arch+=("${pkg}")
            else
                aur+=("${pkg}")
            fi
        done

        if [[ ${#arch[@]} -gt 0 ]]; then
            sudo pacman -S --needed "${arch[@]}"
        fi

        if [[ ${#aur[@]} -gt 0 ]]; then
            ${aurhelper} -S --needed "${aur[@]}"
        fi
    elif command -v apt-get &>/dev/null; then
        for pkg in "${inPkg[@]}"; do
            if apt-cache show "${pkg}" &>/dev/null; then
                ubuntu+=("${pkg}")
            else
                echo "Package not found in Ubuntu repositories: ${pkg}" >&2
            fi
        done

        if [[ ${#ubuntu[@]} -gt 0 ]]; then
            sudo apt-get install -y "${ubuntu[@]}"
        fi
    else
        echo "No supported package manager found (pacman or apt-get)." >&2
    fi
}

if [[ ! -d "/opt/pokemon-colorscripts" ]]; then
    git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git /tmp/pokemon-colorscripts
    auto_sudo /tmp/pokemon-colorscripts/rinstall.sh
    rm -rf /tmp/pokemon-colorscripts
fi

function print-pokemon {
    if [[ $(tput lines) -lt 40 ]]; then
        pokemon-colorscripts --no-title -r
    else
        pokemon-colorscripts --no-title -r -b
    fi
}

# Helpful aliases
alias clear='clear; print-pokemon' # clear terminal and generate a random pokemon
alias c='clear'
alias celar='clear'
alias l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias un='$aurhelper -Rns' # uninstall package
alias up='$aurhelper -Syu' # update system/package/aur
alias pl='$aurhelper -Qs' # list installed package
alias pa='$aurhelper -Ss' # list availabe package
alias pc='$aurhelper -Sc' # remove unused cache
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias vc='code' # gui code editor
alias clone="git clone"
alias ga="git add"
alias g="git"
alias gti="git"
alias gco="git checkout"
alias gc="git commit"
alias commit="git commit"
alias vomit="git commit"
alias gp="git push"
alias push="git push"
alias pus="git push"
alias gl="git pull"
alias pul="git pull"
alias pull="git pull"
alias plul="git pull"
alias pulu="git pull"
alias pulul="git pull"
alias uplu="git pull"
alias uplul="git pull"
alias plulu="git pull"
alias plull="git pull"
alias pllu="git pull"
alias pullu="git pull"
alias pllul="git pull"
alias upll="git pull"
alias stash="git stash"
alias gs="git stash"
alias gsp="git stash pop"
alias gst="git status"
alias m="make"
alias cm="clear; make"
alias clean="make clean"
alias cclean="clear; make clean"
alias fclean="make fclean"
alias cfclean="clear; make fclean"
alias f="make fclean"
alias cf="clear; make fclean"
alias debug="make debug"
alias cdebug="clear; make debug"
alias d="make debug"
alias re="make re"
alias cre="clear; make re"
alias py="python"
alias lockScreenBackground="/home/quentin/my_scripts/lockScreenBackground.sh"
alias down="docker compose down --volumes"
alias up="docker-compose up --build"
alias ealias="code ~/.zshrc"
alias aliases="code ~/.zshrc"
alias build="./build.sh"
alias b="./build.sh"
alias cfg="config"
alias cg="config"
alias nukeDocker="docker rm -f $(docker ps -aq); docker system prune -a --volumes; docker system prune --all -f"
alias killdb="sudo systemctl stop postgresql; sudo pkill -u postgres postgres"
alias startdb="sudo systemctl start postgresql"
alias restartdb="sudo systemctl restart postgresql"
alias wip="git add .; git commit -m "wip" --no-verify"
alias link_steam="~/my_scripts/link_steam.sh"

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#Display Pokemon
print-pokemon

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$PATH:/home/quentin/.local/bin
export PATH=$PATH:/home/quentin/Clone/android-studio/bin
export PATH=$PATH:/opt/visual-studio-code/
export ANDROID_HOME=/home/quentin/Android/Sdk
export PATH=$ANDROID_HOME/tools:$PATH
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

# bun completions
[ -s "/home/quentin/.bun/_bun" ] && source "/home/quentin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

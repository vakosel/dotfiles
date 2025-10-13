# -----------------------------------------------------
# General
# -----------------------------------------------------
alias cls='clear'
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
alias vv 'nvim $(fzf)'
alias vim='$EDITOR'
alias v='nvim'
alias so='source ~/.config/fish/config.fish'
alias ww='source .venv/bin/activate.fish'
alias qq='deactivate'
alias pti='ptipython'
alias rofi='rofi -show drun'
alias orphans='sudo pacman -Rns $(pacman -Qdtq)'

# -----------------------------------------------------
# Changing "ls" to "eza"
# -----------------------------------------------------
alias ls='eza -al --color=always --icons=always --group-directories-first' # my preferred listing
alias la='eza -a --color=always --icons=always --group-directories-first' # all files and dirs
alias ll='eza -l --color=always --icons=always --group-directories-first' # long format
alias lt='eza -aT --color=always --icons=always --group-directories-first' # tree listing
alias l.='eza -a | egrep "^\."'
alias l.='eza -al --color=always --icons=always --group-directories-first ../' # ls on the PARENT directory
alias l..='eza -al --color=always --icons=always --group-directories-first ../../' # ls on directory 2 levels up
alias l...='eza -al --color=always --icons=always --group-directories-first ../../../' # ls on directory 3 levels up

# -----------------------------------------------------
#  pacman and yay
# -----------------------------------------------------
alias update-all="sudo pacman -Syu && yay -Syu --devel --cleanafter && yay -Yc && echo (set_color green)'✅ System fully updated!'(set_color normal)"
alias pacsyu='sudo pacman -Syu' # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu' # Refresh pkglist & update standard pkgs
alias S="sudo pacman -S"
alias R="sudo pacman -R"
alias unlock='sudo rm /var/lib/pacman/db.lck' # remove pacman lock
alias orphan='sudo pacman -Rns (pacman -Qtdq)' # remove orphaned packages (DANGEROUS!)

# -----------------------------------------------------
# get fastest mirrors
# -----------------------------------------------------
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# -----------------------------------------------------
# adding flags
# -----------------------------------------------------
alias df='df -h' # human-readable sizes
alias free='free -m' # show sizes in MB
alias grep='grep --color=auto' # colorize output (good for log files)

# -----------------------------------------------------
# ps
# -----------------------------------------------------
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

#  * Create missing directories in path when calling `mkdir`
alias mkdir='mkdir -pv'

#  * `cppath` command to copy full file path
# alias cppath = 'printf (realpath $argv[1]) | xclip -selection clipboard'

#  * `rmm` command to remove directories, but ask nicely
alias rmm='rm -rvI'

#  * `cpp` command to copy directories, but ask nicely
alias cpp='cp -R'

#  * `cp` to ask when overwriting files
alias cp='cp -i'

#  * `mv` to ask when overwriting files
alias mv='mv -i'

#  * `add-to-path` Command to add current directory to path
alias add-to-path='set -U fish_user_paths (pwd) $fish_user_paths'

# Update `PATH` variable
alias path-update='set -gx PATH (bash -c "source ~/git/stuff/config/path; echo \$PATH")'

#  * `fs` command to show free space on physical drives
alias fs='df -h -x squashfs -x tmpfs -x devtmpfs'

#  * `disks` command to List disks
#    - Clearly shows which disks are mounted temporary
#    - I always run this command before `dd` sd-card, to make 100% sure not to override system partition
alias disks='lsblk -o HOTPLUG,NAME,SIZE,MODEL,TYPE | awk "NR == 1 || /disk/"'

#  * `partitions` command to list partitions
alias partitions='lsblk -o HOTPLUG,NAME,LABEL,MOUNTPOINT,SIZE,MODEL,PARTLABEL,TYPE,UUID | grep -v loop | cut -c1-$COLUMNS'

#  * `sizeof` command to show size of file or directory
alias sizeof="du -hs"

#  * `connect` command Connect to wifi from terminal
alias connect=nmtui

#  * `lockblock` command to prevent screen  locking untill next reboot
alias lockblock='killall xautolock; xset s off; xset -dpms; echo ok'

#  * `wget` to save file with provided name
alias wget='wget --content-disposition'

#  * `unset` to unset enviroment variable
alias unset 'set --erase'

# -----------------------------------------------------
# Git
# -----------------------------------------------------
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias stat='git status' # 'status' is protected name so using 'stat' instead
alias tag='git tag'
alias newtag='git tag -a'

# -----------------------------------------------------
#  Navigation
# -----------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# -----------------------------------------------------
#  System
# -----------------------------------------------------
alias jctl="journalctl -p 3 -xb"

function sll --description "Scroll ll if theres more files that fit on screen"
    ls -l $argv --color=always | less -R -X -F
end

function mkcd --description "Create and cd to directory"
    mkdir $argv
    and cd $argv
end

function amount --description "Mount archive"
    /usr/lib/gvfs/gvfsd-archive file=$argv 2>/dev/null &
    sleep 1
    cd $XDG_RUNTIME_DIR/gvfs
    cd (ls -p | grep / | tail -1) # cd last created dir
end

function aumount --description "Unmount all mounted archive (and gvfs locations)"
    gvfs-mount --unmount $XDG_RUNTIME_DIR/gvfs/*
end

# Useful for piping, i.e. `cat ~/.ssh/id_rsa.pub | copy` or `uuid | copy`
# If arguments are given, copies it to clipboard
function copy --description "Copy pipe or argument"
    if [ "$argv" = "" ]
        xclip -sel clip
    else
        printf "$argv" | xclip -sel clip
    end
end

function copypath --description "Copy full file path"
    readlink -e $argv | xclip -sel clip
    echo "copied to clipboard"
end

function color --description "Print color"
    echo (set_color (string trim -c '#' "$argv"))"██"
end

function reset_windows --description "Reset all windows size and bring it to main monitor. Useful if DE messes up in multiple monitor configuration"
    for f in (wmctrl -l | cut -d' ' -f 1)
        wmctrl -i -r $f -e 0,0,0,800,600
        wmctrl -i -a $f
    end
end

#  * Prepend `sudo` to `nano` command if file is not editable by current user
#    - Warn if file does no exist
function nano
    if not test -e "$argv"
        read -p "echo 'File $argv does not exist. Ctrl+C to cancel'" -l confirm
        touch "$argv" 2>/dev/null
    end

    if test -w "$argv"
        /bin/nano -mui $argv
    else
        echo "Editing $argv requires root permission"
        sudo /bin/nano -mui $argv
    end
end

function run --description "Make file executable, then run it"
    chmod +x "$argv"
    eval "./$argv"
end

function launch --description "Launch GUI program - hide output and don't close when terminal closes"
    eval "$argv >/dev/null 2>&1 &" & disown
end

function open --description "Open file by default application in new process"
    env XDG_CURRENT_DESKTOP=X-Generic xdg-open $argv >/dev/null 2>&1 & disown
end

function b --description "Exec command in bash. Useful when copy-pasting commands with imcompatible syntax to fish "
    bash -c "$argv"
end

function c --description "Math using Python"
    python -c "print($argv)"
end

#  * Show 3 (next and prev) months in `cal`, start week on monday
#    - Use [nicl](https://github.com/dmi3/nicl) in installed
if type -q nicl
    alias cal="nicl -w3 -f ~/git/stuff/documents/bank_days.csv"
else
    alias cal="ncal -bM3"
end

#  * If [sssh2](https://github.com/dmi3/bin/blob/master/sssh2) installed - use it instead of ssh
if type -q sssh2
    alias ssh=sssh2
end

#  * If [plug](https://github.com/dmi3/bin/blob/master/plug) installed - use it for interactive mount/unmount of USB drives 
if type -q plug
    alias unplug='plug -u'
    alias plug='cd (command plug)'
end

#  * `icat` Show images in [kitty](https://sw.kovidgoyal.net/kitty/)
if type -q kitty
    alias icat="kitty +kitten icat"
end

function qr --description "Prints QR. E.g. super useful when you need to transfer private key to the phone without intermediaries `cat ~/.ssh/topsecret.pem | qr`"
    if [ "$argv" = "" ]
        qrencode --background=00000000 --foreground=FFFFFF -o - | kitty +kitten icat
    else
        printf "$argv" | qrencode --background=00000000 --foreground=FFFFFF -o - | kitty +kitten icat
    end
end

alias sharewifi='qr "WIFI:T:WPA;S:aaa;P:bbb;;"'

# * Use (y)  instead of yazi 
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

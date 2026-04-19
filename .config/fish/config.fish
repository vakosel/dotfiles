### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin $HOME/.local/bin $HOME/Scripts $fish_user_paths

# -----------------------------------------------------
# Source files
# -----------------------------------------------------
source $HOME/.config/fish/functions/myfunc.fish
# -----------------------------------------------------
# Exports
# -----------------------------------------------------
set fish_greeting # Supresses fish's intro message
set TERM xterm-256color # Sets the terminal type
set -gx EDITOR nvim
set -gx SUDO_EDITOR nvim
set -gx MANPATH /usr/local/man:$MANPATH
set -x MANPAGER "nvim +Man!"
set -gx PTPYTHON_CONFIG_HOME $HOME/.config/ptpython

# -----------------------------------------------------
# SET FZF DEFAULT
# -----------------------------------------------------
set FZF_DEFAULT_OPTS "--layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark"

# -----------------------------------------------------
#  vi key bindings 
# -----------------------------------------------------
set -g fish_key_bindings fish_vi_key_bindings

# -----------------------------------------------------
# Fastfetch
# -----------------------------------------------------
fastfetch --config ~/.config/fastfetch/examples/13.jsonc

# -----------------------------------------------------
# FZF
# -----------------------------------------------------
# Enables the following keybindings:
# CTRL-t = fzf select
# CTRL-r = fzf history
# ALT-c = fzf cd
fzf --fish | source

# -----------------------------
# Interactive file editor with preview
# -----------------------------
function fedit
    # Only list regular files to avoid nvim complaining about directories
    fd -H -t f | fzf --preview "bat --style=numbers --color=always {}" \
        --bind "enter:execute(nvim {})" \
        --bind "ctrl-d:execute(rm -i {})"
end

# -----------------------------
# Interactive directory jump
# -----------------------------
function fdcd
    # Only list directories
    cd (fd -H -t d | fzf --preview "tree -C {} | head -20")
end
# -----------------------------------------------------
#  AUTOCOMPLETE AND HIGHLIGHT COLORS ###
# -----------------------------------------------------

# set fish_color_normal brcyan
# set fish_color_autosuggestion '#7d7d7d'
# set fish_color_command brcyan
# set fish_color_error '#ff6c6b'
# set fish_color_param brcyan

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/vakosel/.lmstudio/bin
# End of LM Studio CLI section

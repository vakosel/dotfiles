function git-pull
    git pull
    git subtree pull --prefix=.config/nvim nvim-remote main --squash
end

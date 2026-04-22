function git-pull
    git pull --rebase

    echo "Updating nvim subtree..."
    git subtree pull --prefix=.config/nvim nvim-remote main --squash
end

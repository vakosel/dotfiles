function git-pull
    echo "⬇️ Pulling dotfiles..."
    git pull --rebase
    if test $status -ne 0
        echo "❌ dotfiles pull failed"
        return 1
    end

    echo "🧠 Updating nvim subtree..."
    git subtree pull --prefix=.config/nvim nvim-remote main --squash
    if test $status -eq 0
        echo "✅ All synced successfully"
    else
        echo "❌ nvim subtree pull failed"
    end
end

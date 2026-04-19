function git-push
    if test (count $argv) -gt 0
        set msg $argv
    else
        set msg "update dotfiles"
    end

    echo "📦 Adding changes..."
    git add .

    echo "💾 Committing..."
    git commit -m "$msg"

    if test $status -ne 0
        echo "⚠️ Nothing to commit"
    end

    echo "⬆️ Pushing dotfiles..."
    git push

    if test $status -ne 0
        echo "❌ dotfiles push failed"
        return 1
    end

    echo "🧠 Pushing nvim subtree..."
    git subtree push --prefix=.config/nvim nvim-remote main

    if test $status -eq 0
        echo "✅ All synced successfully"
    else
        echo "❌ nvim subtree push failed"
    end
end

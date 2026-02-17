
One off setup

```
brew install direnv

# ZSH: Add the following line at the end of the ~/.zshrc file:
eval "$(direnv hook zsh)"

mkdir -p ~/.cache/bundle
npm config set cache "$HOME/.cache/npm"
yarn config set cache-folder "$HOME/.cache/yarn"
```

Create a new worktree
```
bin/new-worktree <name>
```

Daily flow in a worktree
```
cd ../core.worktrees/<name>
bin/agent-boot
```

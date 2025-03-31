## Aliases
Create a symlink from the `ZSH_CUSTOM` folder to the `dotfiles/my-aliases.zsh` file.

```sh
# Create new symlink
ln -s ~/dev/dotfiles/my-aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh

# If the symlink already exists, use -f to force creation
ln -sf ~/dev/dotfiles/my-aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
```

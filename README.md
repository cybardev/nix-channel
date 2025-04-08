# nix-channel

A Nix channel for my packages

> [!NOTE]
> See [`pkgs/`](./pkgs) for list of available packages.

## Usage

### Channels

1. Add the channel:

    ```sh
    sudo -H nix-channel --add "https://github.com/cybardev/nix-channel/archive/main.tar.gz" cypkgs
    sudo -H nix-channel --update
    ```

2. Use in Nix config. Example: [github.com/cybardev/nix-dotfiles/blob/5716763/packages/common.nix#L7](<https://github.com/cybardev/nix-dotfiles/blob/571676319abbd5da3e81c750a7e7ef833e389115/packages/common.nix#L7>)

### Flakes

Honestly, I don't know. If you want to use flakes, you probably know much better than I do how to use this repository. Good luck~

Though, I do use it myself this way: [github.com/cybardev/nix-dotfiles/blob/87ac41c/flake.nix#L24](<https://github.com/cybardev/nix-dotfiles/blob/87ac41c388b815ee771dc58023610b4eaf04463f/flake.nix#L24>)

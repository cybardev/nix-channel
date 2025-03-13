# nix-channel

A Nix channel for my packages

## Usage

1. Add the channel:

    ```sh
    sudo -H nix-channel --add "https://github.com/cybardev/nix-channel/archive/main.tar.gz" cypkgs
    sudo -H nix-channel --update
    ```

2. Use in Nix config. Example: [github.com/cybardev/nix-dotfiles/blob/5716763/packages/common.nix#L7](<https://github.com/cybardev/nix-dotfiles/blob/571676319abbd5da3e81c750a7e7ef833e389115/packages/common.nix#L7>)

<div align="center">
<h1>veplix's hyprland-dotfiles</h1>
</div>

<div align="center">
  
  ## Showcase
  
  <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/preview.jpg">
</div>

## Main Features

### Alacritty

  <p>Simple, GPU-accelerated terminal emulator written in Rust. It supports scrollback, 24-bit colors, copy/paste, clicking on URLs, and custom key bindings<br>
  In rice used zsh shell and +oh-my-zsh with theme powerlevel10k and plugins</p>
  <details>
    <summary>Screenshot</summary>
    <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/alacritty.jpg">
  </details>


### Waybar

  Highly customizable Wayland bar for Sway and Wlroots based compositors.
  <details>
    <summary>Screenshot</summary>
  <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/Waybar.png">
</details>

### Rofi

  Rofi: A window switcher, application launcher and dmenu replacement. On rofi written my custom scripts: "Power Menu", "Wi-fi Menu" and "Wallpaper Changer". All of those scripts are situated in `/main/.scipts` or `~/.scripts` after install.
    Unfortunately you need to run "Wallpapers Changer" manually because for changing wallpapers for sddm theme needed sudo+password
    <details>
      <summary>Screenshots (Rofi, Power Menu, Wi-fi Menu and Wallpaper Changer)</summary>
        <details>
          <summary>Rofi</summary>
          <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/rofi.jpg"></p>
        </details>
        <details>
          <summary>Power Menu</summary>
          <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/Power_Menu.jpg">
        </details>
        <details>
          <summary>Wi-fi Menu</summary>
          <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/Wi-fi_Menu.jpg">
        </details>
        <details>
          <summary>Wallpaper Changer</summary>
          <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/Wallpapers_Changer.jpg">
        </details>
    </details>

### Nemo (file manager)

  Nemo is a free and open-source software and official file manager of the Cinnamon desktop environment. It is a fork of GNOME Files (formerly named Nautilus). (Im using this instead of Thunar because nemo fixes some issues that i had in Thunar)
  <details>
    <summary>Screenshot</summary>
  <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/nemo.jpg">
</details>

### Neovim

  Neovim is a Vim-based text editor engineered for extensibility and usability, to encourage new applications and contributions with plugin support.  
  Added alias-`sudo -E nvim=nvim`(through oh-my-zsh) now you dont need write everytime sudo, just `nvim /path/to/file`
  Contains also plugins for autosuggestion/autocompletition `~/.config.nvim/lua/plugins/autosuggestion.lua`: `cmp-nvim-lsp`, `cmp-bufer`, `cmp-path`, `cmp-cmdline`, `cmp_luasnip`, `LuaSnip`, `friendly-snippets`, `lspkind-nvim`  
  Plugin managerfor nvim:Lazy</p>
  <details>
    <summary>Screenshot</summary>
  <img src="https://raw.githubusercontent.com/veplix/Hyprland-dotfiles/refs/heads/main/screenshots/nvim.jpg">
</details>

## Keybinds
- Keybinds [`CLICK`]:(https://github.com/veplix/Hyprland-dotfiles/wiki/Keybinds)

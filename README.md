## Requirements

- Neovim >= 0.10
- [fzf](https://github.com/junegunn/fzf) (for fzf-lua)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for live grep)
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- `git`, `tmux` (optional, for sessionizer)
- `yazi` (optional, for file manager integration)
- [lazygit](https://github.com/jesseduffield/lazygit) (optional, for lazygit integration)

## Installation

```bash
git clone https://github.com/matheussalinas/nvim ~/.config/nvim
```

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point
└── lua/
    ├── config/
    │   ├── lazy.lua      # Plugin manager setup
    │   ├── remap.lua     # Global keymaps
    │   └── set.lua       # Vim options
    └── plugins/          # One file per plugin
```

## Plugins

| Plugin | Purpose |
|--------|---------|
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | Fuzzy finder (files, grep, git, LSP) |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File system navigation |
| [harpoon](https://github.com/ThePrimeagen/harpoon) | File bookmarks |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | LazyGit integration |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git hunk signs and actions |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [undotree](https://github.com/mbbill/undotree) | Undo history visualizer |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | Find and replace |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [rose-pine](https://github.com/rose-pine/neovim) | Colorscheme |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown rendering |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight TODOs |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [mini.pairs](https://github.com/echasnovski/mini.pairs) | Auto pairs |
| [vim-sleuth](https://github.com/tpope/vim-sleuth) | Auto indent detection |

## Keymaps

`<leader>` is `Space`.

### General

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>v` | Vertical split |
| `<leader>h` | Horizontal split |
| `<leader>s` | Search & replace word under cursor |
| `<leader>x` | Make file executable |
| `<leader>o` | Open URL under cursor |
| `<leader>u` | Toggle undotree |
| `<A-s>` | Open tmux sessionizer |
| `<A-e>` | Open yazi |

### Navigation

| Key | Action |
|-----|--------|
| `<C-d>` / `<C-u>` | Scroll half-page down/up (centered) |
| `n` / `N` | Next/prev search result (centered) |
| `J` / `K` (visual) | Move selected lines down/up |

### Clipboard

| Key | Action |
|-----|--------|
| `<leader>y` / `<leader>Y` | Yank to system clipboard |
| `<leader>p` (visual) | Paste without overwriting register |
| `<leader>d` | Delete to void register |

### fzf-lua

| Key | Action |
|-----|--------|
| `<C-n>` | Find files |
| `<leader>ps` | Live grep |
| `<leader>fw` | Find word under cursor |
| `<leader>fd` | Find diagnostics |
| `<leader>fc` | Find in nvim config |
| `<leader>gb` | Git branches |
| `<leader>gc` | Git commits |
| `<C-t>` *(inside fzf)* | Toggle preview |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>rn` | Rename |
| `<leader>ca` | Code actions |
| `<leader>f` | Format |
| `<leader>tf` | Toggle format on save |
| `<leader>th` | Toggle inlay hints |

### Git

| Key | Action |
|-----|--------|
| `<leader>gl` | Open LazyGit |
| `]h` / `[h` | Next/prev hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gt` | Toggle line blame |

### Oil

| Key | Action |
|-----|--------|
| `-` | Open parent directory (float) |
| `<BS>` | Go to parent directory |
| `.` | Toggle hidden files |
| `<Esc>` | Close oil |

### Harpoon

| Key | Action |
|-----|--------|
| `<leader>a` | Add file to list |
| `<C-e>` | Toggle harpoon menu |
| `<A-1>` – `<A-4>` | Jump to file 1–4 |

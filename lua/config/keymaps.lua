-- All keymaps live here.
--
-- Plugin keymaps call `require("<plugin>")` inside the callback: lazy.nvim
-- loads the plugin on first require, so lazy-loading keeps working without
-- `keys = {}` in the plugin specs.
--
-- Not here: keys that only exist inside a plugin's own window (blink menu,
-- fzf-lua picker, oil buffer). Those stay in the plugin config.
--
-- Search all keymaps from inside nvim: <leader>fk

local map = vim.keymap.set

-- stylua: ignore start

-- Editor ---------------------------------------------------------------------
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>h", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw" })
map("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
map("n", "<leader>x", "<cmd>!chmod +x %<cr>", { desc = "Make file executable" })
map("n", "<leader>o", function() vim.ui.open(vim.fn.expand("<cWORD>")) end, { desc = "Open URL under cursor" })
map("n", "<leader>cp", function()
    local path = vim.fn.expand("%")
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path)
end, { desc = "Copy file path to clipboard" })

-- Navigation -----------------------------------------------------------------
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
map("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Clipboard / registers ------------------------------------------------------
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

-- External tools (tmux) ------------------------------------------------------
map("n", "<A-s>", "<cmd>silent !tmux neww tmux-sessionizer<cr>", { desc = "tmux sessionizer" })
map("n", "<A-e>", "<cmd>silent !tmux neww yazi<cr>", { desc = "Open yazi" })

-- Find (fzf-lua) -------------------------------------------------------------
map("n", "<C-n>", function() require("fzf-lua").files() end, { desc = "Find files" })
map("n", "<leader>ps", function() require("fzf-lua").live_grep() end, { desc = "Live grep" })
map("n", "<leader>fw", function() require("fzf-lua").grep_cword() end, { desc = "Find word under cursor" })
map("v", "<C-f>", function() require("fzf-lua").grep_visual() end, { desc = "Grep selection" })
map("n", "<leader>fd", function() require("fzf-lua").diagnostics_document() end, { desc = "Find diagnostics" })
map("n", "<leader>fc", function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find in nvim config" })
map("n", "<leader>fk", function() require("fzf-lua").keymaps() end, { desc = "Find keymaps" })
map("n", "<leader>pt", "<cmd>TodoFzfLua<cr>", { desc = "Find TODOs" })

-- Files ----------------------------------------------------------------------
map("n", "<C-b>", "<cmd>Oil --float<cr>", { desc = "Open parent directory (oil)" })
map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undotree" })

-- Harpoon --------------------------------------------------------------------
map("n", "<leader>a", function() require("harpoon"):list():add() end, { desc = "Harpoon add file" })
map("n", "<C-e>", function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end, { desc = "Harpoon menu" })
map("n", "<A-h>", function() require("harpoon"):list():select(1) end, { desc = "Harpoon file 1" })
map("n", "<A-j>", function() require("harpoon"):list():select(2) end, { desc = "Harpoon file 2" })
map("n", "<A-k>", function() require("harpoon"):list():select(3) end, { desc = "Harpoon file 3" })
map("n", "<A-l>", function() require("harpoon"):list():select(4) end, { desc = "Harpoon file 4" })

-- Git ------------------------------------------------------------------------
map("n", "<leader>gl", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>gb", function() require("fzf-lua").git_branches() end, { desc = "Git branches" })
map("n", "<leader>gc", function() require("fzf-lua").git_commits() end, { desc = "Git commits" })
map("n", "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next hunk" })
map("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Prev hunk" })
map("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" })
map("n", "<leader>gs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
map("n", "<leader>gr", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
map("n", "<leader>gt", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Toggle line blame" })

-- Format ---------------------------------------------------------------------
map("n", "<leader>cf", function() require("conform").format({ lsp_format = "fallback" }) end, { desc = "Format buffer" })
map("n", "<leader>tf", function()
    vim.g.disable_format_on_save = not vim.g.disable_format_on_save
    local state = vim.g.disable_format_on_save and "disabled" or "enabled"
    require("fidget").notify("Format on save " .. state, vim.log.levels.INFO)
end, { desc = "Toggle format on save" })

-- Toggles --------------------------------------------------------------------
map("n", "<leader>ti", "<cmd>IBLToggle<cr>", { desc = "Toggle indent guides" })
map("n", "<leader>tl", "<cmd>TodoLocList<cr>", { desc = "TODOs in location list" })

-- stylua: ignore end

local M = {}

--- LSP keymaps, buffer-local. Called from the LspAttach autocmd in plugins/lsp.lua.
---@param buf integer
---@param client vim.lsp.Client?
function M.lsp(buf, client)
    local function lmap(lhs, rhs, desc)
        map("n", lhs, rhs, { buffer = buf, desc = desc })
    end

    -- stylua: ignore start
    lmap("gd", function() require("fzf-lua").lsp_definitions() end, "Go to definition")
    lmap("grr", function() require("fzf-lua").lsp_references() end, "Go to references")
    lmap("gri", function() require("fzf-lua").lsp_implementations() end, "Go to implementation")
    lmap("gD", vim.lsp.buf.declaration, "Go to declaration")
    lmap("<leader>D", function() require("fzf-lua").lsp_typedefs() end, "Type definition")
    lmap("<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, "Document symbols")
    lmap("<leader>rn", vim.lsp.buf.rename, "Rename")
    lmap("<leader>ca", function() require("fzf-lua").lsp_code_actions() end, "Code actions")
    lmap("<C-k>", vim.lsp.buf.hover, "Hover")
    -- stylua: ignore end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        lmap("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
        end, "Toggle inlay hints")
    end
end

return M

-- All user commands live here.

vim.api.nvim_create_user_command("Update", function()
    vim.notify("Updating...")
    vim.fn.jobstart({ "git", "pull" }, {
        cwd = vim.fn.stdpath("config"),
        on_exit = function(_, code)
            if code ~= 0 then
                vim.notify("git pull failed", vim.log.levels.ERROR)
                return
            end
            vim.cmd("Lazy restore")
            vim.notify("Neovim updated, restart to apply changes.")
        end,
    })
end, { desc = "Pull config and restore plugins" })

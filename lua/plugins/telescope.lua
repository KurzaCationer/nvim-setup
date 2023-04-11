return {
    {
        'nvim-telescope/telescope.nvim',
        name = 'telescope',
        tag = '0.1.1',
        cmd = "Telescope",
        lazy = true,
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            defaults = {
                file_ignore_patterns = { ".git", "node_modules" }
            }
        },
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        name = 'telescope-file-browser',
        lazy = true,
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require 'telescope'.load_extension "file_browser"
        end
    }
}

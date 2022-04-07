-- Indentation
-- Set default indentation to tab with 4 spaces length
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Folding
-- Use folding based on text indentation
vim.opt.foldmethod = "indent"
-- Limit folding level
vim.opt.foldnestmax = 3
-- Open files with all folds open
vim.opt.foldenable = false

-- Searching
-- Be case insensitive for small caps, sensitive otherwise
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- User interface
-- Show statusline only if splits are open
vim.opt.laststatus = 1
-- Show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- Default split direction
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Netrw
-- Disable top banner
vim.g.netrw_banner = 0
-- Normal cursor
vim.g.netrw_cursor = 0
-- Start with hidden dotfiles
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]

-- System behaviour
vim.opt.updatetime = 100
-- Use system clipboard
if vim.fn.has("macunix") then
    vim.opt.clipboard = "unnamed"
else
    vim.opt.clipboard = "unnamedplus"
end

-- If running embedded in VS Code then exit early
if vim.g.vscode then
    return
end

-- Plugins
require("packer").startup(
    function()
        use "wbthomason/packer.nvim"
        use "nvim-treesitter/nvim-treesitter"
        use "lewis6991/spellsitter.nvim"
        use "neovim/nvim-lspconfig"
        use "hrsh7th/nvim-cmp"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/cmp-path"
        use "hrsh7th/cmp-cmdline"
        use "hrsh7th/cmp-nvim-lsp"
        use "NMAC427/guess-indent.nvim"
        use "terrortylor/nvim-comment"
        use "lewis6991/gitsigns.nvim"
        use "lukas-reineke/indent-blankline.nvim"
        use {"nvim-telescope/telescope.nvim", requires = {"nvim-lua/plenary.nvim"}}
        use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
        use "joshdick/onedark.vim"
    end
)

-- Treesitter

local treesitter = require "nvim-treesitter.configs"
treesitter.setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true
    }
}

-- Reconcile treesitter and spellchecking
require("spellsitter").setup()

-- LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local lspconfig = require("lspconfig")
-- Register servers
local servers = {"clangd", "pylsp"}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = function(client, bufnr)
            local opts = {noremap = true, silent = true}
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
            vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            vim.api.nvim_set_keymap("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
            vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
            vim.api.nvim_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
            vim.api.nvim_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
            vim.api.nvim_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
            vim.api.nvim_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
            vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
            vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
            vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
            vim.api.nvim_set_keymap("n", "<leader>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        end,
        capabilities = capabilities
    }
end

-- Completion

-- Use LSP and buffer for text completion
local cmp = require "cmp"
cmp.setup {
    sources = cmp.config.sources(
        {
            {name = "nvim_lsp"},
            {name = "path"}
        },
        {
            {name = "buffer"}
        }
    ),
    mapping = {
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-1),
        ["<C-f>"] = cmp.mapping.scroll_docs(1),
        ["<C-Space>"] = cmp.mapping.complete()
    }
}

-- Use buffer source for command line completion
cmp.setup.cmdline(
    "/",
    {
        sources = {
            {name = "buffer"}
        }
    }
)

-- Use cmdline and path sources for command line completion
cmp.setup.cmdline(
    ":",
    {
        sources = cmp.config.sources(
            {
                {name = "path"}
            },
            {
                {name = "cmdline"}
            }
        )
    }
)

-- Automatic indentation (if indent is detected will override the defaults)
require("guess-indent").setup()

-- Code commenting
require("nvim_comment").setup()

-- Telescope file finder
require("telescope").load_extension("fzf")

-- Git signs gutter and hunk navigation
require("gitsigns").setup {
    on_attach = function(client, bufnr)
        -- Navigation
        vim.api.nvim_set_keymap("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr = true})
        vim.api.nvim_set_keymap("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr = true})

        local opts = {noremap = true, silent = true}
        -- Actions
        vim.api.nvim_set_keymap("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", opts)
        vim.api.nvim_set_keymap("v", "<leader>hs", ":Gitsigns stage_hunk<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", opts)
        vim.api.nvim_set_keymap("v", "<leader>hr", ":Gitsigns reset_hunk<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', opts)
        vim.api.nvim_set_keymap("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>", opts)
        -- Diff with staged changes shown
        vim.api.nvim_set_keymap("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>', opts)
        vim.api.nvim_set_keymap("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>", opts)
    end
}

-- Other key mappings

-- Set leader to space
vim.g.mapleader = " "
-- Default opts (nonrecursive)
local opts = {noremap = true, silent = true}
-- Netrw
vim.api.nvim_set_keymap("n", "<leader>j", ":Explore<CR>", opts)
--- Telescope
vim.api.nvim_set_keymap("n", "<leader>ff", ':lua require"telescope.builtin".find_files()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>fg", ':lua require"telescope.builtin".live_grep()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>fs", ':lua require"telescope.builtin".grep_string()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>fh", ':lua require"telescope.builtin".help_tags()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>fb", ':lua require"telescope.builtin".buffers()<CR>', opts)

-- Colorschem

vim.cmd([[colorscheme onedark]])

--- Fixes and workarounds

-- Disable error highlighting for markdown
vim.api.nvim_exec([[ highlight link markdownError None ]], false)
-- Force indent guessing on buffer open
vim.api.nvim_exec([[ autocmd BufReadPost * :silent GuessIndent ]], false)

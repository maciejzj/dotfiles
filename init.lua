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
-- Auto reload changed files from disk
vim.opt.autoread = true
-- Disable mouse
vim.opt.mouse = nil

-- Plugins
require("packer").startup(
function()
    use "NMAC427/guess-indent.nvim"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-path"
    use "hrsh7th/nvim-cmp"
    use "joshdick/onedark.vim"
    use "lewis6991/gitsigns.nvim"
    use "lewis6991/spellsitter.nvim"
    use "lukas-reineke/indent-blankline.nvim"
    use "neovim/nvim-lspconfig"
    use "nvim-treesitter/nvim-treesitter"
    use "ray-x/lsp_signature.nvim"
    use "terrortylor/nvim-comment"
    use "wbthomason/packer.nvim"
    use "kylechui/nvim-surround"
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "rrethy/nvim-treesitter-textsubjects"
    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
    use {"nvim-telescope/telescope.nvim", requires = {"nvim-lua/plenary.nvim"}}
end
)

-- Automatic indentation (if indent is detected will override the defaults)
require("guess-indent").setup()

-- Indent guides
require("indent_blankline").setup()

-- Code commenting
require("nvim_comment").setup()

-- Surround motions
require("nvim-surround").setup()

-- If using vscode exit early and don't load the rest of the plugins
if vim.g.vscode then
    return
end

-- Treesitter

local treesitter = require "nvim-treesitter.configs"
treesitter.setup {
    ensure_installed = "all",
    highlight = {
        enable = true
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner"
            }
        }
    },
    textsubjects = {
        enable = true,
        keymaps = {
            ['.'] = 'textsubjects-smart',
        }
    },
}

-- Reconcile treesitter and spellchecking
require("spellsitter").setup()

-- LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local lspconfig = require("lspconfig")

-- Diagnostics bindings
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Register servers
local servers = {"clangd", "pylsp", "texlab"}
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

-- LSP based signatures when passing arguments
require("lsp_signature").setup {
    hint_enable = false,
}

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
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<C-f>"] = cmp.mapping.scroll_docs(1),
        ["<C-b>"] = cmp.mapping.scroll_docs(-1),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    })
}

-- Use buffer source for command line completion
cmp.setup.cmdline(
"/",
{
    sources = {
        {name = "buffer"}
    },
    mapping = cmp.mapping.preset.cmdline()
}
)

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

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
-- Telescope
vim.api.nvim_set_keymap("n", "<leader>ff", ':lua require"telescope.builtin".find_files()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>fg", ':lua require"telescope.builtin".live_grep()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>fs", ':lua require"telescope.builtin".grep_string()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>fc", ':lua require"telescope.builtin".commands()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>fh", ':lua require"telescope.builtin".help_tags()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>fb", ':lua require"telescope.builtin".buffers()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>gc", ':lua require"telescope.builtin".find_files()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>gb", ':lua require"telescope.builtin".git_commits()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>gf", ':lua require"telescope.builtin".git_bcommits()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>gs", ':lua require"telescope.builtin".git_status()<CR>', opts)
-- Exit insert mode interminal with the Escape key
vim.api.nvim_set_keymap("t", "<esc>", "<C-\\><C-n>", opts)
-- Show/hide Diagnostics
vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
    if vim.g.diagnostics_visible then
        vim.g.diagnostics_visible = false
        vim.diagnostic.disable()
    else
        vim.g.diagnostics_visible = true
        vim.diagnostic.enable()
    end
end
vim.api.nvim_set_keymap("n", "<Leader>d", ":call v:lua.toggle_diagnostics()<CR>", opts)

-- Colorscheme
vim.cmd([[colorscheme onedark]])

--- Fixes and workarounds

-- Disable error highlighting for markdown
vim.api.nvim_exec([[ highlight link markdownError None ]], false)

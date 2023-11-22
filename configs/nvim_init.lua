----------✦ 📝 Editor setup 📝 ✦----------

-- Indentation
-- Set default indentation to tab with 4 spaces length
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Textwidth
vim.opt.textwidth = 80
-- Don't use hard autowrap on textwidth
vim.opt.formatoptions:remove({ "t" })

-- Folding
-- Use folding based on text indentation
vim.opt.foldmethod = "indent"
-- Limit folding level
vim.opt.foldnestmax = 3
-- Open files with all folds open
vim.opt.foldenable = false
vim.opt.foldlevelstart = 100

-- Searching
-- Be case insensitive for small caps, sensitive otherwise
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Whitespace characters representation
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

-- User interface
-- Show cursorline
vim.opt.cursorline = true
-- Show statusline only if splits are open
vim.opt.laststatus = 1
-- Show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- Default split direction
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Sbow whitesapce as the dot char
vim.opt.fillchars = { diff = "⋅" }

-- System behaviour
vim.opt.updatetime = 100
-- Use system clipboard
if vim.fn.has("macunix") then
  vim.opt.clipboard = "unnamed"
else
  vim.opt.clipboard = "unnamedplus"
end

-- Auto reload changed files from disk
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'command' | silent! checktime | endif",
  pattern = { "*" },
})

-- Disable mouse
vim.opt.mouse = nil

-- Set leader to space
vim.g.mapleader = " "

-- Helper function to define mapping with default options and a description
local function defopts(desc)
  return { noremap = true, silent = true, desc = desc }
end

----------✦ 📦 Plugins setup 📦 ✦----------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  "williamboman/mason.nvim",

  -- Help
  "folke/which-key.nvim",
  -- Treesitter
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "chrisgrieser/nvim-various-textobjs",
  -- LSP
  "neovim/nvim-lspconfig",
  "williamboman/mason-lspconfig.nvim",
  "nvimtools/none-ls.nvim",
  "antosha417/nvim-lsp-file-operations",
  "ray-x/lsp_signature.nvim",
  -- Core functionalities
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-path",
  "l3mon4d3/luasnip",
  "nmac427/guess-indent.nvim",
  "theprimeagen/refactoring.nvim",
  -- Editor functionalities
  "kylechui/nvim-surround",
  "rrethy/vim-illuminate",
  "numtostr/comment.nvim",
  -- UI, visuals and tooling
  "stevearc/dressing.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-neo-tree/neo-tree.nvim", dependencies = { "nvim-lua/plenary.nvim", "muniftanjim/nui.nvim" } },
  "lukas-reineke/indent-blankline.nvim",
  "joshdick/onedark.vim",
  -- External tools integration
  "lewis6991/gitsigns.nvim",
  { "folke/neodev.nvim", opts = {} }
})

----------✦ ❓ Help ❓ ✦----------

local wk = require("which-key")
wk.setup()

----------✦ 🌳 Treesitter 🌳 ✦----------

require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "outer function" },
        ["if"] = { query = "@function.inner", desc = "inner function" },
        ["ac"] = { query = "@class.outer", desc = "outer class" },
        ["ic"] = { query = "@class.inner", desc = "inner class" },
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = { query = "@class.outer", desc = "Next class end" },
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = { query = "@class.outer", desc = "Previous class start" },
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = { query = "@class.outer", desc = "Previous class end" },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>ln"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
      },
      swap_previous = {
        ["<leader>lp"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
      },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "<C-n>",
      node_decremental = "<C-p>",
    },
  },
})

-- Extra text objects
require('various-textobjs').setup({ useDefaultKeymaps = true })

----------✦ 🛠️ LSP 🛠️ ✦----------

local servers = {
  pylsp = {}, clangd = {}, cmake = {}, bashls = {}, dockerls = {}, html = {},
  cssls = {}, jsonls = {}, yamlls = {}, marksman = {}, texlab = {},
}

local on_attach = function(client, bufnr)
  -- Disable highlighting, we use Treesitter for that
  client.server_capabilities.semanticTokensProvider = nil

  -- Lsp bindings
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, defopts("Definition"))
  vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, defopts("Definition"))
  vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, defopts("Type definition"))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, defopts("Declaration"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, defopts("Hover"))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, defopts("Implementation"))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, defopts("Show signature"))
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, defopts("Rename symbol"))
  vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, defopts("Code action"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, defopts("References"))

  -- Diagnostics bindings
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, defopts("Show diagnostics"))
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, defopts("Next diagnostics"))
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, defopts("Previous diagnostics"))
  vim.keymap.set("n", "<space>d", vim.diagnostic.setloclist, defopts("Diagnostics list"))

  -- Telescope-LSP bindings
  local tb = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ls", tb.lsp_document_symbols, defopts("Browse buffer symbols"))
  vim.keymap.set("n", "<leader>lS", tb.lsp_workspace_symbols, defopts("Browse workspace symbols"))
  vim.keymap.set("n", "<leader>lr", tb.lsp_references, defopts("Browse symbol references"))
  vim.keymap.set("n", "<leader>D", tb.diagnostics, defopts("Browse workspace diagnostics"))
  -- Exit insert mode interminal with the Escape key
  vim.keymap.set("t", "<esc>", "<C-\\><C-n>")

  -- Formatting
  vim.keymap.set("n", "<leader>F", function()
    vim.lsp.buf.format({ async = true })
  end, defopts("Format with lsp"))

  -- Show/hide Diagnostics
  vim.g.diagnostics_visible = true
  function _G.toggle_diagnostics()
    if vim.g.diagnostics_visible then
      vim.g.diagnostics_visible = false
      vim.diagnostic.disable()
      print("Diagnostics off")
    else
      vim.g.diagnostics_visible = true
      vim.diagnostic.enable()
      print("Diagnostics on")
    end
  end

  vim.keymap.set("n", "<leader>td", toggle_diagnostics, defopts("Toggle diagnostics"))
end

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })

-- Register servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
require("mason-lspconfig").setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
})

-- None-ls extra LSP servers
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
    -- Causes some issues because for: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1618
    null_ls.builtins.diagnostics.mypy.with({
      extra_args = function()
        local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
        return { "--python-executable", virtual .. "/bin/python3" }
      end,
    }),
    null_ls.builtins.code_actions.refactoring,
  },
})

-- LSP-related operations on files in NeoTree
require("lsp-file-operations").setup()

-- LSP based signatures when passing arguments
require("lsp_signature").setup({
  hint_enable = false,
  toggle_key = "<C-s>",
  toggle_key_flip_floatwin_setting = true,
})

-- LSP & related floating windows styling
vim.diagnostic.config({
  float = { border = "rounded" },
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { style = "minimal", border = "rounded" }
)

----------✦ ⚙️  Core functionalities ⚙️ ✦----------

-- Code completion
local cmp = require("cmp")
-- LSP
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<C-f>"] = cmp.mapping.scroll_docs(1),
    ["<C-b>"] = cmp.mapping.scroll_docs(-1),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-e>"] = cmp.mapping.abort(),
  }),
})
-- From buffer
cmp.setup.cmdline({ "/", "?" }, {
  sources = {
    { name = "buffer" },
  },
  mapping = cmp.mapping.preset.cmdline(),
})
-- For command line
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- Snippers
local ls = require("luasnip")
vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- Automatic indentation (if indent is detected will override the defaults)
require("guess-indent").setup()

-- Refactoring tools
require("refactoring").setup()
vim.keymap.set({ "n", "x" }, "<leader>R", function()
  require("refactoring").select_refactor()
end, defopts("Refactor"))

----------✦ 🔠 Editor functionalities 🔠 ✦----------

-- Surround motions
require("nvim-surround").setup()

-- Symbols highlighting
require("illuminate").configure({
  providers = {
    "lsp",
    "treesitter",
    -- 'regex' is ommited here on purpose, I dont' want it
  },
  delay = 500, -- A bit longer than the default
})

-- Code commenting
require("Comment").setup()

----------✦ ✨ UI, visuals and tooling ✨ ✦----------

-- Better UI components
require("dressing").setup()

-- Telescope file finder
local telescope = require("telescope")
telescope.setup({
  defaults = {
    mappings = {
      i = {
        -- Show picker actions help with which-key
        ["<C-h>"] = "which_key",
      },
    },
    vimgrep_arguments = { "rg", "--vimgrep", "--smart-case", "--type-not", "jupyter" },
  },
})
telescope.load_extension("fzf")

local tb = require("telescope.builtin")



vim.keymap.set("n", "<leader>ff", tb.find_files, defopts("Find file"))
vim.keymap.set("n", "<leader>fg", tb.current_buffer_fuzzy_find, defopts("Grep in buffer"))
vim.keymap.set("n", "<leader>fG", tb.live_grep, defopts("Grep in workspace"))
vim.keymap.set("n", "<leader>fs", tb.grep_string, defopts("Find string (at cursor)"))
vim.keymap.set("n", "<leader>fc", tb.commands, defopts("Find command"))
vim.keymap.set("n", "<leader>fh", tb.help_tags, defopts("Search help"))
vim.keymap.set("n", "<leader>fr", tb.command_history, defopts("Search command history"))
vim.keymap.set("n", "<leader>fb", tb.buffers, defopts("Find buffer"))
vim.keymap.set("n", "<leader>fk", tb.keymaps, defopts("Find keymap"))
vim.keymap.set("n", "<leader>fm", tb.marks, defopts("Find mark"))

-- Telescope git status
vim.fn.system("git rev-parse --is-inside-work-tree")
if vim.v.shell_error == 0 then
  wk.register({ ["<leader>g"] = { name = "git" } })
  vim.keymap.set("n", "<leader>gc", tb.git_commits, defopts("Browse commits"))
  vim.keymap.set("n", "<leader>gC", tb.git_bcommits, defopts("Browse buffer commits"))
  vim.keymap.set("n", "<leader>gb", tb.git_branches, defopts("Browse branches"))
  vim.keymap.set("n", "<leader>gs", tb.git_status, defopts("Browse git status"))
end

-- File explorer/file tree
require("neo-tree").setup({
  popup_border_style = "rounded",
  window = {
    position = "float",
  },
  default_component_configs = {
    icon = {
      default = "",
    },
  },
})

-- Indent guides
require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = false },
})

----------✦ ⚡️ External tools integration ⚡️ ✦----------

-- Git signs gutter and hunk navigation
require("gitsigns").setup({
  on_attach = function(client, bufnr)
    local gs = package.loaded.gitsigns

    -- Hunk navigation
    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Next hunk" })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Previous hunk" })

    wk.register({
      ["<leader>h"] = { name = "git hunk" },
    })

    -- Actions
    vim.keymap.set("n", "<leader>hs", gs.stage_hunk, defopts("Stage hunk"))
    vim.keymap.set("n", "<leader>hr", gs.reset_hunk, defopts("Restore hunk"))
    vim.keymap.set("n", "<leader>hS", gs.stage_buffer, defopts("Stage buffer"))
    vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, defopts("Unstage hunk"))
    vim.keymap.set("n", "<leader>hR", gs.reset_buffer, defopts("Restore buffer"))
    vim.keymap.set("n", "<leader>hp", gs.preview_hunk, defopts("Preview hunk"))
    vim.keymap.set("n", "<leader>hb", gs.blame_line, defopts("Blame line"))
    vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, defopts("Toggle line blame"))
    vim.keymap.set("n", "<leader>gd", gs.diffthis, defopts("Diff buffer"))
    vim.keymap.set("n", "<leader>gD", function()
      gs.diffthis("~")
    end, defopts("Diff buffer (with staged)"))
    vim.keymap.set("n", "<leader>tD", gs.toggle_deleted, defopts("Toggle show deleted"))
  end,
})

----------✦ ☎️  Keymaps ☎️  ✦----------

-- Mapping groups
wk.register({
  ["<leader>c"] = { name = "config" },
  ["<leader>f"] = { name = "find" },
  ["<leader>g"] = { name = "git" },
  ["<leader>l"] = { name = "language symbols" },
  ["<leader>p"] = { name = "plugins" },
  ["<leader>t"] = { name = "toggle" },
})
vim.keymap.set('o', '<a-i>', require('illuminate').textobj_select, { desc="highlighted symbol" })
vim.keymap.set('x', '<a-i>', require('illuminate').textobj_select, { desc="highlighted symbol" })

-- General nvim functionalities keymaps

vim.keymap.set("n", "<leader>E", ":Neotree<CR>", defopts("File explorer"))
vim.keymap.set("n", "<leader>ce", ":edit ~/.config/nvim/init.lua<CR>", defopts("Edit config"))
vim.keymap.set(
  "n",
  "<leader>cr",
  ":source ~/.config/nvim/init.lua<CR>:GuessIndent<CR>",
  defopts("Reload config")
)
vim.keymap.set("n", "<leader>n", ":nohlsearch<CR>", defopts("Hide search highlight"))
vim.keymap.set("n", "<leader>qq", ":copen<CR>", defopts("Open quickfix list"))
vim.keymap.set("n", "<leader>qn", ":cnext<CR>", defopts("Open quickfix list"))
vim.keymap.set("n", "<leader>qp", ":cprev<CR>", defopts("Open quickfix list"))
vim.keymap.set("n", "<leader>ts", ":set spell!<CR>", defopts("Toggle spellchecking"))
vim.keymap.set("n", "<leader>tw", ":set list!<CR>", defopts("Toggle visible whitespace characters"))
vim.keymap.set("n", "<leader>s", "/\\s\\+$<CR>", defopts("Search trailing whitespaces"))

-- Plugin management keymaps

vim.keymap.set("n", "<leader>pp", ":Lazy<CR>", defopts("Lazy plugin packages panel"))
vim.keymap.set("n", "<leader>pm", ":Mason<CR>", defopts("Mason pakcages panel"))

----------✦ 🎨 Colorscheme 🎨 ✦----------

-- Main Colorscheme
vim.cmd.colorscheme("onedark")

-- Don't underline changed lines in diff
vim.api.nvim_set_hl(0, "DiffChange", { cterm = nil })

-- Highlight LSP symbol under cursor using underline
vim.api.nvim_set_hl(0, "IlluminatedWordText", { ctermbg = 237 })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { ctermbg = 237 })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { ctermbg = 237 })

-- Make NeoTree floating window bordor look same as the Telescope's one
vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { ctermbg = 0 })
vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { ctermbg = 0 })

----------✦ ⚠️  Fixes and workarounds ⚠️  ✦----------

-- Disable error highlighting for markdown
vim.api.nvim_set_hl(0, "markdownError", { link = nil })

-- Redraw indent guides after folding operations
for _, keymap in pairs({
  "zo", "zO", "zc", "zC", "za", "zA", "zv", "zx", "zX", "zm", "zM", "zr", "zR",
}) do
  vim.api.nvim_set_keymap(
    "n", keymap, keymap .. "<CMD>IndentBlanklineRefresh<CR>", { noremap = true, silent = true }
  )
end


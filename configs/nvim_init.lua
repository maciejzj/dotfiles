----------✦ 📝 Editor setup 📝 ✦----------

-- Indentation
-- Set default indentation to tab with 4 spaces length
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Textwidth
vim.opt.textwidth = 80
-- Don't use hard autowrap on textwidth
vim.opt.formatoptions:remove("t")

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
-- Disabled until https://github.com/neovim/neovim/issues/9800 is resolved
-- vim.opt.cursorline = true
-- Show statusline only if splits are open
vim.opt.laststatus = 1
-- Show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- Default split direction
vim.opt.splitbelow = true
vim.opt.splitright = true

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

-- Helper functions and utilities

-- Helper function to define mapping with default options and a description
local function defopts(desc)
  return { noremap = true, silent = true, desc = desc }
end

local function bufopts(desc, buffer)
  return { noremap = true, silent = true, desc = desc, buffer = buffer }
end

-- Extend existing highlight
local function extend_hl(name, new_opts)
  vim.api.nvim_set_hl(0, name, vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = name }), new_opts))
end

----------✦ 📦 Plugins setup 📦 ✦----------

-- Setup Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- Plugins
---@format disable-next
require("lazy").setup({
  -- Language support package management
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
  -- TODO: Rm this when nvim 10 is released (it will have built in commenting)
  "numtostr/comment.nvim",
  -- UI, visuals and tooling
  "stevearc/dressing.nvim",
  { "nvim-neo-tree/neo-tree.nvim", dependencies = { "nvim-lua/plenary.nvim", "muniftanjim/nui.nvim" } },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  "lukas-reineke/indent-blankline.nvim",
  "joshdick/onedark.vim",
  -- External tools integration
  "lewis6991/gitsigns.nvim",
  -- TODO: Track this issue to free up the pinned down commit:
  -- https://github.com/folke/neodev.nvim/issues/180
  {"folke/neodev.nvim", commit="7d86c1d844b883e7bf0634af48c8ffcb2d4bb088"},
  "catppuccin/nvim",
})

----------✦ ❓ Help ❓ ✦----------

local wk = require("which-key")
wk.setup()

----------✦ 🌳 Treesitter 🌳 ✦----------

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
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
      node_incremental = "<C-j>",
      node_decremental = "<C-k>",
    },
  },
})

-- Extra text objects
require("various-textobjs").setup({ useDefaultKeymaps = true, disabledKeymaps = { "gw", "gW" } })

----------✦ 🛠️ LSP 🛠️ ✦----------

---@format disable-next
local servers = {
  pyright = {
    python = { analysis = { typeCheckingMode = "off" } }
  },
  clangd = {}, lua_ls = {}, cmake = {}, bashls = {}, dockerls = {}, tsserver = {}, html = {},
  cssls = {}, jsonls = {}, yamlls = {}, marksman = {}, texlab = {},
}

local on_attach = function(client, bufnr)
  -- Disable highlighting, we use Treesitter for that
  client.server_capabilities.semanticTokensProvider = nil

  -- Lsp bindings
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts("Definition", bufnr))
  vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, bufopts("Definition", bufnr))
  vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, bufopts("Type definition", bufnr))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts("Declaration", bufnr))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts("Hover", bufnr))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts("Implementation", bufnr))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts("Show signature", bufnr))
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts("Rename symbol", bufnr))
  vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, bufopts("Code action", bufnr))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts("References", bufnr))

  -- Diagnostics bindings
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, bufopts("Show diagnostics", bufnr))
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts("Next diagnostics", bufnr))
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts("Previous diagnostics", bufnr))
  vim.keymap.set("n", "<space>d", vim.diagnostic.setloclist, bufopts("Diagnostics list", bufnr))

  -- Telescope-LSP bindings
  local tb = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ls", tb.lsp_document_symbols, bufopts("Browse buffer symbols", bufnr))
  vim.keymap.set("n", "<leader>lS", tb.lsp_dynamic_workspace_symbols, bufopts("Browse workspace symbols", bufnr))
  vim.keymap.set("n", "<leader>lr", tb.lsp_references, bufopts("Browse symbol references", bufnr))
  vim.keymap.set("n", "<leader>D", tb.diagnostics, bufopts("Browse workspace diagnostics", bufnr))

  -- Formatting
  vim.keymap.set("n", "<leader>F", function()
    vim.lsp.buf.format({ async = true })
  end, bufopts("Format with lsp", bufnr))

  -- Show/hide Diagnostics
  vim.g.diagnostics_visible = true
  function _G.toggle_diagnostics()
    if vim.g.diagnostics_visible then
      vim.g.diagnostics_visible = false
      vim.diagnostic.enable(false)
      print("Diagnostics off")
    else
      vim.g.diagnostics_visible = true
      vim.diagnostic.enable()
      print("Diagnostics on")
    end
  end

  vim.keymap.set("n", "<leader>td", toggle_diagnostics, bufopts("Toggle diagnostics", bufnr))

  -- Refactoring tools
  local refactoring = require("refactoring")
  refactoring.setup({ show_success_message = true })
  vim.keymap.set({ "n", "x" }, "<leader>R", function()
    refactoring.select_refactor({ show_success_message = true })
  end, bufopts("Refactor", bufnr))
end

require("neodev").setup({
  override = function(root_dir, library)
    -- Path-based override activation helps neodev work with symlinked dotfiles setup
    if root_dir:find("nvim") or root_dir:find("dotfiles") then
      library.enabled = true
      library.plugins = true
      library.types = true
      library.runtime = true
    end
  end
})
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })

-- Register servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
require("mason-lspconfig").setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup {
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
local luasnip = require("luasnip")
-- LSP
cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
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
    ["<C-f>"] = cmp.mapping.scroll_docs(1),
    ["<C-b>"] = cmp.mapping.scroll_docs(-1),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-e>"] = cmp.mapping.abort(),
    -- Tab and S-Tab for navigating completion and snippet placeholders
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
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
  mapping = cmp.mapping.preset.cmdline({
    ["<C-n>"] = { c = cmp.mapping.select_next_item() },
    ["<C-p>"] = { c = cmp.mapping.select_prev_item() },
  }),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- Snippets
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

----------✦ 🔠 Editor functionalities 🔠 ✦----------

-- Surround motions
require("nvim-surround").setup()

-- Symbols highlighting
require("illuminate").configure({
  providers = {
    "lsp",
    "treesitter",
    -- "regex" is ommited here on purpose, I dont' want it
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
local action_state = require("telescope.actions.state")
telescope.setup({
  defaults = {
    mappings = {
      -- Show picker actions help with which-key
      i = {
        ["<C-h>"] = "which_key",
        ["<C-e>"] = function(bufnr) action_state.get_current_picker(bufnr).previewer:scroll_fn(1) end,
        ["<C-y>"] = function(bufnr) action_state.get_current_picker(bufnr).previewer:scroll_fn(-1) end,
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
vim.keymap.set("n", "<leader>fj", tb.jumplist, defopts("Find mark"))
vim.keymap.set("n", "<leader>fb", tb.buffers, defopts("Find buffer"))
vim.keymap.set("n", "<leader>fk", tb.keymaps, defopts("Find keymap"))
vim.keymap.set("n", "<leader>fm", tb.marks, defopts("Find mark"))
vim.keymap.set("n", "<leader>fp", tb.builtin, defopts("Find telescope pickers"))

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
  preview_config = {
    border = 'rounded',
  },
  on_attach = function(client, bufnr)
    local gs = package.loaded.gitsigns

    -- Hunk navigation
    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(gs.next_hunk)
      return "<Ignore>"
    end, { expr = true, desc = "Next hunk" })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(gs.prev_hunk)
      return "<Ignore>"
    end, { expr = true, desc = "Previous hunk" })

    wk.register({ ["<leader>h"] = { name = "git hunk" } })

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
    vim.keymap.set("n", "<leader>gD", function() gs.diffthis("~") end, defopts("Diff buffer (with staged)"))
    vim.keymap.set("n", "<leader>tD", gs.toggle_deleted, defopts("Toggle show deleted"))
    -- Actions on visual selections
    vim.keymap.set("v", "<leader>s", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end,
      defopts("Stage selection"))
    vim.keymap.set("v", "<leader>r", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
      defopts("Restore selection"))
    -- Text object
    vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", defopts("git hunk"))
  end,
})

----------✦ ☎️  Keymaps ☎️  ✦----------

-- Mapping groups
wk.register({
  ["<leader>c"] = { name = "config" },
  ["<leader>f"] = { name = "find" },
  ["<leader>g"] = { name = "git" },
  ["<leader>gm"] = { name = "merge conflict" },
  ["<leader>l"] = { name = "language symbols" },
  ["<leader>p"] = { name = "plugins" },
  ["<leader>t"] = { name = "toggle" },
  ["<leader>q"] = { name = "quickfix" },
})
vim.keymap.set({ "o", "x" }, "<a-i>", require("illuminate").textobj_select, defopts("highlighted symbol"))

-- General nvim functionalities keymaps

vim.keymap.set("n", "<leader>E", ":Neotree<CR>", defopts("File explorer"))
vim.keymap.set("n", "<leader>ce", ":edit ~/.config/nvim/init.lua<CR>", defopts("Edit config"))
vim.keymap.set("n", "<leader>cr", ":source ~/.config/nvim/init.lua<CR>:GuessIndent<CR>", defopts("Reload config"))
vim.keymap.set("n", "<leader>n", ":nohlsearch<CR>", defopts("Hide search highlight"))
vim.keymap.set("n", "<leader>qq", ":copen<CR>", defopts("Open quickfix list"))
vim.keymap.set("n", "]q", ":cnext<CR>", defopts("Next quickfix entry"))
vim.keymap.set("n", "[q", ":cprev<CR>", defopts("Previous quickfix entry"))
vim.keymap.set("n", "<leader>ts", ":set spell!<CR>", defopts("Toggle spellchecking"))
vim.keymap.set("n", "<leader>s", "/\\s\\+$<CR>", defopts("Search trailing whitespaces"))
vim.keymap.set("n", "<leader>tw", ":set list!<CR>", defopts("Toggle visible whitespace characters"))
vim.keymap.set("n", "<leader>tW",
  function()
    if vim.tbl_contains(vim.opt.diffopt:get(), "iwhiteall") then
      print("Whitespace enabled in diffview")
      vim.opt.diffopt:remove("iwhiteall")
    else
      print("Whitespace disabled in diffview")
      vim.opt.diffopt:append("iwhiteall")
    end
  end,
  defopts("Toogle whitespaces in diffview")
)
vim.keymap.set("n", "<leader>gl", ":diffget LOCAL<CR>", defopts("Take local changes in conflict"))
vim.keymap.set("n", "<leader>gr", ":diffget REMOTE<CR>", defopts("Take remote changes in conflict"))
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", defopts("Escape terminal inser mode with ESC"))
-- Readline-like insert mode bindings
vim.keymap.set("i", "<C-f>", "<RIGHT>", defopts("Move cursor right"))
vim.keymap.set("i", "<C-b>", "<LEFT>", defopts("Move cursor left"))

-- Plugin management keymaps

vim.keymap.set("n", "<leader>pp", ":Lazy<CR>", defopts("Lazy plugin packages panel"))
vim.keymap.set("n", "<leader>pm", ":Mason<CR>", defopts("Mason packages panel"))

----------✦ 🎨 Colorscheme 🎨 ✦----------

-- Main Colorscheme
require("catppuccin").setup({
  transparent_background = true,
})
vim.cmd.colorscheme("catppuccin")

vim.opt.fillchars = { diff = " ", foldopen = "▾", foldsep = "│", foldclose = "▸" }

----------✦ ⚠️  Fixes and workarounds ⚠️  ✦----------

-- Redraw indent guides after folding operations
for _, keymap in pairs({
  "zo", "zO", "zc", "zC", "za", "zA", "zv", "zx", "zX", "zm", "zM", "zr", "zR",
}) do
  vim.api.nvim_set_keymap(
    "n", keymap, keymap .. ":lua require('ibl').refresh()<CR>", { noremap = true, silent = true }
  )
end

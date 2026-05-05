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
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Open files with all folds open
vim.opt.foldenable = false
vim.opt.foldlevelstart = 1
-- Fold visual style
vim.opt.foldcolumn = "auto"
-- Show fold summary for diff buffers, show highlighted code for normal buffers
vim.api.nvim_create_autocmd({ "BufEnter", "OptionSet" },
  { callback = function() vim.wo.foldtext = vim.wo.diff and "foldtext()" or "" end }
)

-- Searching
-- Be case insensitive for small caps, sensitive otherwise
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Whitespace characters representation
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

-- User interface
-- Show cursorline in normal buffers, hide it in diff buffers (it produces
-- unpleant uderline effect in diffs)
vim.opt.cursorline = true
vim.api.nvim_create_autocmd({ "BufEnter", "OptionSet" },
  { callback = function() vim.wo.culopt = vim.wo.diff and "number" or "both" end }
)
-- Show statusline only if splits are open
vim.opt.laststatus = 1
-- Show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- Default split direction
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Keep splits even when the window is resized
vim.api.nvim_create_autocmd({ "VimResized" }, { command = "wincmd=" })
-- Scrolling margin
vim.opt.scrolloff = 3
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
})

-- System behaviour
-- Persistent undo
vim.opt.undofile = true
-- Open confirmation dialog on file overwrites etc
vim.opt.confirm = true
-- Use system clipboard
vim.opt.clipboard:append({'unnamed', 'unnamedplus'})

-- Enter builtin terminal in insert mode
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, { command = "if &buftype == 'terminal' | :startinsert | endif" })

-- Set leader to space
vim.g.mapleader = " "

-- Helper functions and utilities

-- Helper function to define mapping with default options and a description
local function defopts(desc)
  return { noremap = true, silent = true, desc = desc }
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
require("lazy").setup(
  {
    -- Language support package management
    "mason-org/mason.nvim",
    -- Help
    "folke/which-key.nvim",
    -- Treesitter
    {"nvim-treesitter/nvim-treesitter", branch = "main"},
    {"nvim-treesitter/nvim-treesitter-textobjects", branch = "main"},
    "chrisgrieser/nvim-various-textobjs",
    -- LSP
    "neovim/nvim-lspconfig",
    "mason-org/mason-lspconfig.nvim",
    "nvimtools/none-ls.nvim",
    "ray-x/lsp_signature.nvim",
    -- Core functionalities
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
    "nmac427/guess-indent.nvim",
    -- Editor functionalities
    "kylechui/nvim-surround",
    "rrethy/vim-illuminate",
    -- UI, visuals and tooling
    "hiphish/rainbow-delimiters.nvim",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-lualine/lualine.nvim",
    { "nvim-neo-tree/neo-tree.nvim", dependencies = { "muniftanjim/nui.nvim" } },
    "nvim-telescope/telescope.nvim",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    "lukas-reineke/indent-blankline.nvim",
    "catppuccin/nvim",
    -- External tools integration
    "lewis6991/gitsigns.nvim",
    "folke/lazydev.nvim",
    "zbirenbaum/copilot.lua",
  },
  {
    install = { colorscheme = { 'catppuccin' } }
  }
)

vim.cmd.packadd("cfilter")
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

----------✦ ❓ Help ❓ ✦----------

local wk = require("which-key")
wk.setup({ delay = 500, icons = { rules = false } })

----------✦ 🌳 Treesitter 🌳 ✦----------

-- Only highlight with treesitter
vim.cmd("syntax off")
vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})

-- Textobjects selection
require("nvim-treesitter-textobjects").setup()
vim.keymap.set({ "x", "o" }, "am", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end, defopts("outer method"))
vim.keymap.set({ "x", "o" }, "im", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end, defopts("inner method"))
vim.keymap.set({ "x", "o" }, "ac", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
end, defopts("outer class"))
vim.keymap.set({ "x", "o" }, "ic", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
end, defopts("inner class"))

-- Repeat movement with ; (forward) and , (backward)
local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

-- Swap parameters order
vim.keymap.set("n", "<leader>ln", function()
  require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
end, defopts("Swap with next parameter"))
vim.keymap.set("n", "<leader>lp", function()
  require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
end, { desc = "Swap with previous parameter" })

-- Incremental selection
vim.keymap.set({ 'x', 'o' }, '<C-n>', function()
    require 'vim.treesitter._select'.select_parent(vim.v.count1)
end, { desc = "Select parent node with incremental selection" })

vim.keymap.set({ 'x', 'o' }, '<C-p>', function()
	require 'vim.treesitter._select'.select_child(vim.v.count1)
end, { desc = "Select child node with incremental selection" })

-- Various textobjects
require("various-textobjs").setup({ keymaps = { useDefaults = true, disabledDefaults = { "gw", "gW", "r" } } })

----------✦ 🛠️ LSP 🛠️ ✦----------

---@format disable-next
local servers = {
  pyright = { python = { analysis = { typeCheckingMode = "off" } } },
  clangd = {}, lua_ls = {}, cmake = {}, bashls = {}, dockerls = {}, ts_ls = {}, html = {},
  cssls = {}, jsonls = {}, yamlls = {}, marksman = {}, texlab = {},
}
-- Disable LSP semantic tokens highlighting - we use treesitter for that
vim.lsp.config('*', {
  capabilities = { semanticTokensProvider = nil },
})
-- Apply setting for each LSP server
for server, opts in pairs(servers) do
  vim.lsp.config(server, { settings = opts })
end

require("lazydev").setup()
require("mason").setup()
require("mason-lspconfig").setup({
  automatic_enable = true, ensure_installed = vim.tbl_keys(servers), automatic_installation = false
})

-- None-ls extra LSP servers
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
  },
})

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

----------✦ ⚙️  Core functionalities ⚙️ ✦----------

-- Code completion
local cmp = require("cmp")
-- LSP
cmp.setup({
  window = {
    documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-f>"] = cmp.mapping.scroll_docs(1),
    ["<C-b>"] = cmp.mapping.scroll_docs(-1),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
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
    { name = "cmdline", option = { ignore_cmds = { "!", "vimgrep" } } }
  }),
})

-- Automatic indentation (if indent is detected will override the defaults)
require("guess-indent").setup({})

----------✦ 🔠 Editor functionalities 🔠 ✦----------

-- Surround motions
require("nvim-surround").setup()

-- Symbols highlighting
local illuminate = require("illuminate")
illuminate.configure({
  providers = { "lsp", "treesitter", "regex" },
  delay = 500, -- A bit longer than the default
})
vim.keymap.set({ "o", "x" }, "H", illuminate.textobj_select, defopts("highlighted symbol"))
vim.keymap.set({ "n" }, "]r", illuminate.goto_next_reference, defopts("Next reference of the highlighted symbol"))
vim.keymap.set({ "n" }, "[r", illuminate.goto_prev_reference, defopts("Previous reference of the highlighted symbol"))

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
vim.keymap.set("n", "<leader>fj", tb.jumplist, defopts("Find jumplist position"))
vim.keymap.set("n", "<leader>fb", tb.buffers, defopts("Find buffer"))
vim.keymap.set("n", "<leader>fk", tb.keymaps, defopts("Find keymap"))
vim.keymap.set("n", "<leader>fm", tb.marks, defopts("Find mark"))
vim.keymap.set("n", "<leader>fp", tb.builtin, defopts("Find telescope pickers"))

-- Telescope git status
vim.fn.system("git rev-parse --is-inside-work-tree")
if vim.v.shell_error == 0 then
  wk.add({ "<leader>g", group = "git" })
  vim.keymap.set("n", "<leader>gc", tb.git_commits, defopts("Browse commits"))
  vim.keymap.set("n", "<leader>gC", tb.git_bcommits, defopts("Browse buffer commits"))
  vim.keymap.set("n", "<leader>gb", tb.git_branches, defopts("Browse branches"))
  vim.keymap.set("n", "<leader>gs", tb.git_status, defopts("Browse git status"))
end

-- File explorer/file tree
require("neo-tree").setup({
  popup_border_style = "rounded",
  window = { position = "float" },
  default_component_configs = { icon = { default = "" } },
})

-- Indent guides
require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = true, show_start = false, show_end = false, highlight = "Whitespace" },
})

-- Redraw indent guides after folding operations
for _, keymap in pairs({
  "zo", "zO", "zc", "zC", "za", "zA", "zv", "zx", "zX", "zm", "zM", "zr", "zR",
}) do
  vim.api.nvim_set_keymap(
    "n", keymap, keymap .. ":lua require('ibl').refresh()<CR>", { noremap = true, silent = true }
  )
end

----------✦ ⚡️ External tools integration ⚡️ ✦----------

-- Git signs gutter and hunk navigation
require("gitsigns").setup({
  preview_config = { border = "rounded" },
  on_attach = function(client, bufnr)
    local gs = package.loaded.gitsigns

    -- Hunk navigation
    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(gs.next_hunk)
      return "<Ignore>"
    end, { expr = true, desc = "Next hunk" })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(gs.prev_hunk)
      return "<Ignore>"
    end, { expr = true, desc = "Previous hunk" })

    wk.add({ "<leader>h", group = "git hunk" })

    -- Actions
    vim.keymap.set("n", "<leader>hs", gs.stage_hunk, defopts("Toggle hunk stage"))
    vim.keymap.set("n", "<leader>hr", gs.reset_hunk, defopts("Restore hunk"))
    vim.keymap.set("n", "<leader>hS", gs.stage_buffer, defopts("Stage buffer"))
    vim.keymap.set("n", "<leader>hR", gs.reset_buffer, defopts("Restore buffer"))
    vim.keymap.set("n", "<leader>hp", gs.preview_hunk, defopts("Preview hunk"))
    vim.keymap.set("n", "<leader>hb", gs.blame_line, defopts("Blame line"))
    vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, defopts("Toggle line blame"))
    vim.keymap.set("n", "<leader>gd", function() gs.diffthis("HEAD") end, defopts("Diff buffer"))
    vim.keymap.set("n", "<leader>tD", gs.toggle_deleted, defopts("Toggle show deleted"))
    vim.keymap.set("n", "<leader>gl", function() gs.setloclist() end, defopts("List this buffer hunks"))
    vim.keymap.set("n", "<leader>gL", function() gs.setqflist("all") end, defopts("List all hunks"))
    -- Text object
    vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", defopts("git hunk"))
  end,
})

-- Save last nvim server id when nvim loses focus (FocusLost) (useful for determining last used neovim instance)
vim.api.nvim_create_autocmd('FocusLost', {
  group = vim.api.nvim_create_augroup('focus_lost', {}),
  callback = function()
    local servername = vim.v.servername
    vim.fn.writefile({ servername }, '/tmp/nvim-focuslost')
  end,
})

-- Copilot
require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept_word = "<M-f>",
    },
  }
})
-- Accept copilot suggestion with <C-f> if visible, otherwise move cursor right
local copilot_command = require("copilot.command")
local copilot_suggestion = require("copilot.suggestion")
vim.keymap.set('i', '<C-f>', function()
  if copilot_suggestion.is_visible() then
    return copilot_suggestion.accept()
  else
    vim.api.nvim_input("<Right>")
  end
end, { expr = true, noremap = true })
vim.keymap.set("n", "<leader>tc", copilot_command.toggle, defopts("Toggle copilot"))

----------✦ ☎️  Keymaps ☎️  ✦----------

-- Mapping groups
---@format disable-next
wk.add({
  -- Group common functionalities
  { "<leader>c", group = "config" },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>gm", group = "merge conflict" },
  { "<leader>l", group = "language symbols" },
  { "<leader>p", group = "plugins" },
  { "<leader>q", group = "quickfix" },
  { "<leader>t", group = "toggle" },

  -- Better descriptions for builtin keymaps
  { "grr", group = "symbol reference" },
  { "grc", group = "symbol calls" },
  { "grn", desc = "Rename symbol" },
  { "grr", desc = "Symbol references list" },
  { "gri", desc = "Implementation" },
  { "gra", desc = "Code action" },
  { "gO", desc = "Document symbols list" },
})

-- General nvim functionalities keymaps

vim.keymap.set("n", "<leader>U", ":Undotree<CR>", defopts("Undo tree"))
vim.keymap.set("n", "<leader>E", ":Neotree<CR>", defopts("File explorer"))
vim.keymap.set("n", "<leader>T", ":split<CR>:term<CR>", defopts("Terminal in horizontal split"))
vim.keymap.set("n", "<leader>ce", ":edit ~/.config/nvim/init.lua<CR>", defopts("Edit config"))
vim.keymap.set("n", "<leader>cr", ":source ~/.config/nvim/init.lua<CR>:GuessIndent<CR>", defopts("Reload config"))
vim.keymap.set("n", "<leader>n", ":nohlsearch<CR>", defopts("Hide search highlight"))
vim.keymap.set("n", "<leader>q", ":copen<CR>", defopts("Open quickfix list"))
vim.keymap.set("n", "<leader>ts", ":set spell!<CR>", defopts("Toggle spellchecking"))
vim.keymap.set("n", "<leader>s", "/\\s\\+$<CR>", defopts("Search trailing whitespaces"))
vim.keymap.set("n", "<leader>ts", ":set spell!<CR>", defopts("Toggle spellchecking"))
vim.keymap.set("n", "<leader>tf", ":set foldenable!<CR>", defopts("Toggle folding"))
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
  defopts("Toggle whitespaces in diffview")
)
vim.keymap.set("n", "<leader>gml", ":diffget LOCAL<CR>", defopts("Take local changes in conflict"))
vim.keymap.set("n", "<leader>gmr", ":diffget REMOTE<CR>", defopts("Take remote changes in conflict"))
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", defopts("Escape terminal insert mode with ESC"))

-- Readline-like insert mode bindings

-- Ctl-f is also shared with Copilot, fallback to this keymap is set up alongisde Copilot
-- vim.keymap.set("i", "<C-f>", "<RIGHT>", defopts("Move cursor right"))
vim.keymap.set("i", "<C-b>", "<LEFT>", defopts("Move cursor left"))

-- Lsp bindings

-- LSP symbol reference bindings
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, defopts("Declaration"))
vim.keymap.set("n", "grci", vim.lsp.buf.incoming_calls, defopts("Incoming calls"))
vim.keymap.set("n", "grco", vim.lsp.buf.outgoing_calls, defopts("Outgoing calls"))
vim.keymap.set("n", "grh", vim.lsp.buf.typehierarchy, defopts("Type hierarchy"))

-- Diagnostics bindings
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, defopts("Show diagnostics"))
vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, defopts("Diagnostics list"))

-- Telescope-LSP bindings
vim.keymap.set("n", "<leader>ls", tb.lsp_document_symbols, defopts("Browse buffer symbols"))
vim.keymap.set("n", "<leader>lS", tb.lsp_dynamic_workspace_symbols, defopts("Browse workspace symbols"))
vim.keymap.set("n", "<leader>lr", tb.lsp_references, defopts("Browse symbol references"))
vim.keymap.set("n", "<leader>D", tb.diagnostics, defopts("Browse workspace diagnostics"))

-- Formatting
vim.keymap.set("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, defopts("Format with lsp"))

-- Show/hide Diagnostics
vim.keymap.set("n", "<leader>td", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, defopts("Toggle diagnostics"))

-- Plugin management keymaps

vim.keymap.set("n", "<leader>pp", ":Lazy<CR>", defopts("Lazy plugin packages panel"))
vim.keymap.set("n", "<leader>pm", ":Mason<CR>", defopts("Mason packages panel"))

----------✦ 🎨 Colorscheme and UI 🎨 ✦----------

-- Main Colorscheme
require("catppuccin").setup({
  transparent_background = true,
  dim_inactive = { enabled = true },
})
vim.cmd.colorscheme("catppuccin")
local mocha = require("catppuccin.palettes.mocha")

-- Colorscheme tweaks
extend_hl("Pmenu", { bg = mocha.mantle })
extend_hl("Folded", { fg = mocha.overlay0 })
extend_hl("WinSeparator", { fg = mocha.base })
extend_hl("CopilotSuggestion", { fg = mocha.overlay0 })

-- Statusline
require('lualine').setup({
  options = {
    component_separators = { left = '│', right = '│' },
    section_separators = { left = '', right = '' },
  }
})

-- Nicer characters for UI elements
vim.opt.fillchars = { diff = " ", eob = " ", foldopen = "▾", foldsep = "┆", foldclose = "▸", vert = " " }

----------✦ ⚠️  Fixes and workarounds ⚠️  ✦----------

--- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter in completion docs window
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  vim.treesitter.start(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)
  return contents
end

-- HACK: In nvim 0.11 border settings are remade and set globally using `vim.opt.winborder`,
-- however, this is not suported by many plugins so far. Thus we don't use this option for now, and
-- hack hover to use rounded borders
local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function() return hover({ border = "rounded" }) end

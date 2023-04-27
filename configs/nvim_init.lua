-- Indentation
-- Set default indentation to tab with 4 spaces length
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Textwidth
vim.opt.textwidth = 80

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
-- Fill empty spaces with dot char
vim.opt.fillchars = {diff = '⋅'}
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

-- Set leader to space
vim.g.mapleader = " "

-- Helper function to define mapping with default options and a description
function defopts(desc)
  return {noremap = true, silent = true, desc = desc}
end

-- Plugins
require("packer").startup{
  function()
    use "wbthomason/packer.nvim"

    use "folke/which-key.nvim"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-path"
    use "hrsh7th/nvim-cmp"
    use "joshdick/onedark.vim"
    use "kylechui/nvim-surround"
    use "lewis6991/gitsigns.nvim"
    use "lukas-reineke/indent-blankline.nvim"
    use "neovim/nvim-lspconfig"
    use "nmac427/guess-indent.nvim"
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "ray-x/lsp_signature.nvim"
    use "numtostr/comment.nvim"
    use "kiyoon/treesitter-indent-object.nvim"
    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
    use {"nvim-telescope/telescope.nvim", requires = {"nvim-lua/plenary.nvim"}}
    use {"sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim"}
  end,

  config = {
    display = {
      open_fn = function()
        return require("packer.util").float{border = "rounded"}
      end
    }
  }
}

-- Plugins setup

-- Whick key keymappings
local wk = require("which-key")
wk.setup()
wk.register{
  ["<leader>f"] = {name = "find"},
  ["<leader>t"] = {name = "toggle"},
  ["<leader>c"] = {name = "config"},
  ["<leader>p"] = {name = "plugins"}
}

-- General nvim functionalities keymaps

vim.keymap.set("n", "<leader>E", ":Explore<CR>", defopts("File explorer"))
vim.keymap.set("n", "<leader>ce", ":edit ~/.config/nvim/init.lua<CR>", defopts("Edit editor config"))
vim.keymap.set("n", "<leader>cr", ":source ~/.config/nvim/init.lua<CR>:GuessIndent<CR>", defopts("Reload editor config"))
vim.keymap.set("n", "<leader>n", ":nohlsearch<CR>", defopts("Hide search highlight"))
vim.keymap.set("n", "<leader>ts", ":set spell!<CR>", defopts("Toggle spellchecking"))
vim.keymap.set("n", "<leader>tw", ":set list!<CR>", defopts("Toggle visible whitespace characters"))
vim.keymap.set("n", "<leader>L", ":copen<CR>", defopts("Open quickfix list"))

-- Plugin management keymaps

vim.keymap.set("n", "<leader>ps", ":PackerStatus<CR>", defopts("Plugins status"))
vim.keymap.set("n", "<leader>pu", ":PackerUpdate<CR>", defopts("Update plugins"))
vim.keymap.set("n", "<leader>pi", ":PackerInstall<CR>", defopts("Install plugins"))
vim.keymap.set("n", "<leader>pc", ":PackerClean<CR>", defopts("Cleanup unused plugins"))

-- Automatic indentation (if indent is detected will override the defaults)
require("guess-indent").setup()

-- Indent guides
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
  show_current_context = true
}

-- Indent text object
require("treesitter_indent_object").setup()

indentobj = require("treesitter_indent_object.textobj")
vim.keymap.set({"x", "o"}, "ai", indentobj.select_indent_outer, defopts("outer indent (context-aware)"))
vim.keymap.set({"x", "o"}, "aI", function() indentobj.select_indent_outer(true) end, defopts("outer indent line-wise (context-aware)"))
vim.keymap.set({"x", "o"}, "ii", indentobj.select_indent_inner, defopts("inner indent (context-aware)"))
vim.keymap.set({"x", "o"}, "iI", function() indentobj.select_indent_inner(true) end, defopts("inner indent line-wise (context-aware)"))

-- Code commenting
require("Comment").setup()

-- Surround motions
require("nvim-surround").setup()

-- If using vscode exit early and don't load the rest of the plugins
if vim.g.vscode then
  return
end

-- Telescope file finder
local telescope = require("telescope")
telescope.setup {
  defaults = {
    mappings = {
      i = {
        -- Show picker actions help with which-key
        ["<C-h>"] = "which_key"
      }
    },
    vimgrep_arguments = { "rg", "--vimgrep", "--smart-case", "--type-not", "jupyter", },
  }
}
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

local is_repo = vim.fn.system("git rev-parse --is-inside-work-tree")
if vim.v.shell_error == 0 then
  wk.register {
    ["<leader>g"] = {name = "git"},
  }
  vim.keymap.set("n", "<leader>gc", tb.git_commits, defopts("Browse commits"))
  vim.keymap.set("n", "<leader>gC", tb.git_bcommits, defopts("Browse buffer commits"))
  vim.keymap.set("n", "<leader>gb", tb.git_branches, defopts("Browse branches"))
  vim.keymap.set("n", "<leader>gs", tb.git_status, defopts("Browse git status"))
end

-- Treesitter

local treesitter = require("nvim-treesitter.configs")
treesitter.setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  textobjects = {
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
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "outer function"},
        ["if"] = { query = "@function.inner", desc = "inner function"},
        ["ac"] = { query = "@class.outer", desc = "outer class"},
        ["ic"] = { query = "@class.inner", desc = "inner class"},
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>la"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
      },
      swap_previous = {
        ["<leader>lA"] = { query = "@parameter.inner", desc = "Swap with previous parameter" },
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
}

-- LSP

local lspconfig = require("lspconfig")

-- LSP & related floating windows styling
vim.diagnostic.config {
    float = { border = "rounded" },
}
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { style = "minimal", border = "rounded" }
)

-- Register servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {"clangd", "pylsp", "bashls", "marksman", "texlab"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function(client, bufnr)
      wk.register{
        ["<leader>l"] = {name = "lsp symbols"},
      }

      -- Lsp bindings
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, defopts("Definition"))
      vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, defopts("Definition"))
      vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, defopts("Type definition"))
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, defopts("Declaration"))
      vim.keymap.set("n", "K", vim.lsp.buf.hover, defopts("Hover"))
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, defopts("Implementation"))
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, defopts("Show signature"))
      vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, defopts("Rename symbol"))
      vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, defopts("Code action"))
      vim.keymap.set("n", "gr", vim.lsp.buf.references, defopts("References"))

      -- Diagnostics bindings
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, defopts("Show diagnostics"))
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, defopts("Next diagnostics"))
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, defopts("Previous diagnostics"))
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, defopts("Diagnostics list"))

      -- Telescope-LSP bindings
      local tb = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ls", tb.lsp_document_symbols, defopts("Browse buffer symbols"))
      vim.keymap.set("n", "<leader>lS", tb.lsp_workspace_symbols, defopts("Browse workspace symbols"))
      vim.keymap.set("n", "<leader>lr", tb.lsp_references, defopts("Browse symbol references"))
      vim.keymap.set("n", "<leader>Q", tb.diagnostics, defopts("Browse workspace diagnostics"))
      -- Exit insert mode interminal with the Escape key
      vim.keymap.set("t", "<esc>", "<C-\\><C-n>", opts)

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
      vim.keymap.set("n", "<leader>tq", toggle_diagnostics, defopts("Toggle diagnostics"))

      -- Highlight symbol under cursor
      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd("CursorHold", {
          pattern = "*",
          callback = function()
            vim.lsp.buf.document_highlight()
          end,
          group = group,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
          pattern = "*",
          callback = function()
            vim.lsp.buf.clear_references()
          end,
          group = group,
        })
      end
    end,

    capabilities = capabilities
  }
end

-- LSP based signatures when passing arguments
require("lsp_signature").setup {
  hint_enable = false,
  toggle_key = "<C-s>"
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
  mapping = cmp.mapping.preset.insert(
  {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<C-f>"] = cmp.mapping.scroll_docs(1),
    ["<C-b>"] = cmp.mapping.scroll_docs(-1),
    ["<CR>"] = cmp.mapping.confirm({select = true}),
    ["<C-e>"] = cmp.mapping.abort()
  }
  )
}

-- Use buffer source for command line completion
cmp.setup.cmdline(
{ "/", "?" },
{
  sources = {
    {name = "buffer"}
  },
  mapping = cmp.mapping.preset.cmdline()
}
)

cmp.setup.cmdline(
":",
{
  mapping = cmp.mapping.preset.cmdline(),
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

-- Git signs gutter and hunk navigation
require("gitsigns").setup {
  on_attach = function(client, bufnr)
    local gs = package.loaded.gitsigns

    -- Hunk navigation
    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then return "]c" end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, {expr = true, desc = "Next hunk"})

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then return "[c" end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, {expr = true, desc = "Previous hunk"})

    wk.register{
      ["<leader>h"] = {name = "git hunk"},
    }

    -- Actions
    vim.keymap.set("n", "<leader>hs", gs.stage_hunk, defopts("Stage hunk"))
    vim.keymap.set("n", "<leader>hr", gs.reset_hunk, defopts("Restore hunk"))
    vim.keymap.set("n", "<leader>hS", gs.stage_buffer, defopts("Stage buffer"))
    vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, defopts("Unstage hunk"))
    vim.keymap.set("n", "<leader>hR", gs.reset_buffer, defopts("Restore buffer"))
    vim.keymap.set("n", "<leader>hp", gs.preview_hunk, defopts("Preview hunk"))
    vim.keymap.set("n", "<leader>hb", gs.blame_line, defopts("Blame line"))
    vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, defopts("Toggle current line blame"))
    vim.keymap.set("n", "<leader>gd", gs.diffthis, defopts("Diff buffer"))
    vim.keymap.set("n", "<leader>gD", function() gs.diffthis("~") end, defopts("Diff buffer (with staged)"))
    vim.keymap.set("n", "<leader>td", gs.toggle_deleted, defopts("Toggle show deleted"))
  end
}

-- Colorscheme
vim.cmd.colorscheme("onedark")

-- Don't underline changed lines in diff
vim.api.nvim_set_hl(0, "DiffChange", { cterm = nil })

-- Highlight LSP symbol under cursor using underline
vim.api.nvim_set_hl(0, 'LspReferenceRead', { underline = true })

-- Fixes and workarounds

-- Disable error highlighting for markdown
vim.api.nvim_set_hl(0, "markdownError", { link = nil })

-- Redraw indent guides after folding operations
for _, keymap in pairs {
    "zo", "zO", "zc", "zC", "za", "zA", "zv", "zx", "zX", "zm", "zM", "zr", "zR",
} do
    vim.api.nvim_set_keymap("n", keymap,  keymap .. "<CMD>IndentBlanklineRefresh<CR>", { noremap=true, silent=true })
end

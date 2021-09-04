vim.cmd('packloadall')

-- LSP{{{
local nvim_lsp = require('lspconfig')
local on_attach = function(_, bufnr)
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>d', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-space>', '<C-x><C-o>', opts)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.api.nvim_command("au! * <buffer>")
  vim.api.nvim_command("au CursorHoldI <buffer> :lua Show_func_help()")
end

nvim_lsp.sumneko_lua.setup {
  cmd = {"/usr/bin/lua-language-server"},
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
}

function GetFileDirectory()
  vim.fn.expand('%:p:h')
end

nvim_lsp.solargraph.setup {
  root_dir = GetFileDirectory,
  on_attach = on_attach
}

local pid = vim.fn.getpid()
local omnisharp_bin = "/home/flynn/tmp/run"

nvim_lsp.omnisharp.setup{
  cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
  on_attach = on_attach,
}

local servers = {
  'jsonls',
  'vimls',
  'clangd',
  'gdscript',
  'angularls',
  'gopls',
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
  }
end

-- Based on https://github.com/golang/tools/blob/d39bbca0a38c8407ab8046997c3cc0973f428995/gopls/doc/vim.md#neovim-imports
local function lsp_codeaction(code_action, timeout_ms)
  local context = { only = { code_action } }
  vim.validate { context = { context, "t", true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  -- See the implementation of the textDocument/codeAction callback
  -- (lua/vim/lsp/handler.lua) for how to do this properly.
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  if not result or next(result) == nil then return end
  local actions = result[1].result
  if not actions then return end
  local action = actions[1]

  -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
  -- is a CodeAction, it can have either an edit, a command or both. Edits
  -- should be executed first.
  if action.edit or type(action.command) == "table" then
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit)
    end
    if type(action.command) == "table" then
      vim.lsp.buf.execute_command(action.command)
    end
  else
    vim.lsp.buf.execute_command(action)
  end
end

function Goimports()
  lsp_codeaction("source.organizeImports")
end

-- Based on make_position_param from $VIMRUNTIME/lua/vim/lsp/util.lua
local function make_function_position_param()
  local row, col = unpack(vim.call("searchpos", "\\w(", "bn", vim.call("line", ".")))
  if (row == nil or col == nil) then
    return { line = 0; character = 0 }
  end
  row = row - 1
  local line = vim.api.nvim_buf_get_lines(0, row, row+1, true)[1]
  if not line then
    return { line = 0; character = 0; }
  end
  col = vim.str_utfindex(line, col)
  return { line = row; character = col; }
end

-- Based on vim.lsp.util.make_position_params
local function make_function_position_params()
  return {
    textDocument = vim.lsp.util.make_text_document_params();
    position = make_function_position_param();
  }
end

-- Based on vim.lsp.buf.hover
function Show_func_help()
  local params = make_function_position_params()
  vim.lsp.buf_request(0, "textDocument/signatureHelp", params)
end

-- Stoled from tjdevries
function P(foo)
  print(vim.inspect(foo))
  return foo
end

--}}}

-- Treesitter {{{
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "go",
    "ruby",
    "fish",
    "bash",
    "gomod",
    "json",
    "javascript",
    "lua",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = {
      "go",
    },
  },
  additional_vim_regex_highlighting = false,
}
-- }}}

-- Display Settings{{{
vim.o.termguicolors = true
vim.cmd('syntax off')
vim.cmd('colorscheme gruvbox')
vim.wo.number = true
vim.wo.wrap = false
vim.wo.cursorline = true
vim.o.hidden = true
vim.wo.signcolumn = 'number'
vim.wo.list = true
vim.o.listchars='tab:->,nbsp:_,trail:.'
vim.o.guifont = 'FiraCode-Regular:h22'
vim.g.airline_powerline_fonts = 1

vim.g['float_preview#docked'] = 1
vim.g['float_preview#auto_close'] = 0
function DisableExtras()
  print(vim.g['float_preview#win'])
  vim.api.nvim_win_set_option(vim.g['float_preview#win'], 'number', true)
  vim.api.nvim_win_set_option(vim.g['float_preview#win'], 'wrap', false)
  vim.api.nvim_win_set_option(vim.g['float_preview#win'], 'linebreak', false)
end

vim.cmd('autocmd! User FloatPreviewWinOpen')
vim.cmd('autocmd User FloatPreviewWinOpen lua DisableExtras()')
--}}}

-- file browser stuff{{{
vim.g['rnvimr_enable_ex'] = 1
vim.g['rnvimr_enable_picker'] = 1
vim.g['rnvimr_enable_bw'] = 1
--}}}

-- Completion Settings{{{
vim.o.completeopt = 'menuone,noinsert,noselect,longest'
--}}}

-- Tab Settings{{{
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.cmd("filetype indent off")
--}}}

-- Normal Mode Bindings{{{
for lhs, rhs in pairs({
  ['<C-s>']      = ':w<cr>',
  ['<C-g>']      = ':Goyo<cr>',
  ['<Tab>']      = ':BufferLineCycleNext<cr>',
  ['<S-Tab>']    = ':BufferLineCyclePrev<cr>',
  ['<C-Left>']   = ':bprevious<cr>',
  ['<C-Right>']  = ':bnext<cr>',
  ['<C-Down>']   = ':bdelete<cr>',
  ['<C-Up>']     = ':enew<cr>',
  ['<leader>ev'] = ':e $MYVIMRC<cr>',
  ['<C-p>']      = ':Files<cr>',
  ['<C-e>']      = ':RnvimrToggle<cr>',
  ['']         = ":call NERDComment('n', 'toggle')<cr>",
}) do
  vim.api.nvim_set_keymap('n', lhs, rhs, {noremap=true,silent=true})
end
--}}}

-- Other bindings{{{
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', {noremap=true,silent=true})
vim.api.nvim_set_keymap('v', '', ":call NERDComment('x', 'toggle')<cr>", {noremap=true,silent=true})
--}}}

-- Autocommands{{{
--}}}

-- Etc{{{
vim.o.updatetime = 1000
vim.wo.foldmethod = 'marker'
require'bufferline'.setup{
  options = {
    view = "multiwindow",
    numbers = "none",
    --number_style = "superscript" | "" | { "none", "subscript" }, -- buffer_id at index 1, ordinal at index 2
    separator_style = 'thick',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 32,
    max_prefix_length = 15, -- prefix used when a buffer is deduplicated
    tab_size = 32,
    diagnostics = "nvim_lsp",
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = false,
    persist_buffer_sort = true,
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = 'relative_directory',
  }
}
--}}}

-- statusline{{{
vim.cmd('command! Statusl lua statusl()')
local statusline = {
  "%#DiffAdd#%{(mode()=='n')?'  NORMAL ':''}",
  "%6*%{(mode()=='i')?'  INSERT ':''}",
  "%8*%{(mode()=='r')?'  RPLACE ':''}",
  "%7*%{(mode()=='v')?'  VISUAL ':''}",
  '%* %<%.30F%*',                      -- path, trunc to 30 length
  '%*%m%*',                            -- modified flag
  '%=',                                -- right align
  '%{strlen(&ft)?&ft:"none"} ',        -- filetype
  '(%{strlen(&fenc)?&fenc:&enc},',     -- encoding
  '%{&fileformat})',                   -- file format
  '%*%5l%*',                           -- current line
  '%*/%L %*',                          -- total lines
  '%*%4v\' %*',                        -- virtual column number
  '%*0x%04B %*',                       -- character under cursor
}
vim.o.statusline = table.concat(statusline)
--}}}


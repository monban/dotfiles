vim.cmd('packloadall')

-- LSP{{{
local nvim_lsp = require('lspconfig')
local on_attach = function(_, bufnr)
  require('completion').on_attach()
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>xD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>xr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>xd', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
end

nvim_lsp.sumneko_lua.setup {
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

local servers = {
  'jsonls',
  'vimls',
  'clangd',
  'omnisharp',
  'gdscript',
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
  }
end
--}}}

-- Display Settings{{{
vim.cmd('colorscheme molokai')
vim.cmd('highlight Normal ctermbg=none guibg=none')
vim.o.termguicolors = true
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

-- netrw stuff{{{
vim.g.netrw_banner=0
vim.g.netrw_browse_split=4
vim.g.netrw_altv=1
vim.g.netrw_liststyle=3
vim.g.netrw_winsize=32
function Toggle_netrw()
  local killed = false
  for _,buf in pairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, 'filetype') == 'netrw' then
      vim.api.nvim_buf_delete(buf, {})
      killed = true
    end
  end
  if not killed then
    vim.cmd('Vexplore')
  end
end
--}}}

-- Completion Settings{{{
vim.o.completeopt = 'menuone,noinsert,noselect,longest'
--}}}

-- Tab Settings{{{
vim.bo.expandtab = true
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
--}}}

-- Normal Mode Bindings{{{
local nnoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, {noremap=true,silent=true})
end
nnoremap('<C-s>', ':w<CR>')
nnoremap('<C-e>', ':lua Toggle_netrw()<CR>')
nnoremap('<C-s>', ':w<CR>')
nnoremap('<C-g>', ':Goyo<CR>')
nnoremap('<Tab>', ':bnext<CR>')
nnoremap('<S-Tab>', ':bprevious<CR>')
nnoremap('<C-Left>', ':bprevious<CR>')
nnoremap('<C-Right>', ':bnext<CR>')
nnoremap('<C-Down>', ':bdelete<CR>')
nnoremap('<C-Up>', ':enew<CR>')
nnoremap('<leader>ev', ':e $MYVIMRC<cr>')
nnoremap('<C-p>', ':Files<cr>')
nnoremap('<C-Space>', '<C-x><C-o>')
--}}}

-- Other bindings{{{
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', {noremap=true,silent=true})
--}}}

-- Autocommands{{{
--vim.cmd("autocmd! BufEnter * lua require'completion'.on_attach()")
vim.cmd('command! LspAttached :lua print(vim.inspect(vim.lsp.buf_get_clients()))')
--}}}

-- Etc{{{
vim.wo.foldmethod = 'marker'
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


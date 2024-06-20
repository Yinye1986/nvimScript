package.path = package.path .. ';../lua/'

require("script.forCenteringCursor")

require("script.forSwitchFcitx5")

require("script.forFlipVal")
vim.keymap.set("n", "'f", ':lua vim.cmd(_G.Flip)<CR>', {noremap=true, silent=true})


vim.cmd[[
     autocmd BufRead,BufNewFile *.md luafile ~/.local/share/nvim/lazy/nvimScript/lua/ftplugin/markdown/previewer.lua
     autocmd BufRead,BufNewFile *.md luafile ~/.local/share/nvim/lazy/nvimScript/lua/ftplugin/markdown/snippet.lua
     autocmd BufRead,BufNewFile *.md nnoremap sp :lua vim.cmd(_G.StartPv)<CR>
]]

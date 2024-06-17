vim.api.nvim_create_user_command("Flip",
    function()
        local word = vim.fn.expand("<cword>")
        if word == "true" then
            vim.api.nvim_command("normal! ciwfalse")
        elseif word == "false" then
            vim.api.nvim_command("normal! ciwtrue")
        elseif word == "1" then
            vim.api.nvim_command("normal! ciw0")
        elseif word == "0" then
            vim.api.nvim_command("normal! ciw1")
        else
            local line = vim.api.nvim_get_current_line() -- 找到光标下的字符
            local cursor = vim.api.nvim_win_get_cursor(0)
            local char = string.sub(line, cursor[2]+1, cursor[2]+1)
            if char == "1" then
                vim.api.nvim_command(':normal! r0')
            elseif char == "0" then
                vim.api.nvim_command(':normal! r1')
            elseif char == "f" then
                vim.api.nvim_command(':normal! 5dlitrue')
            elseif char == "t" then
                vim.api.nvim_command(':normal! 4dlifalse')
            end
        end
    end,{}
    )


_G.Flip="Flip"

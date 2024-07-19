vim.api.nvim_create_user_command("StartPv",
    function()
        -- 获取当前文件的路径
        local current_file = vim.fn.expand('%:p')
        -- 使用curl和GitHub的API将Markdown转换为HTML
        local command = 'curl -s --data-binary @"' .. current_file .. '" -H "Content-Type:text/plain" https://api.github.com/markdown/raw > /tmp/preview.html'
        os.execute(command)
        -- 在新窗口中打开HTML文件
        os.execute('chromium /tmp/preview.html')
    end,{}
    )
_G.StartPv = "StartPv"

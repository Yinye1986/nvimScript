-- 检查 fcitx-remote (fcitx5-remote)
-- 这部分代码检查系统中是否存在 'fcitx-remote' 或 'fcitx5-remote' 命令。
-- 如果两者都不存在，脚本就返回并不执行任何操作。
local fcitx_cmd = ''
if vim.fn.executable('fcitx-remote') == 1 then
  fcitx_cmd = 'fcitx-remote'
elseif vim.fn.executable('fcitx5-remote') == 1 then
  fcitx_cmd = 'fcitx5-remote'
else
  return
end

-- 这部分代码检查脚本是否在 SSH 会话中运行。如果是，脚本就返回并不执行任何操作。
if os.getenv('SSH_TTY') ~= nil then
  return
end

-- 这部分代码检查操作系统是否为 Linux 或 Unix，以及是否存在 X11 或 Wayland 显示服务器。
-- 如果操作系统不是 Linux 或 Unix，或者既没有 X11 也没有 Wayland 显示服务器，脚本就返回并不执行任何操作。
local os_name = vim.loop.os_uname().sysname
if (os_name == 'Linux' or os_name == 'Unix') and os.getenv('DISPLAY') == nil and os.getenv('WAYLAND_DISPLAY') == nil then
  return
end

-- 这部分代码定义了两个函数：_Fcitx2en 和 _Fcitx2NonLatin。
-- _Fcitx2en 函数检查输入法状态，如果当前是中文输入状态（fcitx-remote 返回值为 2），就切换到英文输入状态，并设置一个标志位。
-- _Fcitx2NonLatin 函数根据之前的标志位，如果之前是中文输入状态，就切换回中文输入状态。
function _Fcitx2en()
  local input_status = tonumber(vim.fn.system(fcitx_cmd))
  if input_status == 2 then
    vim.b.input_toggle_flag = true
    vim.fn.system(fcitx_cmd .. ' -c')
  end
end

function _Fcitx2NonLatin()
  if vim.b.input_toggle_flag == nil then
    vim.b.input_toggle_flag = false
  elseif vim.b.input_toggle_flag == true then
    vim.fn.system(fcitx_cmd .. ' -o')
    vim.b.input_toggle_flag = false
  end
end

-- 这部分代码在 Vim 的 autocmd 事件中调用了上面定义的两个函数。
-- 在进入插入模式或命令行模式时，调用 _Fcitx2NonLatin 切换到中文输入状态；
-- 在离开插入模式或命令行模式时，调用 _Fcitx2en 切换到英文输入状态。
vim.cmd[[
  augroup fcitx
    au InsertEnter * :lua _Fcitx2NonLatin()
    au InsertLeave * :lua _Fcitx2en()
    au CmdlineEnter [/\?] :lua _Fcitx2NonLatin()
    au CmdlineLeave [/\?] :lua _Fcitx2en()
  augroup END
]]

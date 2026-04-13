-- tcode.lua

-- 主处理函数
local function tcode(key_event, env)
  -- 忽略控制键、释放事件等
  if key_event:ctrl() or key_event:alt() or key_event:release() or key_event:shift() or key_event:caps() then
    return kNoop
  end

  local context = env.engine.context
  local key_repr = key_event:repr()

  -- 处理 Tab 键
  if key_repr == "Tab" then
    if context:has_menu() then
      -- 有候选菜单时：选中第一个候选并上屏
      context:select(0)
      context:commit()
      -- 上屏后返回 kNoop，让 Tab 键本身继续被后续处理器处理（即可输出制表符）
      return kNoop
    else
      -- 没有候选菜单时：完全不干涉，让系统正常处理 Tab
      return kNoop
    end
  end

  return kNoop  -- 继续处理
end

return tcode


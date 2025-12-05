-- tcode.lua
-- 用于处理分号、单引号、小写z和数字0-9的特殊行为

-- 主处理函数
local function tcode(key_event, env)
  -- 忽略控制键、释放事件等
  if key_event:ctrl() or key_event:alt() or key_event:release() or key_event:shift() or key_event:caps() then
    return kNoop
  end

  local context = env.engine.context
  local key_repr = key_event:repr()

  -- 检查是否为数字键0-9
  local is_number = key_repr:match("^[0-9]$")
  if is_number then
    -- 如果有候选菜单，则顶屏
    if context:has_menu() then
      -- 选择第一个候选并上屏
      context:select(0)  -- 索引从0开始，0表示第一个候选
      context:commit()
      return kNoop  -- 继续处理，允许输出数字键本身
    else
      -- 如果没有候选菜单，保持原样
      return kNoop  -- 继续处理
    end
  end

  return kNoop  -- 继续处理
end

return tcode
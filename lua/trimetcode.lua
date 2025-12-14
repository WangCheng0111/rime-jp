-- tcode.lua
-- 处理空格键的特殊行为：当编码区只有一个字符（a-z和;,.?）时，将空格映射为下划线并添加到编码区

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

  -- 处理空格键
  if key_repr == "space" then
    local input = context.input or ""

    -- 编码区为空时，保持系统原样输出不干涉
    if #input == 0 then
      return kNoop
    end

    -- 编码区只有一个字符时，检查是否为 a-z 和 ;,.? 这30个字符之一
    if #input == 1 then
      local char = input
      -- 检查是否为 a-z 或 ;,./ 这30个字符
      local is_valid_char = char:match("^[a-z;,.?]$")
      if is_valid_char then
        -- 模拟按下下划线键，让RIME正常处理（类似key_binder的send: underscore）
        -- 这样会触发完整的处理流程，包括speller检查auto_select_pattern
        local underscore_key = KeyEvent("underscore")
        -- 让RIME处理下划线按键（会正常添加到编码区并触发auto_select_pattern检查）
        env.engine:process_key(underscore_key)
        -- 屏蔽空格本身的输出
        return 1
      end
    end

    -- 其他情况保持原样
    return kNoop
  end

  return kNoop  -- 继续处理
end

return tcode


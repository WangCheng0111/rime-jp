-- special_key_processor.lua
-- 用于处理分号、单引号、小写z和数字0-9的特殊行为

-- 主处理函数
local function special_key_processor(key_event, env)
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

  -- 检查是否为小写z键
  if key_repr == "z" then
    -- 排除zz顶屏：如果编码区有且只有一个字符"z"，则不顶屏
    local input = context.input or ""
    if input == "z" then
      return kNoop  -- 保持原样，不顶屏
    end
    -- 如果有候选菜单，则顶屏
    if context:has_menu() then
      -- 选择第一个候选并上屏
      context:select(0)  -- 索引从0开始，0表示第一个候选
      context:commit()
      return kNoop  -- 继续处理，允许输出z键本身
    else
      -- 如果没有候选菜单，保持原样
      return kNoop  -- 继续处理
    end
  end

  -- 仅处理分号和单引号
  if key_repr ~= "semicolon" and key_repr ~= "apostrophe" then
    return kNoop  -- 继续处理
  end

  -- 如果没有候选菜单，继续正常处理
  if not context:has_menu() then
    return kNoop  -- 继续处理
  end

  -- 获取候选数量
  local candidate_count = 0
  local composition = context.composition
  if composition and not composition:empty() then
    local segment = composition:back()
    if segment and segment.menu then
      candidate_count = segment.menu:candidate_count()
    end
  end

  -- 处理分号键和引号键的特殊逻辑
  if key_repr == "semicolon" or key_repr == "apostrophe" then
    if candidate_count == 1 then
      -- 只有一个候选时，直接让系统处理（自动上屏第一候选+输出标点）
      return kNoop
    elseif candidate_count == 2 then
      if key_repr == "semicolon" then
        -- 两个候选时，分号选择第二个候选
        context:select(1)  -- 索引从0开始，1表示第二个候选
        context:commit()
        if not context:has_menu() then
          return 1  -- 屏蔽分号本身的输出
        end
      else  -- apostrophe
        -- 两个候选时，单引号直接让系统处理（自动上屏第一候选+输出标点）
        return kNoop
      end
    else  -- candidate_count >= 3
      if key_repr == "semicolon" then
        -- 三个及以上候选时，分号选择第二个候选
        context:select(1)  -- 索引从0开始，1表示第二个候选
        context:commit()
        if not context:has_menu() then
          return 1  -- 屏蔽分号本身的输出
        end
      else  -- apostrophe
        -- 三个及以上候选时，单引号选择第三个候选
        context:select(2)  -- 索引从0开始，2表示第三个候选
        context:commit()
        if not context:has_menu() then
          return 1  -- 屏蔽单引号本身的输出
        end
      end
    end
  end

  return kNoop  -- 继续处理
end

return special_key_processor
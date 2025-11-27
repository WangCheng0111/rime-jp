-- special_key_processor.lua
-- 用于处理分号、问号键、小写z和数字0-9的特殊行为

-- 主处理函数
local function special_key_processor(key_event, env)
  -- 忽略控制键、释放事件等（但允许shift组合键通过）
  if key_event:ctrl() or key_event:alt() or key_event:release() or key_event:caps() then
    return kNoop
  end

  local context = env.engine.context
  local key_repr = key_event:repr()

  -- 处理Shift组合键（如Shift+D等）
  if key_event:shift() and context:has_menu() then
    -- 获取第一个候选词的文本并直接提交（适配Trime）
    local composition = context.composition
    if composition and not composition:empty() then
      local segment = composition:back()
      if segment and segment.menu then
        local candidate = segment.menu:get_candidate_at(0)
        if candidate then
          env.engine:commit_text(candidate.text)
          context:clear()
          -- 让Shift组合键正常处理，输出对应的大写字母或符号
          return kNoop
        end
      end
    end
  end

  -- 检查是否为数字键0-9
  local is_number = key_repr:match("^[0-9]$")
  if is_number then
    -- 如果有候选菜单，则顶屏
    if context:has_menu() then
      -- 获取第一个候选词的文本并直接提交（适配Trime）
      local composition = context.composition
      if composition and not composition:empty() then
        local segment = composition:back()
        if segment and segment.menu then
          local candidate = segment.menu:get_candidate_at(0)
          if candidate then
            env.engine:commit_text(candidate.text)
            context:clear()
            -- 然后输出数字键本身
            env.engine:commit_text(key_repr)
            return 1  -- 屏蔽原始数字键输出，因为我们已经手动输出了
          end
        end
      end
    end
    return kNoop
  end

  -- 检查是否为小写z键（保持原有逻辑不变）
  if key_repr == "z" then
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

  -- 仅处理分号和问号键
  if key_repr ~= "semicolon" and key_repr ~= "question" then
    return kNoop
  end

  -- 如果没有候选菜单，继续正常处理
  if not context:has_menu() then
    return kNoop
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

  -- 处理分号键和问号键的特殊逻辑
  if key_repr == "semicolon" or key_repr == "question" then
    if candidate_count == 1 then
      -- 只有一个候选时，使用系统默认行为
      return kNoop
    elseif candidate_count == 2 then
      if key_repr == "semicolon" then
        -- 两个候选时，分号选择第二个候选
        context:select(1)  -- 索引从0开始，1表示第二个候选
        context:commit()
        if not context:has_menu() then
          return 1  -- 屏蔽分号本身的输出
        end
      else  -- question
        -- 两个候选时，问号键使用系统默认行为
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
      else  -- question
        -- 三个及以上候选时，问号键选择第三个候选
        context:select(2)  -- 索引从0开始，2表示第三个候选
        context:commit()
        if not context:has_menu() then
          return 1  -- 屏蔽问号键本身的输出
        end
      end
    end
  end

  return kNoop
end

return special_key_processor
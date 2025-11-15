-- special_key_processor.lua
-- 用于处理分号、斜杠键、小写z和数字0-9的特殊行为

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

  -- 仅处理分号和斜杠键
  if key_repr ~= "period" and key_repr ~= "comma" then
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

  -- 处理分号键和斜杠键的特殊逻辑
  if key_repr == "period" or key_repr == "comma" then
    if candidate_count == 1 then
      -- 只有一个候选时，使用系统默认行为
      return kNoop
    elseif candidate_count == 2 then
      if key_repr == "period" then
        -- 两个候选时，分号选择第二个候选
        context:select(1)  -- 索引从0开始，1表示第二个候选
        context:commit()
        if not context:has_menu() then
          return 1  -- 屏蔽分号本身的输出
        end
      else  -- slash
        -- 两个候选时，斜杠键使用系统默认行为
        return kNoop
      end
    else  -- candidate_count >= 3
      if key_repr == "period" then
        -- 三个及以上候选时，分号选择第二个候选
        context:select(1)  -- 索引从0开始，1表示第二个候选
        context:commit()
        if not context:has_menu() then
          return 1  -- 屏蔽分号本身的输出
        end
      else  -- slash
        -- 三个及以上候选时，斜杠键选择第三个候选
        context:select(2)  -- 索引从0开始，2表示第三个候选
        context:commit()
        if not context:has_menu() then
          return 1  -- 屏蔽斜杠键本身的输出
        end
      end
    end
  end

  return kNoop
end

return special_key_processor
-- tcode.lua
-- 参考 special_key_processor.lua 的风格，处理回车与单引号对候选的直顶逻辑
-- 规则摘要：
-- 1) 候选数 == 1：回车与单引号均不干预（保持默认行为，返回 kNoop）
-- 2) 候选数 == 2：回车直顶第 2 候选并吞键（返回 1）；单引号不干预
-- 3) 候选数 >= 3：回车直顶第 2 候选并吞键；单引号直顶第 3 候选并吞键

local function tcode_processor(key_event, env)
  -- 忽略控制键、Shift、Caps 以及按键释放事件
  -- 说明：这些情况不参与处理，交由后续处理器或默认逻辑
  if key_event:ctrl() or key_event:alt() or key_event:release() or key_event:shift() or key_event:caps() then
    return kNoop
  end

  local context = env.engine.context
  local key_repr = key_event:repr()

  if key_repr == "Return" then
    -- 无候选窗：直接不干预
    if not context:has_menu() then
      return kNoop
    end

    -- 统计候选数量
    local candidate_count = 0
    local composition = context.composition
    if composition and not composition:empty() then
      local segment = composition:back()
      if segment and segment.menu then
        candidate_count = segment.menu:candidate_count()
      end
    end

    -- 候选 == 1：保持默认行为
    if candidate_count == 1 then
      return kNoop
    elseif candidate_count == 2 then
      -- 候选 == 2：Enter 直顶第 2 候选，并吞掉回车
      context:select(1)
      context:commit()
      if not context:has_menu() then
        return 1
      end
      return kNoop
    elseif candidate_count >= 3 then
      -- 候选 >= 3：Enter 直顶第 2 候选，并吞掉回车
      context:select(1)
      context:commit()
      if not context:has_menu() then
        return 1
      end
      return kNoop
    end

    return kNoop

  elseif key_repr == "apostrophe" then
    -- 无候选窗：直接不干预
    if not context:has_menu() then
      return kNoop
    end

    -- 统计候选数量
    local candidate_count = 0
    local composition = context.composition
    if composition and not composition:empty() then
      local segment = composition:back()
      if segment and segment.menu then
        candidate_count = segment.menu:candidate_count()
      end
    end

    -- 候选 == 1：保持默认行为
    if candidate_count == 1 then
      return kNoop
    elseif candidate_count == 2 then
      -- 候选 == 2：保持默认行为
      return kNoop
    elseif candidate_count >= 3 then
      -- 候选 >= 3：' 直顶第 3 候选，并吞掉按键
      context:select(2)
      context:commit()
      if not context:has_menu() then
        return 1
      end
      return kNoop
    end

    return kNoop
  end

  -- 其他按键：不处理
  return kNoop
end

return tcode_processor



-- tcode.lua
-- 规则：
-- 1) 有候选窗且候选数 == 1：不干预（保持回车默认行为）
-- 2) 有候选窗且候选数 >= 2：上屏第 2 候选并吞掉回车

local function tcode_processor(key_event, env)
  -- 忽略控制键、Shift、Caps 以及按键释放事件
  if key_event:ctrl() or key_event:alt() or key_event:release() or key_event:shift() or key_event:caps() then
    return kNoop
  end

  local context = env.engine.context
  local key_repr = key_event:repr()

  -- 仅处理回车键，其它按键不干预
  if key_repr == "Return" then
    -- 无候选窗：不处理
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

    -- 候选 == 1：保持默认回车行为
    if candidate_count == 1 then
      return kNoop
    end

    -- 候选 >= 2：直顶第 2 候选并吞掉回车
    if candidate_count >= 2 then
      context:select(1)
      context:commit()
      if not context:has_menu() then
        return 1
      end
      return kNoop
    end

    return kNoop
  end

  return kNoop
end

return tcode_processor

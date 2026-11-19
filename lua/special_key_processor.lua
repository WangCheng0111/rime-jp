-- special_key_processor.lua
-- 处理分号、单引号、小写 z 和数字 0-9 的特殊行为
-- 返回值：kNoop(2) = 不处理，继续往下传；kAccepted(1) = 吞掉这个键

local kNoop = 2
local kAccepted = 1

-- 有候选时选中第 index 个候选并上屏
local function commit_index(context, index)
  if not context:has_menu() then
    return false
  end
  context:select(index)
  context:commit()
  return true
end

-- 分号 / 单引号专用：上屏第 index 个候选；上屏后菜单消失就吞掉这个标点键
local function commit_punct(context, index)
  context:select(index)
  context:commit()
  if not context:has_menu() then
    return kAccepted
  end
  return nil
end

local function special_key_processor(key_event, env)
  -- 忽略控制键、修饰键、抬起事件
  if key_event:ctrl() or key_event:alt() or key_event:release()
     or key_event:shift() or key_event:caps() then
    return kNoop
  end

  local context = env.engine.context
  local key_repr = key_event:repr()

  -- 数字 0-9：有候选就顶屏第一个
  local code = key_repr:byte()
  if code and #key_repr == 1 and code >= 0x30 and code <= 0x39 then
    commit_index(context, 0)
    return kNoop
  end

  -- 小写 z：编码以 z 开头时不顶屏；否则有候选就顶屏
  if key_repr == "z" then
    if context:has_menu() and (context.input or ""):sub(1, 1) ~= "z" then
      context:select(0)
      context:commit()
    end
    return kNoop
  end

  -- Tab：有候选就顶屏，Tab 本身继续往下走
  if key_repr == "Tab" then
    commit_index(context, 0)
    return kNoop
  end

  -- 其余按键只处理分号和单引号
  if key_repr ~= "semicolon" and key_repr ~= "apostrophe" then
    return kNoop
  end
  if not context:has_menu() then
    return kNoop
  end

  -- 候选数量
  local candidate_count = 0
  local composition = context.composition
  if composition and not composition:empty() then
    local segment = composition:back()
    if segment and segment.menu then
      candidate_count = segment.menu:candidate_count()
    end
  end

  if candidate_count == 1 then
    return kNoop
  end

  -- 分号：2 个及以上候选 → 选第二个
  if key_repr == "semicolon" then
    return commit_punct(context, 1) or kNoop
  end

  -- 单引号：2 个候选交给系统；3 个及以上 → 选第三个
  if candidate_count == 2 then
    return kNoop
  end
  return commit_punct(context, 2) or kNoop
end

return special_key_processor

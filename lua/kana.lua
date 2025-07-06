-- kana.lua
-- 按键到假名的映射处理器
-- 支持单字符映射和两字符组合映射

-- 按键映射表
local key_mappings = {
  -- 字母映射
  a = "ち", b = "こ", c = "そ", d = "し", e = "い", f = "は", g = "き", h = "く", i = "に",
  j = "ま", k = "の", l = "り", m = "も", n = "み", o = "ら", p = "せ", q = "た", r = "す",
  s = "と", t = "か", u = "な", v = "ひ", w = "て", x = "さ", y = "ん", z = "つ",
  -- 数字映射
  ["1"] = "ぬ", ["2"] = "ふ", ["3"] = "あ", ["4"] = "う", ["5"] = "え", ["6"] = "お",
  ["7"] = "や", ["8"] = "ゆ", ["9"] = "よ", ["0"] = "わ",
  -- 符号映射
  minus = "ほ", equal = "へ", backslash = "む", comma = "ね", period = "る", slash = "め",
  grave = "ろ", apostrophe = "け", semicolon = "れ"
}

-- Shift组合键映射表
local shift_key_mappings = {
  ["Shift+numbersign"] = "ぁ",     -- Shift+#
  ["Shift+dollar"] = "ぅ",         -- Shift+$
  ["Shift+percent"] = "ぇ",        -- Shift+%
  ["Shift+asciicircum"] = "ぉ",    -- Shift+^
  ["Shift+ampersand"] = "ゃ",      -- Shift+&
  ["Shift+asterisk"] = "ゅ",       -- Shift+*
  ["Shift+parenleft"] = "ょ",      -- Shift+(
  ["Shift+parenright"] = "を",     -- Shift+)
  ["Shift+Z"] = "っ",              -- Shift+Z
  ["Shift+E"] = "ぃ",              -- Shift+E
  ["Shift+S"] = "って"             -- Shift+S
}

-- 两字符组合映射表
local combo_mappings = {
  -- [ 组合
  ["ほ["] = "ぼ", ["へ["] = "べ", ["ふ["] = "ぶ", ["た["] = "だ", ["て["] = "で", ["す["] = "ず",
  ["か["] = "が", ["せ["] = "ぜ", ["ち["] = "ぢ", ["と["] = "ど", ["し["] = "じ", ["は["] = "ば",
  ["き["] = "ぎ", ["く["] = "ぐ", ["け["] = "げ", ["つ["] = "づ", ["さ["] = "ざ", ["そ["] = "ぞ",
  ["ひ["] = "び", ["こ["] = "ご",
  -- ] 組合
  ["ふ]"] = "ぷ", ["ほ]"] = "ぽ", ["へ]"] = "ぺ", ["は]"] = "ぱ", ["ひ]"] = "ぴ"
}

-- 添加平假名到片假名的映射表
local hiragana_to_katakana = {
  ["あ"]="ア", ["い"]="イ", ["う"]="ウ", ["え"]="エ", ["お"]="オ",
  ["か"]="カ", ["き"]="キ", ["く"]="ク", ["け"]="ケ", ["こ"]="コ",
  ["さ"]="サ", ["し"]="シ", ["す"]="ス", ["せ"]="セ", ["そ"]="ソ",
  ["た"]="タ", ["ち"]="チ", ["つ"]="ツ", ["て"]="テ", ["と"]="ト",
  ["な"]="ナ", ["に"]="ニ", ["ぬ"]="ヌ", ["ね"]="ネ", ["の"]="ノ",
  ["は"]="ハ", ["ひ"]="ヒ", ["ふ"]="フ", ["へ"]="ヘ", ["ほ"]="ホ",
  ["ま"]="マ", ["み"]="ミ", ["む"]="ム", ["め"]="メ", ["も"]="モ",
  ["や"]="ヤ", ["ゆ"]="ユ", ["よ"]="ヨ",
  ["ら"]="ラ", ["り"]="リ", ["る"]="ル", ["れ"]="レ", ["ろ"]="ロ",
  ["わ"]="ワ", ["ゐ"]="ヰ", ["ゑ"]="ヱ", ["を"]="ヲ",
  ["ぱ"]="パ", ["ぴ"]="ピ", ["ぷ"]="プ", ["ぺ"]="ペ", ["ぽ"]="ポ",
  ["が"]="ガ", ["ぎ"]="ギ", ["ぐ"]="グ", ["げ"]="ゲ", ["ご"]="ゴ",
  ["ざ"]="ザ", ["じ"]="ジ", ["ず"]="ズ", ["ぜ"]="ゼ", ["ぞ"]="ゾ",
  ["だ"]="ダ", ["ぢ"]="ヂ", ["づ"]="ヅ", ["で"]="デ", ["ど"]="ド",
  ["ば"]="バ", ["び"]="ビ", ["ぶ"]="ブ", ["べ"]="ベ", ["ぼ"]="ボ",
  ["ゔ"]="ヴ",
  ["ゃ"]="ャ", ["ゅ"]="ュ", ["ょ"]="ョ", ["ゎ"]="ヮ",
  ["っ"]="ッ",
  ["ぁ"]="ァ", ["ぃ"]="ィ", ["ぅ"]="ゥ", ["ぇ"]="ェ", ["ぉ"]="ォ",
  ["ん"]="ン",
  ["ゕ"]="ヵ", ["ゖ"]="ヶ"
}

-- 获取UTF-8字符串的最后一个字符
local function get_last_char(input)
  if utf8.len(input) == 0 then return "" end
  local last_char = ""
  for pos, code in utf8.codes(input) do
    last_char = utf8.char(code)
  end
  return last_char
end

-- 删除UTF-8字符串的最后一个字符
local function remove_last_char(input)
  local char_count = utf8.len(input)
  if char_count <= 1 then return "" end
  
  local result = ""
  local i = 0
  for pos, code in utf8.codes(input) do
    i = i + 1
    if i < char_count then
      result = result .. utf8.char(code)
    end
  end
  return result
end

-- 更新编码区内容
local function update_input(context, new_input)
  context:clear()
  if #new_input > 0 then
    context:push_input(new_input)
    -- 如果有候选窗，立即设置为未选中状态
    if context:has_menu() then
      local composition = context.composition
      if not composition:empty() then
        local segment = composition:back()
        segment.selected_index = -1
      end
    end
  end
end

-- 添加状态跟踪变量
local waiting_for_next_char = false
-- 添加变量跟踪最后选中的候选词，-1表示还没有按过空格
local last_selected_index = -1

-- 添加不允许[组合的字符集合
local block_left_bracket_chars = {
  ["ほ"]=true, ["へ"]=true, ["ふ"]=true, ["た"]=true, ["て"]=true, ["す"]=true,
  ["か"]=true, ["せ"]=true, ["ち"]=true, ["と"]=true, ["し"]=true, ["は"]=true,
  ["き"]=true, ["く"]=true, ["け"]=true, ["つ"]=true, ["さ"]=true, ["そ"]=true,
  ["ひ"]=true, ["こ"]=true
}

-- 添加不允许]组合的字符集合
local block_right_bracket_chars = {
  ["ふ"]=true, ["ほ"]=true, ["へ"]=true, ["は"]=true, ["ひ"]=true
}

local function processor(key_event, env)
  local context = env.engine.context
  local key_repr = key_event:repr()
  
  -- 初始化候选窗状态
  if context:has_menu() and last_selected_index == -1 then
    local composition = context.composition
    if not composition:empty() then
      local segment = composition:back()
      segment.selected_index = -1  -- 设置为-1表示未选中任何候选词
    end
  end

  -- 处理Shift+Space键
  if key_repr == "Shift+space" then
    if context:has_menu() then
      local composition = context.composition
      if not composition:empty() then
        local segment = composition:back()
        local menu = segment.menu
        local candidate_count = menu:candidate_count()
        
        -- 如果当前未选中任何候选词，从最后一个开始
        if segment.selected_index == -1 then
          segment.selected_index = candidate_count - 1
          last_selected_index = candidate_count - 1
        -- 如果当前是第一个候选词，选择最后一个
        elseif segment.selected_index == 0 then
          segment.selected_index = candidate_count - 1
          last_selected_index = candidate_count - 1
        else
          -- 否则选择前一个候选词
          segment.selected_index = segment.selected_index - 1
          last_selected_index = segment.selected_index
        end
        return 1
      end
    end
  end
  
  -- 处理回车键
  if key_repr == "Return" then
    -- 如果有选中的候选词，直接上屏
    if last_selected_index >= 0 and context:has_menu() then
      local composition = context.composition
      if not composition:empty() then
        local segment = composition:back()
        local menu = segment.menu
        -- 获取选中的候选词并上屏
        local cand = menu:get_candidate_at(last_selected_index)
        if cand then
          env.engine:commit_text(cand.text)
          context:clear()
          -- 重置选中的候选词索引
          last_selected_index = -1
          return 1
        end
      end
    end
  end
  
  local input = context.input or ""
  
  -- 处理Tab键的特殊情况
  if key_repr == "Tab" then
    -- 如果有候选框且有选中的候选词，转换选中的候选词
    if context:has_menu() and last_selected_index >= 0 then
      local composition = context.composition
      if not composition:empty() then
        local segment = composition:back()
        local menu = segment.menu
        local cand = menu:get_candidate_at(last_selected_index)
        if cand then
          -- 先检查是否有需要转换的平假名
          local text = cand.text
          local has_hiragana = false
          for pos, code in utf8.codes(text) do
            local char = utf8.char(code)
            if hiragana_to_katakana[char] then
              has_hiragana = true
              break
            end
          end
          
          -- 只有在有平假名需要转换时才进行转换
          if has_hiragana then
            local result = ""
            for pos, code in utf8.codes(text) do
              local char = utf8.char(code)
              result = result .. (hiragana_to_katakana[char] or char)
            end
            env.engine:commit_text(result)
            context:clear()
            -- 重置选中的候选词索引
            last_selected_index = -1
            return 1
          end
        end
      end
      -- 如果选中的候选词中没有平假名可转换，屏蔽tab键输出
      return 1
    end
    
    -- 如果编码区有内容，处理平假名到片假名的转换
    if utf8.len(input) > 0 then
      -- 先检查是否有需要转换的平假名
      local has_hiragana = false
      for pos, code in utf8.codes(input) do
        local char = utf8.char(code)
        if hiragana_to_katakana[char] then
          has_hiragana = true
          break
        end
      end
      
      -- 只有在有平假名需要转换时才进行转换
      if has_hiragana then
        local result = ""
        for pos, code in utf8.codes(input) do
          local char = utf8.char(code)
          result = result .. (hiragana_to_katakana[char] or char)
        end
        env.engine:commit_text(result)
        context:clear()
        return 1
      end
    end
    
    -- 如果编码区为空或没有可转换的平假名，保持tab原输出
    return kNoop
  end
  
  -- 处理空格键
  if key_repr == "space" then
    if context:has_menu() then
      local composition = context.composition
      if not composition:empty() then
        local segment = composition:back()
        local menu = segment.menu
        local candidate_count = menu:candidate_count()
        
        -- 如果未选中任何候选词，选中第一个
        if segment.selected_index == -1 then
          segment.selected_index = 0
          last_selected_index = 0
          return 1
        end
        
        -- 已经选中某个候选词，切换到下一个
        last_selected_index = last_selected_index + 1
        if last_selected_index >= candidate_count then
          last_selected_index = 0
        end
        segment.selected_index = last_selected_index
        return 1
      end
    end
  end
  
  -- 处理其他按键输入时，检查是否需要上屏之前选中的候选词
  if not key_event:release() and 
     not key_event:ctrl() and 
     not key_event:alt() and 
     not key_event:caps() and
     key_repr ~= "space" and
     key_repr ~= "Shift+BackSpace" and
     key_repr ~= "backspace" then
    -- 如果有选中的候选词且有新的输入，先上屏选中的候选词
    if last_selected_index >= 0 and context:has_menu() then
      local composition = context.composition
      if not composition:empty() then
        local segment = composition:back()
        local menu = segment.menu
        -- 获取选中的候选词并上屏
        local cand = menu:get_candidate_at(last_selected_index)
        if cand then
          env.engine:commit_text(cand.text)
          context:clear()
        end
      end
    end
    -- 重置选中的候选词索引
    last_selected_index = -1
  end
  
  -- 处理CapsLock特殊功能（暂时禁用）
  --[[
  if key_repr == "Caps_Lock" and not key_event:release() then
    if utf8.len(input) > 0 then
      local last_char = get_last_char(input)
      -- 如果最后一个字符是ま（j的映射），替换为っ并屏蔽CapsLock原有输出
      if last_char == "ま" then
        local prefix = remove_last_char(input)
        update_input(context, prefix .. "っ")
        return 1  -- 只在最后字符为ま时屏蔽CapsLock原有输出
      end
    end
    return kNoop  -- 其他情况保持CapsLock原有功能
  end
  --]]
  
  -- 忽略修饰键和释放事件
  if key_event:ctrl() or key_event:alt() or key_event:release() or key_event:caps() then
    return kNoop
  end
  
  -- 处理Shift组合键映射
  local shift_mapped_char = shift_key_mappings[key_repr]
  if shift_mapped_char then
    update_input(context, input .. shift_mapped_char)
    return 1
  end
  
  -- 处理Shift+BackSpace清空编码区
  if key_repr == "Shift+BackSpace" and utf8.len(input) > 0 then
    context:clear()
    return 1
  end
  
  -- 如果是其他Shift组合键，忽略
  if key_event:shift() then
    return kNoop
  end
  
  -- 现在对按键名称进行小写化处理
  key_repr = string.lower(key_repr)
  
  -- 处理中括号的特殊情况
  if key_repr == "bracketleft" or key_repr == "bracketright" then
    -- 如果编码区为空
    if utf8.len(input) == 0 then
      if key_repr == "bracketleft" then
        env.engine:commit_text("、")
        return 1
      else
        env.engine:commit_text("。")
        return 1
      end
    end
    
    -- 如果编码区有内容
    local last_char = get_last_char(input)
    if key_repr == "bracketleft" then
      -- 检查是否允许[组合
      if not block_left_bracket_chars[last_char] then
        -- 直接上屏编码区内容并上屏顿号
        env.engine:commit_text(input)
        env.engine:commit_text("、")
        context:clear()
        return 1
      end
    else  -- bracketright
      -- 检查是否允许]组合
      if not block_right_bracket_chars[last_char] then
        -- 直接上屏编码区内容并上屏句号
        env.engine:commit_text(input)
        env.engine:commit_text("。")
        context:clear()
        return 1
      end
    end
  end
  
  -- 处理单字符映射
  local mapped_char = key_mappings[key_repr]
  if mapped_char then
    update_input(context, input .. mapped_char)
    return 1
  end
  
  -- 处理组合映射（[ 或 ]）
  if (key_repr == "bracketleft" or key_repr == "bracketright") and utf8.len(input) > 0 then
    local last_char = get_last_char(input)
    local combo_key = last_char .. (key_repr == "bracketleft" and "[" or "]")
    local combo_char = combo_mappings[combo_key]
    
    if combo_char then
      local prefix = remove_last_char(input)
      update_input(context, prefix .. combo_char)
      return 1
    end
  end
  
  -- 处理退格键
  if key_repr == "backspace" and utf8.len(input) > 0 then
    update_input(context, remove_last_char(input))
    return 1
  end
  
  return kNoop
end

return processor 
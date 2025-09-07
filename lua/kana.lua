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
  ["Shift+at"] = "っふ",           -- Shift+@
  ["Shift+plus"] = "っへ",         -- Shift++ (Shift+equal)
  ["Shift+Q"] = "った",            -- Shift+Q
  ["Shift+W"] = "って",            -- Shift+W
  ["Shift+R"] = "っす",            -- Shift+R
  ["Shift+T"] = "っか",            -- Shift+T
  ["Shift+Y"] = "っん",            -- Shift+Y
  ["Shift+U"] = "っな",            -- Shift+U
  ["Shift+I"] = "っに",            -- Shift+I
  ["Shift+O"] = "っら",            -- Shift+O
  ["Shift+P"] = "っせ",            -- Shift+P
  ["Shift+bar"] = "っむ",          -- Shift+| (Shift+backslash)
  ["Shift+A"] = "っち",            -- Shift+A
  ["Shift+S"] = "っと",            -- Shift+S
  ["Shift+D"] = "っし",            -- Shift+D
  ["Shift+F"] = "っは",            -- Shift+F
  ["Shift+G"] = "っき",            -- Shift+G
  ["Shift+H"] = "っく",            -- Shift+H
  ["Shift+J"] = "っま",            -- Shift+J
  ["Shift+K"] = "っの",            -- Shift+K
  ["Shift+L"] = "っり",            -- Shift+L
  ["Shift+colon"] = "っれ",        -- Shift+: (Shift+semicolon)
  ["Shift+quotedbl"] = "っけ",     -- Shift+" (Shift+apostrophe)
  ["Shift+X"] = "っさ",            -- Shift+X
  ["Shift+C"] = "っそ",            -- Shift+C
  ["Shift+V"] = "っひ",            -- Shift+V
  ["Shift+B"] = "っこ",            -- Shift+B
  ["Shift+N"] = "っみ",            -- Shift+N
  ["Shift+M"] = "っも",            -- Shift+M
  ["Shift+underscore"] = "ー"       -- Shift+_ (Shift+minus)
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

-- 平假名到片假名的映射表
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

-- 不允许[组合的字符集合
local block_left_bracket_chars = {
  ["ほ"]=true, ["へ"]=true, ["ふ"]=true, ["た"]=true, ["て"]=true, ["す"]=true,
  ["か"]=true, ["せ"]=true, ["ち"]=true, ["と"]=true, ["し"]=true, ["は"]=true,
  ["き"]=true, ["く"]=true, ["け"]=true, ["つ"]=true, ["さ"]=true, ["そ"]=true,
  ["ひ"]=true, ["こ"]=true
}

-- 不允许]组合的字符集合
local block_right_bracket_chars = {
  ["ふ"]=true, ["ほ"]=true, ["へ"]=true, ["は"]=true, ["ひ"]=true
}

-- 跟踪最后选中的候选词，-1表示还没有按过空格
local last_selected_index = -1

-- 获取UTF-8字符串的字节长度
local function get_utf8_char_len(b)
  if b >= 240 then return 4
  elseif b >= 224 then return 3
  elseif b >= 192 then return 2
  else return 1 end
end

-- 获取UTF-8字符串的最后一个字符
local function get_last_char(input)
  if #input == 0 then return "" end

  -- 从后向前查找UTF-8字符的起始字节
  local i = #input
  local bytes = 0
  while i > 0 do
    local b = string.byte(input, i)
    if b >= 128 and b < 192 then
      -- UTF-8后续字节(10xxxxxx)
      bytes = bytes + 1
      i = i - 1
    else
      -- UTF-8起始字节
      return string.sub(input, i, i + bytes)
  end
  end

  -- 如果没找到起始字节，返回最后一个字节
  return string.sub(input, #input, #input)
end

-- 删除UTF-8字符串的最后一个字符
local function remove_last_char(input)
  if #input == 0 then return "" end

  -- 从后向前查找UTF-8字符的起始字节
  local i = #input
  while i > 0 do
    local b = string.byte(input, i)
    if b < 128 or b >= 192 then
      -- 找到起始字节
      return string.sub(input, 1, i - 1)
    end
    i = i - 1
  end

  -- 如果没找到起始字节，返回空字符串
  return ""
end

-- 迭代UTF-8字符串中的每个字符
local function iter_utf8_chars(text)
  if #text == 0 then return function() return nil end end

  local i = 1
  return function()
    if i > #text then return nil end

    local b = string.byte(text, i)
    local char_len = get_utf8_char_len(b)
    local char = string.sub(text, i, i + char_len - 1)

    i = i + char_len
    return char
  end
end

-- 检查文本中是否包含平假名
local function has_hiragana(text)
  if #text == 0 then return false end

  for char in iter_utf8_chars(text) do
    if hiragana_to_katakana[char] then
      return true
    end
  end

  return false
end

-- 将平假名转换为片假名
local function convert_to_katakana(text)
  if #text == 0 then return "" end

  local result = {}

  for char in iter_utf8_chars(text) do
    table.insert(result, hiragana_to_katakana[char] or char)
  end

  return table.concat(result)
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

-- 获取当前候选词的菜单信息
local function get_candidate_menu(context)
  if not context:has_menu() then return nil end
  local composition = context.composition
  if composition:empty() then return nil end
  local segment = composition:back()
  return segment, segment.menu
end

-- 处理单个候选词的上屏
local function commit_single_candidate(segment, menu, context, env)
  local cand = menu:get_candidate_at(0)
  env.engine:commit_text(cand.text)
  context:clear()
  last_selected_index = -1
  return true
end

-- 上屏选中的候选词
local function commit_selected_candidate(context, env)
  local segment, menu = get_candidate_menu(context)
  if segment and menu and last_selected_index >= 0 then
    local cand = menu:get_candidate_at(last_selected_index)
    if cand then
      env.engine:commit_text(cand.text)
      context:clear()
      last_selected_index = -1
      return true
    end
  end
  return false
end

-- 处理Tab键的平假名转换
local function handle_tab_conversion(context, env, input)
  -- 优先处理选中的候选词
  if last_selected_index >= 0 then
    local segment, menu = get_candidate_menu(context)
    if segment and menu then
      local cand = menu:get_candidate_at(last_selected_index)
      if cand and has_hiragana(cand.text) then
        env.engine:commit_text(convert_to_katakana(cand.text))
        context:clear()
        last_selected_index = -1
        return 1
      end
    end
    -- 如果选中的候选词中没有平假名可转换，屏蔽tab键输出
    return 1
  end

  -- 处理编码区内容
  if #input > 0 and has_hiragana(input) then
    env.engine:commit_text(convert_to_katakana(input))
    context:clear()
    return 1
  end

  return kNoop
end

-- 处理中括号按键
local function handle_bracket_key(key_repr, input, context, env)
  local is_left = (key_repr == "bracketleft")
  local punct = is_left and "、" or "。"

  -- 如果编码区为空，直接输出标点符号
  if #input == 0 then
    env.engine:commit_text(punct)
    return 1
  end

  -- 如果编码区有内容，检查是否允许组合
  local last_char = get_last_char(input)
  local block_chars = is_left and block_left_bracket_chars or block_right_bracket_chars

  if not block_chars[last_char] then
    -- 不允许组合，直接上屏编码区内容和标点符号
    env.engine:commit_text(input)
    env.engine:commit_text(punct)
    context:clear()
    return 1
  end

  return nil -- 继续处理组合逻辑
end

-- 处理候选词选择
local function handle_candidate_selection(context, env, segment, menu, index_change)
  local candidate_count = menu:candidate_count()

  -- 如果只有一个候选词，直接上屏
  if candidate_count == 1 then
    return commit_single_candidate(segment, menu, context, env)
  end

  -- 多个候选词时根据index_change调整选择
  if index_change == "next" then
    if segment.selected_index == -1 then
      segment.selected_index = 0
    else
      segment.selected_index = (segment.selected_index + 1) % candidate_count
    end
  elseif index_change == "prev" then
    if segment.selected_index == -1 or segment.selected_index == 0 then
      segment.selected_index = candidate_count - 1
    else
      segment.selected_index = segment.selected_index - 1
    end
  end

  last_selected_index = segment.selected_index
  return true
end

local function processor(key_event, env)
  local context = env.engine.context
  local key_repr = key_event:repr()
  local input = context.input or ""

  -- 初始化候选窗状态
  if context:has_menu() and last_selected_index == -1 then
    local composition = context.composition
    if not composition:empty() then
      local segment = composition:back()
      segment.selected_index = -1
    end
  end

  -- 处理Shift+Space键（向前选择候选词）
  if key_repr == "Shift+space" then
    local segment, menu = get_candidate_menu(context)
    if segment and menu then
      if handle_candidate_selection(context, env, segment, menu, "prev") then
        return 1
      end
    end
  end

  -- 处理回车键
  if key_repr == "Return" then
    if commit_selected_candidate(context, env) then
          return 1
    end
  end

  -- 处理Tab键的平假名转换
  if key_repr == "Tab" then
    return handle_tab_conversion(context, env, input)
  end

  -- 处理空格键（向后选择候选词）
  if key_repr == "space" then
    local segment, menu = get_candidate_menu(context)
    if segment and menu then
      if handle_candidate_selection(context, env, segment, menu, "next") then
        return 1
      end
    end
  end

  -- 处理其他按键输入时，检查是否需要上屏之前选中的候选词
  if not (key_event:release() or key_event:ctrl() or key_event:alt() or key_event:caps() or
          key_repr == "space" or key_repr == "Shift+BackSpace" or key_repr == "BackSpace" or
          key_repr == "Shift+Shift_L" or key_repr == "Shift+Shift_R" or
          key_repr == "Caps_Lock") then
    if commit_selected_candidate(context, env) then
          input = ""  -- 清空input变量
    end
    last_selected_index = -1
  end

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
  if key_repr == "Shift+BackSpace" and #input > 0 then
    context:clear()
    return 1
  end

  -- 如果是其他Shift组合键，忽略
  if key_event:shift() then
    return kNoop
  end

  -- 处理中括号的特殊情况
  if key_repr == "bracketleft" or key_repr == "bracketright" then
    local result = handle_bracket_key(key_repr, input, context, env)
    if result then return result end
  end

  -- 处理单字符映射
  local mapped_char = key_mappings[key_repr]
  if mapped_char then
    update_input(context, input .. mapped_char)
    return 1
  end

  -- 处理组合映射（[ 或 ]）
  if (key_repr == "bracketleft" or key_repr == "bracketright") and #input > 0 then
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
  if key_repr == "BackSpace" and #input > 0 then
    update_input(context, remove_last_char(input))
    return 1
  end

  return kNoop
end

return processor
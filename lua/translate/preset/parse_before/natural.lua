local util = require("translate.util.util")

local M = {}

--- This function is now simplified. It no longer groups lines.
--- Instead, it treats every line as a separate paragraph for translation.
--- It also correctly populates the `pos._group` table as expected by other parts of the plugin.
---@param lines string[]
---@param pos positions
---@param cmd_args table
---@return string[]
function M.cmd(lines, pos, cmd_args)
  pos._group = {}
  for i, _ in ipairs(lines) do
    util.append_dict_list(pos._group, i, i)
  end
  return lines
end

-- The following tables and functions are kept for compatibility,
-- but are no longer used for grouping logic in this simplified version.
M.lang_abbr = {
  en = "english",
  eng = "english",
  ja = "japanese",
  jpn = "japanese",
  zh = "chinese",
  zho = "chinese",
  ["zh-CN"] = "chinese",
  ["zh-TW"] = "chinese",
}

M.end_marks = {
  english = { ".", "?", "!", ":", ";" },
  japanese = { "。", ".", "？", "?", "！", "!", "：", "；" },
  chinese = { "。", "！", "？", "：" },
}

M.start_marks = {
  english = { [[\u]] },
}

function M.get_end(lang, option)
  lang = lang:lower()
  lang = option.lang_abbr[lang] or M.lang_abbr[lang]
  return option.end_marks[lang] or M.end_marks[lang]
end

function M.get_start(lang, option)
  lang = lang:lower()
  lang = option.lang_abbr[lang] or M.lang_abbr[lang]
  return option.start_marks[lang] or M.start_marks[lang]
end

return M

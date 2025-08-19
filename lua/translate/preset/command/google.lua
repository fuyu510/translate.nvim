local util = require("translate.util.util")

local M = {}

M.url =
  "https://script.google.com/macros/s/AKfycbxLRZgWI3UyHvHuYVyH1StiXbzJDHyibO5XpVZm5kMlXFlzaFVtLReR0ZteEkUbecRpPQ/exec"

---@param lines string[]
---@param command_args table
---@return string|nil
---@return string[]|nil
function M.cmd(lines, command_args)
  local text = table.concat(lines, "\n")
  local text_size = #text

  if text_size > 6000 then
    vim.notify(
      string.format("Google Translate has a 6k character limit. Your text has %d characters", text_size),
      vim.log.levels.WARN,
      { title = "Translate.nvim" }
    )
    return nil, nil
  end

  local data = vim.json.encode({
    text = lines,
    target = command_args.target,
    source = command_args.source,
  })

  local path = util.write_temp_data(data)
  local curl_args = {
    "-sL",
    M.url,
    "-d",
    "@" .. path,
  }

  local options = require("translate.config").get("preset").command.google
  if #options.args > 0 then
    curl_args = vim.list_extend(curl_args, options.args)
  end

  if vim.fn.has("win32") == 1 then
    local command_string = table.concat(vim.list_extend({ "curl" }, curl_args), " ")
    return "cmd.exe", { "/c", command_string }
  else
    return "curl", curl_args
  end
end

function M.complete_list()
  -- See <https://cloud.google.com/translate/docs/languages>
  local list = {
    "af",
    "sq",
    "am",
    "ar",
    "hy",
    "az",
    "eu",
    "be",
    "bn",
    "bs",
    "bg",
    "ca",
    "ceb",
    "zh",
    "zh-CN",
    "zh-TW",
    "co",
    "hr",
    "cs",
    "da",
    "nl",
    "en",
    "eo",
    "et",
    "fi",
    "fr",
    "fy",
    "gl",
    "ka",
    "de",
    "el",
    "gu",
    "ht",
    "ha",
    "haw",
    "he",
    "iw",
    "hi",
    "hmn",
    "hu",
    "is",
    "ig",
    "id",
    "ga",
    "it",
    "ja",
    "jv",
    "kn",
    "kk",
    "km",
    "rw",
    "ko",
    "ku",
    "ky",
    "lo",
    "lv",
    "lt",
    "lb",
    "mk",
    "mg",
    "ms",
    "ml",
    "mt",
    "mi",
    "mr",
    "mn",
    "my",
    "ne",
    "no",
    "ny",
    "or",
    "ps",
    "fa",
    "pl",
    "pt",
    "pa",
    "ro",
    "ru",
    "sm",
    "gd",
    "sr",
    "st",
    "sn",
    "sd",
    "si",
    "sk",
    "sl",
    "so",
    "es",
    "su",
    "sw",
    "sv",
    "tl",
    "tg",
    "ta",
    "tt",
    "te",
    "th",
    "tr",
    "tk",
    "uk",
    "ur",
    "ug",
    "uz",
    "vi",
    "cy",
    "xh",
    "yi",
    "yo",
    "zu",
  }
  return list
end

return M

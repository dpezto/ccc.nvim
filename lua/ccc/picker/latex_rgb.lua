local utils = require("ccc.utils")
local parse = require("ccc.utils.parse")
local pattern = require("ccc.utils.pattern")

---@class ccc.ColorPicker.LaTeXRgb: ccc.ColorPicker
---@field pattern string[]
local LatexRgbPicker = {}

function LatexRgbPicker:init()
  if self.pattern then
    return
  end
  self.pattern = {
    pattern.create("{RGB}{ [<number>] , [<number>] , [<number>] }"),
    pattern.create("{rgb}{ [<per-num>|none] , [<per-num>|none] , [<per-num>|none] }"),
  }
end

---@param s string
---@param init? integer
---@return integer? start_col
---@return integer? end_col
---@return RGB? rgb
---@return Alpha? alpha
function LatexRgbPicker:parse_color(s, init)
  self:init()
  init = init or 1
  -- The shortest patten is 14 characters like `{RGB}{0, 0, 0}`
  while init < #s - 13 do
    local start_col, end_col, cap1, cap2, cap3, cap4
    for _, pat in ipairs(self.pattern) do
      start_col, end_col, cap1, cap2, cap3, cap4 = pattern.find(s, pat, init)
      if start_col then
        break
      end
    end
    if not (start_col and end_col and cap1 and cap2 and cap3) then
      return
    end
    local R = parse.percent(cap1, 255, true)
    local G = parse.percent(cap2, 255, true)
    local B = parse.percent(cap3, 255, true)
    if utils.valid_range({ R, G, B }, 0, 1) then
      local A = parse.alpha(cap4)
      return start_col, end_col, { R, G, B }, A
    end
    init = end_col + 1
  end
end

return LatexRgbPicker

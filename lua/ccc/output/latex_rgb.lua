local convert = require("ccc.utils.convert")

---@class ccc.ColorOutput
local LatexRgbOutput = {
  name = "LatexRGB",
}

function LatexRgbOutput.str(RGB)
  local R, G, B = convert.rgb_format(RGB)
  return ("{RGB}{%d, %d, %d}"):format(R, G, B)
end

return LatexRgbOutput

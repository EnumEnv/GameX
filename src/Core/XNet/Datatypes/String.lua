-- Module --
local StringX = {}

-- Variables --
local Encoding = script.Parent.Parent.Encoding
local RLE = require(Encoding.RLE)

-- Module Functions --
function StringX.AutoOptimize(text: string)
    -- Encode Repetitions --
    local encodedForRepetitions = RLE.Encode(text)

    return encodedForRepetitions
end

function StringX.Deoptimize(text: string)
    return RLE.Decode(text)
end

-- End --
return StringX

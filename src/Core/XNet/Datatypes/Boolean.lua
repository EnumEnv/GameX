-- Module --
local Boolean = {}

-- Local Functions --
local function PackTo32BitOne(boolean, lshift, disp)
	return lshift and bit32.lshift(boolean and 1 or 0, disp) or (boolean and 1 or 0)
end

local function PackTo32BitMultiple(bools)
    if type(bools) ~= "table" then
        error("Input must be a table of boolean values")
    end

    local packedData = 0

    for i, dataInstance in bools do
        packedData = bit32.bor(packedData, bit32.lshift(dataInstance and 1 or 0, (i - 1) * 1))
    end

    return packedData
end

local function UnpackFromBit32(bit32Data)
	local unpackedData = {}

	while bit32Data > 0 do
		-- Check if the least significant bit is set
		local booleanValue = bit32.band(bit32Data, 1) == 1

		table.insert(unpackedData, booleanValue)

		-- Shift the bit32Data to the right to process the next bit
		bit32Data = bit32.rshift(bit32Data, 1)
        task.wait()
	end

	return unpackedData
end

-- Module Functions --
function Boolean.AutoOptimizeOne(boolean, lshift, disp)
	return PackTo32BitOne(boolean, lshift, disp)
end

function Boolean.AutoOptimizeMultiple(bools)
	return PackTo32BitMultiple(bools)
end

function Boolean.ConvertFromBit32ToBool(bit32Data)
	return UnpackFromBit32(bit32Data)
end

-- End --
return Boolean

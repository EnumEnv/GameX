-- Module --
local bit8 = {}

-- Local Functions --
local function CompareTwo(toCompare: number, one: number, two: number): number
    local num: number

    if toCompare < one then
        num = one
    elseif toCompare > two then
        num = two
    end

    return num
end

-- Module Functions --
function bit8.ConvertToUnsigned(data: any)
	local num = tonumber(data) or 0 -- Convert to number, default to 0 if conversion fails
	num = math.floor(num) -- Ensure it's an integer
    num = CompareTwo(num, 0, 255)

	return num
end

function bit8.ConvertToSigned(data: any)
	local num = tonumber(data) or 0 -- Convert to number, default to 0 if conversion fails
    num = math.floor(num) -- Ensure it's an integer
    num = CompareTwo(num, -128, 127)

	return num
end

-- End --
return bit8

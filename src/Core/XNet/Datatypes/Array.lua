-- Module --
local Array = {}

-- Variables --
local Boolean = require(script.Parent.Boolean)
local String = require(script.Parent.String)

-- Module Functions --
function Array.AutoOptimize(array: { [any]: any })
	local convertedArray = {}

	local numbers = {}
	local booleans = {}
	local strings = {}

	-- Store data types --
	for index, value in array do
		if typeof(value) == "number" then
			numbers[index] = value
			continue
		end

		if typeof(value) == "boolean" then
			booleans[index] = value
			continue
		end

		if typeof(value) == "string" then
			strings[index] = value
			continue
		end
	end

	-- Optimize data types --
	local optimizedBooleans = Boolean.AutoOptimizeMultiple(booleans)
	local optimizedStrings = {}

	for index, text in strings do
		optimizedStrings[index] = String.AutoOptimize(text)
	end

	local allOptimizedTypes = { ">" .. optimizedBooleans, optimizedStrings, numbers }

	-- Build converted array --
	for index, optimizedType in allOptimizedTypes do
		if typeof(optimizedType) == "table" then
			for dataIndex, dataValue in optimizedType do
				convertedArray[dataIndex] = dataValue
			end

			continue
		elseif typeof(optimizedType) == "string" and string.sub(optimizedType, 1, 1) == ">" then
			local largestIndex

			for lIndex, _ in booleans do
				largestIndex = lIndex
			end

			convertedArray[largestIndex] = optimizedType
		end
	end

	-- Return converted array --
	return convertedArray
end

-- End --
return Array

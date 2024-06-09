-- Module --
local RLE = {}

-- Module Functions --
function RLE.Encode(text: string): string
	local encoded = ""
	local i = 1

	while i <= #text do
		local count = 1

		while i + count <= #text and text:sub(i, i) == text:sub(i + count, i + count) do
			count = count + 1
			task.wait()
		end

		encoded = encoded .. count .. text:sub(i, i)

		i = i + count
		task.wait()
	end

	return encoded
end

function RLE.Decode(text: string): string
	local decoded = ""
	local i = 1

	while i <= #text do
		local count = tonumber(text:sub(i, i))
		local char = text:sub(i + 1, i + 1)

		decoded = decoded .. string.rep(char, count)

		i = i + 2
	end

	return decoded
end

-- End --
return RLE

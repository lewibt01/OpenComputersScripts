numberUtils

local utils = {}

function utils.round(number,numDecimals)
	local mult = 10^(numDecimals or 0)
	return math.floor(number*mult) / mult
end



return utils
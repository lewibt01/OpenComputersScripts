local addons = {}

function addons.splitStr(inputStr,delim)
	local pieces = {}
	for str in string.gmatch(inputStr,"([^"..delim.."]+)") do
		table.insert(pieces,str)
	end
	return pieces
end

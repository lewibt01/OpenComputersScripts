internet = require("internet")

local Github = {}
Github.BaseURL = "https://raw.githubusercontent.com/lewibt01/OpenComputersScripts/master/"

function Github.ReadFile(name)
	local handle = internet.open(BaseURL..name)
	local data = handle:read()
	handle:close()
	return data
end

function Github.Clone(name,folderPath)
	local data = Github.ReadFile(name)
	
	--ensure the folder path has a / at the end for when we append the file name
	if(folderPath[#folderPath-1] ~= "/") then
		folderPath = folderPath.."/"
	end
	
	--use base functions instead of custom library to ensure first-run compatibility
	local file = io.open(folderPath..name,"w")
	file:write(data)
	file:close()
end

return Github
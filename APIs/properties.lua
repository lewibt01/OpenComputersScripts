local f = require("fileUtils")
local s = require("stringUtils")

local props = {}
props.propFilePath = "/usr/properties"

if(not f.exists(props.propFilePath)) then
	f.createFile(proper.propFilePath)
end

function props.add(key,value)
	local propString = table.concat({key,value},":")
	f.WriteFileString(propString,props.propFilePath)
end

function props.delByKey(key)
	
end
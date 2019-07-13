local fileOps = {}

function fileOps.exists(path)
	local f = io.open(path,"r")
	if(f~=nil) then
		io.close(f)
		return true
	else
		return false
	end
end

function fileOps.writeString(data,path)
	file = io.open(path,"w")
	file:write(tostring(data))
	file:close()
end

function fileOps.readString(path)
	file = io.open(path,"r")
	data = file:read()
	file:close()
	return data
end

function fileOps.appendString(data,path)
	file = io.open(path,"a")
	file:write(tostring(data))
	file:close()
end

function fileOps.createFile(path)
	fileOps.writeString("",path)
end

return fileOps
local FileOps = {}

function FileOps.Exists(path)
	local f = io.open(path,"r")
	if(f~=nil) then
		io.close(f)
		return true
	else
		return false
	end
end

function FileOps.WriteString(data,path)
	file = io.open(path,"w")
	file:write(tostring(data))
	file:close()
end

function FileOps.ReadString(path)
	file = io.open(path,"r")
	return io.read(file)
end

function FileOps.AppendString(data,path)
	file = io.open(path,"a")
	file:write(tostring(data))
	file:close()
end

return FileOps
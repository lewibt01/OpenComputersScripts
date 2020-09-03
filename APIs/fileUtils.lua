local s = require("stringUtils")
local fs = require("filesystem")

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
    local file = io.open(path,"w")
    file:write(tostring(data))
    file:close()
end

function fileOps.readString(path)
    local file = io.open(path,"r")
    data = file:read("*a")
    file:close()
    return data
end

function fileOps.appendString(data,path)
    local file = io.open(path,"a")
    file:write(tostring(data))
    file:close()
end

function fileOps.createFile(path)
    local pieces = s.splitStr(path,"/")
    local appended = ""
    for i=1,#pieces-1 do
        appended = appended..pieces[i].."/" 
    end
    if not (fs.exists(appended)) then
        fs.makeDirectory(appended)
    end
    fileOps.writeString("",path)
end

function fileOps.listFiles(path)
    local objects = fs.list(path)
    local result = {}
    for el in table.unpack(objects) do
        if(not fs.isDirectory(el)) then
            table.insert(result,el)
        end
    end
    return result
end

function fileOps.listFolders(path)
    local objects = fs.list(path)
    local result = {}
    for el in table.unpack(objects) do
        if(fs.isDirectory(el)) then
            table.insert(result,el)
        end
    end
    return result
end 

return fileOps
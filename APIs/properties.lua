local f = require("fileUtils")
local s = require("stringUtils")

local props = {}
props.propFilePath = "/usr/properties"

if(not f.exists(props.propFilePath)) then
    f.createFile(props.propFilePath)
end

function props.add(key,value)
    local propString = key..":"..value --table.concat({key,value},":")
    f.appendString(propString,props.propFilePath)
end

function props.get(key)
    local propFile = f.readString(props.propFilePath)
    local lines = s.splitStr(propFile,"\n")

    for i=1,#lines do
        local pair = s.splitStr(lines[i],":")
        if(pair[1] == key) then
            return pair[2]
        end
    end
    return nil
end

function props.set(key,value)
    if(props.get(key) ~= nil) then
        delByKey(key)
    end
    props.add(key,value)
end

function props.getAll()
    local propFile = f.readString(props.propFilePath)
    
    --make sure the property file wasn't empty
    if(propFile == "") then return {} end

    local lines = s.splitStr(propFile,"\n")

    local propTable = {}
    for i=1,#lines do
        local pair = s.splitStr(lines[i],":")
        propTable[pair[1]] = pair[2]
    end
    return propTable
end

function props.del(index)

end

function props.delByKey(key)
    local propFile = f.readString(props.propFilepath)
    local lines = s.splitStr(propFile,"\n")
    for i = 1,#lines do
        local piece = s.splitStr(lines[i],":")[1]
        if(piece == key) then
            table.remove(lines,i)
            break --remove only 1, not all 
        end
    end

    --rewrite the properties
    f.writeString(table.concat(lines,"\n"),props.propFilePath)
end

function props.delByValue(key)

end

return props
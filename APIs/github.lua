internet = require("internet")
f = require("fileUtils")

local github = {}
github.baseURL = "https://raw.githubusercontent.com/lewibt01/OpenComputersScripts/master/"

--[[
function github.readFile(name)
    local handle = internet.open(github.baseURL..name, 443)
    local data = handle:read()
    handle:close()
    return data
end
]]
function github.requestFile(name)
    local handle = internet.request(github.baseURL..name)
    local result = ""

    for chunk in handle do
        result = result..chunk
    end

    return result
end

function github.pull(name,dest)
    local data = github.requestFile(name)
    f.createFile(dest)
    local file = io.open(dest,"w")
    file:write(data)
    file:close()
end

--[[
function github.clone(name,folderPath)
    local data = github.readFile(name)
    
    --ensure the folder path has a / at the end for when we append the file name
    if(folderPath[#folderPath-1] ~= "/") then
        folderPath = folderPath.."/"
    end
    
    --use base functions instead of custom library to ensure first-run compatibility
    local file = io.open(folderPath..name,"w")
    file:write(data)
    file:close()
end]]

return github

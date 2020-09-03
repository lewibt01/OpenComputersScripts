local r = require("registration")
local arg = { ... }

function main(input)
    if(input == "host") then
        print(r.listen())
    elseif(input == "join") then
        print("attempting to join network")
        r.announce()
    else
        print("Usage: registration <host/join>") 
    end
end

main(table.unpack(arg))
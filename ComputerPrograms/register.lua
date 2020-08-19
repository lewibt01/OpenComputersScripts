local r = require("registration")
local arg = { ... }

function main(input)
    if(input == "host")
        r.listen()
    elseif(input == "join")
        r.announce()
    else
        print("Usage: registration <host/join>")
    end
end

main(table.unpack(arg))
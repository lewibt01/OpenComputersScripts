local component = require("component")
local robot = require("robot")

local analyze = component.geolyzer.analyze(3) -- 3 is the front of the robot
local bonemeal = 2 --which slot to check for bonemeal in

function getFacing()    -- Get the facing of the cocoa bean
    for k,v in pairs(analyze) do
        local i = k
        if i == "metadata" then
            local n = v
            return n
        end
    end
end

function growCocoa()    -- Fertilize as needed
    if robot.count(bonemeal) > 0 then   -- If bonemeal is in slot 2
        robot.select(bonemeal)
        for k,v in pairs(analyze) do
            local i = k
            if i == "metadata" then
                local n = v
                if n < getFacing()+8 then
                    robot.place()
                    os.sleep(1)
                    robot.place()
                end
            end
        end

    else if robot.count(bonemeal) == 0 then
        for k,v in pairs(analyze) do
            local i = k
            if i == "metadata" then
                local n = v
                if n < getFacing()+8 then
                    local x,y = robot.durability()
                    if y == "tool cannot be damaged" then
                        robot.use()
                        os.sleep(1)
                        robot.use()
                    else
                        for k,v in pairs(analyze) do
                            local i = k
                            if i == "metadata" then
                                local n = v
                                while n < getFacing()+8 do
                                    print("Waiting for growth to finish...")
                                        for k,v in pairs(analyze) do
                                            local i = k
                                            if i == "metadata" then
                                                local n = v
                                                if n == getFacing()+8 then
                                                    return
                                                end
                                            else
                                                os.sleep(10)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

growCocoa()
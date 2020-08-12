local arg = { ... }
component = require("component")
o=require("os")
robot=require("robot")
robotAPI=component.robot

--repeatedly attempt to call a function until it returns
function repeatAttempt(numAttempts,timeInterval,func)
    local counter = 0
    while (not func() and counter<numAttempts) do
        os.sleep(timeInterval)
    end
end

function isDigit(char)
    if(char == "0" or char == "1" or char == "2" or char == "3" or char == "4" or char == "5" or char == "6" or char == "7" or char == "8" or char == "9" or char == "0") then
        return true
    else
        return false
    end
end


function aggressiveMove(numTries,moveFunc,attackFunc)
    while (not moveFunc()) and (counter < numTries) do
        attackFunc()
    end
end

function interpret(input)
    for i=1,string.len(input) do
        local tmp = string.sub(input,i,i)

        --movement functions
        if(tmp == "f") then
            robot.forward()
        elseif(tmp == "l") then
            robot.turnLeft()
        elseif(tmp == "r") then
            robot.turnRight()
        elseif(tmp == "b") then
            robot.back()
        elseif(tmp == "d") then
            robot.down()
        elseif(tmp == "u") then
            robot.up()

        --passive ensured movement functions
        ---will wait until whatever is in front of them moves away

        elseif(tmp == "q") then
            repeatAttempt(20,0.5,robot.forward)
        elseif(tmp == "e") then
            repeatAttempt(20,0.5,robot.up)
        elseif(tmp == "c") then
            repeatAttempt(20,0.5,robot.down)

        --aggressive ensured movement functions
        ---if movement fails it will try to remove obstacles
        elseif(tmp == "Q") then
            aggressiveMove(20,robot.forward,robot.swing)
        elseif(tmp == "E") then
            aggressiveMove(20,robot.up,robot.swingUp)
        elseif(tmp == "C") then
            aggressiveMove(20,robot.down,robot.swingDown)

        --dig functions
        elseif(tmp == "D") then
            robot.swingDown()
        elseif(tmp == "U") then
            robot.swingUp()
        elseif(tmp == "F") then
            robot.swing()

        --placement functions
        elseif(tmp == "P") then
            robot.place()
        elseif(tmp == "A") then
            robot.placeUp()
        elseif(tmp == "B") then
            robot.placeDown()

        --inventory managemnet
        elseif(isDigit(tmp)) then
            robot.select(tonumber(tmp))
        elseif(tmp == "!") then
            robot.select(11)
        elseif(tmp == "@") then
            robot.select(12)
        elseif(tmp == "#") then
            robot.select(13)
        elseif(tmp == "$") then
            robot.select(14)
        elseif(tmp == "%") then
            robot.select(15)
        elseif(tmp == "^") then
            robot.select(16)
        end
    end
end

--[[    [DEPRECATED]
function interpret_old(input)
    for i=1,string.len(input) do
        tmp = string.sub(input,i,i)
        --movement functions
        if tmp=="f" then robot.forward() end
        if tmp=="l" then robot.turnLeft() end
        if tmp=="r" then robot.turnRight() end
        if tmp=="b" then robot.back() end
        if tmp=="d" then robot.down() end
        if tmp=="u" then robot.up() end
       
        --passive ensured movement functions
        ---will wait until whatever is in front of them moves away
        if tmp=="q" then
            repeatAttempt(20,0.5,robot.forward)
        end
        if tmp=="e" then
            repeatAttempt(20,0.5,robot.up)
            --while not robot.up() do os.sleep(0.1) end
        end
        if tmp=="c" then
            repeatAttempt(20,0.5,robot.down)
            --while not robot.down() do os.sleep(0.1) end
        end
       
        --aggressive ensured movement functions
        ---if movement fails it will try to remove obstacles
        if tmp=="Q" then
            while not robot.forward() do
                robot.swing()
            end
        end
        if tmp=="E" then
            while not robot.up() do
                robot.swingUp()
            end
        end
        if tmp=="C" then
            while not robot.down() do
                robot.swingDown()
            end
        end
       
        --dig functions...
        if tmp=="D" then robot.swingDown() end
        if tmp=="U" then robot.swingUp() end
        if tmp=="F" then robot.swing() end
       
        --placement functions...
        if tmp=="P" then robot.place() end
        if tmp=="A" then robot.placeUp() end
        if tmp=="B" then robot.placeDown() end
       
        --inventory management...
        if tmp=="1" then robot.select(1) end
        if tmp=="2" then robot.select(2) end
        if tmp=="3" then robot.select(3) end
        if tmp=="4" then robot.select(4) end
        if tmp=="5" then robot.select(5) end
        if tmp=="6" then robot.select(6) end
        if tmp=="7" then robot.select(7) end
        if tmp=="8" then robot.select(8) end
        if tmp=="9" then robot.select(9) end
        if tmp=="0" then robot.select(10) end 
        if tmp=="!" then robot.select(11) end
        if tmp=="@" then robot.select(12) end
        if tmp=="#" then robot.select(13) end
        if tmp=="$" then robot.select(14) end
        if tmp=="%" then robot.select(15) end
        if tmp=="^" then robot.select(16) end
    end
end
]]

interpret(table.concat(arg))
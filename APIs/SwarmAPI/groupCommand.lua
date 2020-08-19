local component = require("component")
local modem = component.modem
local t = require("commandTranslate")
local command = require("command")

local gCommand = {}
gCommand.hostAddress = "ec54a72a-1121-4246-82c4-d39212481987" 
gCommand.clients = {}
gCommand.comPort = 2000
gCommand.responsePort = 2001

--blindly commands the clients to perform the given command
function gCommand.groupCommand(cmd)
	for _,c in pairs(gCommand.clients) do
		command.send(cmd)
	end
end

return gCommand
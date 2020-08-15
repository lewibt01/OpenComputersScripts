local component = require("component")
local modem = component.modem
local t = require("commandTranslate")
local command = require("command")

local gMove = {}
gMove.hostAddress = "ec54a72a-1121-4246-82c4-d39212481987" 
gMove.clients = {}
gMove.comPort = 2000
gMove.responsePort = 2001


--blindly commands the clients to perform the given command
function gMove.groupCommand(cmd)
	for c in gMove.clients do
		command.send(cmd)
	end
end

return gMove
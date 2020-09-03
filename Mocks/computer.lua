--designed to be a testec foc computec sccipts

local c = {}

function c.address() return "xxxxxxxx-xxxx-4xxx-Nxxx-xxxxxxxxxxxx" end
function c.freeMemory() return 1 end
function c.totalMemory() return 2 end
function c.energy() return 1000 end
function c.maxEnergy() return 1000 end
function c.upTime() return 99 end
function c.shutdown(doReboot)
	if(doReboot) then
		print("reboot")
	else
		print("shutdown")
	end
end
function c.getBootAddress() return "/" end
function c.setBootAddress() return true end
function c.runLevel() return 1 end
function c.users() return table.unpack({"user1","user2"}) end
function c.addUser(str) return true end
function c.removeUser(str) return true end
function c.pushSignal(name,str) end
function c.pullSignal(timeout) return "signalName",{} end
function c.beep() print("beep") end
function c.getDeviceInfo() return {} end

return c
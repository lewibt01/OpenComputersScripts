local gps = {}

local component = require("component")
local modem = component.modem
local vector = require("vector")
local os = require("os")
local event = require("event")
local serialization = require("serialization")

local CHANNEL_GPS = 65534

local function trilaterate( A, B, C )
	local a2b = B.vPosition - A.vPosition
	local a2c = C.vPosition - A.vPosition
		
	if math.abs( a2b:normalize():dot( a2c:normalize() ) ) > 0.999 then
		return nil
	end
	
	local d = a2b:length()
	local ex = a2b:normalize( )
	local i = ex:dot( a2c )
	local ey = (a2c - (ex * i)):normalize()
	local j = ey:dot( a2c )
	local ez = ex:cross( ey )

	local r1 = A.nDistance
	local r2 = B.nDistance
	local r3 = C.nDistance
		
	local x = (r1*r1 - r2*r2 + d*d) / (2*d)
	local y = (r1*r1 - r3*r3 - x*x + (x-i)*(x-i) + j*j) / (2*j)
		
	local result = A.vPosition + (ex * x) + (ey * y)

	local zSquared = r1*r1 - x*x - y*y
	if zSquared > 0 then
		local z = math.sqrt( zSquared )
		local result1 = result + (ez * z)
		local result2 = result - (ez * z)
		
		local rounded1, rounded2 = result1:round( 0.01 ), result2:round( 0.01 )
		if rounded1.x ~= rounded2.x or rounded1.y ~= rounded2.y or rounded1.z ~= rounded2.z then
			return rounded1, rounded2
		else
			return rounded1
		end
	end
	return result:round( 0.01 )
	
end

local function narrow( p1, p2, fix )
	local dist1 = math.abs( (p1 - fix.vPosition):length() - fix.nDistance )
	local dist2 = math.abs( (p2 - fix.vPosition):length() - fix.nDistance )
	
	if math.abs(dist1 - dist2) < 0.01 then
		return p1, p2
	elseif dist1 < dist2 then
		return p1:round( 0.01 )
	else
		return p2:round( 0.01 )
	end
end

function gps.locate( _nTimeout, _bDebug )
		if _nTimeout ~= nil and type( _nTimeout ) ~= "number" then
				error( "bad argument #1 (expected number, got " .. type( _nTimeout ) .. ")", 2 ) 
		end
		if _bDebug ~= nil and type( _bDebug ) ~= "boolean" then
				error( "bad argument #2 (expected boolean, got " .. type( _bDebug) .. ")", 2 ) 
		end
	
	-- Find a modem

	if not modem.isWireless() then
		if _bDebug then
			print( "No wireless network card installed" )
		end
		return nil
	end
	
	if _bDebug then
		print( "Finding position..." )
	end

	-- Open a channel
	if not modem.isOpen(CHANNEL_GPS) then
		modem.open(CHANNEL_GPS)
		bCloseChannel = true
	end
	-- Send a ping to listening GPS hosts
	modem.broadcast( CHANNEL_GPS, "PING" )
	-- Wait for the responses
	local tFixes = {}
	local pos1, pos2 = nil, nil
	local timeout = _nTimeout or 2
	while true do
		local e, modemID, _, port, nDistance, tMessage = event.pull(timeout, "modem_message")
		tMessage = serialization.unserialize(tMessage)
		if e == "modem_message"  then
			-- We received a reply from a modem
			if modemID == modem.address and port == CHANNEL_GPS and nDistance then
				print(nDistance)
				-- Received the correct message from the correct modem: use it to determine position
				if type(tMessage) == "table" and #tMessage == 3 and tonumber(tMessage[1]) and tonumber(tMessage[2]) and tonumber(tMessage[3]) then
					local tFix = { vPosition = vector.new( tMessage[1], tMessage[2], tMessage[3] ), nDistance = nDistance }
					if _bDebug then
						print( tFix.nDistance.." metres from "..tostring( tFix.vPosition ) )
					end
					if tFix.nDistance == 0 then
							pos1, pos2 = tFix.vPosition, nil
					else
						table.insert( tFixes, tFix )
						if #tFixes >= 3 then
							if not pos1 then
								pos1, pos2 = trilaterate( tFixes[1], tFixes[2], tFixes[#tFixes] )
							else
								pos1, pos2 = narrow( pos1, pos2, tFixes[#tFixes] )
							end
						end
					end
					if pos1 and not pos2 then
						break
					end
				end
			end
		elseif e == nil then
			break
		end
	end
	
	-- Close the channel, if we opened one
	if bCloseChannel then
		modem.close(CHANNEL_GPS)
	end
	
	-- Return the response
	if pos1 and pos2 then
		if _bDebug then
			print( "Ambiguous position" )
			print( "Could be "..pos1.x..","..pos1.y..","..pos1.z.." or "..pos2.x..","..pos2.y..","..pos2.z )
		end
		return nil
	elseif pos1 then
		if _bDebug then
			print( "Position is "..pos1.x..","..pos1.y..","..pos1.z )
		end
		return pos1.x, pos1.y, pos1.z
	else
		if _bDebug then
			print( "Could not determine position" )
		end
		return nil
	end
end

return gps
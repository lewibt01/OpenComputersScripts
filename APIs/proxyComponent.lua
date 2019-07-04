local component = require("component")

local p = {}

function p.proxyComponent(name)
	return component.proxy(component.list(name)())
end

function p.proxyComponentAsStr(name)
	return "component.proxy(component.list(\""..name.."\")())"
end

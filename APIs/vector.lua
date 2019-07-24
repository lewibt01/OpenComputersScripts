--library meant to handle 3d vectors
--https://gist.github.com/Rapptz/11305872

vector = {}

local function isVector(t)
    return getmetatable(t) == vector
end

--operator overloads
function vector.__add(v1,v2)
    assert(isVector(v1) and isVector(v2),"Type mismatch: Argument must be a vector")
    return vector.new(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z)
end

function vector.__sub(v1,v2)
    assert(isVector(v1) and isVector(v2),"Type mismatch: Argument must be a vector")
    return vector.new(v1.x-v2.x, v1.y-v2.y, v1.z-v2.z)
end

function vector.__mul(v1,v2)
    local isVector1 = isVector(v1)
    local isVector2 = isVector(v2)
    if type(v1) == "number" and isVector2 then
        return vector.new(v2.x*v1, v2.y*v1, v2.z*v1)
    elseif type(v2) == "number" and isVector1 then
        return vector.new(v1.x*v2, v1.y*v2, v1.z*v2)
    elseif isVector1 and isVector2 then
        return vector.new(v1.x*v2.x, v1.y*v2.y, v1.z*v2.z)
    else
        error("Type mismatch: vector and/or number expected")
    end
end

function vector.__unm(t)
    assert(isVector(t),"Type mismatch: vector expected")
    return vector.new(-t.x,-t.y,-t.z)
end

function vector:__tostring()
    return "("..self.x..", "..self.y..", "..self.z..")"
end

function vector.__eq(v1,v2)
    return (v1.x == v2.x and v1.y == v2.y and v1.z == v2.z)
end

--[[--need to figure out how to implement these in 3d
function vector.__lt(v1,v2)

end

function vectr.__le(v1,v2)

end
]]

function vector.new(x,y,z)
    return setmetatable({x=x or 0, y=y or 0, z=z or 0},vector)
end

function vector:clone()
    return vector.new(self.x,self.y,self.z)
end

function vector:length()
    return math.sqrt(math.pow(self.x,2)+math.pow(self.y,2)+math.pow(self.z,2))
end

function vector:unpack()
    return self.x,self.y,self.z
end

function vector:normalize()
    local len = self:length()
    if len ~= 0 and len ~= 1 then
        self.x = self.x/len
        self.y = self.y/len
        self.z = self.z/len
    end
end

--dot product
function vector.dot(v1,v2)
    assert(isVector(v1) and isVector(v2),"Argument must be a vector")
    return ((v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z))
end

function vector.distanceSquared(v1,v2)
    assert(isVector(v1) and isVector(v2),"Type mismatch: Argument must be a vector")
    local dx,dy,dz = v2.x-v1.x, v2.y-v1.y, v2.z-v1.z
    return math.pow(dx,2)+math.pow(dy,2)+math.pow(dz,2)
end

function vector.distance(v1,v2)
    return math.sqrt(vector.distanceSquared(v1,v2))
end

function vector.max(v1,v2)
    assert(isVector(v1) and isVector(v2),"Type mismatch: Argument must be a vector")
    local x = math.max(v1.x,v2.x)
    local y = math.max(v1.y,v2.y)
    local z = math.max(v1.z,v2.z)
    return vector.new(x,y,z)
end

function vector.min(v1,v2)
    assert(isVector(v1) and isVector(v2),"Type mismatch: Argument must be a vector")
    local x = math.min(v1.x,v2.x)
    local y = math.min(v1.y,v2.y)
    local z = math.min(v1.z,v2.z)
    return vector.new(x,y,z)
end

function vector.angle(from,to)
    assert(isVector(from) and isVector(to),"Type mismatch: Argument must be a vector")
    return math.atan2(to.y - from.y, to.x)
end

return vector
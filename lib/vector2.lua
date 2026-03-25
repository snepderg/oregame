local object = require( "external.classic" )

local vector2 = object:extend()

function vector2:__index( key ) 
    if key == "x" then
        return rawget( self, 1 )
    elseif key == "y" then
        return rawget( self, 2 )
    else 
        return getmetatable( self )[key]
    end
end

function vector2:__newindex( key, value ) 
    if key == "x" then
        rawset( self, 1, value )
    elseif key == "y" then
        rawset( self, 2, value )
    else
        getmetatable( self )[key] = value
    end
end

function vector2:Zero()
    return vector2( 0, 0 )
end

function vector2:new( x, y )
    self.x = x
    self.y = y
end

function vector2.__add( lhs, rhs )
    return vector2( lhs.x + rhs.x, lhs.y + rhs.y )
end

function vector2.__sub( lhs, rhs )
    return vector2( lhs.x - rhs.x, lhs.y - rhs.y )
end

function vector2.__mul( lhs, rhs )
    return vector2( lhs.x * rhs.x, lhs.y * rhs.y )
end

function vector2.__div( lhs, rhs )
    return vector2( lhs.x / rhs.x, lhs.y / rhs.y )
end

function vector2.__eq( lhs, rhs )
    return lhs.x == rhs.x and lhs.y == rhs.y
end

function vector2:IsNearlyEqual( other, epsilon )
    if epsilon == nil then epsilon = 0.001 end
    
    return not ( ( self.x > other.x + epsilon ) or ( self.x < other.x - epsilon ) or ( self.y > other.y + epsilon ) or ( self.y < other.y - epsilon ) )
end

function vector2:Dot( other )
    return self.x * other.x + self.y * other.y
end

function vector2:Length()
    return math.sqrt( self.x * self.x + self.y * self.y )
end

function vector2:Normalize()
    local max = math.max( self.x, self.y )
    return vector2( self.x / max, self.y / max )
end

function vector2:Angle( other )
    local length1 = math.sqrt( self.x * self.x + self.y * self.y )
    local length2 = math.sqrt( other.x * other.x + other.y * other.y )
    return math.acos( ( self.x * other.x + self.y * other.y ) * ( length2 / length1 ) )
end

return vector2
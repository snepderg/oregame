local Object = require( "external.classic" )

local Vector2 = Object:extend(  )

function Vector2:__index( key ) 
    if key == "x" then
        return rawget( self, 1 )
    elseif key == "y" then
        return rawget( self, 2 )
    else 
        return getmetatable( self )[key]
    end
end

function Vector2:__newindex( key, value ) 
    if key == "x" then
        rawset( self, 1, value )
    elseif key == "y" then
        rawset( self, 2, value )
    else
        getmetatable( self )[key] = value
    end
end

function Vector2:Zero()
    return Vector2( 0, 0 )
end

function Vector2:new( x, y )
    self.x = x
    self.y = y
end

function Vector2.__add( lhs, rhs )
    return Vector2( lhs.x + rhs.x, lhs.y + rhs.y )
end

function Vector2.__sub( lhs, rhs )
    return Vector2( lhs.x - rhs.x, lhs.y - rhs.y )
end

function Vector2.__mul( lhs, rhs )
    return Vector2( lhs.x * rhs.x, lhs.y * rhs.y )
end

function Vector2.__div( lhs, rhs )
    return Vector2( lhs.x / rhs.x, lhs.y / rhs.y )
end

function Vector2.__eq( lhs, rhs )
    return lhs.x == rhs.x and lhs.y == rhs.y
end

function Vector2:IsNearlyEqual( other, epsilon )
    if epsilon == nil then epsilon = 0.001 end
    
    return not ( ( self.x > other.x + epsilon ) or ( self.x < other.x - epsilon ) or ( self.y > other.y + epsilon ) or ( self.y < other.y - epsilon ) )
end

function Vector2:Dot( other )
    return self.x * other.x + self.y * other.y
end

function Vector2:Length()
    return math.sqrt( self.x * self.x + self.y * self.y )
end

function Vector2:Normalize()
    local max = math.max( self.x, self.y )
    return Vector2( self.x / max, self.y / max )
end

function Vector2:Angle( other )

    local length1 = math.sqrt( self.x * self.x + self.y * self.y )
    local length2 = math.sqrt( other.x * other.x + other.y * other.y )
    return math.acos( ( self.x * other.x + self.y * other.y ) * ( length2 / length1 ) )
end

return Vector2
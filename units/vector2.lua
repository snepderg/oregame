local middleclass = require( "external.middleclass.middleclass" )
local middleclass_extensions = require( "lib.middleclass_extensions" )

local Vector2 = middleclass.class( "Vector2" )

local metaMethods = {
    __add = function( lhs, rhs ) return Vector2( lhs.x + rhs.x, lhs.y + rhs.y ) end,
    __sub = function( lhs, rhs ) return Vector2( lhs.x - rhs.x, lhs.y - rhs.y ) end,
    __mul = function( lhs, rhs ) return Vector2( lhs.x * rhs.x, lhs.y * rhs.y ) end,
    __div = function( lhs, rhs ) return Vector2( lhs.x / rhs.x, lhs.y / rhs.y ) end,
    __eq = function( lhs, rhs ) return lhs.x == rhs.x and lhs.y == rhs.y end,
}


function Vector2:zero()
    return Vector2( 0, 0 )
end

function Vector2:initialize( x, y )
    middleclass_extensions.injectMeta( self, metaMethods )
    self.x = x
    self.y = y
end

function Vector2:isNearlyEqual( other, epsilon )
    if epsilon == nil then epsilon = 0.001 end

    return not ( ( self.x > other.x + epsilon ) or ( self.x < other.x - epsilon ) or ( self.y > other.y + epsilon ) or ( self.y < other.y - epsilon ) )
end

function Vector2:dot( other )
    return self.x * other.x + self.y * other.y
end

function Vector2:length()
    return math.sqrt( self.x * self.x + self.y * self.y )
end

function Vector2:normalize()
    local max = math.max( self.x, self.y )
    return Vector2( self.x / max, self.y / max )
end

function Vector2:getAngleBetween( other )
    local length1 = math.sqrt( self.x * self.x + self.y * self.y )
    local length2 = math.sqrt( other.x * other.x + other.y * other.y )
    return math.acos( ( self.x * other.x + self.y * other.y ) * ( length2 / length1 ) )
end

return Vector2

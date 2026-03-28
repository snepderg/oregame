local middleclass = require( "external.middleclass.middleclass" )
local Vector2 = require( "units.vector2" )

local TileGrid = middleclass.class( "TileGrid" )


----- STATIC METHODS -----

function TileGrid:initialize( gridSize, tileSize )
    self.buffer = {}
    self.gridSize = gridSize
    self.tileSize = tileSize or 1
end


----- INSTANCE METHODS -----

function TileGrid:posToIndex( pos )
    return ( pos.y * self.size.x + pos.x ) + 1
end

function TileGrid:indexToPos( index )
    return Vector2( ( index - 1 ) % self.size.x, math.ceil( index / self.size.x ) - 1 )
end

function TileGrid:setCell( pos, building )
    self.buffer[self:posToIndex( pos )] = building
end

function TileGrid:getCell( pos )
    return self.buffer[self:posToIndex( pos )]
end


return TileGrid

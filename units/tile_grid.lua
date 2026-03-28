local middleclass = require( "external.middleclass.middleclass" )
local Vector2 = require( "units.vector2" )

local TileGrid = middleclass.class( "TileGrid" )

function TileGrid:initialize( gridSize, tileSize )
    self.buffer = {}
    self.gridSize = gridSize
    self.tileSize = tileSize or 1
end

function TileGrid:PositionToIndex( position )
    return ( position.y * self.size.x + position.x ) + 1
end

function TileGrid:IndexToPosition( index )
    return Vector2( ( index - 1 ) % self.size.x, math.ceil( index / self.size.x ) - 1 )
end

function TileGrid:SetCell( position, building )
    self.buffer[self:PositionToIndex( position )] = building
end

function TileGrid:GetCell( position )
    return self.buffer[self:PositionToIndex( position )]
end

return TileGrid
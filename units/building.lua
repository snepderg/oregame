local middleclass = require( "external.middleclass.middleclass" )
local Vector2 = require( "units.vector2" )

local Building = middleclass.class( "Building" )

function Building:initialize( pos, size, image )
    self.pos = pos
    self.size = size
    self.image = love.graphics.newImage( image )
end

function Building:draw()
    love.graphics.draw( self.image, self.pos.x, self.pos.y, nil, self.size.x / self.image:getWidth(), self.size.y / self.image:getHeight() )
end

return Building
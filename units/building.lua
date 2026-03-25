local Object = require( "external.classic" )
local Vector2 = require( "units.vector2" )

local Building = Object:extend()

function Building:new( pos, size, image )
    self.pos = pos
    self.size = size
    self.image = love.graphics.newImage( image )
end

function Building:draw()
    love.graphics.draw( self.image, self.pos.x, self.pos.y, nil, self.size, self.size )
end

return Building
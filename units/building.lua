local Destroyable = require( "classes.destroyable" )
local Vector2 = require( "units.vector2" )

local Building = Destroyable:subclass( "Building" )


----- STATIC METHODS -----

function Building:initialize( pos, size, image )
    self.pos = pos
    self.size = size
    self.image = love.graphics.newImage( image )
end


----- INSTANCE METHODS -----

function Building:draw()
    love.graphics.draw( self.image, self.pos.x, self.pos.y, nil, self.size.x / self.image:getWidth(), self.size.y / self.image:getHeight() )
end


----- IMPLEMENTED METHODS -----

function Building:onDestroyed()
    -- TODO
end


return Building

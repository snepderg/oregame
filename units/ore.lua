local Destroyable = require( "classes.destroyable" )
local Ore = Destroyable:subclass( "Ore" )


----- STATIC METHODS -----

function Ore:initialize( pos, size, vel, color, value, tags )
    self.pos = pos
    self.size = size
    self.vel = vel
    self.color = color

    self.value = value or 0
    self.tags = tags or {}
    self.upgradeHistory = {}

    self.mode = "fill"
end


----- INSTANCE METHODS -----

function Ore:update( dt )
    self.pos.x = self.pos.x + ( self.vel.x * dt )
    self.pos.y = self.pos.y + ( self.vel.y * dt )
end

function Ore:draw()
    local prevColor = { love.graphics.getColor() }
    love.graphics.setColor( self.color )
    love.graphics.rectangle( self.mode, self.pos.x, self.pos.y, self.size.x, self.size.y )
    love.graphics.setColor( prevColor )
end


----- IMPLEMENTED METHODS -----

function Ore:onDestroyed()
    -- TODO
end


return Ore

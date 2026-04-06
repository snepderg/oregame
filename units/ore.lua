local Sprite = require( "units.sprite" )
local Vector2 = require( "units.vector2" )
local Ore = Sprite:subclass( "Ore" )


----- STATIC METHODS -----

function Ore:initialize()
    Ore.super.initialize( self )
    self.size = Vector2:zero()
    self.velocity = Vector2:zero()
    self.color = { 0, 0, 0, 1 }

    self.value = 0
    self.tags = {}
    self._upgradeHistory = {}

    self.texture = love.graphics.newCanvas( 1, 1 )
end

----- INSTANCE METHODS -----

function Ore:update( dt )
    self._position.x = self._position.x + ( self.velocity.x * dt )
    self._position.y = self._position.y + ( self.velocity.y * dt )
end

----- IMPLEMENTED METHODS -----

function Ore:onDestroyed()
    -- TODO
end

function Ore:draw()
    love.graphics.setCanvas( self.texture )
    love.graphics.clear( self.color )
    love.graphics.setCanvas()
    Ore.super.draw( self )
end

return Ore

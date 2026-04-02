local GameObject2D = require( "units.game_object_2d" )
local Vector2 = require( "units.vector2" )

local Sprite = GameObject2D:subclass( "Sprite" )

----- STATIC METHODS -----

function Sprite:initialize( imagePath )
    Sprite.super.initialize( self )

    self.texture = love.graphics.newImage( imagePath )

    self.flipH = false
    self.flipV = false

    self.centered = true
    self.size = Vector2( self.texture:getWidth(), self.texture:getHeight() )
    self.offset = Vector2( 0, 0 )
end

----- INSTANCE METHODS -----


----- IMPLEMENTED METHODS -----

function Sprite:draw()

    local position = self:getPosition()
    local offset = Vector2(
        self.centered and self.texture:getWidth() / 2 + self.offset.x or self.offset.x,
        self.centered and self.texture:getHeight() / 2 + self.offset.y or self.offset.y
    )

    local flipFactor = Vector2( self.flipH and -1 or 1, self.flipV and -1 or 1 )

    love.graphics.draw(
        self.texture,
        position.x,
        position.y,
        nil,
        self.size.x / self.texture:getWidth() * flipFactor.x,
        self.size.y / self.texture:getHeight() * flipFactor.y,
        offset.x,
        offset.y
    )
    love.graphics.setPointSize( 4 )
    love.graphics.points( position.x, position.y )
    love.graphics.setPointSize( 1 )
end

return Sprite
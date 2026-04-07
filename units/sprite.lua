local GameObject2D = require( "units.game_object_2d" )
local Vector2 = require( "units.vector2" )

local Sprite = GameObject2D:subclass( "Sprite" )

----- STATIC METHODS -----

function Sprite:initialize( imagePath )
    Sprite.super.initialize( self );

    if imagePath ~= nil then
        self.texture = love.graphics.newImage( imagePath )
    else
        self.texture = love.graphics.newCanvas( 1, 1 )
    end


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
        self.centered and self.size.x / 2 + self.offset.x or self.offset.x,
        self.centered and self.size.y / 2 + self.offset.y or self.offset.y
    )

    local flipFactor = Vector2( self.flipH and -1 or 1, self.flipV and -1 or 1 )
    local scaleFactor = Vector2( self.size.x / self.texture:getWidth() * flipFactor.x, self.size.y / self.texture:getHeight() * flipFactor.y )

    love.graphics.draw(
        self.texture,
        position.x - offset.x,
        position.y - offset.y,
        nil,
        scaleFactor.x,
        scaleFactor.y
    )
    love.graphics.setPointSize( 4 )
    love.graphics.points( position.x, position.y )
    love.graphics.setPointSize( 1 )
end

return Sprite
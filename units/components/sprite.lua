local BaseComponent = require( "units.components.base" )
local Vector2 = require( "units.vector2" )

local Sprite = BaseComponent:subclass( "Sprite" )

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


return Sprite
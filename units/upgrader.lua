local GameObject2D = require( "units.game_object_2d" )
local Vector2 = require( "units.vector2" )
local Sprite = require( "units.sprite" )

local collision = require( "units.collision" )


local DEFAULT_BEAM_COLOR = { 0, 1, 1, 0.3 }

local Upgrader = GameObject2D:subclass( "Upgrader" )


----- STATIC METHODS -----

function Upgrader:initialize( pos, tag, beamColor, upgradeCallback )
    Upgrader.super.initialize( self )

    self.sprite = Sprite( "res/upgrader.png" )
    self.sprite.size = Vector2( 256, 256 )
    self:addChild( self.sprite )

    self.tag = tag
    self.beam = Sprite()

    self.beam.size = Vector2( 40, 40 )
    love.graphics.setCanvas( self.beam.texture )
    love.graphics.clear( self.beamColor )
    love.graphics.setCanvas()

    self:addChild( self.beam )

    self.beamColor = beamColor or DEFAULT_BEAM_COLOR
    self.callback = upgradeCallback
    self.zIndex = 1

    self:setPosition( pos )
end


----- INSTANCE METHODS -----

function Upgrader:checkCollision( objA, objB )
    return collision.checkAABB( objA, objB )
end

----- IMPLEMENTED METHODS -----

function Upgrader:draw()
    love.graphics.setColor( self.beamColor )
    love.graphics.rectangle(
        "fill",
        self.beam._position.x,
        self.beam._position.y,
        self.beam.size.x,
        self.beam.size.y
    )
    love.graphics.setColor( 1, 1, 1, 1 )
end

function Upgrader:onDestroyed()
    -- TODO
end


return Upgrader

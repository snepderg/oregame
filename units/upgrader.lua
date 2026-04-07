local GameObject2D = require( "units.game_object_2d" )
local Vector2 = require( "units.vector2" )
local Sprite = require( "units.sprite" )

local collision = require( "units.collision" )


local DEFAULT_BEAM_COLOR = { 0, 1, 1, 0.3 }

local Upgrader = GameObject2D:subclass( "Upgrader" )


----- STATIC METHODS -----

function Upgrader:initialize( pos, tag, beamColor, upgradeCallback )
    Upgrader.super.initialize( self )

    self.tag = tag
    self.callback = upgradeCallback
    self:setPosition( pos )

    self.sprite = Sprite( "res/upgrader.png" )
    self.sprite.size = Vector2( 256, 256 )
    self:addChild( self.sprite )

    self.beamColor = beamColor or DEFAULT_BEAM_COLOR
    self.beam = Sprite()
    self.beam.size = Vector2( 40, 40 )
    love.graphics.setCanvas( self.beam.texture )
    love.graphics.clear( self.beamColor )
    love.graphics.setCanvas()
    self:addChild( self.beam )
end


----- INSTANCE METHODS -----

function Upgrader:checkCollision( objA, objB )
    return collision.checkAABB( objA, objB )
end

----- IMPLEMENTED METHODS -----

function Upgrader:onDestroyed()
    -- TODO
end


return Upgrader

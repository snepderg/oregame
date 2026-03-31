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
    self.beam = {}
    self.beam.size = Vector2( 8, self.sprite.size.y )
    self.beam.pos = Vector2( 0, 0 )
    self.beam.color = beamColor or DEFAULT_BEAM_COLOR
    self.callback = upgradeCallback

    self:setPosition( pos )
end


----- INSTANCE METHODS -----

function Upgrader:checkCollision( objA, objB )
    return collision.checkAABB( objA, objB )
end

function Upgrader:frameUpdate()

    local prevColor = { love.graphics.getColor() }
    love.graphics.setColor( self.beam.color )
    love.graphics.rectangle(
        "fill",
        self.beam.pos.x,
        self.beam.pos.y,
        self.beam.size.x,
        self.beam.size.y
    )

    love.graphics.setColor( prevColor )
end


----- IMPLEMENTED METHODS -----

function Upgrader:onDestroyed()
    -- TODO
end


return Upgrader

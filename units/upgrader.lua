local GameObject2D = require( "units.game_object_2d" )
local Vector2 = require( "units.vector2" )
local collision = require( "units.collision" )


local DEFAULT_BEAM_COLOR = { 0, 1, 1, 0.3 }

local Upgrader = GameObject2D:subclass( "Upgrader" )


----- STATIC METHODS -----

function Upgrader:initialize( pos, tag, beamColor, upgradeCallback )
    Upgrader.super.initialize( self )
    self.beamColor = beamColor or DEFAULT_BEAM_COLOR

    self.size = Vector2( 128, 128 )
    self.image = love.graphics.newImage( "res/upgrader.png" )

    self.beam = {}
    self.beam.size = Vector2( 8, self.size.y )
    self.beam.pos = Vector2( 0, 0 )
    self.tag = tag

    self.callback = upgradeCallback

    self:setPosition( pos )
end


----- INSTANCE METHODS -----

function Upgrader:checkCollision( objA, objB )
    return collision.checkAABB( objA, objB )
end

function Upgrader:frameUpdate()
    local pos = self:getPosition()
    love.graphics.draw( self.image, pos.x, pos.y, nil, self.size.x / self.image:getWidth(), self.size.y / self.image:getHeight() )

    local prevColor = { love.graphics.getColor() }
    love.graphics.setColor( self.beamColor )
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

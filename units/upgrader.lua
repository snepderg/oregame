local Vector2 = require( "units.vector2" )
local Building = require( "units.building" )

local collision = require( "units.collision" )

local DEFAULT_BEAM_COLOR = { 0, 1, 1, 0.3 }

local Upgrader = Building:extend()


function Upgrader:new( pos, tag, beamColor, upgradeCallback )
    Upgrader.super.new( self, pos, Vector2( 128, 128 ), "res/upgrader.png" )
    self.beamColor = beamColor or DEFAULT_BEAM_COLOR

    self.beam = {}
    self.beam.size = Vector2( 8, self.size.y )
    self.beam.pos = Vector2( self.pos.x + self.size.x / 2 - self.beam.size.x / 2, self.pos.y )
    self.tag = tag

    self.callback = upgradeCallback
end

function Upgrader:CheckCollision( objA, objB )
    return collision.checkAABB( objA, objB )
end

function Upgrader:draw()
    Upgrader.super.draw( self )

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


return Upgrader
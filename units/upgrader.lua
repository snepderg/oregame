local Object = require( "external.classic" )
local Vector2 = require( "units.vector2" )
local Building = require( "units.building" )

local COLOR_WHITE = { 1, 1, 1, 1 }
local DEFAULT_BEAM_COLOR = { 0, 1, 1, 0.3 }

local UPGRADER_PIXEL_OFFSET = 2 -- The texture is offset by 2 pixels.

local Upgrader = Building:extend()
local UpgraderBeam = Object:extend()


function Upgrader:new( pos, tag, beamColor, upgradeCallback )
    Upgrader.super.new(self, pos, Vector2( 128, 128 ), "res/upgrader.png")
    self.beamColor = beamColor or DEFAULT_BEAM_COLOR

    self.beam = {}
    self.beam.size = Vector2( 8, self.size.y )
    self.beam.pos = Vector2( self.pos.x + self.size.x / 2 - self.beam.size.x / 2, self.pos.y )
    self.tag = tag

    self.callback = upgradeCallback
end

function Upgrader:CheckCollisions( ore )
    local aLeft = self.beam.pos.x
    local aRight = self.beam.pos.x + self.beam.size.x
    local aTop = self.beam.pos.y
    local aBottom = self.beam.pos.y + self.beam.size.y

    local bLeft = ore.pos.x
    local bRight = ore.pos.x + ore.size.x
    local bTop = ore.pos.y
    local bBottom = ore.pos.y + ore.size.y

    return aRight > bLeft
        and aLeft < bRight
        and aBottom > bTop
        and aTop < bBottom
end

function Upgrader:draw()
    Upgrader.super.draw(self)

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
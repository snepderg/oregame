local Object = require( "external.classic" )
local Vector2 = require( "units.Vector2" )

local COLOR_WHITE = { 1, 1, 1, 1 }
local DEFAULT_BEAM_COLOR = { 0, 1, 1, 0.3 }

local UpgraderBeam = Object:extend()

function UpgraderBeam:new( pos, size, color, callback )
    self.pos = pos
    self.size = size
    self.color = color or DEFAULT_BEAM_COLOR
    self.callback = callback

    if not self.callback then
        print( "Some upgrade beam didn't return a value! (" .. tostring( callback ) .. ")" )
        return
    end
end

function UpgraderBeam:draw()
    local prevColor = { love.graphics.getColor() }
    love.graphics.setColor( self.color )
    love.graphics.rectangle( "fill", self.pos.x, self.pos.y, self.size.x, self.size.y )
    love.graphics.setColor( prevColor )
end

return UpgraderBeam
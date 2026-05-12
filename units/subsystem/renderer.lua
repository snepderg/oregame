--[[
    The Renderer is currently a collection of stateless functions that take a scene as input and renders it to the screen.
]]
local Vector2 = require( "units.vector2" )

local Renderer = {}

function Renderer.draw( scene )

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

return Renderer
local Building = require( "units.building" )
local Vector2 = require( "units.vector2" )

local Conveyor = Building:extend()

function Conveyor:new( pos, size )
    Conveyor.super.new(self, pos, size, "res/belt.png")
end

return Building
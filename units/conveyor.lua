local Building = require( "units.building" )
local Vector2 = require( "units.vector2" )

local Conveyor = Building:subclass( "Conveyor" )

function Conveyor:initialize( pos, size )
    Conveyor.super.initialize(self, pos, size, "res/belt.png")
end

return Building

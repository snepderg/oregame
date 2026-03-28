local Building = require( "units.building" )
local Conveyor = Building:subclass( "Conveyor" )


----- STATIC METHODS -----

function Conveyor:initialize( pos, size )
    Conveyor.super.initialize( self, pos, size, "res/belt.png" )
end


----- IMPLEMENTED METHODS -----

function Conveyor:onDestroyed()
    -- TODO
end


return Conveyor

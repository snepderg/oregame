local GameObject2D = require( "units.game_object_2d" )
local Conveyor = GameObject2D:subclass( "Conveyor" )


----- STATIC METHODS -----

function Conveyor:initialize( pos, size )
    Conveyor.super.initialize( self )
end


----- IMPLEMENTED METHODS -----

function Conveyor:onDestroyed()
    -- TODO
end


return Conveyor

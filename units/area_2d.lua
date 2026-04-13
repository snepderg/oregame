local GameObject2D = require( "units.game_object_2d" )
local Vector2 = require( "units.vector2" )

local Area2D = GameObject2D:subclass( "Area2D" )

----- STATIC METHODS -----

function Area2D:initialize( rect )
    Area2D.super.initialize( self );

    self.bounds = rect
end

return Area2D
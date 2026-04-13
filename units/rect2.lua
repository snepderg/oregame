local middleclass = require( "external.middleclass.middleclass" )

local Rect2 = middleclass.class( "Rect2" )

----- STATIC METHODS -----

function Rect2:initialize( position, size )
    self.position = position
    self.size = size
end

return Rect2

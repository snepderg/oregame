local Building = require( "units.building" )

local Upgrader = Building:extend()

-- Takes a callback, expects a number value to be returned
function Upgrader:new( pos, size, tag )
    Upgrader.super.new( self, pos, size, "res/upgrader.png" )
    self.tag = tag
end

return Upgrader
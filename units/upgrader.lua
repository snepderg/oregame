local Object = require( "external.classic" )
local Building = require( "units.building" )

local Upgrader = Building:extend()
local UpgraderBeam = Object:extend()

--[[
-- Takes a callback, expects a number value to be returned
function Upgrader:new( pos, size, tag )
    Upgrader.super.new( self, pos, size, "res/upgrader.png" )
    self.tag = tag
end
]]

function Upgrader:new( pos, size, tag, beamColor, callback )
    self.pos = pos
    self.size = size
    self.beam = UpgraderBeam( pos, size, beamColor, callback )
    self.tag = tag
end

return Upgrader
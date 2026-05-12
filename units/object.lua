local Destroyable = require( "classes.destroyable" )
local UUID = require( "units.uuid" )

local Object = Destroyable:subclass( "Object" )

----- STATIC METHODS -----

function Object:initialize()
    Object.super.initialize( self );

    self.name = self.class.name
    self._instanceID = UUID.new()
end

----- INSTANCE METHODS -----

function Object:getInstanceID()
    return self._instanceID
end


return Object
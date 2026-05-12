local Vector2 = require( "units.vector2" )

local Scene = require( "units.subsystem.scene" )
local GameObject = require( "units.game_object" )


-- We use love.load to populate the active scene as there's currently no point that serializes from disk, or the implementation of an "editor" that controls the runtime.
function love.load()
    local gameObject1 = GameObject( ActiveScene )
    local gameObject2 = GameObject( ActiveScene )

    local transform1 = gameObject1:getComponent( "Transform" )
    local transform2 = gameObject2:getComponent( "Transform" )

    transform2:setParent( transform1 )

end


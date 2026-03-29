local Destroyable = require( "classes.destroyable" )
local GameObject = require( "units.game_object" )

local Scene = Destroyable:subclass( "Scene" )


----- STATIC METHODS -----

function Scene:initialize()
    self._root = GameObject()
    self._root:_setScene( self )
    self._started = false
end

----- INSTANCE METHODS -----

function Scene:start()
    self._started = true
    local function tickObjects( gameObject )
        for _, child in ipairs( gameObject:getChildren() ) do
            tickObjects( child )
        end
        if gameObject._ready == false then
            gameObject._ready = true
            gameObject:ready()
        end
    end

    tickObjects( self._root )

end

function Scene:hasStarted()
    return self._started
end

function Scene:getRoot()
    return self._root
end

function Scene:tickUpdate( deltaTime )
    local function tickObjects( gameObject )
        gameObject:tickUpdate( deltaTime )
        local children = gameObject:getChildren()
        for _, child in ipairs( children ) do
            tickObjects( child )
        end
    end

    tickObjects( self._root )
end

function Scene:frameUpdate( deltaTime )
    local function tickObjects( gameObject )
        gameObject:frameUpdate( deltaTime )
        local children = gameObject:getChildren()
        for _, child in ipairs( children ) do
            tickObjects( child )
        end
    end

    tickObjects( self._root )
end

----- IMPLEMENTED METHODS -----

function Scene:onDestroyed()
    self._root:destroy()
end

return Scene
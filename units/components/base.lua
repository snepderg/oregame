local Object = require( "units.object" )

local BaseComponent = Object:subclass( "BaseComponent" )

----- STATIC METHODS -----

function BaseComponent:initialize()
    BaseComponent.super.initialize( self );

    local weak_table = {}
    weak_table.__mode = "v"
    self._weak = {}
    setmetatable( self._weak, weak_table )

    self._weak.gameObjectRef = nil
end

----- INSTANCE METHODS -----

function BaseComponent:getGameObject()
    return self._weak.gameObjectRef
end

----- OVERRIDABLE METHODS -----

-- Called when the component starts existing.
-- Use this to initialize internal component data.
function BaseComponent:setup()
    print( self .. "GameObject Setup" )
end

-- Called when all other components had their setup method called.
-- Use this to set up references with other components.
function BaseComponent:start()
    print( self .. "GameObject Ready" )
end

-- Called once every tick
function BaseComponent:update( deltaTime )
end

-- Called once after update and before render
function BaseComponent:onPreRender()
end

-- Called once after pre-render
function BaseComponent:onRender()
end

----- PRIVATE METHODS -----

function BaseComponent:_setGameObject( gameObject )
    self._weak.gameObjectRef = gameObject
end

return BaseComponent
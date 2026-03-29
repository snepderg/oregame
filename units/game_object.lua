local Destroyable = require( "classes.destroyable" )

local GameObject = Destroyable:subclass( "GameObject" )

----- STATIC METHODS -----

function GameObject:initialize()
    local weak_table = {}
    weak_table.__mode = "v"
    self._weak = {}
    setmetatable( self._weak, weak_table )

    self._children = {}
    self._ready = false
    self._weak._parent = nil
    self._weak._scene = nil
end

----- INSTANCE METHODS -----

function GameObject:getParent()
    return self._weak._parent
end

function GameObject:getChildren()
    return self._children
end

function GameObject:addChild( gameObject )
    gameObject:_setParent( self )
    gameObject:_setScene( self:getScene() )
    table.insert( self._children, gameObject )
end

function GameObject:removeChild( gameObject )
    --TODO: Replace with table extension table.removeByValue
    for i, child in ipairs( self._children ) do
        if gameObject == child then
            table.remove( self._children, i )
            child:_setParent( nil )
            self._setScene( nil )
        end
    end
end

function GameObject:getScene()
    return self._weak._scene
end

----- OVERRIDABLE METHODS -----

-- Called when this GameObject enters a scene tree
function GameObject:enterScene( newScene )
    print( self .. "Entered Scene" )
end

-- Called when this GameObject leaves a scene tree
function GameObject:exitScene( newScene )
    print( self .. "Exited Scene" )
end

-- Called once all children GameObjects are ready
function GameObject:ready()
    print( self .. "GameObject Ready" )
end

-- Called by the scene in depth first order at a fixed interval on all GameObjects
function GameObject:tickUpdate( deltaTime )
    --print( self .. "Tick" )
end

-- Called by the scene in depth first order on all GameObjects before drawing the frame
function GameObject:frameUpdate( deltaTime )
    --print( self .. "Draw" )
end

----- IMPLEMENTED METHODS -----

function GameObject:onDestroyed()
    local children = self._children

    for i, v in ipairs( children ) do
        children[i] = nil

        if isValid( v ) then
            v:destroy()
        end
    end
end

----- PRIVATE METHODS -----

function GameObject:_setScene( newScene )
    local children = self:getChildren()

    if self._weak._scene ~= nil then
        self:exitScene( self._weak._scene )
        for _, child in ipairs( children ) do
            child:_setScene( newScene )
        end
    end

    self._weak._scene = newScene

    if newScene ~= nil then
        self:enterScene( newScene )
        for _, child in ipairs( children ) do
            child:_setScene( newScene )
        end
        if self:getScene():hasStarted() == true and self._ready == false then
            self._ready = true
            self:ready()
        end
    end
end

function GameObject:_setParent( newParent )
    self._weak._parent = newParent
end

return GameObject
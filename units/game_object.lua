local Object = require( "units.object" )
local Transform = require( "units.components.transform" )

local GameObject = Object:subclass( "GameObject" )

----- STATIC METHODS -----

function GameObject:initialize( scene )
    GameObject.super.initialize( self );

    self._scene = scene

    self._components = {}

    self:addComponent( Transform() )
end

----- INSTANCE METHODS -----

function GameObject:getScene()
    return self._scene
end

function GameObject:addComponent( component )
    component:_setGameObject( self )
    self._components[component.name] = component

    if self._scene ~= nil then
        self._scene:_addWeakRefToComponentList( component )
    end
end

function GameObject:getComponent( name )
    return self._components[name]
end

----- PRIVATE METHODS -----

return GameObject
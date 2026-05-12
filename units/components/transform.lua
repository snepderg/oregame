local BaseComponent = require( "units.components.base" )
local Vector2 = require( "units.vector2" )

local Transform = BaseComponent:subclass( "Transform" )

----- STATIC METHODS -----

function Transform:initialize()
    Transform.super.initialize( self );

    self._children = {}
    self._weak._parent = nil

    self.zIndex = 0
    self.position = Vector2( 0, 0 )
    self.rotation = 0
    self.scale = Vector2( 1, 1 )
end

----- INSTANCE METHODS -----

function Transform:getParent()
    return self._weak._parent
end

function Transform:setParent( newParent )
    local oldParent = self._weak._parent
    if ( oldParent ~= nil ) then
        for i = 1, oldParent:getChildCount() do
            local child = oldParent:getChild( i )
            if child.name == self.name then
                self._children[i] = self._children[#self._children]
                self._children[#self._children] = nil
            end
        end
    end

    table.insert( newParent._children, self )
    self._weak._parent = newParent

end

function Transform:findChild( name )
    for i = 1, self:getChildCount() do
        local child = self:getChild( i )
        if child.name == name then
            return child
        end
    end
end

function Transform:getChild( index )
    return self._children[index]
end

function Transform:getChildCount()
    return #self._children
end

----- IMPLEMENTED METHODS -----

function Transform:onDestroyed()
    local children = self._children

    for i, child in ipairs( children ) do
        children[i] = nil
        if isValid( child ) then
            child:destroy()
        end
    end
end

----- PRIVATE METHODS -----

return Transform
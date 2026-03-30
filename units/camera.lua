local GameObject2D = require( "units.game_object_2d" )
local Vector2 = require( "units.vector2" )

local Camera = GameObject2D:subclass( "Camera" )

----- STATIC METHODS -----

function Camera:initialize()
    Camera.super.initialize( self )

    self._zoom = Vector2( 1, 1 )
    self._viewProjection = love.math.newTransform( -self._position.x, -self._position.y, -self._rotation, 1 / self._zoom.x, 1 / self._zoom.y )
end

----- INSTANCE METHODS -----

function Camera:isCurrent()
    return self:getScene()._activeCamera == self
end

function Camera:makeCurrent()
    self:getScene()._activeCamera = self
end

function Camera:setZoom( newZoom )
    self._zoom = newZoom
    self._viewProjection:setTransformation( -self._position.x, -self._position.y, -self._rotation, 1 / self._zoom.x, 1 / self._zoom.y )
end

function Camera:getZoom()
    return self._zoom
end

function Camera:getViewProjection()
    return self._viewProjection
end

----- IMPLEMENTED METHODS -----

function Camera:setPosition( newPosition )
    Camera.super.setPosition( self, newPosition )
    self._viewProjection:setTransformation( -self._position.x, -self._position.y, -self._rotation, 1 / self._zoom.x, 1 / self._zoom.y )
end

function Camera:setRotation( newRotation )
    Camera.super.setRotation( self, newRotation )
    self._viewProjection:setTransformation( -self._position.x, -self._position.y, -self._rotation, 1 / self._zoom.x, 1 / self._zoom.y )
end

return Camera
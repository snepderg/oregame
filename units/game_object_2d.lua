local GameObject = require( "units.game_object" )
local Vector2 = require( "units.vector2" )

local GameObject2D = GameObject:subclass( "GameObject2D" )


----- STATIC METHODS -----

function GameObject2D:initialize()
    GameObject2D.super.initialize( self )

    self._position = Vector2( 0, 0 )
    self._rotation = 0
    self._scale = Vector2( 1, 1 )

    self._modelProjection = love.math.newTransform( self._position.x, self._position.y, self._rotation, self._scale.x, self._scale.y )
end

----- INSTANCE METHODS -----

function GameObject2D:setPosition( newPosition )
    self._position = newPosition
    self._modelProjection:setTransformation( self._position.x, self._position.y, self._rotation, self._scale.x, self._scale.y )
    
end

function GameObject2D:getPosition()
    return self._position
end

function GameObject2D:setRotation( newRotation )
    self._position = newRotation
    self._modelProjection:setTransformation( self._position.x, self._position.y, self._rotation, self._scale.x, self._scale.y )
end

function GameObject2D:getRotation()
    return self._rotation
end

function GameObject2D:setScale( newScale )
    self._position = newScale
    self._modelProjection:setTransformation( self._position.x, self._position.y, self._rotation, self._scale.x, self._scale.y )
end

function GameObject2D:getScale()
    return self._scale
end

function GameObject2D:getModelProjection()
    return self._modelProjection
end

function GameObject2D:frameUpdate()
    --love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.points( self:getPosition().x, self:getPosition().y )
end


return GameObject2D
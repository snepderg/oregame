local Destroyable = require( "classes.destroyable" )
local GameObject = require( "units.game_object" )
local GameObject2D = require( "units.game_object_2d" )
local Camera = require( "units.camera" )

local Scene = Destroyable:subclass( "Scene" )


----- STATIC METHODS -----

function Scene:initialize()
    self._root = GameObject()
    self._root:_setScene( self )
    self._started = false
    self._activeCamera = nil
end

----- INSTANCE METHODS -----

function Scene:start()
    self._started = true

    -- Scenes require a camera to render objects, so if an active camera isn't present in the scene, we create one.
    if self._activeCamera == nil then
        local camera = Camera()
        self._root:addChild( camera )
        camera:makeCurrent()
    end

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

function Scene:getCurrentCamera()
    return self._activeCamera
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
    -- Setup
    if self._activeCamera == nil then return end

    local screenProjection = love.math.newTransform()
    screenProjection:scale( 1, -1 )
    screenProjection:translate( love.graphics.getWidth() / 2, -love.graphics.getHeight() / 2 )
    -- Screen Space

    -- View Space
    love.graphics.push()
    love.graphics.applyTransform( screenProjection )

    -- World Space
    love.graphics.push()
    love.graphics.applyTransform( self._activeCamera:getViewProjection() )

    local function drawObjects( gameObject )
        gameObject:frameUpdate( deltaTime )

        -- Local Space
        love.graphics.push()
        if gameObject:isInstanceOf( GameObject2D ) then
            love.graphics.applyTransform( gameObject:getModelProjection() )
        end

        local children = gameObject:getChildren()
        for _, child in ipairs( children ) do
            drawObjects( child )
        end
        love.graphics.pop()
    end
    drawObjects( self._root )

    love.graphics.pop()
    love.graphics.pop()
end

----- IMPLEMENTED METHODS -----

function Scene:onDestroyed()
    self._root:destroy()
end

return Scene
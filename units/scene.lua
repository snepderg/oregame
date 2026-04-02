local Destroyable = require( "classes.destroyable" )
local GameObject = require( "units.game_object" )
local GameObject2D = require( "units.game_object_2d" )
local Camera = require( "units.camera" )

local utils = require( "lib.utils" )


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

    -- Because our world coordinate system represents up as +y instead of -y,
    -- we use a shader to remap UVs as bottom-left origin instead of top-left origin so that textures are read in the correct orientation.
    local pixelcode = [[
    vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
    {
        vec2 bl_texture_coords = vec2(texture_coords.x, -texture_coords.y + 1);
        vec4 texcolor = Texel(tex, bl_texture_coords);
        return texcolor * color;
    }
    ]]

    local vertexcode = [[
    vec4 position( mat4 transform_projection, vec4 vertex_position )
    {
        return transform_projection * vertex_position;
    }
    ]]

    local shader = love.graphics.newShader( pixelcode, vertexcode )
    love.graphics.setShader( shader )
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

    local function updateObjects( gameObject )
        gameObject:frameUpdate( deltaTime )

        local children = gameObject:getChildren()
        for _, child in ipairs( children ) do
            updateObjects( child )
        end
    end
    updateObjects( self._root )

    -- Screen Space

    -- View Space
    love.graphics.push()
    local screenProjection = love.math.newTransform()
    screenProjection:translate( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 )
    screenProjection:scale( 1, -1 )
    love.graphics.applyTransform( screenProjection )

    -- World Space
    love.graphics.push()
    love.graphics.applyTransform( self._activeCamera:getViewProjection() )

    local unsortedDrawQueue = {}
    local zOccurances = {}

    local function collectDraws( gameObject )

        local function resolveGlobalTransform( target )
            local parent = target:getParent()
            local stackedTransform
            if parent ~= nil then
                stackedTransform = resolveGlobalTransform( parent )
            else
                stackedTransform = love.math.newTransform()
            end

            local localTransform
            if target:isInstanceOf( "GameObject2D" ) then
                localTransform = target:getModelProjection()
            else
                localTransform = love.math.newTransform()
            end

            return stackedTransform:apply( localTransform )
        end

        local zIndex = gameObject.zIndex or 0
        table.insert( unsortedDrawQueue, {
            call = utils.bind( gameObject.draw, gameObject ),
            zIndex = zIndex,
            transform = resolveGlobalTransform( gameObject )
        } )
        if zOccurances[zIndex] == nil then
            zOccurances[zIndex] = 0
        end
        zOccurances[zIndex] = zOccurances[zIndex] + 1

        local children = gameObject:getChildren()
        for _, child in ipairs( children ) do
            collectDraws( child )
        end
    end
    collectDraws( self._root )

    local zLookup = {}
    local zLookupInverse = {}
    do
        local currentIndex = 1
        for k in pairs( zOccurances ) do
            zLookup[currentIndex] = k
            zLookupInverse[k] = currentIndex
            currentIndex = currentIndex + 1
        end
    end
    table.sort( zLookup )

    local drawStartIndices = {}
    do
        local currentIndex = 1
        for i in ipairs( zLookup ) do
            local size = zOccurances[zLookup[i]]
            table.insert( drawStartIndices, currentIndex )
            currentIndex = currentIndex + size
        end
    end

    local drawQueue = {}

    do
        local indexOffsets = {}
        for i = 1, #drawStartIndices do
            indexOffsets[i] = 0
        end
        for _, draw in pairs( unsortedDrawQueue ) do
            local denseIndex = zLookupInverse[draw.zIndex]
            drawQueue[drawStartIndices[denseIndex] + indexOffsets[denseIndex]] = draw
            indexOffsets[denseIndex] = indexOffsets[denseIndex] + 1
        end
    end

    for _, draw in ipairs( drawQueue ) do
        love.graphics.push()
        love.graphics.applyTransform( draw.transform )
        draw.call()
        love.graphics.pop()
    end

    love.graphics.pop()
    love.graphics.pop()
end

----- IMPLEMENTED METHODS -----

function Scene:onDestroyed()
    love.graphics.setShader()
    self._root:destroy()
end

return Scene
local Destroyable = require( "classes.destroyable" )
local GameObject = require( "units.game_object" )

local Scene = Destroyable:subclass( "Scene" )


----- STATIC METHODS -----

function Scene:initialize()
    Scene.super.initialize( self );

    self._roots = {}
    self._loaded = false
    self._componentRefList = {}
end

----- INSTANCE METHODS -----

function Scene:getRootGameObjects()
    return self._roots
end

function Scene:isLoaded()
    return self._loaded
end

function Scene:load()

    --- TODO: MOVE TO RENDERER SUBSYSTEM
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
    ---

    self._loaded = true
end

function Scene:update( deltaTime )
    print( self._componentRefList )
end


----- IMPLEMENTED METHODS -----

function Scene:onDestroyed()
    love.graphics.setShader()
    for _, object in ipairs( self._roots ) do
        object:destroy()
    end
end

----- PRIVATE METHODS -----

function Scene:_addWeakRefToComponentList( componentRef )
    if ( self._componentRefList[componentRef.name] == nil ) then
        local weak_table = {}
        weak_table.__mode = "v"

        self._componentRefList[componentRef.name] = {}
        setmetatable( self._componentRefList[componentRef.name], weak_table )
    end

    local gameObjectID = componentRef:getGameObject():getInstanceID()

    self._componentRefList[componentRef.name][gameObjectID] = componentRef
end

return Scene
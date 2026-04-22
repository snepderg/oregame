require( "lib.math" )

local json = require( "external.json" )
local tick = require( "external.tick" )

local Vector2 = require( "units.vector2" )

local Conveyor = require( "units.conveyor" )
local Upgrader = require( "units.upgrader" )
local Ore = require( "units.ore" )

local TileGrid = require( "units.tile_grid" )
local Scene = require( "units.scene" )
local GameObject = require( "units.game_object" )
local Camera = require( "units.camera" )

love.graphics.setDefaultFilter( "nearest", "nearest" ) -- Move to renderer

SCREEN_WIDTH = love.graphics.getWidth()

local COLOR_WHITE = { 1, 1, 1, 1 }
local COLOR_RED = { 1, 0, 0, 1 }
local COLOR_ORANGE = { 0.5, 0.75, 0, 1 }
local COLOR_ORE = { 1, 0.75, 0, 1 }

local COLOR_BEAM = { 0, 1, 1, 0.3 }

local ores = {} -- TODO: Have a static table tracking ores and tie it to :initialize() and :onDestroyed(). Should it be done in Ore or a base class?

local upgraderTag = { name = "upgrader_tier1", upgradeCount = 0, maxUses = 1 }

local upgrader = Upgrader( Vector2( 0, 0 ), upgraderTag, nil, function( ore )
    ore.value = ore.value * 2
end )

local makeOre

local worldScene = Scene()
local camera = Camera()
worldScene:getRoot():addChild( upgrader )
worldScene:getRoot():addChild( camera )
camera:makeCurrent()

function love.load()
    worldScene:start()
end

makeOre = function()
    local speed = 50

    local ore = Ore()
    ore.size = Vector2( 20, 20 )
    ore.velocity = Vector2( speed, 0 )
    ore.color = COLOR_ORANGE
    ore.value = 5

    ore:setPosition( Vector2( 0, 0 ) )

    worldScene:getRoot():addChild( ore )

    ore.timeSinceLastUpgrade = os.time() -- FIXME: Band-aid fix for frame debounce
    ore.upgradeDebounceTime = 1

    table.insert( ores, ore )
    print( #ores )
end

function love.keypressed( key )
    if key == "space" then
        makeOre()
    end
end

--[[
function love.update( dt )

    local speed = 100
    if love.keyboard.isDown( "w" ) then
        camera:setPosition( camera:getPosition() + Vector2( 0, speed * dt ) )
    end
    if love.keyboard.isDown( "a" ) then
        camera:setPosition( camera:getPosition() + Vector2( -speed * dt, 0 ) )
    end
    if love.keyboard.isDown( "s" ) then
        camera:setPosition( camera:getPosition() + Vector2( 0, -speed * dt ) )
    end
    if love.keyboard.isDown( "d" ) then
        camera:setPosition( camera:getPosition() + Vector2( speed * dt, 0 ) )
    end

    worldScene:tickUpdate()

    if #ores == 0 then return end

    for i, ore in ipairs( ores ) do
        ore:update( dt )
        if ore._position.x > SCREEN_WIDTH then
            table.remove( ores, i ) -- FIXME: Garbage collection
            goto nextOre
        end

        if not upgrader:checkCollision( ore, upgrader.beam ) then goto nextOre end
        if os.time() - ore.timeSinceLastUpgrade <= ore.upgradeDebounceTime then goto nextOre end

        ore.timeSinceLastUpgrade = os.time()

        local oreValue = ore.value

        local tagName = upgraderTag.name
        local tagMaxUses = upgraderTag.maxUses

        if not ore.tags[tagName] then
            ore.tags[tagName] = upgraderTag
        end

        if ore.tags[tagName].upgradeCount <= tagMaxUses then
            upgrader.callback( ore )
            ore.tags[tagName].upgradeCount = math.clamp( ore.tags[tagName].upgradeCount + 1, 0, tagMaxUses )
            table.insert( ore.upgradeHistory, tagName )

            print( "(" .. tostring( ore ) .. ") Upgraded value from " .. oreValue .. " to " .. ore.value )

            local alpha = 0.5 -- lerp intensity
            ore.color = {
                ( 1 - alpha ) * ore.color[1] + alpha * COLOR_BEAM[1],
                ( 1 - alpha ) * ore.color[2] + alpha * COLOR_BEAM[2],
                ( 1 - alpha ) * ore.color[3] + alpha * COLOR_BEAM[3],
                --( 1 - alpha ) * ore.color[4] + alpha * COLOR_BEAM[4]
            }
        else
            print( "(" .. tostring( ore ) .. ") Failed upgrade" )
            ore.color = COLOR_RED

            goto nextOre
        end

        ::nextOre::
    end
end


function love.draw()
    worldScene:frameUpdate()
end
]]
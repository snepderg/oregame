require( "lib.math" )

local json = require( "external.json" )
local tick = require( "external.tick" )
local _ = require( "units.debug" )

local Vector2 = require( "units.vector2" )

local Conveyor = require( "units.conveyor" )
local Upgrader = require( "units.upgrader" )
local Ore = require( "units.ore" )

local TileGrid = require( "units.tile_grid" )
local Scene = require( "units.scene" )
local GameObject = require( "units.game_object" )

SCREEN_WIDTH = love.graphics.getWidth()

local COLOR_WHITE = { 1, 1, 1, 1 }
local COLOR_RED = { 1, 0, 0, 1 }
local COLOR_ORANGE = { 0.5, 0.75, 0, 1 }
local COLOR_ORE = { 1, 0.75, 0, 1 }

local COLOR_BEAM = { 0, 1, 1, 0.3 }

local ores = {} -- TODO: Have a static table tracking ores and tie it to :initialize() and :onDestroyed(). Should it be done in Ore or a base class?

local upgrader
local upgraderBeam

local makeOre

local worldScene = Scene()

worldScene:getRoot():addChild( GameObject() )

-- #FIXME: Move to utility library
local function clamp( val, min, max )
    return math.max( min, math.min( max, val ) )
end

function love.load()
    love.graphics.setDefaultFilter( "nearest", "nearest" )

    local upgraderPos = Vector2( 200, 200 )
    local upgraderTag = { name = "upgrader_tier1", upgradeCount = 0, maxUses = 1 }

    upgrader = Upgrader( upgraderPos, upgraderTag, nil, function( ore )
        ore.value = ore.value * 2
    end )

    upgraderBeam = upgrader.beam

    tick.recur( function()
        makeOre()
    end, 0.5 )

    worldScene:start()
end

makeOre = function()
    local pos = Vector2( 100, 190 + upgrader.size.y / 2 )
    local size = Vector2( 20, 20 )
    local speed = 50
    local vel = Vector2( speed, 0 )
    local color = COLOR_ORANGE

    local value = 5
    local ore = Ore( pos, size, vel, color, value )

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

function love.update( dt )
    worldScene:tickUpdate()

    tick.update( dt )

    if #ores == 0 then return end

    for i, ore in ipairs( ores ) do
        ore:update( dt )
        if ore.pos.x > SCREEN_WIDTH then
            table.remove( ores, i ) -- FIXME: Garbage collection
            goto nextOre
        end

        if not upgrader:checkCollision( ore, upgraderBeam ) then goto nextOre end
        if os.time() - ore.timeSinceLastUpgrade <= ore.upgradeDebounceTime then goto nextOre end

        ore.timeSinceLastUpgrade = os.time()

        local oreValue = ore.value

        local upgraderTag = upgrader.tag

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

    upgrader:draw()

    for _, ore in ipairs( ores ) do
        ore:draw()
    end
end
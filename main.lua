--! file: main.lua

local json = require( "external.json" )

local _ = require( "units.debug" )
local Vector2 = require( "units.vector2" )
local TileGrid = require( "units.tile_grid" )
local Ore = require( "units.ore" )
local Upgrader = require( "units.upgrader" )
local Conveyor = require( "units.conveyor" )

local COLOR_WHITE = { 1, 1, 1, 1 }
local COLOR_RED = { 1, 0, 0, 1 }
local COLOR_ORANGE = { 0.5, 0.75, 0, 1 }
local COLOR_ORE = { 1, 0.75, 0, 1 }

local COLOR_BEAM = { 0, 1, 1, 0.3 }

local ores = {}

local upgrader

function love.load()
    love.graphics.setDefaultFilter( "nearest", "nearest" )

    local upgraderPos = Vector2( 200, 200 )
    local upgraderTag = { name = "upgrader_tier1", upgradeCount = 0, maxUses = 1 }

    upgrader = Upgrader( upgraderPos, upgraderTag, nil, function( ore )
        ore.value = ore.value * 2
    end )
end

local function makeOre()
    local pos = Vector2( 100, 190 + upgrader.size.y / 2 )
    local size = Vector2( 20, 20 )
    local speed = 50
    local vel = Vector2( speed, 0 )
    local color = COLOR_ORANGE

    local value = 5
    local ore = Ore( pos, size, vel, color, value )
    table.insert( ores, ore )
end

function love.keypressed( key )
    if key == "space" then
        makeOre()
    end
end

function love.update( dt )
    for _, ore in ipairs( ores ) do
        ore:update( dt )

        local upgraderTag = upgrader.tag
        local oreTags = ore.tags

        local tagOnOre = oreTags[upgraderTag]

        if not tagOnOre or tagOnOre["upgradeCount"] >= tagOnOre["maxUses"] then
            print( "(" .. tostring( ore ) .. ") Failed upgrade" )
            ore.color = COLOR_RED

        else
            upgrader.callback( ore )
            print( "(" .. tostring( ore ) .. ") Value updated to " .. ore.value )

            local alpha = 0.01
            ore.color = {
                ( 1 - alpha ) * ore.color[1] + alpha * COLOR_BEAM[1],
                ( 1 - alpha ) * ore.color[2] + alpha * COLOR_BEAM[2],
                ( 1 - alpha ) * ore.color[3] + alpha * COLOR_BEAM[3],
                ( 1 - alpha ) * ore.color[4] + alpha * COLOR_BEAM[4]
            }
        end
    end
end

function love.draw()
    upgrader:draw()

    for _, ore in ipairs( ores ) do
        ore:draw()
    end
end
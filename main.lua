--! file: main.lua

local _ = require( "units.debug" )
local Vector2 = require( "units.vector2" )
local TileGrid = require( "units.tile_grid" )
local Ore = require( "units.ore" )
local Upgrader = require( "units.upgrader" )
local Conveyor = require( "units.conveyor" )
local UpgraderBeam = require( "units.upgrader_beam" )

local UPGRADER_PIXEL_OFFSET = 2 -- The texture is offset by 2 pixels.

local COLOR_WHITE = { 1, 1, 1, 1 }
local COLOR_ORE_ORANGE = { 0.5, 0.75, 0, 1 }
local COLOR_ORE = { 1, 0.75, 0, 1 }
local COLOR_BEAM = { 0, 1, 1, 0.3 }

local ores = {}

local upgrader
local beam

function love.load()

    love.graphics.setDefaultFilter( "nearest", "nearest" )

    --[[
    upgrader.x = 200
    upgrader.y = 200
    upgrader.size = 4
    upgrader.image = love.graphics.newImage( "res/upgrader.png" )
    upgrader.width = upgrader.image:getWidth() * upgrader.size
    upgrader.height = upgrader.image:getHeight() * upgrader.size
    upgrader.beam = beam
    ]]

    local upgraderPos = Vector2( 200, 200 )
    local upgraderSize = Vector2( 4, 4 )
    local upgraderTag = { "upgrader_tier1", 1 } -- Ore: { upgrader_tier1 = { current, max } }
    
    upgrader = Upgrader( upgraderPos, upgraderSize, upgraderTag )
    
    beam = UpgraderBeam(
        Vector2( upgrader.x + ( upgrader.width / 2 ) - upgrader.size * 2, upgrader.y + upgrader.size * UPGRADER_PIXEL_OFFSET ),
        Vector2( upgrader.size * 4, upgrader.height - upgrader.size * 4 ),
        function( ore )
            return ore.value * 2
        end
    )

    print( beam.width )
end

local function makeOre()
    local pos = Vector2( 100, 190 + upgrader.height / 2 )
    local size = Vector2( 20, 20 )
    local speed = 50
    local vel = Vector2( speed, 0 )
    local color = COLOR_ORE_ORANGE
    
    local value = 5
    local ore = Ore( pos, size, vel, color, value )
    table.insert( ores, ore )
end

function love.keypressed( key )
    if key == "space" then
        makeOre()
    end
end

local function checkCollisions( a, b )

    local aLeft = a.pos.x
    local aRight = a.pos.x + a.size.x
    local aTop = a.pos.y
    local aBottom = a.pos.y + a.size.y

    local bLeft = b.pos.x
    local bRight = b.pos.x + b.size.x
    local bTop = b.pos.y
    local bBottom = b.pos.y + b.size.y
    
    return aRight > bLeft
        and aLeft < bRight
        and aBottom > bTop
        and aTop < bBottom
end

function love.update( dt )
    for _, ore in ipairs( ores ) do
        ore:update( dt )

        if checkCollisions( ore, beam ) then
            --ore.color = COLOR_BEAM
            
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

    love.graphics.draw( upgrader.image, upgrader.x, upgrader.y, nil, upgrader.size, upgrader.size )

    for _, ore in ipairs( ores ) do
        ore:draw()
    end

    beam:draw()
end
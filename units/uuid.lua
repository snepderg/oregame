--[[
    This file is a collection of functions for creating UUIDs. Following https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-4 as a reference.
]]

local UUID = {}

function UUID.new()
    math.randomseed( os.time() )
    local hex = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F" }
    local uuid = ""

    for _ = 1, 8 do
        uuid = uuid .. hex[math.random( 16 )]
    end

    uuid = uuid .. "-"

    for _ = 1, 4 do
        uuid = uuid .. hex[math.random( 16 )]
    end

    uuid = uuid .. "-4" -- Version Field

    for _ = 1, 3 do
        uuid = uuid .. hex[math.random( 16 )]
    end

    uuid = uuid .. "-8" -- Variant Field

    for _ = 1, 3 do
        uuid = uuid .. hex[math.random( 16 )]
    end

    uuid = uuid .. "-"

    for _ = 1, 12 do
        uuid = uuid .. hex[math.random( 16 )]
    end

    return uuid
end

function UUID.null()
    return "00000000-0000-0000-0000-000000000000"
end

return UUID
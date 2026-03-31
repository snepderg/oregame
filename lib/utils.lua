local utils = {}

local IS_TABLE_LOOKUP = { ["table"] = true }
local IS_FUNCTION_LOOKUP = { ["function"] = true }

local type = type -- localize for SPEED


----- LIBRARY FUNCTIONS -----

--- Checks if a value is a table, much faster than doing type() == "table".
--- Even faster if you localize this function.
-- @param any x The value to check.
-- @return boolean Whether x is a table or not.
function utils.isTable( x )
    return IS_TABLE_LOOKUP[type( x )] == true
end

--- Checks if a value is a function, much faster than doing type() == "function".
--- Even faster if you localize this function.
-- @param any x The value to check.
-- @return boolean Whether x is a function or not.
function utils.isFunction( x )
    return IS_FUNCTION_LOOKUP[type( x )] == true
end

function utils.bind( func, ... )
    local boundArgs = { ... }
    return function( ... )
        local totalArgs = { unpack( boundArgs ) }
        for i = 1, select( "#", ... ) do
            table.insert( totalArgs, select( i, ... ) )
        end
        return func( unpack( totalArgs ) )
    end
end

return utils

io.stdout:setvbuf( "no" )

if arg[2] == "debug" then
    require( "lldebugger" ).start()
end

local default_errorhandler = love.errorhandler or love.errhand

function love.errorhandler( msg )
    if lldebugger then
        error( msg, 2 )
    else
        return default_errorhandler( msg )
    end
end

return lldebugger

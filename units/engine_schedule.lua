local Scene = require( "units.scene" )

ActiveScene = Scene()

function love.run()
    if love.load then love.load( love.arg.parseGameArguments(arg), arg ) end

    if love.timer then
        love.timer.step()
    else
        -- If timer doesn't exist, we cannot run the game.
        love.event.quit( 1 )
    end

    local dt = 0

    -- Main loop time.
    return function()
        -- Process events.
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" and not love.quit or not love.quit() then
                    return a or 0
                end
            end
        end

        dt = love.timer.step()

        -- Call update and draw
        ActiveScene:tickUpdate( dt )

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear( love.graphics.getBackgroundColor() )

            ActiveScene:frameUpdate( dt )

            love.graphics.present()
        end

        if love.timer then love.timer.sleep( 0.001 ) end
    end
end
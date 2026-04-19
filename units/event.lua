local middleclass = require( "external.middleclass.middleclass" )

local EventEmitter = middleclass.class( "EventEmitter" )

----- STATIC METHODS -----

function EventEmitter:initialize()
    self.eventTable = {}
end


----- INSTANCE METHODS -----

function EventEmitter:on( eventName, listener )
    if self.eventTable[eventName] == nil then
        self.eventTable[eventName] = {}
    end
    table.insert( self.eventTable[eventName], listener )
end

function EventEmitter:off( eventName, listener )
    local listenerArray = self.eventTable[eventName]
    if listenerArray == nil then
        return
    end

    for i = #listenerArray, 1, -1 do
        if listenerArray[i] == listener then
            table.remove( listenerArray, i )
        end
    end
end

function EventEmitter:emit( eventName, ... )
    local listenerArray = self.eventTable[eventName]
    for _, listener in ipairs( listenerArray ) do
        listener( ... )
    end
end

return EventEmitter

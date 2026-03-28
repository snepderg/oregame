--[[
    - A super simple class that handles :isValid() and :destroy()
    - Also calls :onDestroyed() right before destruction completes, which is for subclasses to implement.
--]]


local StandardPrintable = require( "classes.standard_printable" )
local utils = require( "lib.utils" )

local Destroyable = StandardPrintable:subclass( "Destroyable" )

local UNREMOVABLE_METHODS = {
    __tostring = true,
    isInstanceOf = true,
    isValid = true,
    toStringInner = true,
}

local isTable = utils.isTable
local isFunction = utils.isFunction

local destroyedFunc


----- GLOBAL FUNCTIONS -----

--- An isValid check that safeguards against non-table values.
-- @param any obj The object to check.
-- @return boolean Whether the object is valid or not.
function isValid( obj )
    if not isTable( obj ) then return false end

    local check = obj.isValid
    if not isFunction( isValid ) then return false end

    return check( obj )
end


----- INSTANCE METHODS -----

--- Returns whether the object is valid.
-- @return boolean Whether the object is valid or not.
function Destroyable:isValid()
    return true
end

--- Destroys the object, marking it as invalid and disabling (nearly) every instance method.
--- Calls :onDestroyed() before invalidating the object.
function Destroyable:destroy()
    self:onDestroyed()

    for name in pairs( self.class.__declaredMethods ) do
        if not UNREMOVABLE_METHODS[name] then
            self[name] = destroyedFunc
        end
    end

    function self:isValid()
        return false
    end
end


----- OVERRIDABLE METHODS -----

--- Called when the object is destroyed.
--- When implementing subclasses, it is recommended to call super.onDestroyed() AFTER your implementation, not before.
function Destroyable:onDestroyed()
end


----- LOCAL FUNCTIONS -----

destroyedFunc = function( obj )
    error( "Invalid " .. obj.class.name )
end


return Destroyable

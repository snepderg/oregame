--[[
    - Standardizes :__tostring() to give the class name and address.
        - Style is loosely based off of how GMod prints entities.
        - If the class has :isValid(), it will also add text to indicate the object is invalid, if it is.
        - Examples:
            - Panel[0xf2e83e22]
            - Panel(INVALID)[0xf2e83e22]
            - ColorScheme[Dark][0x1a2b3c4d]
    - Subclasses can implement :toStringInner() to add more information.
        - This will be skipped if the object is considered invalid.
        - Example setup:
            function MyClass:toStringInner()
                return self:getName()
            end
--]]


local middleclass = require( "external.middleclass.middleclass" )

local StandardPrintable = middleclass.class( "StandardPrintable" )


----- META METHODS -----

function StandardPrintable:__tostring()
    local valid = self.isValid == nil or self:isValid() -- Automatically considered valid if isValid() doesn't exist
    local toStringInner = valid and self:toStringInner() or ""
    local out = self.class.name

    if not valid then
        out = out .. "(INVALID)"
    end

    if toStringInner ~= "" then
        out = out .. "[" .. toStringInner .. "]"
    end

    return string.format( "%s[%p]", out, self ) -- Add table address
end

function StandardPrintable:__concat( other )
    return tostring( self ) .. tostring( other )
end


----- OVERRIDABLE METHODS -----

function StandardPrintable:toStringInner()
    return ""
end


return StandardPrintable

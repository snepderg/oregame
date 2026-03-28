local middleclass_extensions = {}


--- Injects meta methods into a middleclass object instance.
--- Intended for use with stuff like __add and __eq.
-- @param object instance A middleclass instance. Should be called in initialize.
-- @param table metaMethods The metamethods to apply.
function middleclass_extensions.injectMeta( instance, metaMethods )
    local meta = getmetatable( instance )

    for k, v in pairs( metaMethods ) do
        meta[k] = v
    end
end


return middleclass_extensions

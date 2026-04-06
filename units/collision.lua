local collision = {}

function collision.checkAABB( objA, objB )
    local aLeft = objA._position.x
    local aRight = objA._position.x + objA.size.x
    local aTop = objA._position.y
    local aBottom = objA._position.y + objA.size.y

    local bLeft = objB._position.x
    local bRight = objB._position.x + objB.size.x
    local bTop = objB._position.y
    local bBottom = objB._position.y + objB.size.y

    return aRight > bLeft
        and aLeft < bRight
        and aBottom > bTop
        and aTop < bBottom
end

return collision

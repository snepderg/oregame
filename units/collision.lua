local collision = {}

function collision.checkAABB( objA, objB )
    local aLeft = objA.pos.x
    local aRight = objA.pos.x + objA.size.x
    local aTop = objA.pos.y
    local aBottom = objA.pos.y + objA.size.y

    local bLeft = objB.pos.x
    local bRight = objB.pos.x + objB.size.x
    local bTop = objB.pos.y
    local bBottom = objB.pos.y + objB.size.y

    return aRight > bLeft
        and aLeft < bRight
        and aBottom > bTop
        and aTop < bBottom
end

return collision

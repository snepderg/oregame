local collision = {}

function collision.checkAABB( rectA, rectB )
    return (
        rectB.position.x < rectA.position.x + rectA.size.x and
        rectA.position.x < rectB.position.x + rectB.size.x and
        rectB.position.y < rectA.position.y + rectA.size.y and
        rectA.position.y < rectB.position.y + rectB.size.y
    )
end

return collision
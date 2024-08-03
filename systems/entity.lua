local g = require("global")

return {
    filter = { "sprite" },
    update = function(sprite)
        if (sprite.position - g.player.position):squareLength() < 0.25 then
            sprite:close(g.player)
        end
    end
}

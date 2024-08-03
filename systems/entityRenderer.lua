local g = require("global")

return {
    filter = { "level" },
    draw = function(level)
        local sprites = require("libraries.world"):findEntities({ "sprite" })
        table.sort(sprites, function(a, b)
            return (a.position - g.player.position):squareLength() > (b.position - g.player.position):squareLength()
        end)
        for _, sprite in pairs(sprites) do
            local relative = sprite.position - g.player.position
            local distance = relative:length()
            if distance < 0.5 then
                goto continue
            end
            local eyeX = math.cos(g.player.angle)
            local eyeY = math.sin(g.player.angle)
            local objectAngle = math.atan2(-eyeY, eyeX) - math.atan2(-relative.y, relative.x)
            while objectAngle < -math.pi do
                objectAngle = objectAngle + math.pi * 2
            end
            while objectAngle > math.pi do
                objectAngle = objectAngle - math.pi * 2
            end

            local top = g.screenHeight / 2 - (g.wallHeight / distance) * sprite.scale
            local bottom = g.screenHeight - top

            local height = bottom - top
            local aspectRatio = sprite.texture:getHeight() / sprite.texture:getWidth()
            local width = height / aspectRatio

            local middle = (0.5 * (objectAngle / (g.fov / 2)) + 0.5) * g.screenWidth

            love.graphics.setColor(1, 1, 1)
            for x = 0, width - 1 do
                for y = 0, height - 1 do
                    local dx = x / width
                    local dy = y / height
                    local red, green, blue, alpha =
                        sprite.texture:getPixel(dx * sprite.texture:getWidth(), dy * sprite.texture:getHeight())
                    local column = math.floor(middle + x - width / 2)
                    if column >= 0 and column < g.screenWidth then
                        if level.depthBuffer[column] > distance then
                            love.graphics.setColor(red, green, blue, alpha)
                            love.graphics.rectangle(
                                "fill",
                                column,
                                top + y + (g.wallHeight / distance) * sprite.verticalOffset,
                                1,
                                1
                            )
                        end
                    end
                end
            end
            ::continue::
        end
    end,
}

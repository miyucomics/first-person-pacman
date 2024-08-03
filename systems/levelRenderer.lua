local Colors = require("libraries.colors")
local Vector = require("libraries.vector")
local g = require("global")

return {
    filter = { "level" },
    draw = function(level)
        love.graphics.setColor(Colors.Black)
        for x = 0, g.screenWidth - 1, 1 do
            local progress = x / (g.screenWidth - 1) - 0.5
            local angleOffset = g.fov * progress
            local rayAngle = g.player.angle + angleOffset

            local rayDir = Vector(math.cos(rayAngle), math.sin(rayAngle))
            local rayUnit = Vector(math.abs(1 / rayDir.x), math.abs(1 / rayDir.y))
            local mapCheck = Vector(math.floor(g.player.position.x), math.floor(g.player.position.y))
            local rayLength = Vector(0, 0)
            local step = Vector(0, 0)

            if rayDir.x < 0 then
                step.x = -1
                rayLength.x = (g.player.position.x - mapCheck.x) * rayUnit.x
            else
                step.x = 1
                rayLength.x = (mapCheck.x + 1 - g.player.position.x) * rayUnit.x
            end
            if rayDir.y < 0 then
                step.y = -1
                rayLength.y = (g.player.position.y - mapCheck.y) * rayUnit.y
            else
                step.y = 1
                rayLength.y = (mapCheck.y + 1 - g.player.position.y) * rayUnit.y
            end

            local distance = 0
            local horizontal = false
            while true do
                horizontal = rayLength.x < rayLength.y
                if horizontal then
                    mapCheck.x = mapCheck.x + step.x
                    distance = rayLength.x
                    rayLength.x = rayLength.x + rayUnit.x
                else
                    mapCheck.y = mapCheck.y + step.y
                    distance = rayLength.y
                    rayLength.y = rayLength.y + rayUnit.y
                end
                if level:isSolid(mapCheck.x, mapCheck.y) then
                    break
                end
            end

            level.depthBuffer[x] = distance

            local raFix = math.cos(angleOffset)
            distance = distance * raFix
            local height = g.wallHeight / distance
            local ceiling = (g.screenHeight / 2) - height
            love.graphics.setColor(Colors.White)
            if horizontal then
                love.graphics.setColor(Colors.Peach)
            end
            love.graphics.rectangle("fill", x, ceiling, 1, height * 2)

            -- for y = global.screenHeight - ceiling, global.screenHeight, 1 do
            --     local diagonalDistance = global.screenHeight / (y - global.screenHeight / 2) / raFix
            --     local tile = player.position + rayDir * diagonalDistance
            --     love.graphics.setColor(Colors.Overlay1)
            --     if (math.floor(tile.x) + math.floor(tile.y)) % 2 == 0 then
            --         love.graphics.setColor(Colors.Overlay2)
            --     end
            --     love.graphics.rectangle("fill", x, y, 1, 1)
            -- end
        end
    end,
}

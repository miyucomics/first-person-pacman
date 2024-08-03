local Colors = require("libraries.colors")
local Input = require("libraries.input")
local g = require("global")
local world = require("libraries.world")

local uiMovementSpeed = 2500

return {
    filter = {},
    d_update = function(_, dt)
        if Input:pressed("f") then
            g.uiActive = not g.uiActive
        end
        if g.uiActive then
            g.uiElevation = math.max(g.uiElevation - dt * uiMovementSpeed, g.uiY)
        else
            g.uiElevation = math.min(g.uiElevation + dt * uiMovementSpeed, love.graphics.getHeight())
        end
    end,
    d_draw = function()
        local postCanvas = love.graphics.getCanvas()
        love.graphics.setCanvas(g.uiCanvas)

        for x = 0, g.level.data:getWidth() - 1 do
            for y = 0, g.level.data:getHeight() - 1 do
                local r, _, _, _ = g.level.data:getPixel(x, y)
                if r == 1 then
                    love.graphics.setColor(Colors.White)
                    love.graphics.rectangle("fill", x * 16, y * 16, 16, 16)
                end
            end
        end
        love.graphics.setColor(1, 1, 1)
        for _, orb in pairs(world:findEntities({ "orb" })) do
            love.graphics.draw(orb.image, (orb.position.x - 0.5) * 16, (orb.position.y - 0.5) * 16)
        end
        for _, powerup in pairs(world:findEntities({ "powerup" })) do
            love.graphics.draw(powerup.image, (powerup.position.x - 0.5) * 16, (powerup.position.y - 0.5) * 16)
        end
        for _, ghost in pairs(g.ghosts) do
            love.graphics.draw(ghost.image, (ghost.position.x - 0.5) * 16, (ghost.position.y - 0.5) * 16)
        end
        love.graphics.setColor(Colors.Peach)
        local openness = math.sin(g.clock * 10) / 2 + 0.5
        love.graphics.arc("fill", g.player.position.x * 16, g.player.position.y * 16, 5, g.player.angle + (math.pi / 4) * openness, g.player.angle + math.pi * 2 - (1 / 4) * openness)

        love.graphics.setCanvas(postCanvas)
    end,
}

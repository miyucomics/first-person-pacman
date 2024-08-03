local Input = require("libraries.input")
local Vector = require("libraries.vector")
local g = require("global")

return {
    filter = { "player" },
    update = function(player, dt)
        local desired = Vector(0, 0)
        local cos = math.cos(player.angle)
        local sin = math.sin(player.angle)

        if Input:active("w") then
            desired = desired + Vector(cos, sin)
        end
        if Input:active("s") then
            desired = desired - Vector(cos, sin)
        end
        if Input:active("a") then
            desired = desired + Vector(sin, -cos)
        end
        if Input:active("d") then
            desired = desired + Vector(-sin, cos)
        end

        desired = desired:normalized()

        player.position.x = player.position.x + desired.x * dt * g.playerSpeed
        if g.level:isSolid(player.position.x, player.position.y) then
            player.position.x = player.position.x - desired.x * dt * g.playerSpeed
        end
        player.position.y = player.position.y + desired.y * dt * g.playerSpeed
        if g.level:isSolid(player.position.x, player.position.y) then
            player.position.y = player.position.y - desired.y * dt * g.playerSpeed
        end

        if Input:pressed("escape") then
            love.mouse.setRelativeMode(not love.mouse.getRelativeMode())
        end
    end,
    mousemoved = function(entity, dx)
        entity.angle = entity.angle + dx * g.turnSpeed
    end,
}

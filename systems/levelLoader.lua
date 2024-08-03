local world = require("libraries.world")
local Colors = require("libraries.colors")
local globals = require("global")
local Vector = require("libraries.vector")

local Ghost = require("entities.ghost")
local Orb = require("entities.orb")
local Powerup = require("entities.powerup")
local ghosts = { "blinky", "pinky", "inky", "clyde" }
local ghostColors = { Colors.Red, Colors.Pink, Colors.Blue, Colors.Yellow }

return {
    filter = { "level" },
    load = function(level)
        globals.level = level
        local data = love.image.newImageData("assets/map.png")
        level.data = data

        for x = 0, data:getWidth() - 1 do
            for y = 0, data:getHeight() - 1 do
                local r, _, _, _ = data:getPixel(x, y)
                local mode = math.floor(r * 255)
                if mode == 128 then
                    local player = require("entities.player")
                    player.position = Vector(x + 0.5, y + 0.5)
                    globals.player = player
                    world:addEntity(player)
                elseif mode == 64 then
                    for i, name in pairs(ghosts) do
                        local ghost = Ghost(Vector(x + 0.5, y + 0.5), name, ghostColors[i])
                        world:addEntity(ghost)
                        table.insert(globals.ghosts, ghost)
                        globals[name] = ghost
                    end
                    data:setPixel(x, y, 1, 1, 1, 1)
                elseif mode == 200 then
                    world:addEntity(Orb(Vector(x + 0.5, y + 0.5)))
                elseif mode == 214 then
                    world:addEntity(Powerup(Vector(x + 0.5, y + 0.5)))
                end
            end
        end
    end,
}

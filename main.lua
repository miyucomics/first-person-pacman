love.graphics.setLineStyle("rough")
love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setFont(love.graphics.newFont("assets/pico8.ttf", 6))

local Input = require("libraries.input")
local World = require("libraries.world")
local global = require("global")

function love.load()
    Input:load()
    World:addEntity(require("entities.level"))
    World:addSystem(require("systems.levelLoader"))
    World:addSystem(require("systems.player"))
    World:addSystem(require("systems.entity"))
    World:addSystem(require("systems.powerups"))
    World:addSystem(require("systems.ghosts"))
    World:addSystem(require("systems.win"))
    World:addSystem(require("systems.levelRenderer"))
    World:addSystem(require("systems.entityRenderer"))
    World:addSystem(require("systems.mapScreen"))
    World:emit("load")
    require("libraries.post")
end

function love.update(dt)
    global.clock = global.clock + dt
    World:emit("update", dt)
    World:collectGarbage()
end

function love.draw()
    World:emit("draw")
end

function love.mousemoved(_, _, dx, _, _)
    World:emit("mousemoved", dx)
end

function love.keypressed(key)
    World:emit("keypressed", key)
end

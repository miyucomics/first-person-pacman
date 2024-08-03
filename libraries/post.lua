local g = require("global")
local Colors = require("libraries.colors")

local pixelSize = 4
local screenWidth = love.graphics.getWidth() / pixelSize
local screenHeight = love.graphics.getHeight() / pixelSize
local screenCanvas = love.graphics.newCanvas(screenWidth, screenHeight)
local uiCanvas = love.graphics.newCanvas(g.level.data:getWidth() * 16, g.level.data:getHeight() * 16)
local shader = love.graphics.newShader("assets/crt.glsl")

local uiX = (love.graphics.getWidth() - uiCanvas:getWidth()) / 2
local uiY = (love.graphics.getHeight() - uiCanvas:getHeight()) / 2

g.screenWidth = screenWidth
g.screenHeight = screenHeight
g.uiCanvas = uiCanvas
g.uiY = uiY

local old_draw = love.draw
love.draw = function()
    love.graphics.setCanvas(uiCanvas)
    love.graphics.clear(Colors.Black)
    love.graphics.setCanvas()
    love.graphics.setCanvas(screenCanvas)
    love.graphics.clear(Colors.Black)
    old_draw()
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(screenCanvas, 0, 0, 0, pixelSize, pixelSize)
    love.graphics.setShader(shader)
    love.graphics.draw(uiCanvas, uiX, g.uiElevation)
    love.graphics.setShader()
end

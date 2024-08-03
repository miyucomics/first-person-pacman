local Colors = require("libraries.colors")
local g = require("global")

return {
    filter = {},
    d_draw = function()
        local postCanvas = love.graphics.getCanvas()
        love.graphics.setCanvas(g.uiCanvas)
        love.graphics.clear()
        love.graphics.setCanvas(postCanvas)
        love.graphics.printf("you lost!", 10, 20, g.screenWidth - 20, "center")
        love.graphics.printf("that's alright, this is a really hard game", 10, 50, g.screenWidth - 20, "center")
        love.graphics.printf("better luck next time!", 10, 70, g.screenWidth - 20, "center")
    end
}

local g = require("global")

return {
    filter = {},
    d_draw = function()
        local postCanvas = love.graphics.getCanvas()
        love.graphics.setCanvas(g.uiCanvas)
        love.graphics.clear()
        love.graphics.setCanvas(postCanvas)
        love.graphics.printf("congratulations! you won!", 10, 20, g.screenWidth - 20, "center")
        love.graphics.printf("pacman v2 by brian nguyen", 10, 50, g.screenWidth - 20, "center")
        love.graphics.printf("code - brian nguyen", 10, 60, g.screenWidth - 20, "center")
        love.graphics.printf("sounds - brian nguyen", 10, 70, g.screenWidth - 20, "center")
        love.graphics.printf("sprites - brian nguyen", 10, 80, g.screenWidth - 20, "center")
    end,
}

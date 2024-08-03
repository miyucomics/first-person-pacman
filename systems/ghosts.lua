local timer = 0
local tickLength = 1
local ticks = 0
local g = require("global")
local ghostActivation = { "blinky", "pinky", "inky", "clyde" }

local scatterSound = love.audio.newSource("assets/sounds/scatter.wav", "static")
local chaseSound = love.audio.newSource("assets/sounds/chase.wav", "static")
local scattered = false

return {
    filter = { "ghost" },
    d_update = function(_, dt)
        timer = timer + dt

        if scattered then
            if ticks == 10 then
                ticks = ticks - 10
                scattered = false
                chaseSound:play()
                for _, ghost in pairs(g.ghosts) do
                    if ghost.state == "scatter" then
                        ghost.state = "chase"
                    end
                end
            end
        else
            if ticks == 20 then
                ticks = ticks - 20
                scattered = true
                scatterSound:play()
                for _, ghost in pairs(g.ghosts) do
                    if ghost.state == "chase" then
                        ghost.state = "scatter"
                    end
                end
            end
        end

        if timer > tickLength then
            timer = timer - tickLength
            ticks = ticks + 1
            if #ghostActivation ~= 0 then
                g[ghostActivation[1]].active = true
                table.remove(ghostActivation, 1)
            end
            for _, ghost in pairs(g.ghosts) do
                if ghost.active then
                    ghost:tick()
                end
            end
        end
    end,
    update = function(ghost)
        ghost:update((timer % tickLength) / tickLength)
    end,
}

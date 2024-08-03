local Powerup = require("libraries.classic"):extend()
local g = require("global")

local image = love.graphics.newImage("assets/powerup.png")
local texture = love.image.newImageData("assets/powerup.png")
local pickupSound = love.audio.newSource("assets/sounds/powerup.wav", "static")

function Powerup:new(position)
    self.components = { "sprite", "powerup" }
    self.position = position
    self.image = image
    self.texture = texture
    self.scale = 0.25
    self.verticalOffset = 0.5
    self.shouldRemove = false
end

function Powerup:close()
    g.poweredUp = 15
    for _, ghost in pairs(g.ghosts) do
        ghost.state = "fearful"
        ghost.facing = -ghost.facing
    end
    pickupSound:play()
    self.shouldRemove = true
end

return Powerup

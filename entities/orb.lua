local Orb = require("libraries.classic"):extend()

local image = love.graphics.newImage("assets/orb.png")
local texture = love.image.newImageData("assets/orb.png")
local pickupSound = love.audio.newSource("assets/sounds/collect.wav", "static")
pickupSound:setVolume(0.5)

function Orb:new(position)
    self.components = { "sprite", "orb" }
    self.position = position
    self.image = image
    self.texture = texture
    self.scale = 0.25
    self.verticalOffset = 0.5
    self.shouldRemove = false
end

function Orb:close()
    pickupSound:play()
    self.shouldRemove = true
end

return Orb

local Ghost = require("libraries.classic"):extend()
local Vector = require("libraries.vector")
local world = require("libraries.world")
local g = require("global")

local killSound = love.audio.newSource("assets/sounds/death.wav", "static")
local nomSound = love.audio.newSource("assets/sounds/nom.wav", "static")

local scatterTargets = {
    blinky = Vector(16, -3),
    pinky = Vector(2, -3),
    inky = Vector(18, 21),
    clyde = Vector(0, 21),
}
local targettingLookup = {
    blinky = function(_, player)
        return player.position
    end,
    pinky = function(_, player)
        local offset = Vector(math.cos(player.angle), math.sin(player.angle))
        return player.position + offset * 4
    end,
    inky = function(_, player)
        local offset = Vector(math.cos(player.angle), math.sin(player.angle))
        local intermediary = player.position + offset * 2
        return intermediary + (player.position - g.blinky.position)
    end,
    clyde = function(self, player)
        if (self.position - player.position):squareLength() < 64 then
            return scatterTargets.clyde
        end
        return player.position
    end,
}

local fearfulTexture = love.image.newImageData("assets/textures/fearful.png")
local fearfulImage = love.graphics.newImage("assets/textures/fearful.png")

local offsets = {
    Vector(1, 0),
    Vector(-1, 0),
    Vector(0, 1),
    Vector(0, -1)
}

function Ghost:new(position, name, color)
    self.components = { "sprite", "ghost", name }
    self.position = position
    self.tilePosition = position
    self.previousTilePosition = position
    self.facing = Vector(1, 0)
    self.name = name
    self.color = color
    self.scale = 1
    self.state = "chase"
    self.verticalOffset = 0
    self.targettingFunction = targettingLookup[name]
    self.home = Vector(position.x, position.y)

    self.texture = nil
    self.image = nil

    self.primaryTexture = love.image.newImageData("assets/textures/" .. name .. ".png")
    self.primaryImage = love.graphics.newImage("assets/textures/" .. name .. ".png")
    self.eatenTexture = love.image.newImageData("assets/textures/" .. name .. "_eaten.png")
    self.eatenImage = love.graphics.newImage("assets/textures/" .. name .. "_eaten.png")

    self.active = false
end

function Ghost:getTarget()
    if self.state == "chase" then
        local raw = self:targettingFunction(g.player)
        return Vector(math.floor(raw.x) + 0.5, math.floor(raw.y) + 0.5)
    elseif self.state == "scatter" then
        return scatterTargets[self.name]
    elseif self.state == "eaten" then
        return self.home
    end
end

function Ghost:update(deltaTick)
    self.position = (self.tilePosition - self.previousTilePosition) * deltaTick + self.previousTilePosition
    if self.state == "fearful" then
        self.texture = fearfulTexture
        self.image = fearfulImage
        if g.poweredUp < 0 then
            self.state = "chase"
        end
    elseif self.state == "eaten" then
        self.texture = self.eatenTexture
        self.image = self.eatenImage
    else
        self.texture = self.primaryTexture
        self.image = self.primaryImage
    end
end

function Ghost:tick()
    local target = self:getTarget()
    local possible = {}
    for _, offset in pairs(offsets) do
        local displaced = self.tilePosition + offset
        if displaced == self.home and self.state == "eaten" then
            self.state = "chase"
        end
        if not g.level:isSolid(displaced.x, displaced.y) and offset * -1 ~= self.facing then
            table.insert(possible, offset)
        end
    end
    local bestDirection = -1
    if self.state == "fearful" then
        bestDirection = love.math.random(#possible)
    else
        local bestScore = 100
        for i, offset in pairs(possible) do
            local score = ((self.position + offset) - target):length()
            if score < bestScore then
                bestScore = score
                bestDirection = i
            end
        end
    end
    self.facing = possible[bestDirection]
    self.previousTilePosition = self.tilePosition
    self.tilePosition = self.tilePosition + self.facing
end

function Ghost:close()
    if self.state == "fearful" then
        self.state = "eaten"
        nomSound:play()
    elseif self.state ~= "eaten" then
        world.systems = {}
        world.entities = {}
        world:addSystem(require("systems.loseScreen"))
        killSound:play()
    end
end

return Ghost

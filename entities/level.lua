local Level = {
    components = { "level" },
    depthBuffer = {},
    data = {},
}

function Level:isSolid(x, y)
    local r, _, _ = self.data:getPixel(x, y)
    return r == 1
end

return Level

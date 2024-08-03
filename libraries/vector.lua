local Vector = require("libraries/classic"):extend()

function Vector:new(x, y)
    self.x = x
    self.y = y
end

function Vector.__tostring(s)
    return "(" .. s.x .. ", " .. s.y .. ")"
end

function Vector.__add(a, b)
    if type(a) == "number" then
        return Vector(a + b.x, a + b.y)
    elseif type(b) == "number" then
        return Vector(a.x + b, a.y + b)
    end
    return Vector(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
    if type(a) == "number" then
        return Vector(a - b.x, a - b.y)
    elseif type(b) == "number" then
        return Vector(a.x - b, a.y - b)
    end
    return Vector(a.x - b.x, a.y - b.y)
end

function Vector.__mul(a, b)
    if type(a) == "number" then
        return Vector(a * b.x, a * b.y)
    elseif type(b) == "number" then
        return Vector(a.x * b, a.y * b)
    end
    return Vector(a.x * b.x, a.y * b.y)
end

function Vector.__div(a, b)
    if type(a) == "number" then
        return Vector(a / b.x, a / b.y)
    elseif type(b) == "number" then
        return Vector(a.x / b, a.y / b)
    end
    return Vector(a.x / b.x, a.y / b.y)
end

function Vector.__unm(t)
    return Vector(-t.x, -t.y)
end

function Vector.__eq(a, b)
    return a.x == b.x and a.y == b.y
end

function Vector:squareLength()
    return self.x ^ 2 + self.y ^ 2
end

function Vector:length()
    return (self.x ^ 2 + self.y ^ 2) ^ 0.5
end

function Vector:normalized()
    if self:length() == 0 then
        return Vector(0, 0)
    end
    return self / self:length()
end

return Vector

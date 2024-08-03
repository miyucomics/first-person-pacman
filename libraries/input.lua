local Input = { prev_state = {}, state = {} }
Input.__index = Input

function Input:load()
    local callbacks = { "keypressed", "keyreleased", "mousepressed", "mousereleased", "update" }
    local old_functions = {}
    local empty_function = function() end
    for _, f in ipairs(callbacks) do
        old_functions[f] = love[f] or empty_function
        love[f] = function(...)
            old_functions[f](...)
            Input[f](Input, ...)
        end
    end
end

function Input:pressed(action)
    if self.state[action] == nil then
        return false
    end
    if self.state[action] and not self.prev_state[action] then
        return true
    end
end

function Input:released(action)
    if self.state[action] == nil then
        return false
    end
    if not self.state[action] and self.prev_state[action] then
        return true
    end
end

function Input:active(action)
    if self.state[action] == nil then
        return false
    end
    return self.state[action]
end

function Input:update()
    for k, v in pairs(self.state) do
        self.prev_state[k] = v
    end
end

function Input:keypressed(key)
    self.state[key] = true
end

function Input:keyreleased(key)
    self.state[key] = false
end

local button_to_key = { "leftmouse", "rightmouse" }
function Input:mousepressed(_, _, button)
    self.state[button_to_key[button]] = true
end

function Input:mousereleased(_, _, button)
    self.state[button_to_key[button]] = false
end

return Input

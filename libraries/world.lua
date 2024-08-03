local World = {
    entities = {},
    systems = {},
}

function World:addEntity(entity)
    table.insert(self.entities, entity)
end

function World:addSystem(player)
    table.insert(self.systems, player)
end

local function hasComponent(entity, component)
    for _, v in pairs(entity.components) do
        if v == component then
            return true
        end
    end
    return false
end

local function hasAllComponents(entity, components)
    for _, value in pairs(components) do
        if not hasComponent(entity, value) then
            return false
        end
    end
    return true
end

function World:findEntity(unique)
    for _, entity in pairs(self.entities) do
        if hasComponent(entity, unique) then
            return entity
        end
    end
    return nil
end

function World:findEntities(components)
    local results = {}
    for _, entity in pairs(self.entities) do
        if hasAllComponents(entity, components) then
            table.insert(results, entity)
        end
    end
    return results
end

function World:emit(signal, args)
    for _, system in pairs(self.systems) do
        if system["d_" .. signal] then
            system["d_" .. signal](system, args)
        end
        if system[signal] then
            for _, entity in pairs(self:findEntities(system.filter)) do
                system[signal](entity, args)
            end
        end
    end
end

function World:collectGarbage()
    for i = #self.entities, 1, -1 do
        if self.entities[i].shouldRemove == true then
            table.remove(self.entities, i)
        end
    end
end

return World

local world = require("libraries.world")

return {
    filter = { "level" },
    update = function()
        if #world:findEntities({ "orb" }) == 0 then
            world.systems = {}
            world.entities = {}
            world:addSystem(require("systems.winScreen"))
        end
    end,
}

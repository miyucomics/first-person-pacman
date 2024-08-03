local g = require("global")

return {
    filter = {},
    d_update = function(_, dt)
        g.poweredUp = g.poweredUp - dt
    end,
}

local NilCommand = require('command/nil')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local RegisterCommand = NilCommand:NilCommand()
RegisterCommand.__index = RegisterCommand

--------------------------------------------------------------------------------
function RegisterCommand:RegisterCommand()
    local o = NilCommand:NilCommand()
    setmetatable(o, self)
    o._type = 'RegisterCommand'
    return o
end

return NilCommand

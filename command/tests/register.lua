local LuaUnit = require('luaunit')
local RegisterCommand = require('command/register')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
RegisterCommandTests = {}

--------------------------------------------------------------------------------
function RegisterCommandTests:SetUp()
    windower = {}
    windower.ffxi = {}
    function windower.ffxi.get_mob_by_id(id)
        return { id = id, index = 4321, distance = 9999, valid_target = true }
    end

    function windower.ffxi.get_player()
        return {}
    end

    function windower.ffxi.get_items()
        return {max = 0, count = 0}
    end

    function windower.ffxi.get_info()
        return { zone = 11 }
    end

    settings = {}
    settings.config = {}
    settings.config.maxdistance = 90

    function log()
    end
end

--------------------------------------------------------------------------------
function RegisterCommandTests:TestTypeIsRegisterCommand()
    local c = RegisterCommand:RegisterCommand()
    LuaUnit.assertEquals(c:Type(), 'RegisterCommand')
end

LuaUnit.LuaUnit.run('RegisterCommandTests')
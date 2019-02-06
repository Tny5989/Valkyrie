local LuaUnit = require('luaunit')
local EnterCommand = require('command/enter')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
EnterCommandTests = {}

--------------------------------------------------------------------------------
function EnterCommandTests:SetUp()
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
function EnterCommandTests:TestTypeIsEnterCommand()
    local c = EnterCommand:EnterCommand()
    LuaUnit.assertEquals(c:Type(), 'EnterCommand')
end

LuaUnit.LuaUnit.run('EnterCommandTests')
local LuaUnit = require('luaunit')
local CommandFactory = require('command/factory')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
CommandFactoryTests = {}

--------------------------------------------------------------------------------
function CommandFactoryTests:SetUp()
    windower = {}
    windower.ffxi = {}
    function windower.ffxi.get_mob_by_id(id)
        return {id = id, index = 4321, distance = 5}
    end

    function windower.ffxi.get_player()
        return { id = 9999, index = 8888, distance = 0 }
    end

    function windower.ffxi.get_items()
        return { max = 0, count = 0 }
    end

    function windower.ffxi.get_info()
        return {zone = 78}
    end

    function windower.convert_auto_trans()
    end

    function log()
    end

    resources = {}
    resources.zones = {}

    function resources.zones.with()
    end

    settings = {}
    settings.config = {}
    settings.config.maxdistance = 25
end


--------------------------------------------------------------------------------
function CommandFactoryTests:TestNilCommandCreatedWhenBadCommand()
    local c = CommandFactory.CreateCommand(nil)
    LuaUnit.assertEquals(c:Type(), 'NilCommand')
end

--------------------------------------------------------------------------------
function CommandFactoryTests:TestNilCommandCreatedWhenUnknownCommand()
    local c = CommandFactory.CreateCommand('', '')
    LuaUnit.assertEquals(c:Type(), 'NilCommand')
end

--------------------------------------------------------------------------------
function CommandFactoryTests:TestNilCommandCreatedWhenBadName()
    local c = CommandFactory.CreateCommand('register', nil)
    LuaUnit.assertEquals(c:Type(), 'NilCommand')
end

--------------------------------------------------------------------------------
function CommandFactoryTests:TestRegisterCommmandCreatedForValidRegister()
    local c = CommandFactory.CreateCommand('register', 'Rossweisse\'s Chamber')
    LuaUnit.assertEquals(c:Type(), 'RegisterCommand')
end

--------------------------------------------------------------------------------
function CommandFactoryTests:TestEnterCommmandCreatedForValidEnter()
    local c = CommandFactory.CreateCommand('enter')
    LuaUnit.assertEquals(c:Type(), 'EnterCommand')
end


LuaUnit.LuaUnit.run('CommandFactoryTests')

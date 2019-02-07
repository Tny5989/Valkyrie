local LuaUnit = require('luaunit')
local MenuFactory = require('model/menu/factory')
local SimpleMenu = require('model/menu/simple')
local NilMenu = require('model/menu/nil')
local ConfirmMenu = require('model/menu/confirm')
local WarpMenu = require('model/menu/warp')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
MenuFactoryTests = {}

--------------------------------------------------------------------------------
function MenuFactoryTests:SetUp()
    packets = {}
    function packets.parse()
        return {}
    end
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenBadPacket()
    local menu = MenuFactory.CreateRegisterMenu()
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenNoPacketLib()
    packets = nil
    local menu = MenuFactory.CreateRegisterMenu({})
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenBadParse()
    function packets.parse(dir, data)
        return nil
    end

    local menu = MenuFactory.CreateRegisterMenu({})
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenBadMenuId()
    function packets.parse(dir, data)
        return { ['Menu ID'] = 0 }
    end

    local menu = MenuFactory.CreateRegisterMenu({})
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenBadIndex()
    function packets.parse(dir, data)
        return { ['Menu ID'] = 1 }
    end

    local menu = MenuFactory.CreateRegisterMenu({})
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenMissingMenuParameters()
    function packets.parse(dir, data)
        return { ['Menu ID'] = 1 }
    end

    local menu = MenuFactory.CreateRegisterMenu({}, 9)
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestSimpleMenuCreatedWhenAllGood()
    function packets.parse(dir, data)
        return { ['Menu ID'] = 1, ['Menu Parameters'] = '' }
    end

    local menu = MenuFactory.CreateRegisterMenu({}, 9)
    LuaUnit.assertEquals(menu:Type(), 'SimpleMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenBadPacket_Extra()
    local menu = MenuFactory.CreateExtraMenu(nil, NilMenu:NilMenu(), 9)
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenBadMenu_Extra()
    local menu = MenuFactory.CreateExtraMenu({}, nil, 9)
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenNoPacketLib_Extra()
    packets = nil
    local menu = MenuFactory.CreateExtraMenu({}, NilMenu:NilMenu())
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenUnableToParsePacket_Extra()
    function packets.parse(_, _)
        return nil
    end

    local menu = MenuFactory.CreateExtraMenu({}, NilMenu:NilMenu())
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestConfirmMenuCreatedWhenLastMenuWasSimple()
    function packets.parse(_, _)
        return {}
    end

    local menu = MenuFactory.CreateExtraMenu({}, SimpleMenu:SimpleMenu(), 9)
    LuaUnit.assertEquals(menu:Type(), 'ConfirmMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenLastMenuWasConfirm()
    function packets.parse(_, _)
        return {}
    end

    local menu = MenuFactory.CreateExtraMenu({}, ConfirmMenu:ConfirmMenu(1, 2), 9)
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenBadPacket_Enter()
    local menu = MenuFactory.CreateEnterMenu()
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenNoPacketLib_Enter()
    packets = nil
    local menu = MenuFactory.CreateEnterMenu({})
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenBadParse_Enter()
    function packets.parse(dir, data)
        return nil
    end

    local menu = MenuFactory.CreateEnterMenu({})
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenBadMenuId_Enter()
    function packets.parse(dir, data)
        return { ['Menu ID'] = 0, ['Menu Parameters'] = '' }
    end

    local menu = MenuFactory.CreateEnterMenu({})
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestNilMenuCreatedWhenMissingMenuParameters_Enter()
    function packets.parse(dir, data)
        return { ['Menu ID'] = 1 }
    end

    local menu = MenuFactory.CreateEnterMenu({}, 9)
    LuaUnit.assertEquals(menu:Type(), 'NilMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestWarpMenuCreatedWhenAllGood_Enter()
    function packets.parse(dir, data)
        return { ['Menu ID'] = 1, ['Menu Parameters'] = '' }
    end

    local menu = MenuFactory.CreateEnterMenu({})
    LuaUnit.assertEquals(menu:Type(), 'WarpMenu')
end

--------------------------------------------------------------------------------
function MenuFactoryTests:TestSimpleExtraMenuCreatedWhenAllGood_Enter()
    function packets.parse(dir, data)
        return { ['Menu ID'] = 1, ['Menu Parameters'] = '' }
    end

    local menu = MenuFactory.CreateExtraMenu({}, WarpMenu:WarpMenu())
    LuaUnit.assertEquals(menu:Type(), 'SimpleMenu')
end

LuaUnit.LuaUnit.run('MenuFactoryTests')
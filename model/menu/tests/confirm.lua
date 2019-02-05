local LuaUnit = require('luaunit')
local ConfirmMenu = require('model/menu/confirm')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ConfirmMenuTests = {}

--------------------------------------------------------------------------------
function ConfirmMenuTests:TestIdIsCorrect()
    local menu = ConfirmMenu:ConfirmMenu(1234, 1)
    LuaUnit.assertEquals(menu:Id(), 1234)
end

--------------------------------------------------------------------------------
function ConfirmMenuTests:TestOptionForResult()
    local menu = ConfirmMenu:ConfirmMenu(1234, 1)
    LuaUnit.assertEquals(menu:OptionFor(0), { option = 65, automated = false, uk1 = 0 })
    LuaUnit.assertEquals(menu:OptionFor(1), { option = 49, automated = false, uk1 = 0 })
    LuaUnit.assertEquals(menu:OptionFor(2), { option = 49, automated = false, uk1 = 0 })
end

--------------------------------------------------------------------------------
function ConfirmMenuTests:TestTypeIsConfirmMenu()
    local menu = ConfirmMenu:ConfirmMenu(1234, 1)
    LuaUnit.assertEquals(menu:Type(), 'ConfirmMenu')
end

LuaUnit.LuaUnit.run('ConfirmMenuTests')
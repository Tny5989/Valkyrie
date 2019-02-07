local LuaUnit = require('luaunit')
local WarpMenu = require('model/menu/warp')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
WarpMenuTests = {}

--------------------------------------------------------------------------------
function WarpMenuTests:TestIdIsCorrect()
    local menu = WarpMenu:WarpMenu(1234)
    LuaUnit.assertEquals(menu:Id(), 1234)
end

--------------------------------------------------------------------------------
function WarpMenuTests:TestTypeIsWarpMenu()
    local menu = WarpMenu:WarpMenu(1234)
    LuaUnit.assertEquals(menu:Type(), 'WarpMenu')
end

LuaUnit.LuaUnit.run('WarpMenuTests')
local NilMenu = require('model/menu/nil')
local SimpleMenu = require('model/menu/simple')
local ConfirmMenu = require('model/menu/confirm')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local MenuFactory = {}

--------------------------------------------------------------------------------
function MenuFactory.CreateRegisterMenu(pkt, idx)
    if not pkt or not idx or not packets then
        return NilMenu:NilMenu()
    end

    local ppkt = packets.parse('incoming', pkt)
    if not ppkt then
        return NilMenu:NilMenu()
    end

    local menu_id = ppkt['Menu ID']
    if not menu_id or menu_id == 0 then
        return NilMenu:NilMenu()
    end

    local params = ppkt['Menu Parameters']
    if not params then
        return NilMenu:NilMenu(menu_id)
    end

    return SimpleMenu:SimpleMenu(menu_id, idx, true, 0)
end

--------------------------------------------------------------------------------
function MenuFactory.CreateExtraMenu(pkt, last_menu, idx)
    if not pkt or not last_menu or not packets then
        return NilMenu:NilMenu()
    end

    -- This isn't really needed until I figure out what is in these packets
    local ppkt = packets.parse('incoming', pkt)
    if not ppkt then
        return NilMenu:NilMenu(last_menu:Id())
    end

    if last_menu:Type() == 'SimpleMenu' then
        if not idx then
            return NilMenu:NilMenu(last_menu:Id())
        else
            return ConfirmMenu:ConfirmMenu(last_menu:Id(), idx)
        end
    end

    return NilMenu:NilMenu(last_menu:Id())
end

return MenuFactory
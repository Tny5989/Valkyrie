local RegisterDialogue = require('model/dialogue/register')
local NilDialogue = require('model/dialogue/nil')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local DialogueFactory = {}

--------------------------------------------------------------------------------
function DialogueFactory.CreateRegisterDialogue(npc, player, chamber, item_id)
    if not npc or npc:Type() == 'NilEntity' then
        log('Unable to find npc')
        return NilDialogue:NilDialogue()
    end

    if not player or player:Type() == 'NilEntity' then
        log('Unable to find player')
        return NilDialogue:NilDialogue()
    end

    if npc:Distance() > settings.config.maxdistance then
        log('Npc too far away')
        return NilDialogue:NilDialogue()
    end

    if not item_id then
        log('Bad item id')
        return NilDialogue:NilDialogue()
    end

    if player:Bag():FreeSlots() < 1 then
        log('Inventory full')
        return NilDialogue:NilDialogue()
    end

    if player:Bag():ItemCount(item_id) < 1 then
        log("No Lamp")
        return NilDialogue:NilDialogue()
    end

    if not chamber or not chamber.idx then
        log('Unknown chamber')
        return NilDialogue:NilDialogue()
    end

    return RegisterDialogue:RegisterDialogue(npc, player, chamber, item_id)
end

return DialogueFactory
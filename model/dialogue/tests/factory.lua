local LuaUnit = require('luaunit')
local DialogueFactory = require('model/dialogue/factory')
local NilInventory = require('model/inventory/nil')
local PlayerInventory = require('model/inventory/player')
local NilEntity = require('model/entity/nil')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local MockEntity = NilEntity:NilEntity()
MockEntity.__index = MockEntity

--------------------------------------------------------------------------------
function MockEntity:MockEntity(id, idx, distance, bag)
    local o = NilEntity:NilEntity()
    setmetatable(o, self)
    o._id = id
    o._index = idx
    o._distance = distance
    o._bag = bag
    o._type = 'MockEntity'
    return o
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
DialogueFactoryTests = {}

--------------------------------------------------------------------------------
function DialogueFactoryTests:SetUp()
    windower = {}
    windower.ffxi = {}
    function windower.ffxi.get_mob_by_id(id)
        return { id = id, index = 4321, distance = 5, valid_target = true }
    end

    function windower.ffxi.get_info()
        return { zone = 11 }
    end

    settings = {}
    settings.config = {}
    settings.config.maxdistance = 20

    function log()
    end
end

--------------------------------------------------------------------------------
function DialogueFactoryTests:TestNilDialogueCreatedWhenBadNpc()
    local items = { { id = 2, index = 1 , count = 1 }, max = 2, count = 1 }
    local bag = PlayerInventory:PlayerInventory(items)
    local entity = MockEntity:MockEntity(1234, 4321, 0, bag)
    local dialogue = DialogueFactory.CreateRegisterDialogue(nil, entity, { idx = 1, en = 'Test' }, 6)
    LuaUnit.assertEquals(dialogue:Type(), 'NilDialogue')
end

--------------------------------------------------------------------------------
function DialogueFactoryTests:TestNilDialogueCreatedWhenBadPlayer()
    local bag = NilInventory:NilInventory()
    local entity = MockEntity:MockEntity(1234, 4321, 0, bag)
    local dialogue = DialogueFactory.CreateRegisterDialogue(entity, nil, { idx = 1, en = 'Test' }, 6)
    LuaUnit.assertEquals(dialogue:Type(), 'NilDialogue')
end

--------------------------------------------------------------------------------
function DialogueFactoryTests:TestNilDialogueCreatedWhenNilNpc()
    local items = { { id = 2, index = 1 , count = 1 }, max = 2, count = 1 }
    local bag = PlayerInventory:PlayerInventory(items)
    local entity = MockEntity:MockEntity(1234, 4321, 0, bag)
    local dialogue = DialogueFactory.CreateRegisterDialogue(NilEntity:NilEntity(), entity, { idx = 1, en = 'Test' }, 6)
    LuaUnit.assertEquals(dialogue:Type(), 'NilDialogue')
end

--------------------------------------------------------------------------------
function DialogueFactoryTests:TestNilDialogueCreatedWhenNilPlayer()
    local bag = NilInventory:NilInventory()
    local entity = MockEntity:MockEntity(1234, 4321, 0, bag)
    local dialogue = DialogueFactory.CreateRegisterDialogue(entity, NilEntity:NilEntity(), { idx = 1, en = 'Test' }, 6)
    LuaUnit.assertEquals(dialogue:Type(), 'NilDialogue')
end

--------------------------------------------------------------------------------
function DialogueFactoryTests:TestNilDialogueCreatedWhenFarAway()
    local items = { { id = 2, index = 1 , count = 1 }, max = 2, count = 1 }
    local pbag = PlayerInventory:PlayerInventory(items)
    local player = MockEntity:MockEntity(1234, 4321, 0, pbag)
    local bag = NilInventory:NilInventory()
    local mob = MockEntity:MockEntity(1234, 4321, 30, bag)
    local dialogue = DialogueFactory.CreateRegisterDialogue(mob, player, { idx = 1, en = 'Test' }, 6)
    LuaUnit.assertEquals(dialogue:Type(), 'NilDialogue')
end

--------------------------------------------------------------------------------
function DialogueFactoryTests:TestNilDialogueCreatedWhenBadItemId()
    local items = { { id = 2, index = 1 , count = 1 }, max = 2, count = 1 }
    local pbag = PlayerInventory:PlayerInventory(items)
    local player = MockEntity:MockEntity(1234, 4321, 0, pbag)
    local bag = NilInventory:NilInventory()
    local mob = MockEntity:MockEntity(1234, 4321, 5, bag)
    local dialogue = DialogueFactory.CreateRegisterDialogue(mob, player, nil, 6)
    LuaUnit.assertEquals(dialogue:Type(), 'NilDialogue')
end

--------------------------------------------------------------------------------
function DialogueFactoryTests:TestNilDialogueCreatedWhenBadItemCount()
    local items = { { id = 2, index = 1 , count = 1 }, max = 2, count = 1 }
    local pbag = PlayerInventory:PlayerInventory(items)
    local player = MockEntity:MockEntity(1234, 4321, 0, pbag)
    local bag = NilInventory:NilInventory()
    local mob = MockEntity:MockEntity(1234, 4321, 5, bag)
    local dialogue = DialogueFactory.CreateRegisterDialogue(mob, player, { idx = 1, en = 'Test' })
    LuaUnit.assertEquals(dialogue:Type(), 'NilDialogue')
end

--------------------------------------------------------------------------------
function DialogueFactoryTests:TestNilDialogueCreatedWhenFullInventory()
    local items = { { id = 2, index = 1 , count = 1 }, max = 2, count = 2 }
    local pbag = PlayerInventory:PlayerInventory(items)
    local player = MockEntity:MockEntity(1234, 4321, 0, pbag)
    local bag = NilInventory:NilInventory()
    local mob = MockEntity:MockEntity(1234, 4321, 5, bag)
    local dialogue = DialogueFactory.CreateRegisterDialogue(mob, player, { idx = 1, en = 'Test' }, 6)
    LuaUnit.assertEquals(dialogue:Type(), 'NilDialogue')
end

--------------------------------------------------------------------------------
function DialogueFactoryTests:TestRegisterDialogueCreatedWhenValidParams()
    local items = { { id = 6, index = 1 , count = 1 }, max = 2, count = 1 }
    local pbag = PlayerInventory:PlayerInventory(items)
    local player = MockEntity:MockEntity(1234, 4321, 0, pbag)
    local bag = NilInventory:NilInventory()
    local mob = MockEntity:MockEntity(1234, 4321, 5, bag)
    local dialogue = DialogueFactory.CreateRegisterDialogue(mob, player, { idx = 1, en = 'Test' }, 6)
    LuaUnit.assertEquals(dialogue:Type(), 'RegisterDialogue')
end

LuaUnit.LuaUnit.run('DialogueFactoryTests')
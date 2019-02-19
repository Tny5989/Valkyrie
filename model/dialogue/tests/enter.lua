local LuaUnit = require('luaunit')
local EnterDialogue = require('model/dialogue/enter')
local NilEntity = require('model/entity/nil')
local PlayerInventory = require('model/inventory/player')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local MockEntity = NilEntity:NilEntity()
MockEntity.__index = MockEntity

--------------------------------------------------------------------------------
function MockEntity:MockEntity(id, idx, zone)
    local o = NilEntity:NilEntity()
    setmetatable(o, self)
    o._id = id
    o._index = idx
    o._zone = zone
    return o
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
EnterDialogueTests = {}

--------------------------------------------------------------------------------
function EnterDialogueTests:SetUp()
    packets = {}
    function packets.new(dir, id)
        return { dir = dir, id = id }
    end

    packets.injected = {}
    function packets.inject(pkt)
        table.insert(packets.injected, pkt)
    end

    function packets.parse(dir, data)
        return {}
    end

    function packets.get_bit_packed()
        return 0
    end

    function log()
    end
end

--------------------------------------------------------------------------------
function EnterDialogueTests:TestPacketsSent()
    local items = { { id = 6, index = 1 , count = 1 }, max = 2, count = 1 }
    local pbag = PlayerInventory:PlayerInventory(items)
    local player = MockEntity:MockEntity(1234, 4321, 0, pbag)
    local npc = MockEntity:MockEntity(1234, 4, 11)
    local dialogue = EnterDialogue:EnterDialogue(npc, player, { idx = 1, en = 'Test' }, 6)

    local fc = 0
    function failure()
        fc = fc + 1
    end

    local sc = 0
    function success()
        sc = sc + 1
    end

    dialogue:SetSuccessCallback(success)
    dialogue:SetFailureCallback(failure)

    dialogue:Start()
    LuaUnit.assertEquals(#packets.injected, 1)
    LuaUnit.assertEquals(packets.injected[1].id, 0x036)

    packets.injected = {}
    dialogue:OnIncomingData(0x034, {})
    dialogue:OnIncomingData(0x05C, {})
    LuaUnit.assertEquals(#packets.injected, 1)
    LuaUnit.assertEquals(packets.injected[1].id, 0x05B)

    packets.injected = {}
    dialogue:OnIncomingData(0x052, {})
    LuaUnit.assertEquals(#packets.injected, 0)

    LuaUnit.assertEquals(fc, 0)
    LuaUnit.assertEquals(sc, 1)
end

--------------------------------------------------------------------------------
function EnterDialogueTests:TestDialogueFailsOnEarly52()
    local items = { { id = 6, index = 1 , count = 1 }, max = 2, count = 1 }
    local pbag = PlayerInventory:PlayerInventory(items)
    local player = MockEntity:MockEntity(1234, 4321, 0, pbag)
    local npc = MockEntity:MockEntity(1234, 4, 11)
    local dialogue = EnterDialogue:EnterDialogue(npc, player, { idx = 1, en = 'Test' }, 6)

    local fc = 0
    function failure()
        fc = fc + 1
    end

    local sc = 0
    function success()
        sc = sc + 1
    end

    dialogue:SetSuccessCallback(success)
    dialogue:SetFailureCallback(failure)

    dialogue:Start()
    LuaUnit.assertEquals(#packets.injected, 1)
    LuaUnit.assertEquals(packets.injected[1].id, 0x036)

    packets.injected = {}
    dialogue:OnIncomingData(0x052, {})
    LuaUnit.assertEquals(#packets.injected, 0)

    LuaUnit.assertEquals(fc, 1)
    LuaUnit.assertEquals(sc, 0)
end

--------------------------------------------------------------------------------
function EnterDialogueTests:TestTypeIsEnterDialogue()
    local dialogue = EnterDialogue:EnterDialogue()
    LuaUnit.assertEquals(dialogue:Type(), 'EnterDialogue')
end

LuaUnit.LuaUnit.run('EnterDialogueTests')
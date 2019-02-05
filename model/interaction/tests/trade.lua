local LuaUnit = require('luaunit')
local Trade = require('model/interaction/trade')
local NilEntity = require('model/entity/nil')

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local MockEntity = NilEntity:NilEntity()
MockEntity.__index = MockEntity

--------------------------------------------------------------------------------
function MockEntity:MockEntity(id, idx)
    local o = NilEntity:NilEntity()
    setmetatable(o, self)
    o._id = id
    o._index = idx
    return o
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
TradeTests = {}

--------------------------------------------------------------------------------
function TradeTests:SetUp()
    packets = {}
    function packets.new(dir, id)
        return { dir = dir, id = id }
    end

    packets.injectcount = 0
    function packets.inject()
        packets.injectcount = packets.injectcount + 1
    end
end

--------------------------------------------------------------------------------
function TradeTests:TestFirstPacketGroupIsItemUsePacket()
    local Trade = Trade:Trade()
    local target = MockEntity:MockEntity(1234, 1)
    local player = MockEntity:MockEntity(4321, 2)
    local data = { target = target, player = player }
    local pkts = Trade:_GeneratePackets(data)
    LuaUnit.assertEquals(1, #pkts)
    LuaUnit.assertEquals(pkts[1].id, 0x036)
    LuaUnit.assertEquals(pkts[1].dir, 'outgoing')
end

--------------------------------------------------------------------------------
function TradeTests:TestSecondPacketGroupIsEmpty()
    local Trade = Trade:Trade()
    local target = MockEntity:MockEntity(1234, 1)
    local player = MockEntity:MockEntity(4321, 2)
    local data = { target = target, player = player }
    Trade:_GeneratePackets(data)
    local pkts = Trade:_GeneratePackets(data)
    LuaUnit.assertEquals(0, #pkts)
end

--------------------------------------------------------------------------------
function TradeTests:TestCallingInjectsPackets()
    local Trade = Trade:Trade()
    local target = MockEntity:MockEntity(1234, 1)
    local player = MockEntity:MockEntity(4321, 2)
    local data = { target = target, player = player }
    Trade(data)
    LuaUnit.assertEquals(packets.injectcount, 1)
    Trade(data)
    LuaUnit.assertEquals(packets.injectcount, 1)
end

--------------------------------------------------------------------------------
function TradeTests:TestFailureReportedOn52()
    local Trade = Trade:Trade()

    local fc = 0
    function failure()
        fc = fc + 1
    end

    local sc = 0
    function success()
        sc = sc + 1
    end

    Trade:SetFailureCallback(failure)
    Trade:SetSuccessCallback(success)

    Trade:OnIncomingData(0x052, {})
    LuaUnit.assertEquals(fc, 1)
    LuaUnit.assertEquals(sc, 0)
end

--------------------------------------------------------------------------------
function TradeTests:TestSuccessReportedOn34()
    local Trade = Trade:Trade()

    local fc = 0
    function failure()
        fc = fc + 1
    end

    local sc = 0
    function success()
        sc = sc + 1
    end

    Trade:SetFailureCallback(failure)
    Trade:SetSuccessCallback(success)

    Trade:OnIncomingData(0x034, {})
    LuaUnit.assertEquals(sc, 1)
    LuaUnit.assertEquals(fc, 0)
end

--------------------------------------------------------------------------------
function TradeTests:TestSuccessReportedOn32()
    local Trade = Trade:Trade()

    local fc = 0
    function failure()
        fc = fc + 1
    end

    local sc = 0
    function success()
        sc = sc + 1
    end

    Trade:SetFailureCallback(failure)
    Trade:SetSuccessCallback(success)

    Trade:OnIncomingData(0x032, {})
    LuaUnit.assertEquals(sc, 1)
    LuaUnit.assertEquals(fc, 0)
end

--------------------------------------------------------------------------------
function TradeTests:TestTypeIsTrade()
    local Trade = Trade:Trade()
    LuaUnit.assertEquals(Trade:Type(), 'Trade')
end

LuaUnit.LuaUnit.run('TradeTests')
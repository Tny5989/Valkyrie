local LuaUnit = require('luaunit')
local Warp = require('model/interaction/warp')
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
WarpTests = {}

--------------------------------------------------------------------------------
function WarpTests:SetUp()
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
function WarpTests:TestFirstPacketGroupIsWarpPacket()
    local Warp = Warp:Warp()
    local target = MockEntity:MockEntity(1234, 1)
    local chamber = { x = 1, y = 2, z = 3, uk3 = 4 }
    local data = { target = target, menu = 3, chamber = chamber, uk1 = 1  }
    local pkts = Warp:_GeneratePackets(data)
    LuaUnit.assertEquals(#pkts, 1)
    LuaUnit.assertEquals(pkts[1].id, 0x05C)
    LuaUnit.assertEquals(pkts[1].dir, 'outgoing')
end

--------------------------------------------------------------------------------
function WarpTests:TestSecondPacketGroupIsEmpty()
    local Warp = Warp:Warp()
    local target = MockEntity:MockEntity(1234, 1)
    local chamber = { x = 1, y = 2, z = 3, uk3 = 4 }
    local data = { target = target, menu = 3, chamber = chamber, uk1 = 1  }
    Warp:_GeneratePackets(data)
    local pkts = Warp:_GeneratePackets(data)
    LuaUnit.assertEquals(0, #pkts)
end

--------------------------------------------------------------------------------
function WarpTests:TestCallingInjectsPackets()
    local Warp = Warp:Warp()
    local target = MockEntity:MockEntity(1234, 1)
    local chamber = { x = 1, y = 2, z = 3, uk3 = 4 }
    local data = { target = target, menu = 3, chamber = chamber, uk1 = 1  }
    Warp(data)
    LuaUnit.assertEquals(packets.injectcount, 1)
    Warp(data)
    LuaUnit.assertEquals(packets.injectcount, 1)
end

--------------------------------------------------------------------------------
function WarpTests:TestSuccessReportedOn52()
    local Warp = Warp:Warp()

    local fc = 0
    function failure()
        fc = fc + 1
    end

    local sc = 0
    function success()
        sc = sc + 1
    end

    Warp:SetFailureCallback(failure)
    Warp:SetSuccessCallback(success)

    Warp:OnIncomingData(0x052, {})
    LuaUnit.assertEquals(sc, 1)
    LuaUnit.assertEquals(fc, 0)
end

--------------------------------------------------------------------------------
function WarpTests:TestTypeIsWarp()
    local Warp = Warp:Warp()
    LuaUnit.assertEquals(Warp:Type(), 'Warp')
end

LuaUnit.LuaUnit.run('WarpTests')
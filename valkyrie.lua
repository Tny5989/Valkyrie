_addon.name = 'Valkyrie'
_addon.author = 'Areint/Alzade'
_addon.version = '1.0.0'
_addon.commands = {'valk', 'valkyrie'}

--------------------------------------------------------------------------------
require('logger')
packets = require('util/packets')
settings = require('util/settings')

local CommandFactory = require('command/factory')
local NilCommand = require('command/nil')

--------------------------------------------------------------------------------
local command = NilCommand:NilCommand()

--------------------------------------------------------------------------------
local function OnSuccess()
    log('success')
    command = NilCommand:NilCommand()
end

--------------------------------------------------------------------------------
local function OnFailure()
    log('failure')
    command = NilCommand:NilCommand()
end

--------------------------------------------------------------------------------
local function OnLoad()
    settings.load()
end

--------------------------------------------------------------------------------
local function OnCommand(cmd, p1)
    if command:Type() == 'NilCommand' then
        command = CommandFactory.CreateCommand(cmd, p1)
        command:SetSuccessCallback(OnSuccess)
        command:SetFailureCallback(OnFailure)
        command()
    else
        log('Already running a complex command')
    end
end

--------------------------------------------------------------------------------
local function OnIncomingData(id, _, pkt, b, i)
    return command:OnIncomingData(id, pkt)
end

--------------------------------------------------------------------------------
local function OnOutgoingData(id, _, pkt, b, i)
    return command:OnOutgoingData(id, pkt)
end

--------------------------------------------------------------------------------
windower.register_event('load', OnLoad)
windower.register_event('addon command', OnCommand)
windower.register_event('incoming chunk', OnIncomingData)
windower.register_event('outgoing chunk', OnOutgoingData)
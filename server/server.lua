-- Load the QBCore object for usage
local QBCore = exports['qb-core']:GetCoreObject()

-- Default state table
local DefaultState = {
    InProgress = false,

    TargetSourceId = false,
    CallerSourceId = false,
}

-- Set initial state to default
local State = DefaultState

-- Add command for starting snatch
lib.addCommand(IR8.Config.Commands.SnatchInitiate, {
    help = IR8.Config.Commands.SnatchInitiateDescription,
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
    },
    restricted = IR8.Config.Commands.Permissions
}, function(source, args, raw)

    -- Make sure source is a number
    SourceID = (type(args.target) == "number" and args.target or tonumber(args.target))

    -- Check if player is online
    local Player = QBCore.Functions.GetPlayer(SourceID)
    if not Player then 
        return IR8.Utilities.NotifyFromServer(source, "not_online", "Error", IR8.Config.Notifications.PlayerNotAvailable, "error")
    end

    -- Set state
    State.TargetSourceId = SourceID
    State.CallerSourceId = source

    -- Get player coords
    local ped = GetPlayerPed(source)
    local coords = QBCore.Functions.GetCoords(ped)

    -- Notify the caller and initiate the target's client
    IR8.Utilities.NotifyFromServer(State.CallerSourceId, "in_progress", "Success", IR8.Config.Notifications.SnatchStarted, "success")
    TriggerClientEvent(IR8.Config.ClientCallbackPrefix .. "Init", State.TargetSourceId, State.TargetSourceId, coords)
end)

-- Add command for canceling snatch
lib.addCommand(IR8.Config.Commands.SnatchCancel, {
    help = IR8.Config.Commands.SnatchCancelDescription,
    params = {},
    restricted = IR8.Config.Commands.Permissions
}, function(source, args, raw)

    -- Trigger cancel for target
    TriggerClientEvent(IR8.Config.ClientCallbackPrefix .. "Cancel", State.TargetSourceId)
end)

RegisterNetEvent(IR8.Config.ServerCallbackPrefix .. "Initiate")
AddEventHandler (IR8.Config.ServerCallbackPrefix .. "Initiate", function(Source)
    TriggerClientEvent(IR8.Config.ClientCallbackPrefix .. "Init", Source)
end)

-- Get state 
lib.callback.register(IR8.Config.ServerCallbackPrefix .. "GetState", function ()
    return State
end)

-- Updates server-side state
lib.callback.register(IR8.Config.ServerCallbackPrefix .. "UpdateState", function (source, Field, Value)
    State[Field] = Value
end)

-- Notifies caller
lib.callback.register(IR8.Config.ServerCallbackPrefix .. "NotifySnatcher", function(source, Title, Message, Type)
    if State.CallerSourceId then 
        IR8.Utilities.NotifyFromServer(State.CallerSourceId, "snatch_notification", Title, Message, Type)
    end
end)

-- Notifies caller
lib.callback.register(IR8.Config.ServerCallbackPrefix .. "Cleanup", function(source)
    State = DefaultState
    IR8.Utilities.DebugPrint("Snatch server-side state has been reset")
end)
-- @Init
-- Sets necessary state to begin process
StateMachine.Steps.Init = function (Source, Args)
    IR8.Utilities.DebugPrint("StateMachine.Steps.Init called")

    StateMachine.State.InProgress = true

    -- Preloads models before doing anything else
    EntityManager.PreloadModels()

    -- Get the spawn coords
    local SpawnData = IR8.Utilities.GetClosestSpawnPoint(GetEntityCoords(PlayerPedId()))

    if not SpawnData then 
        lib.callback.await(IR8.Config.ServerCallbackPrefix .. 'NotifySnatcher', false, "Error", "Was unable to find a spawn point. Canceling...", "error")
        return StateMachine.MoveToStep("Cleanup")
    end

    StateMachine.State.SpawnCoords = SpawnData

    StateMachine.TargetPlayerId = Source
    StateMachine.State.CallerPlayerId = Args.CallerPlayerId
    StateMachine.State.DestinationCoords = Args.DestinationCoords

    -- Move to the loading step
    StateMachine.MoveToStep("Load")
end
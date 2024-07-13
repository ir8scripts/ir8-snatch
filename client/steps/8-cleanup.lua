-- @Cleanup
-- Handles clean up of process
StateMachine.Steps.Cleanup = function ()

    -- Cleanup existing entities and reset state

    if StateMachine.State.DriverEntity then
        if DoesEntityExist(StateMachine.State.DriverEntity) then 
            IR8.Utilities.DebugPrint("Entity " .. StateMachine.State.DriverEntity .. " exists... Attempting to remove")
            EntityManager.DeleteNetworkEntity("Ped", StateMachine.State.DriverEntity)
        end
    end

    if StateMachine.State.SnatcherEntity then
        if DoesEntityExist(StateMachine.State.SnatcherEntity) then 
            IR8.Utilities.DebugPrint("Entity " .. StateMachine.State.SnatcherEntity .. " exists... Attempting to remove")
            EntityManager.DeleteNetworkEntity("Ped", StateMachine.State.SnatcherEntity)
        end
    end

    if StateMachine.State.VehicleEntity then
        if DoesEntityExist(StateMachine.State.VehicleEntity) then 
            IR8.Utilities.DebugPrint("Entity " .. StateMachine.State.VehicleEntity .. " exists... Attempting to remove")
            EntityManager.DeleteNetworkEntity("Vehicle", StateMachine.State.VehicleEntity)
        end
    end

    -- Reset state to default state
    StateMachine.State = StateMachine.DefaultState

    lib.callback.await(IR8.Config.ServerCallbackPrefix .. 'Cleanup', false)
end
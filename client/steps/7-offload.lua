-- @Offload
-- Handles exiting of transport
StateMachine.Steps.Offload = function ()
    IR8.Utilities.DebugPrint("StateMachine.Steps.Offload called")

    -- Set vehicle state
    TaskVehicleTempAction(StateMachine.State.DriverEntity, StateMachine.State.VehicleEntity, 6, 2000)
    SetVehicleHandbrake(StateMachine.State.VehicleEntity, true)
    SetVehicleEngineOn(StateMachine.State.VehicleEntity, false, true, false)
    SetVehicleDoorsLocked(StateMachine.State.VehicleEntity, 1)

    -- Remove player from vehicle
    CreateThread(function()
        Wait(1000)
        TaskLeaveVehicle(PlayerPedId(), StateMachine.State.VehicleEntity, 16)
    end)

    -- Wait for a few seconds
    Wait(5000)

    -- Make the vehicle drive off
    TaskVehicleDriveWander(StateMachine.State.DriverEntity, StateMachine.State.VehicleEntity, 10.0, 786603)

    -- Remove the vehicle after a certain amount of time
    CreateThread(function()
        local timeout = 30000

        -- Update timer while entity still exists
        while DoesEntityExist(StateMachine.State.SnatcherEntity) and timeout > 0 do
            timeout = timeout - 1000
            Wait(1000)
        end

        if StateMachine.State.VehicleEntity then
            StateMachine.MoveToStep("Cleanup")
        end
    end)

    -- If vehcile still exists, remove it
    while DoesEntityExist(StateMachine.State.VehicleEntity) do

        if #(GetEntityCoords(StateMachine.State.VehicleEntity) - GetEntityCoords(PlayerPedId())) >= 90.0 then
            EntityManager.DeleteNetworkEntity("Vehicle", StateMachine.State.VehicleEntity)
        end

        Wait(1000)
    end
end
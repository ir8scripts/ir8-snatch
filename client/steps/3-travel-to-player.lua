-- @TravelToPlayer
-- Handles traveling to player
StateMachine.Steps.TravelToPlayer = function ()
    IR8.Utilities.DebugPrint("StateMachine.Steps.TravelToPlayer called")
    lib.callback.await(IR8.Config.ServerCallbackPrefix .. 'NotifySnatcher', false, "Success", "Transport enroute to player", "success")

    SetVehicleSiren(StateMachine.State.VehicleEntity, true)
    local Coords = GetEntityCoords(PlayerPedId())

    TaskVehicleDriveToCoordLongrange(
        StateMachine.State.DriverEntity, 
        StateMachine.State.VehicleEntity, 
        Coords.x,
        Coords.y,
        Coords.z,
        22.0, 
        316, 
        10.0
    )

    StateMachine.State.Vehicle.Driving = true
    StateMachine.State.Vehicle.Stopped = false

    CreateThread(function() -- loop to check if ped is driving or not
        Wait(1000)

        while (GetScriptTaskStatus(StateMachine.State.DriverEntity, 0x21D33957) ~= 7) and #(Coords.xy - GetEntityCoords(StateMachine.State.VehicleEntity).xy) >= 20 and StateMachine.State.Vehicle.Driving do
            Wait(1000)
            Coords = GetEntityCoords(PlayerPedId())
        end

        StateMachine.State.Vehicle.Stopped = true
        StateMachine.State.Vehicle.Arrived = true
        StateMachine.State.Vehicle.Driving = false
        
        StateMachine.MoveToStep("OnArrival")
    end)
end
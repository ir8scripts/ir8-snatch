-- @GrabPlayer
-- Handles logic for grabbing the player
StateMachine.Steps.GrabPlayer = function(Source, Args)
    IR8.Utilities.DebugPrint("StateMachine.Steps.GrabPlayer called")

    Wait(1000)

    if Args.DidFollow then 
        -- Animate and task ped with grabbing player
        IR8.Utilities.LoadAnimationDictionary("missfinale_c2mcs_1")
        TaskPlayAnim(StateMachine.State.SnatcherEntity, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 8.0, -8.0, -1, 49, 0, false, false, false)
        AttachEntityToEntity(PlayerPedId(), StateMachine.State.SnatcherEntity, 0, 0.27, 0.15, 0.63, 0.5, 0.5, 180, false, false, false, false, 2, false)
        IR8.Utilities.LoadAnimationDictionary("nm")
        TaskPlayAnim(PlayerPedId(), "nm", "firemans_carry", 8.0, -8.0, 100000, 33, 0, false, false, false)
        Wait(1000)
    end

    -- Wait until the snatcher is in the car
    CreateThread(function()
        while GetVehiclePedIsIn(StateMachine.State.SnatcherEntity, true) ~= StateMachine.State.VehicleEntity do
            Wait(0)
        end
    end)

    -- Make snatcher enter vehicle
    TaskEnterVehicle(StateMachine.State.SnatcherEntity, StateMachine.State.VehicleEntity, IR8.Config.AI.TimeoutBeforeWarpIntoVehicle, 1, 2.0, 1, 0)
    SetPedKeepTask(StateMachine.State.SnatcherEntity, true)
    while GetVehiclePedIsIn(StateMachine.State.SnatcherEntity, false) ~= StateMachine.State.VehicleEntity do
        Wait(200)
    end

    -- Remove entity from snatcher then warp them into the vehicle
    DetachEntity(PlayerPedId(), false, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), StateMachine.State.VehicleEntity, 2)

    -- Clear tasks for both snatcher and player
    ClearPedTasks(StateMachine.State.SnatcherEntity)
    ClearPedTasks(PlayerPedId())

    Wait(1000)

    SetVehicleDoorsLocked(StateMachine.State.VehicleEntity, 4)
    StateMachine.MoveToStep("TravelToDestination")
end

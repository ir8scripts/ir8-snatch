-- @OnArrival
-- Handles logic when arrived to player
StateMachine.Steps.OnArrival = function ()
    IR8.Utilities.DebugPrint("StateMachine.Steps.OnArrival called")
    lib.callback.await(IR8.Config.ServerCallbackPrefix .. 'NotifySnatcher', false, "Success", "Transport has arrived at player's position", "success")

    TaskVehicleTempAction(StateMachine.State.SnatcherEntity, StateMachine.State.VehicleEntity, 6, 2000)
    SetVehicleHandbrake(StateMachine.State.VehicleEntity, true)
    ClearPedTasks(StateMachine.State.SnatcherEntity)

    -- Move snatcher towards player
    Wait(1000)
    TaskLeaveVehicle(StateMachine.State.SnatcherEntity, StateMachine.State.VehicleEntity, 0)

    if IR8.Config.PedsHaveWeapons and IR8.Config.PedWeaponHash and IR8.Config.PedWeaponAmmo then
        SetCurrentPedWeapon(StateMachine.State.SnatcherEntity, GetHashKey(IR8.Config.PedWeaponHash), true)
    end

    local timeout = 20000
    local didFollow = true
    TaskFollowToOffsetOfEntity(StateMachine.State.SnatcherEntity, PlayerPedId(), 0.0, 0.0, 0.0, 2.0, 300000, 0.1, true)
    while #(GetEntityCoords(StateMachine.State.SnatcherEntity) - GetEntityCoords(PlayerPedId())) > 2 and timeout >= 0 do
        Wait(1000)

        if timeout == 0 then
            didFollow = false
        end
        
        timeout = timeout - 1000
    end

    StateMachine.MoveToStep("GrabPlayer", PlayerPedId(), { DidFollow = didFollow })
end
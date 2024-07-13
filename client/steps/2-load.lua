-- @Load
-- Handles loading of npcs and vehicles
StateMachine.Steps.Load = function ()
    IR8.Utilities.DebugPrint("StateMachine.Steps.Load called")

    IR8.Utilities.DebugPrint("Spawning entities at " .. json.encode(StateMachine.State.SpawnCoords))
    EntityManager.CreateVehicle(StateMachine.State.SpawnCoords)
    EntityManager.CreateDriver(StateMachine.State.SpawnCoords)
    EntityManager.CreateSnatcher(StateMachine.State.SpawnCoords)

    Wait(2000)

    -- Places entities inside of vehicle
    SetPedIntoVehicle(StateMachine.State.DriverEntity, StateMachine.State.VehicleEntity, -1)
    SetPedIntoVehicle(StateMachine.State.SnatcherEntity, StateMachine.State.VehicleEntity, 0)

    if IR8.Config.PedsHaveWeapons and IR8.Config.PedWeaponHash and IR8.Config.PedWeaponAmmo then
        SetCurrentPedVehicleWeapon(StateMachine.State.SnatcherEntity, GetHashKey(IR8.Config.PedWeaponHash))
    end

    StateMachine.MoveToStep("TravelToPlayer")
end
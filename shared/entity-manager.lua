EntityManager = {

    PreloadModels = function ()
        RequestModel(GetHashKey(IR8.Config.DriverModel))
        while (not HasModelLoaded(GetHashKey(IR8.Config.DriverModel))) do
            Citizen.Wait(1)
        end

        RequestModel(GetHashKey(IR8.Config.SnatcherModel))
        while (not HasModelLoaded(GetHashKey(IR8.Config.SnatcherModel))) do
            Citizen.Wait(1)
        end

        RequestModel(GetHashKey(IR8.Config.VehicleModel))
        while (not HasModelLoaded(GetHashKey(IR8.Config.VehicleModel))) do
            Citizen.Wait(1)
        end

        IR8.Utilities.DebugPrint("All models loaded successfully")
    end,

    CreateDriver = function (Location)
        local PedData = IR8.Utilities.CreateNetworkPed(
            IR8.Config.DriverModel,
            Location.Coords.x,
            Location.Coords.y,
            Location.Coords.z,
            Location.Heading
        )

        IR8.Utilities.DebugPrint("Driver was spawned successfully")

        StateMachine.State.DriverEntity = NetworkGetEntityFromNetworkId(PedData.NetworkId)
        StateMachine.State.DriverNetworkId = PedData.NetworkId
        EntityManager.ConfigurePedSettings(StateMachine.State.DriverNetworkId)
    end,

    CreateSnatcher = function (Location)
        local PedData = IR8.Utilities.CreateNetworkPed(
            IR8.Config.DriverModel,
            Location.Coords.x,
            Location.Coords.y,
            Location.Coords.z,
            Location.Heading
        )

        IR8.Utilities.DebugPrint("Snatcher was spawned successfully")

        StateMachine.State.SnatcherEntity = NetworkGetEntityFromNetworkId(PedData.NetworkId)
        StateMachine.State.SnatcherNetworkId = PedData.NetworkId
        EntityManager.ConfigurePedSettings(StateMachine.State.SnatcherNetworkId)
    end,

    CreateVehicle = function (Location)
        local VehicleData = IR8.Utilities.CreateNetworkVehicle(
            IR8.Config.VehicleModel, 
            Location.Coords.x, 
            Location.Coords.y, 
            Location.Coords.z, 
            Location.Heading
        )

        IR8.Utilities.DebugPrint("Vehicle was spawned successfully")

        StateMachine.State.VehicleEntity = NetworkGetEntityFromNetworkId(VehicleData.NetworkId)
        StateMachine.State.VehicleNetworkId = VehicleData.NetworkId
        EntityManager.ConfigureVehicleSettings(StateMachine.State.VehicleNetworkId)
    end,

    ConfigurePedSettings = function (NetworkId)
        local Entity = NetworkGetEntityFromNetworkId(NetworkId)

        if IR8.Config.PedsHaveWeapons and IR8.Config.PedWeaponHash and IR8.Config.PedWeaponAmmo then
            GiveWeaponToPed(Entity, GetHashKey(IR8.Config.PedWeaponHash), IR8.Config.PedWeaponAmmo, false, true)
        end

        SetEntityInvincible(Entity, IR8.Config.AI.Peds.Invincible)
        SetPedAccuracy(Entity, IR8.Config.AI.Peds.Accuracy)
        SetPedArmour(Entity, IR8.Config.AI.Peds.Armor)

        -- Combat Attributes (https://docs.fivem.net/natives/?_0x9F7794730795E019)
        SetPedCombatAttributes(Entity, 17, IR8.Config.AI.Peds.AlwaysFlee) -- AlwaysFlee
        SetPedCombatAttributes(Entity, 5, IR8.Config.AI.Peds.AlwaysFight) -- Always Fight
        SetPedCombatAttributes(Entity, 46, IR8.Config.AI.Peds.CanFightArmedPedsWhenNotArmed) -- CanFightArmedPedsWhenNotArmed
        SetPedCombatAttributes(Entity, 54, IR8.Config.AI.Peds.AlwaysEquipBestWeapon) -- AlwaysEquipBestWeapon
        SetPedCombatAttributes(Entity, 0, IR8.Config.AI.Peds.CanUseCover) -- CanUseCover
        SetPedCombatAttributes(Entity, 13, IR8.Config.AI.Peds.CanUseCover) -- CanUseCover

        -- Never flee
        SetPedFleeAttributes(Entity, 0, false)
    end,

    ConfigureVehicleSettings = function (NetworkId)
        local Entity = NetworkGetEntityFromNetworkId(NetworkId)
        SetEntityInvincible(Entity, IR8.Config.AI.Vehicle.Invincible)
        SetVehicleDirtLevel(Entity, 0.0)
        SetVehicleMod(Entity, 13, (GetNumVehicleMods(Entity, 13) - 2), false)
        SetVehicleMod(Entity, 15, (GetNumVehicleMods(Entity, 15) - 2), false)
        SetVehicleMod(Entity, 12, (GetNumVehicleMods(Entity, 12) - 2), false)
        SetVehicleStrong(Entity, true)
    end,

    DeleteNetworkEntity = function (Type, Entity)

        -- Check if it exists first
        if DoesEntityExist(Entity) then 

            -- Based on type, do deletion
            if (Type == "Ped") then
                DeletePed(Entity)
            elseif (Type == "Vehicle") then
                DeleteVehicle(Entity)
            end

            IR8.Utilities.DebugPrint("Entity[" .. Type .. "][" .. Entity .. "] was deleted")
        else
            IR8.Utilities.DebugPrint("Entity[" .. Type .. "][" .. Entity .. "] cannot be removed")
        end
    end
}
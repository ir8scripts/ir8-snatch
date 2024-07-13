-- @TravelToDestination
-- Handles logic for traveling to destination
StateMachine.Steps.TravelToDestination = function ()
    IR8.Utilities.DebugPrint("StateMachine.Steps.TravelToDestination called")
    lib.callback.await(IR8.Config.ServerCallbackPrefix .. 'NotifySnatcher', false, "Success", "Player was snatched and enroute to distination", "success")

    -- Set coords for destination and drive to it
    local coords = IR8.Config.Destination

    -- If not called on self, set destination coords of caller if enabled
    if IR8.Config.CallerDestinationEnabled and StateMachine.State.TargetPlayerId ~= StateMachine.State.CallerPlayerId then
        coords = StateMachine.State.DestinationCoords
    end

    TaskVehicleDriveToCoordLongrange(StateMachine.State.DriverEntity, StateMachine.State.VehicleEntity, coords.x, coords.y, coords.z, 33.0, 524604, 10.0)

    -- Update state for vehicle
    StateMachine.State.Vehicle.Driving = true
    StateMachine.State.Vehicle.Stopped = false
    StateMachine.State.Vehicle.Arrived = false

    -- If already in a loop, just return
    if StateMachine.State.Vehicle.Loop == true then 
        return 
    else 
        -- Set state for vehicle loop
        StateMachine.State.Vehicle.Loop = true

        -- Start heading to the destination
        CreateThread(function()
            Wait(2000)

            -- If vehicle is still driving to destination
            while StateMachine.State.Vehicle.Driving and not StateMachine.State.Vehicle.Stopped do
                local VehicleCoords = GetEntityCoords(StateMachine.State.VehicleEntity)

                -- Check if they made it
                if (GetScriptTaskStatus(StateMachine.State.DriverEntity, 0x21D33957) == 7) or #(VehicleCoords.xy - coords.xy) <= 30.0 then
                    StateMachine.State.Vehicle.Driving = false
                    StateMachine.State.Vehicle.Stopped = true
                    SetVehicleSiren(StateMachine.State.VehicleEntity, false)
                end

                -- Check if vehicle wrecked
                if IsEntityUpsidedown(StateMachine.State.VehicleEntity) then
                    StateMachine.State.Vehicle.Driving = false
                    StateMachine.State.Vehicle.Stopped = true
                    StateMachine.State.Vehicle.Wrecked = true
                    SetVehicleSiren(StateMachine.State.VehicleEntity, false)
                    lib.callback.await(IR8.Config.ServerCallbackPrefix .. 'NotifySnatcher', false, "Error", "Transport wrecked while enroute to destination", "error")
                end

                Wait(2000)
            end

            -- Set the loop to false
            StateMachine.State.Vehicle.Loop = false
            
            -- Depending on state, do logic before offloading
            if StateMachine.State.Vehicle.Stopped and not StateMachine.State.Vehicle.Wrecked then
                lib.callback.await(IR8.Config.ServerCallbackPrefix .. 'NotifySnatcher', false, "Success", "Player was dropped off at the destination", "success")
                PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", true)
            elseif StateMachine.State.Vehicle.Wrecked then
                ClearPedTasks(StateMachine.State.DriverEntity)
            end
            
            StateMachine.MoveToStep("Offload")
        end)
    end
end
-- Because of the order of inclusion in fxmanifest, 
-- you should have full access to StateMachine here:
--
-- StateMachine.DefaultState 
-- StateMachine.State 
-- StateMachine.Steps
-- Example: StateMachine.MoveToStep("Init", ..)

RegisterNetEvent(IR8.Config.ClientCallbackPrefix .. "Init")
AddEventHandler (IR8.Config.ClientCallbackPrefix .. "Init", function(caller, coords)
    StateMachine.MoveToStep("Init", source, {
        CallerPlayerId = caller,
        DestinationCoords = coords
    })
end)

RegisterNetEvent(IR8.Config.ClientCallbackPrefix .. "Cancel")
AddEventHandler (IR8.Config.ClientCallbackPrefix .. "Cancel", function()
    StateMachine.MoveToStep("Cleanup")
end)

-------------------------------------------------
-- 
-- CLEANUP ON RESOURCE STOP
-- 
-------------------------------------------------
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if StateMachine.State.InProgress then 
            StateMachine.MoveToStep("Cleanup")
        end
    end
end)
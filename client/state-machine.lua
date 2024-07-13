StateMachine = {}

-------------------------------------------------
-- 
-- STATE MACHINE DEFAULT STATE
-- 
-------------------------------------------------
StateMachine.DefaultState = {

    -- Current step of state machine
    CurrentStep = "Init",

    SpawnCoords = nil,

    -- Target and caller ids
    TargetPlayerId = false,
    CallerPlayerId = false,

    -- Snatcher state vars
    SnatcherNetworkId = false,
    SnatcherEntity = false,

    -- Driver state vars
    DriverNetworkId = false,
    DriverEntity = false,
    
    -- Vehicle state vars
    VehicleNetworkId = false,
    VehicleEntity = false,

    Vehicle = {
        Driving = false,
        Arrived = false,
        Stopped = true,
        Wrecked = false,
        Loop = false
    }
}

-- Set the current state to default state initially
StateMachine.State = StateMachine.DefaultState

-------------------------------------------------
-- 
-- STATE MACHINE METHODS
-- 
-------------------------------------------------
StateMachine.MoveToStep = function (Step, Source, Args)

    IR8.Utilities.DebugPrint("Attempting to move to StateMachine.Steps." .. Step)

    if not StateMachine.Steps[Step] then
        IR8.Utilities.DebugPrint("StateMachine.Steps." .. Step .. ": Does not exist")
        return false
    end

    if Args then
        if not type(Args) == "table" then
            Args = {}
            IR8.Utilities.DebugPrint("StateMachine.MoveToStop(): p2 is required to be a table")
        end
    end

    -- Update state and call step
    StateMachine.State.CurrentStep = Step
    StateMachine.Steps[Step](Source, Args)
end

StateMachine.SetState = function (data)
    if type(data) ~= "table" then return end

    for k, v in pairs(data) do
        StateMachine.State[k] = v
    end
end

-------------------------------------------------
-- 
-- STATE MACHINE STEPS
-- 
-------------------------------------------------
StateMachine.Steps = {}
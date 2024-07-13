IR8.Utilities = {
    DebugPrint = function(...)
        if not IR8.Config.Debugging then
            return
        end

        local args<const> = {...}

        local appendStr = ''
        for _, v in ipairs(args) do
            appendStr = appendStr .. ' ' .. tostring(v)
        end

        print(appendStr)
    end,
    
    -- Server side notification
    NotifyFromServer = function (source, id, title, message, type)
        TriggerClientEvent('ox_lib:notify', source, {
            id = id,
            title = title,
            description = message,
            type = type
        })
    end,

    -- Client side notification
    Notify = function (id, title, message, type)
        lib.notify({
            id = id,
            title = title,
            description = message,
            type = type
        })
    end,

    -- Creates a blip on the map
    CreateBlip = function (coords, title)
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 161)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.65)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(title)
        EndTextCommandSetBlipName(blip)
        return blip
    end,

    -- Creates an NPC
    CreateNetworkPed = function (modelHash, x, y, z, heading)
        local CreatedPed = CreatePed(4, modelHash , x, y, z, heading, true, true)
        while not DoesEntityExist(CreatedPed) do Citizen.Wait(10) end
        return {
            NetworkId = NetworkGetNetworkIdFromEntity(CreatedPed),
            EntityId = CreatedPed
        }
    end,

    -- Creates a Vehicle
    CreateNetworkVehicle = function (modelHash, x, y, z, heading)
        local CreatedVehicle = CreateVehicle(modelHash , x, y, z, heading, true, true)
        while not DoesEntityExist(CreatedVehicle) do Citizen.Wait(10) end
        return {
            NetworkId = NetworkGetNetworkIdFromEntity(CreatedVehicle),
            EntityId = CreatedVehicle
        }
    end,

    -- Loads an animation 
    LoadAnimationDictionary = function (dictionary)
        RequestAnimDict(dictionary)
        while not HasAnimDictLoaded(dictionary) do
            Citizen.Wait(1)
        end
    end,

    -- Gets all blips and returns id
    GetAllBlips = function ()
        local blips = {}
        for k = 0, IR8.Config.BlipCount, 1 do
            local blip = GetFirstBlipInfoId(k)
            if DoesBlipExist(blip) then
                table.insert(blips, blip)
                while true do
                    local blip = GetNextBlipInfoId(k)
                    if DoesBlipExist(blip) then
                        table.insert(blips, blip)
                    else
                        break
                    end
                end
            end
        end
        return blips
    end,

    -- Get pairs by keys from table
    PairsByKeys = function (t, f)
        local a = {}

        for n in pairs(t) do
            table.insert(a, n)
        end

        table.sort(a, f)
        local i = 0

        local iter = function ()
            i = i + 1
            if a[i] == nil then
                return nil
            else
                return a[i], t[a[i]]
            end
        end

        return iter
    end,

    GetClosestSpawnPoint = function (Coords)
        local NewSpawnCoords = nil
        for _, v in IR8.Utilities.PairsByKeys(IR8.Utilities.GetAllBlips()) do 
            if #(Coords - GetBlipCoords(v)) <= 300 then 
                NewSpawnCoords = GetBlipCoords(v) 
                break 
            end 
        end

        if not NewSpawnCoords then 
            return false
        end

        local _, TempLocation, Heading = GetClosestVehicleNodeWithHeading(NewSpawnCoords.x, NewSpawnCoords.y, NewSpawnCoords.z, 1, 3.0, 0)

        return {
            Coords = TempLocation,
            Heading = Heading
        }
    end,
}
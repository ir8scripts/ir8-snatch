IR8 = {}

IR8.Config = {

    -- Enable/disable prints for logs
    Debugging = false,

    -- Event related vars
    ServerCallbackPrefix = "ir8-snatch:Server", -- Change this if you rename the resource folder
    ClientCallbackPrefix = "ir8-snatch:Client", -- Change this if you rename the resource folder

    -- Command information
    Commands = {

        -- Starting a snatch command
        SnatchInitiate = "snatch",
        SnatchInitiateDescription = "Snatches a player",

        -- Canceling a snatch command
        SnatchCancel = "snatchcancel",
        SnatchCancelDescription = "Cancels a snatch in progress",

        -- Permissions for commands
        Permissions = {
            'group.admin'
        }
    },

    -- AI Ped Weapon Configuration
    PedsHaveWeapons = true,
    PedWeaponHash = 'WEAPON_ASSAULTRIFLE',
    PedWeaponAmmo = 200,

    -- Driver NPC model hash
    DriverModel = 's_m_y_swat_01',

    -- Snatcher NPC model hash
    SnatcherModel = 's_m_y_swat_01',

    -- Vehicle model for transport
    VehicleModel = 'fbi2',

    -- Default destination if caller calls on self.
    Destination = vector3(410.78, -1003.54, 29.27),

    -- Takes player to the destination of the caller if enabled.
    -- If not enabled, it will default to the destination coords defined above in Destination
    CallerDestinationEnabled = true,

    -- Build Configurations
    BlipCount = 883, -- build 3095 (Increment amount if you have custom blips)

    -- AI Configuration
    AI = {

        -- Amount of miliseconds before player is warped into vehcile
        TimeoutBeforeWarpIntoVehicle = 30000, -- Thirty seconds by default

        -- AI Ped configuration
        Peds = {
            Invincible = true,
            Accuracy = 85,
            Armor = 100,
            AlwaysFlee = false,
            AlwaysFight = true,
            CanFightArmedPedsWhenNotArmed = true,
            AlwaysEquipBestWeapon = true,
            CanUseCover = true
        },

        -- AI Vehicle Configuration
        Vehicle = {
            Invincible = true,
        }
    },

    -- Notifications
    Notifications = {
        PlayerNotAvailable = "Player does not exist, or is not online",
        SnatchStarted = "Snatching is in progress"
    }
}
# Snatch Script

A snatch n grab script for FiveM. This will work with any framework, just note the dependencies listed below.

Need to grab a player in your server and bring them to a specific location? Use this script, by simply running a command, a transport of two NPCs (a driver and a snatcher) will go to the player's location and grab them then bring them to the location where the caller is. Receive real time notifications throughout the process to keep track of exactly where in the process the transport is. This script is very configurable, and is open source so you can make any adjustment you need to fit your server.

## Dependencies
- qb-core
- ox_lib

## Installation

Drop into your resources folder and ensure:

```
ensure ir8-snatch
```

## Configuration:

```
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
    BlipCount = 900,

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

    Notifications = {
        PlayerNotAvailable = "Player does not exist, or is not online",
        SnatchStarted = "Snatching is in progress"
    }
}
```

## Notice

Please do not rename the files in the `client/steps` folder. These are named for order of inclusion. Renaming may result in unwanted results.

## Commands by Default

`/snatch [playerid]` - Initiates the snatching of the target player
`/snatchcancel` - Cancels a snatch in progress
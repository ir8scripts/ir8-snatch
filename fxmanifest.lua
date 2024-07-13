fx_version "cerulean"

description "IR8 Snatch & Grab"
author "IR8 Scripts"
version '1.0.1'
lua54 'yes'
games { "gta5" }

-- Notice naming convention and ordering 
-- of includes for state machine to work properly.
client_script {
    "client/state-machine.lua",
    "client/steps/**/*",
    "client/client.lua"
}

server_script { "server/**/*" }

shared_script {
    "@ox_lib/init.lua",
    "shared/**/*"
}

escrow_ignore {
	'shared/config.lua',
	'README.md',
}
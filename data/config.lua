Config = {}

Config.Debug = true -- Turn on if you want error logging.
Config.MinAmbulanceCount = 2 --# The minimum amount of ambulance that must be online to block AllowedJobs from using the newlife command
Config.DiscordLogs = false -- Turn on for discordlogs
Config.Webhook = "" -- If `Config.DiscordLogs` is enabled you can insert your webhook in here.

Config.AllowedJobs = {
    ["police"] = true,
    ["ambulance"] = true,
    ["kmar"] = true
}

Config.RespawnLocations ={
    ["graveyard"] = vector3(295.0, -1444.0, 29.0),
    ["hospital"] = vector3(338.8, -1394.5, 32.5)
}

-- Which ambulance job system your server uses
-- Options: "wasabi_ambulance", "esx_ambulancejob", "frp-ambulance", "srp-ambulance", "ars_ambulancejob"
Config.Ambulancejob = "esx_ambulancejob"

return Config
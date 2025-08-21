Config = {}

Config.Debug = true
Config.Fixes = false -- Turn on if ESX.GetExtendedPlayers() doesn't work
Config.MinAmbulanceCount = 2 --# The minimum amount of ambulance that must be online to block AllowedJobs from using the newlife command

Config.AllowedJobs = {
    "police",
    "kmar",
    "ambulance"
}

Config.RespawnLocations ={
    ["graveyard"] = vector3(295.0, -1444.0, 29.0),
    ["hospital"] = vector3(338.8, -1394.5, 32.5)
}

Config.Ambulancejob = "wasabi_ambulance" --# Options [ "wasabi_ambulance", "esx_ambulancejob", "frp-ambulance", "srp-ambulance" ]

return Config
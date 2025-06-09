ESX = exports["es_extended"]:getSharedObject()

-- [[ IMPORTS ]]
local Config = require("data.config")

-- [[ CALLBACKS ]] --
vx.callback.register("walter-newlife:server:isAllowed", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return false
    end

    for _, job in pairs(Config.AllowedJobs) do
        if xPlayer.job.name == job then
            return true
        end
    end

    return false
end)

vx.callback.register("walter-newlife:server:returnAmbulance", function()
    local count = 0
    local players = ESX.GetExtendedPlayers()
    if not players then
        return count
    end

    for _, player in pairs(players) do
        if player.job.name == "ambulance" then
            count = count + 1
        end
    end

    return count
end)

vx.callback.register("walter-newlife:server:fetchConfig", function()
    return Config
end)

-- [[ EVENT ]] --
RegisterNetEvent("walter-newlife:server:respawn", function(location)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return 
    end

    local coords = Config.RespawnLocations[location]
    if not coords then
        vx.print.debug("invalid spawn location")
        return
    end

    if string.lower(Config.Ambulancejob or "") == "esx_ambulancejob" then
        TriggerClientEvent("esx_ambulancejob:revive", src)
    elseif string.lower(Config.Ambulancejob or "") == "wasabi_ambulance" then
        exports.wasabi_ambulance:RevivePlayer(src)
    end

    TriggerClientEvent("walter-newlife:client:teleport", src, coords)
end)
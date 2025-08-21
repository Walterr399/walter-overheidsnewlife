ESX = exports["es_extended"]:getSharedObject()

-- [[ IMPORTS ]]
local Config = require("data.config")

-- [[ CALLBACKS ]] --
lib.callback.register("walter-newlife:server:isAllowed", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        if Config.Debug then
            print("[DEBUG] Failed to get coords")
        end
        return false
    end

    for _, job in pairs(Config.AllowedJobs) do
        if xPlayer.job.name == job then
            return true
        end
    end

    return false
end)

lib.callback.register("walter-newlife:server:returnAmbulance", function()
    local count = 0
    local players = {}

    if Config.Fixes then
        for i = 0, GetNumPlayerIndices() - 1 do
            local playerId = GetPlayerFromIndex(i)
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then table.insert(players, xPlayer) end
        end
    else
        players = ESX.GetExtendedPlayers()
    end

    if not players then
        if Config.Debug then
            print("Error while trying to fetch players using `ESX.GetExtendedPlayers()`, you can fix this error by turning `Config.Fixes` on.")
        end
        return count
    end

    for _, player in pairs(players) do
        if player.job.name == "ambulance" then
            count = count + 1
        end
    end

    return count
end)

lib.callback.register("walter-newlife:server:fetchConfig", function()
    return Config
end)

-- [[ EVENT ]] --
RegisterNetEvent("walter-newlife:server:respawn", function(location)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        if Config.Debug then
            print("[ERROR] Failed to get player")
        end
        return 
    end

    local coords = Config.RespawnLocations[location]

    if not coords then
        if Config.Debug then
            print("[ERROR] Failed to get coords")
        end
        return
    end

    if string.lower(Config.Ambulancejob or "") == "esx_ambulancejob" then
        TriggerClientEvent("esx_ambulancejob:revive", src)
    elseif string.lower(Config.Ambulancejob or "") == "wasabi_ambulance" then
        exports.wasabi_ambulance:RevivePlayer(src)
    elseif string.lower(Config.Ambulancejob or "") == "frp-ambulance" then
        TriggerClientEvent("frp-ambulance:client:staffrevive:player", src)
    elseif string.lower(Config.Ambulancejob or "") == "srp-ambulance" then
        TriggerClientEvent("srp:ambulance:revive", src)
    end

    SetTimeout(1000, function ()
        TriggerClientEvent("walter-newlife:client:teleport", src, coords)
    end)
end)
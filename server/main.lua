ESX = exports["es_extended"]:getSharedObject()

-- [[ IMPORTS ]]
local Config = require("data.config")

if Config.Debug then
    if not ESX then
        vx.print.debug("failed to fetch ESX")
    else
        vx.print.debug("ESX object fetched successfully")
    end
end

-- [[ CALLBACKS ]] --
vx.callback.register("walter-newlife:server:isAllowed", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        if Config.Debug then
            vx.print.debug(("Failed to get player for %s"):format(source))
        end
        return false
    end

    if Config.Debug then
        vx.print.debug(("Checking permissions for %s with job '%s'"):format(source, xPlayer.job.name))
    end

    for _, job in pairs(Config.AllowedJobs) do
        if xPlayer.job.name == job then
            if Config.Debug then
                vx.print.debug(("%s is allowed (job match: %s)"):format(source, job))
            end
            return true
        end
    end

    if Config.Debug then
        vx.print.debug(("%s is not allowed"):format(source))
    end

    return false
end)

vx.callback.register("walter-newlife:server:returnAmbulance", function()
    local count = 0
    local players = ESX.GetExtendedPlayers()

    if not players then
        if Config.Debug then
            vx.print.debug("Failed to get extended players")
        end
        return count
    end

    for _, player in pairs(players) do
        if player.job.name == "ambulance" then
            count = count + 1
            if Config.Debug then
                vx.print.debug(("rFound ambulance player - %s"):format(player.identifier or "unknown"))
            end
        end
    end

    if Config.Debug then
        vx.print.debug(("Total ambulance players - %d"):format(count))
    end

    return count
end)

vx.callback.register("walter-newlife:server:fetchConfig", function()
    if Config.Debug then
        vx.print.debug("Returning config")
    end
    return Config
end)

-- [[ EVENT ]] --
RegisterNetEvent("walter-newlife:server:respawn", function(location)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        if Config.Debug then
            vx.print.debug(("respawn: Invalid player (source: %s)"):format(src))
        end
        return 
    end

    local coords = Config.RespawnLocations[location]

    if not coords then
        if Config.Debug then
            vx.print.debug(("Invalid respawn location '%s' for player %s"):format(location or "nil", src))
        end
        return
    end

    if Config.Debug then
        vx.print.debug(("Reviving player %s at location '%s'"):format(src, location))
    end

    if string.lower(Config.Ambulancejob or "") == "esx_ambulancejob" then
        TriggerClientEvent("esx_ambulancejob:revive", src)
    elseif string.lower(Config.Ambulancejob or "") == "wasabi_ambulance" then
        exports.wasabi_ambulance:RevivePlayer(src)
    elseif string.lower(Config.Ambulancejob or "") == "frp-ambulance" then
        TriggerClientEvent("frp-ambulance:client:staffrevive:player", src)
    elseif string.lower(Config.Ambulancejob or "") == "srp-ambulance" then
        TriggerClientEvent("srp:ambulance:revive", src)
    else
        if Config.Debug then
            vx.print.debug(("Unknown ambulance job '%s'"):format(string.lower(Config.Ambulancejob or "")))
        end
    end

    SetTimeout(1000, function ()
        TriggerClientEvent("walter-newlife:client:teleport", src, coords)
        if Config.Debug then
            vx.print.debug(("Teleported player %s to coords %s"):format(src, json.encode(coords)))
        end
    end)
end)
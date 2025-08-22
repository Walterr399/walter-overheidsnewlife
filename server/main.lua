local Config = require "data.config"

function SendLog(title, message, color)
    if not Config.DiscordLogs then
        return false
    end

    if Config.Webhook == "" then
        if Config.Debug then
            print("^3[DEBUG]^0 ^1Discord logging is enabled, but no webhook URL is set in Config.Webhook^0")
        end
        return false
    end

    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 16777215,
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }

    PerformHttpRequest(Config.Webhook, function() end, "POST", json.encode({
        username = "WDEV - Newlife | All rigthts reserved.",
        embeds = embed
    }), { ["Content-Type"] = "application/json" })
end

lib.callback.register("walter-newlife:server:isAllowed", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return false
    end

    if not Config.AllowedJobs[xPlayer.job.name] then
        return false
    end

    return true
end)

lib.callback.register("walter-newlife:server:returnAmbulance", function()
    local count = 0
    local players = ESX.GetExtendedPlayers()

    if not players then
        if Config.Debug then
            print("^3[DEBUG]^0 ^1Error while trying to fetch players using ^0`ESX.GetExtendedPlayers()`^1, you can fix this by upgrading your ^0`es_extended`^0")
        end
        return count --# Returns 0, because it cannot fetch the amount of players.
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

RegisterNetEvent("walter-newlife:server:respawn", function(location)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return 
    end

    local coords = Config.RespawnLocations[location]

    if not coords then
        if Config.Debug then
            print(("^3[DEBUG]^0 ^1Failed to get coords^0"))
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
    elseif string.lower(Config.Ambulancejob or "") == "ars_ambulancejob" then
        TriggerClientEvent("ars_ambulancejob:healPlayer", src, {revive = true})
    end

    SetTimeout(1000, function ()
        TriggerClientEvent("walter-newlife:client:fade", src, coords)
        SetEntityCoords(GetPlayerPed(src), coords)
    end)

    SendLog(
        "Newlife Respawn",
        string.format("**%s** [%d] used /newlife and respawned at **%s**.",
        xPlayer.getName(), src, location),
        3066993
    )
end)
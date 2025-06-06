function openNewlifeMenu()
    local isDead = false

    if Config.Ambulancejob == "wasabi_ambulance" then
        isDead = exports.wasabi_ambulance:isPlayerDead(GetPlayerServerId(PlayerId()))
    else
        isDead = IsEntityDead(PlayerPedId())
    end

    if not isDead then
        vx.notify({
            title = "Niet dood",
            message = "Je bent niet dood.",
            type = "error"
        })
        return
    end

    local ambulanceCount = vx.callback.await("walter-newlife:server:returnAmbulance")
    if ambulanceCount > 2 then
        vx.notify({
            title = "Helaas",
            message = "Je kunt niet respawnen omdat er ambulancepersoneel aanwezig is.",
            type = "inform"
        })
        return
    end

    lib.registerContext({
        id = 'newlife_menu',
        title = 'Waar wil je respawnen?',
        options = {
            {
                title = 'Begraafplaats',
                onSelect = function()
                    vx.notify({
                        title = "Je wordt gereanimeerd...",
                        message = "Je wordt binnen 30 seconden gespawned bij de begraafplaats.",
                        type = "inform"
                    })
                    SetTimeout(30000, function()
                        vx.TriggerServerEvent("walter-newlife:server:respawn", "graveyard")
                    end)
                end
            },
            {
                title = 'Ziekenhuis',
                onSelect = function()
                    vx.notify({
                        title = "Je wordt gereanimeerd...",
                        message = "Je wordt binnen 30 seconden gespawned bij het ziekenhuis.",
                        type = "inform"
                    })
                    SetTimeout(30000, function()
                        vx.TriggerServerEvent("walter-newlife:server:respawn", "hospital")
                    end)
                end
            }
        }
    })

    lib.showContext("newlife_menu")
end

RegisterCommand("newlife", function()
    local isAllowed = vx.callback.await("walter-newlife:server:isAllowed")

    if not isAllowed then
        vx.notify({
            title = "Geen toegang",
            message = "Je hebt geen toegang tot dit commando.",
            type = "error"
        })
        return
    end

    openNewlifeMenu()
end, false)

RegisterNetEvent("walter-newlife:client:teleport")
AddEventHandler("walter-newlife:client:teleport", function(coords)
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
end)
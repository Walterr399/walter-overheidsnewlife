function OpenNewlifeMenu()
    local Config = lib.callback.await("walter-newlife:server:fetchConfig")
    local isDead = IsEntityDead(cache.ped)

    if Config.Ambulancejob == "wasabi_ambulance" then
        isDead = exports.wasabi_ambulance:isPlayerDead(GetPlayerServerId(PlayerId()))
    end

    if not isDead then
        lib.notify({
            title = "Fout!",
            description = "Je bent niet dood!",
            type = "error"
        })
        return
    end

    local ambulanceCount = lib.callback.await("walter-newlife:server:returnAmbulance")
    if ambulanceCount > Config.MinAmbulanceCount then
        lib.notify({
            title = "Fout!",
            description = "Je kunt niet respawnen omdat er ambulancepersoneel aanwezig is.",
            type = "error"
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
                    lib.notify({
                        title = "Je wordt gereanimeerd...",
                        description = "Je wordt binnen 30 seconden gespawned bij de begraafplaats.",
                        type = "inform"
                    })
                    SetTimeout(30000, function()
                        TriggerServerEvent("walter-newlife:server:respawn", "graveyard")
                    end)
                end
            },
            {
                title = 'Ziekenhuis',
                onSelect = function()
                    lib.notify({
                        title = "Je wordt gereanimeerd...",
                        description = "Je wordt binnen 30 seconden gespawned bij het ziekenhuis.",
                        type = "inform"
                    })
                    SetTimeout(30000, function()
                        TriggerServerEvent("walter-newlife:server:respawn", "hospital")
                    end)
                end
            }
        }
    })

    lib.showContext("newlife_menu")
end

RegisterCommand("newlife", function()
    local isAllowed = lib.callback.await("walter-newlife:server:isAllowed")

    if not isAllowed then
        lib.notify({
            title = "Fout!",
            description = "Je hebt geen toegang tot dit commando.",
            type = "inform"
        })
        return
    end

    OpenNewlifeMenu()
end, false)

RegisterNetEvent("walter-newlife:client:teleport", function(coords)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(50)
    end

    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, true)
    Wait(500)

    DoScreenFadeIn(1000)
end)
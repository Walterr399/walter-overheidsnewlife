lib.locale()

function OpenNewlifeMenu()
    local Config = lib.callback.await("walter-newlife:server:fetchConfig")
    local isDead = IsEntityDead(cache.ped)

    if Config.Ambulancejob == "wasabi_ambulance" then
        isDead = exports.wasabi_ambulance:isPlayerDead(GetPlayerServerId(PlayerId()))
    end

    if not isDead then
        return lib.notify({
            title = locale('error'),
            description = locale('error_not_dead'),
            type = "error"
        })
    end

    local ambulanceCount = lib.callback.await("walter-newlife:server:returnAmbulance")
    if ambulanceCount > Config.MinAmbulanceCount then
        return lib.notify({
            title = locale('error'),
            description = locale('error_ambulance'),
            type = "error"
        })
    end

    lib.registerContext({
        id = 'newlife_menu',
        title = locale('respawn_menu_title'),
        options = {
            {
                title = locale('respawn_graveyard'),
                onSelect = function()
                    lib.notify({
                        title = locale('respawn_notify_title'),
                        description = locale('respawn_graveyard_desc'),
                        type = "inform"
                    })
                    SetTimeout(30000, function()
                        TriggerServerEvent("walter-newlife:server:respawn", "graveyard")
                    end)
                end
            },
            {
                title = locale('respawn_hospital'),
                onSelect = function()
                    lib.notify({
                        title = locale('respawn_notify_title'),
                        description = locale('respawn_hospital_desc'),
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
        return lib.notify({
            title = locale('error'),
            description = locale('error_not_allowed'),
            type = "inform"
        })
    end

    OpenNewlifeMenu()
end, false)

RegisterNetEvent("walter-newlife:client:fade", function(coords)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(50)
    end

    Wait(500)

    DoScreenFadeIn(1000)
end)
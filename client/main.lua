ESX = nil

local isCountDownDeleteCar = false
local lastTimePlaySound = nil
local endSound = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.EventRoute['getSharedObject'], function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerServerEvent(script_name .. ':CheckEventTime')
end)

RegisterNetEvent(script_name .. ':CancelEvent')
AddEventHandler(script_name .. ':CancelEvent', function()
    isCountDownDeleteCar = false
    SendNUIMessage({ ShowMenu = false, })

    SendNUIMessage({
        transactionType = 'stopSound',
    })
end)


RegisterNetEvent(script_name .. ':eventstart')
AddEventHandler(script_name .. ':eventstart', function(text,_times)
    -- ค้นหาเสียงสุดท้ายตอนนับเวลาจบว่ามีหรือไม่

    isCountDownDeleteCar = true


    local times = _times * 60
    local matchTime = ESX.Round(times)
    Citizen.CreateThread(function()
        while matchTime > 0 and isCountDownDeleteCar do
            Citizen.Wait(1000)
            if matchTime > 0 then
                matchTime = matchTime - 1
            end

            local txtMin = ('%s'):format(minToClock(matchTime))
            local txtSec = ('%s'):format(secToClock(matchTime))

            local min = tonumber(txtMin) + 1

            if isCountDownDeleteCar then
                SendNUIMessage({
                    display = true,
                    IsPauseMenuActive = IsPauseMenuActive(),
                    titleText = text,
                    txtMin = txtMin,
                    txtSec = txtSec,
                })

                if matchTime == 0 then
                    isCountDownDeleteCar = false
                    lastTimePlaySound = nil
                    SendNUIMessage({ display = false, })
                end
            end
        end
    end)
end)

function secondsToClock(seconds)
    local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

    if seconds <= 0 then
        return 0, 0
    else
        local hours = string.format("%02.f", math.floor(seconds / 3600))
        local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
        local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

        return mins, secs
    end
end

function minToClock(seconds)
    local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

    if seconds <= 0 then
        return 0, 0
    else
        local hours = string.format("%02.f", math.floor(seconds / 3600))
        local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
        local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

        return mins
    end
end

function secToClock(seconds)
    local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

    if seconds <= 0 then
        return 0, 0
    else
        local hours = string.format("%02.f", math.floor(seconds / 3600))
        local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
        local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

        return secs
    end
end
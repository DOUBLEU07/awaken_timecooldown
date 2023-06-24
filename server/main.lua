ESX = nil
local timer = 0
local isEventStart = false
local textt = nil

TriggerEvent(Config.EventRoute['getSharedObject'], function(obj)
    ESX = obj
end)

------------------------------------------------
--- Register Commands เริ่มนับเวลาถอยหลังลบรถอัตโนมัติ ---
------------------------------------------------
RegisterCommand(Config.Command.command, function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.Command.group[xPlayer.getGroup()] then
        if args[1] ~= nil then
            local text = args[1]
            local minute = args[2]
            TriggerClientEvent(script_name .. ":eventstart", -1,text, minute)
            checkTimeLoad(minute, text)
        end
    end
end)

-----------------------------------------------------
--- Register Commands ยกเลิกการนับเวลาถอยหลังลบรถอัตโนมัติ ---
-----------------------------------------------------
RegisterCommand(Config.CanCelCommand.command, function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.CanCelCommand.group[xPlayer.getGroup()] then
        timer = 0
        isEventStart = false
        TriggerClientEvent(script_name .. ":CancelEvent", -1)
    end
end)

RegisterServerEvent(script_name .. ':CheckEventTime')
AddEventHandler(script_name .. ':CheckEventTime', function()
    if isEventStart then
        TriggerClientEvent(script_name .. ':eventstart', source,textt, timer / 60)
    end
end)

function checkTimeLoad(xTime,text)
    timer = xTime * 60
    textt = text
    isEventStart = true
    Citizen.CreateThread(function()
        while isEventStart do
            Citizen.Wait(1000)
            if timer == 0 then
                isEventStart = false
            end
            timer = timer - 1
        end
    end)
end

function checkTimeRunAuto()
    SetTimeout(1000, function()
        local date_local = os.date('%H:%M', os.time())
        if not isEventStart then
            for i = 1, #Config.Timer, 1 do
                local start_time = Config.Timer[i][1]
                if date_local == start_time then
                    TriggerClientEvent(script_name .. ':eventstart', -1, Config.Timer[i][3], Config.Timer[i][2])
                    checkTimeLoad(Config.Timer[i][2],Config.Timer[i][3])
                end
            end
        end
        checkTimeRunAuto()
    end)
end

checkTimeRunAuto()
script_name = GetCurrentResourceName()

Config = {}
Config.EventRoute = {
    ['getSharedObject'] = 'esx:getSharedObject', -- Default: 'esx:getSharedObject'
}


Config.Timer = {
	{"14:00",3,'กิจกรรม War Time'}, --time,type,text car or restart server minute
	{"16:00",3,'กิจกรรม School Time'},
	{"18:07",3,'กิจกรรม Farm Time'},
}

Config.Command = { -- /eventstart กิจกรรมHunter 10
    command = 'eventstart',
    group = {
        ['superadmin'] = true,
        ['admin'] = true,
    },
}

Config.CanCelCommand = {
    command = 'ccevent',
    group = {
        ['superadmin'] = true,
        ['admin'] = true,
    },
}
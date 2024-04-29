lib.locale()

Oi = {}
local okok = exports['okokNotify']

function Oi.Notify(title, desc, type)
    if Config.Notification == 'ox_lib' then
    lib.notify({
        title = title,
        description =  desc,
        type = type
    })
elseif Config.Notification == 'okok' then
    okok:Alert(title, desc, 5000, type)
elseif Config.Notification == 'custom' then
    -- Your code
else
    print('Notification system not found please check config.lua ---> Config.Notification and make sure that notification system is correct')
    return
    end
end


RegisterNetEvent("uniPark:Success")
AddEventHandler("uniPark:Success", function(cPlate)
    Oi.Notify(locale("title"), locale("bought_suc"):format(cPlate), 'success')
end)
RegisterNetEvent("uniPark:validTicket")
AddEventHandler("uniPark:validTicket", function(cPlate)
    Oi.Notify(locale("title"), locale("found_ticket"):format(cPlate), 'success')
end)
RegisterNetEvent("uniPark:expiredTicket")
AddEventHandler("uniPark:expiredTicket", function(cPlate)
    Oi.Notify(locale("title"), locale("expired"):format(cPlate), 'error')
end)
RegisterNetEvent("uniPark:invalidTicket")
AddEventHandler("uniPark:invalidTicket", function(cPlate)
    Oi.Notify(locale("title"), locale("invalid"):format(cPlate), 'error')
end)

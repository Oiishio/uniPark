RegisterNetEvent("uniPark:Success")
AddEventHandler("uniPark:Success", function(cPlate)  
    lib.notify({
        title = 'uniPark',
        description = 'Sekmingai nusipirkote bilietuka '..cPlate,
        type = 'success'
    })
end)
RegisterNetEvent("uniPark:validTicket")
AddEventHandler("uniPark:validTicket", function(cPlate)  
    lib.notify({
        title = 'uniPark',
        description = 'Rastas bilietukas su numeriais '..cPlate,
        type = 'success'
    })
end)
RegisterNetEvent("uniPark:expiredTicket")
AddEventHandler("uniPark:expiredTicket", function(cPlate)  
    lib.notify({
        title = 'uniPark',
        description = cPlate..' Bilietukas negalioja',
        type = 'error'
    })
end)
RegisterNetEvent("uniPark:invalidTicket")
AddEventHandler("uniPark:invalidTicket", function(cPlate)  
    lib.notify({
        title = 'uniPark',
        description = 'Bilietukas neegzistuoja su šiais numeriais '..cPlate,
        type = 'error'
    })
end)
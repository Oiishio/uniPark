--money checkas
local ParkingMeters = {
    "prop_parknmeter_01",
    "prop_parknmeter_02"
}

local carPlate = {}

exports.ox_target:addModel(ParkingMeters, {
    name = "parkingas",
    icon = "fa-solid fa-square-parking",
    label = "uniPark",
    distance = 1.5,
    onSelect = function(data)
        getClosestCars()
        local input = lib.inputDialog('uniPark', {            
            {type = 'slider', label = "Periodas (50€/h)", default = 1, icon = 'clock',  min = 1, max = 10, required = true,},
            {type = 'select', label = 'Valstybiniai numeriai', options =  carPlate, required = true},
            {type = 'date', disabled = true, label = 'Šiandienos data', icon = {'far', 'calendar'}, default = true, format = "DD/MM/YYYY"}
        })
        if not input then return end
        carPlate = {}
        TriggerServerEvent("uniPark:pay", input)
    end
})


exports.ox_target:addGlobalVehicle({
    name = "checkParking",
    icon = "fa-solid fa-square-parking",
    label = "Patikrinti Parkavimo Bilietuka",
    distance = 1.5,
    groups = Config.Jobs,
    onSelect = function(data)
        if lib.progressCircle({
            duration = 10000,
            position = 'bottom',
            label = 'Tikrinate parkavimo bilietuką',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missarmenian2',
                clip = 'lamar_texting'
            },
            prop = {
                model = `prop_phone_ing_03`,
                pos = vec3(0.00, 0.00, 0.00),
                rot = vec3(0.0, 0.0, 0)
            },
        }) then patikrintiBilietuka(GetVehicleNumberPlateText(data.entity)) else return end
        
    end
})

function patikrintiBilietuka(carPlate)
    TriggerServerEvent("uniPark:checkTicket", carPlate)
end

function getClosestCars()
    local vehiclePool = GetGamePool('CVehicle')

    for i = 1, #vehiclePool do 
        local dist = #(GetEntityCoords(vehiclePool[i]) - GetEntityCoords(GetPlayerPed(-1)))
        if dist < 10 then
            local plateText = GetVehicleNumberPlateText(vehiclePool[i])
            local found = false
            for _, carPlate in ipairs(carPlate) do
                if carPlate.value == plateText then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(carPlate, {value = plateText, label = plateText})
            end
        end
    end
end

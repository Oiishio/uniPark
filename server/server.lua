ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("uniPark:GiveTicket")
AddEventHandler("uniPark:GiveTicket", function(xPlayer, input)
    local valandos = input[1]
    local numeriai = input[2]
    local timestamp = math.floor(input[3] / 1000)
    local fDate = os.date('%Y-%m-%d %H:%M:%S', timestamp)
    local gTimestamp = timestamp + (3600 * valandos)
    local gLaikas = os.date('%Y-%m-%d %H:%M:%S', gTimestamp)
    insertTicket(xPlayer ,numeriai, valandos, fDate, gLaikas)
end)

RegisterNetEvent("uniPark:checkTicket")
AddEventHandler("uniPark:checkTicket", function(carPlate)
    local xPlayer = source
    local response = MySQL.query.await('SELECT `sData`, `pData`, `tPeriod`, `carPlate` FROM `unipark` WHERE `carPlate` = ?', {carPlate})
    local carPlatas = nil
    if response and #response > 0 then
        for i = 1, #response do
            local row = response[i]
            carPlatas = row.carPlate
            confirmValidity(xPlayer, checkTime(row.sData, row.pData), carPlatas, row.sData, row.tPeriod)
        end
    else
        TriggerClientEvent("uniPark:invalidTicket", xPlayer, carPlate)
    end
end)

RegisterNetEvent("uniPark:removeTicket")
AddEventHandler("uniPark:removeTicket", function(carPlate)
   MySQL.update.await('DELETE FROM `uniPark` WHERE carPlate = ?', {carPlate})
end)

RegisterNetEvent('uniPark:pay', function(input)
    local xPlayer = source
    local darbas = ESX.GetPlayerFromId(source).job.name
    TriggerClientEvent('esx:showNotification', source, 'Jūs nesate mechanikas', 'error', 4000)
	if not defaultPaymentMethod(xPlayer, Config.Price, input[1]) then return end
    TriggerEvent('uniPark:GiveTicket', xPlayer, input)
end)

function defaultPaymentMethod(playerId, price, time)
	local success = exports.ox_inventory:RemoveItem(playerId, 'money', price * time)
    local finalPrice = price * time

	if success then return true end

	local money = exports.ox_inventory:GetItem(source, 'money', false, true)

	TriggerClientEvent('ox_lib:notify', source, {
		type = 'error',
        title = 'uniPark',
		description = "Trūksta "..finalPrice.."€"
	})
end

function confirmValidity(xPlayer, valid, carPlate)
    if valid then 
        TriggerClientEvent("uniPark:validTicket", xPlayer, carPlate)
    else
        TriggerClientEvent("uniPark:expiredTicket", xPlayer, carPlate)
    end
end

function checkTime(fDate, gLaikas)
    local currentDateTime = os.date('%Y-%m-%d %H:%M:%S')

    local fDateExtracted = string.sub(fDate, 1, 19)
    local gLaikasExtracted = string.sub(gLaikas, 1, 19)
    
    if currentDateTime >= fDateExtracted and currentDateTime <= gLaikasExtracted then
        return true
    else
        return false
    end
end




function insertTicket(xPlayer, cPlate, pTime, rTime, eTime)
    TriggerEvent("uniPark:removeTicket", cPlate)
    Wait(100)
    TriggerClientEvent("uniPark:Success", xPlayer, cPlate)
    MySQL.insert.await('INSERT INTO `uniPark` (sData, pData, carPlate, tPeriod) VALUES (?, ?, ?, ?)', {rTime, eTime, cPlate, pTime})
end

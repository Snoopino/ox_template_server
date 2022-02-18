RegisterServerEvent('fleevo_hospital:payBill')
AddEventHandler('fleevo_hospital:payBill', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = xPlayer.getMoney()
    if cash >= Config.BillAmount then
        xPlayer.removeMoney(amount)
    end
end)

ESX.RegisterServerCallback('fleevo_hospital:hasMoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = xPlayer.getMoney()
    if cash >= Config.BillAmount then 
        cb(true)
    else
        cb(false)
    end
end)
local QBCore = exports['qb-core']:GetCoreObject()


local function calculateEarning(durability,upgrades)
    local speedCount = 0
    local durabilityCount = 0
    local upgrades = json.decode(upgrades)

    for upgrade, value in pairs(upgrades) do
        local performanceType = Config.Upgrades[upgrade]["performanceType"]
        if performanceType == "speed" then
            speedCount = speedCount + value
        elseif performanceType == "durability" then
            durabilityCount = durabilityCount + value
        end
    end

    local currentValue,currentDamage
    if speedCount == 0 then
        currentValue = Config.StartDrop
    else
        currentValue = Config.StartDrop * (1 + Config.SpeedAndDurability["speed"])^speedCount
    end
    if durabilityCount == 0 then
        currentDamage = Config.DurabilityDamage
    else
        currentDamage = Config.DurabilityDamage * (1 - Config.SpeedAndDurability["durability"])^durabilityCount
    end
    return {currentValue, currentDamage, durability}
end



RegisterNetEvent("qb-oil:server:fix",function(args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local currentID = args.currentID
    local currentLevel = args.currentLevel
    --Remove the items
    for x=1,#Config.Repair["Repair"]["items"] do
        if QBCore.Functions.HasItem(src,Config.Repair["Repair"]["items"][x],Config.Repair["Repair"]["cost"]+Config.RepairIncrease*(currentLevel-1)) then
            Player.Functions.RemoveItem(Config.Repair["Repair"]["items"][x],Config.Repair["Repair"]["cost"]+Config.RepairIncrease*(currentLevel-1))  
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Repair["Repair"]["items"][x]], "remove", Config.Repair["Repair"]["cost"]+Config.RepairIncrease*(currentLevel-1))

        end
    end
    MySQL.Async.execute('UPDATE oilwell_database SET durability = ? WHERE oilwell_id = ?', {
        Config.Durability,
        currentID,
    })
    TriggerClientEvent('QBCore:Notify', source, Lang:t("success.repair"), "success")

end)

RegisterNetEvent("qb-oil:server:deleteWorker",function(args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local currentID = args.currentID
    local workers
    MySQL.query('SELECT * FROM oilwell_database WHERE oilwell_id = ?', {currentID}, function(result)
        if result ~= nil and result[1] ~= nil then
            workers = json.decode(result[1].workers) or {}
        else
            workers = {}
        end
       
        local args1 = {workers = workers, currentID = currentID}
        TriggerClientEvent("qb-oil:client:deleteWorker",src,args1)
    end)
end)
RegisterNetEvent("qb-oil:server:deleteWorkerFinal",function(args)
    local src = source
    local currentID = args.currentID
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local worker = args.worker
    local workerList = args.workers

    table.remove(workerList,args.index)
    local updatedWorkers = json.encode(workerList)
    
    MySQL.Async.execute('UPDATE oilwell_database SET workers = ? WHERE oilwell_id = ?', {
        updatedWorkers,
        currentID,
    })

    TriggerClientEvent('QBCore:Notify', src, Lang:t("success.remove_worker"), "success")
    TriggerClientEvent("qb-oil:client:deleteWorker",src,args)

end)

QBCore.Functions.CreateCallback('qb-oil:server:checkIfUpgradeIsDone', function(src, cb,args)
    local currentID = args.currentID
    MySQL.Async.fetchAll('SELECT * FROM oilwell_database WHERE oilwell_id = ?', {currentID}, function(row)
        local upgradeDict = json.decode(row[1].upgrade)
       
            local upgradeExist = upgradeDict[args.typeUpgrade] == row[1].level
            if not upgradeExist then
                cb({true,""})
            else
                local text
                if row[1].level == Config.MaxLevel then
                    text = Lang:t("error.alreadymax")
                else
                    text = Lang:t("error.alreadydone")
                end
                args = {currentID = currentID}
                TriggerClientEvent('qb-oil:client:upgradeMenu',src,args)
                cb({false,text})

            end
        end)
end)

QBCore.Functions.CreateCallback('qb-oil:server:checkWhoOwns', function(src, cb,currentID)
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local listUpgrades
    MySQL.query('SELECT * FROM oilwell_database WHERE oilwell_id = ?', {currentID}, function(result)
        if result ~= nil and result[1] ~= nil then
            listUpgrades = json.decode(result[1].upgrades) or {}
            if result[1].citizenid == citizenid then
                cb(true,result[1].level,calculateEarning(result[1].durability,result[1].upgrade))
            else
                if result[1].workers then
                    local workers = json.decode(result[1].workers)
                    for i=1,#workers do
                        if workers[i] == citizenid then
                            cb(true,result[1].level,calculateEarning(result[1].durability,result[1].upgrade))
                        end
                    end
                end
                local price = 0
                if result[1].sellprice > 0 then
                    price = result[1].sellprice
                end
                cb(false,result[1].level,calculateEarning(result[1].durability,result[1].upgrade),"empty",price)
            end
        else
            cb(false)
        end
    end)
    

end)




RegisterNetEvent("qb-oil:server:updateOil",function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then
        local citizenid = Player.PlayerData.citizenid
        local updatedOilAmount = 0
        local updatedDurability = 0

        MySQL.Async.fetchAll('SELECT * FROM oilwell_database WHERE citizenid = ?', {citizenid}, function(rows)
            if rows and #rows > 0 then
                for i, row in ipairs(rows) do
                    if row.oil then
                        listUpgrades = json.decode(row.upgrades) or {}
                        updatedDurability = row.durability - calculateEarning(row.durability,row.upgrade)[2]
                        if updatedDurability < 0 then
                            updatedDurability = 0
                            updatedOilAmount = row.oil
                        else
                            updatedOilAmount = row.oil + calculateEarning(row.durability,row.upgrade)[1]
                        end

                        --updatedOilAmount = row.oil + 5
                    else
                        updatedOilAmount = Config.StartDrop
                        updatedDurability = Config.Durability
                    end
                    MySQL.Async.execute('UPDATE oilwell_database SET oil = ?, durability = ? WHERE oilwell_id = ?', {
                        updatedOilAmount,
                        updatedDurability,
                        row.oilwell_id,
                    })
                end
            end
        end)    
    end
end)

RegisterNetEvent("qb-oil:server:buyWell",function(args)
    local currentID = args.currentID
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    local price
    if args.price ~= nil then
        price = args.price
    else
        price = Config.OilWellCost
    end
    local upgrades = {}
    for upgrade, value in pairs(Config.Upgrades) do
        upgrades[upgrade] = 0
    end

    local serializedUpgrades = json.encode(upgrades)

    local bankamount = Player.PlayerData.money.bank
    if bankamount >= price then
        Player.Functions.RemoveMoney("bank", price, "Purchased oilwell")
        if not args.boughtFromPlayer then
            MySQL.Async.insert('INSERT INTO oilwell_database (citizenid, oilwell_id,level,oil,durability,sellprice,upgrade) VALUES (?, ?,?,?,?,?,?)', {
                citizenid,
                currentID,
                1,
                5,
                Config.Durability,
                0,
                serializedUpgrades,
            })
        else
            MySQL.Async.execute('UPDATE oilwell_database SET citizenid = ?, sellprice = ?, workers = NULL WHERE oilwell_id = ?', {
                citizenid,
                0,
                currentID,
            })
        end
        TriggerClientEvent('QBCore:Notify', source, Lang:t("success.bought_well"), "success")
        local args = {}
        args.currentID = currentID
        TriggerClientEvent("qb-oil:client:openMenu",source,args)

    else
        TriggerClientEvent('QBCore:Notify', source, Lang:t("error.not_enough_cash"), "error")
    end

end)

QBCore.Functions.CreateCallback('qb-oil:server:getplayers', function(source, cb)
	local src = source
	local players = {}
	local PlayerPed = GetPlayerPed(src)
	local pCoords = GetEntityCoords(PlayerPed)
	for _, v in pairs(QBCore.Functions.GetPlayers()) do
		local targetped = GetPlayerPed(v)
		local tCoords = GetEntityCoords(targetped)
		local dist = #(pCoords - tCoords)
		if PlayerPed ~= targetped and dist < 10 then
			local ped = QBCore.Functions.GetPlayer(v)
			players[#players+1] = {
			id = v,
			coords = GetEntityCoords(targetped),
			name = ped.PlayerData.charinfo.firstname .. " " .. ped.PlayerData.charinfo.lastname,
			citizenid = ped.PlayerData.citizenid,
			sources = GetPlayerPed(ped.PlayerData.source),
			sourceplayer = ped.PlayerData.source
			}
		end
	end
		table.sort(players, function(a, b)
			return a.name < b.name
		end)
	cb(players)
end)

RegisterNetEvent("qb-oil:server:findOilAmount",function(args)
    
    local currentID = args.currentID
    local oilAmount = 0
    local src = source
    MySQL.Async.fetchAll('SELECT * FROM oilwell_database WHERE oilwell_id = ?', {currentID}, function(rows)
        if rows and #rows > 0 then
            oilAmount = rows[1].oil
            args.oilAmount = oilAmount
            TriggerClientEvent('qb-oil:client:collectItems', src, args)

        end
    end)
end)
local function checkIfResources(source,itemList,amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for x=1,#itemList do
        if not QBCore.Functions.HasItem(src,itemList[x],amount) then
            return false
        end
    end
    
    return true
end


RegisterNetEvent("qb-oil:server:upgrade",function(args)
    local src = source
    local currentID = args.currentID
    local Player = QBCore.Functions.GetPlayer(src)

    MySQL.Async.fetchAll('SELECT * FROM oilwell_database WHERE oilwell_id = ?', {currentID}, function(row)
        local upgradeDict = json.decode(row[1].upgrade)
        if checkIfResources(src,Config.Upgrades[args.typeUpgrade]["items"],Config.UpgradeStartCost+(row[1].level-1)*Config.UpgradeCostIncrease) then
            local upgradeExist = upgradeDict[args.typeUpgrade] == row[1].level
            if not upgradeExist then
                upgradeDict[args.typeUpgrade] = upgradeDict[args.typeUpgrade] +1
                local serializedUpgrades = json.encode(upgradeDict)
                MySQL.Async.execute('UPDATE oilwell_database SET upgrade = ? WHERE oilwell_id = ?', {
                    serializedUpgrades,
                    currentID
                })
                if row[1].level == Config.MaxLevel then
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("success.full_upgrade"), "success")
                else
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("success.upgrade"), "success")
                end
                for i=1,#Config.Upgrades[args.typeUpgrade]["items"] do
                    Player.Functions.RemoveItem(Config.Upgrades[args.typeUpgrade]["items"][i], Config.UpgradeStartCost+(row[1].level-1)*Config.UpgradeCostIncrease)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Upgrades[args.typeUpgrade]["items"][i]], "remove", 1)
                end
                local newLevel = row[1].level
                local allUpgradesSameValue = true
                local valueToCheckAgainst = upgradeDict[args.typeUpgrade]
                for upgrade, value in pairs(upgradeDict) do
                    if valueToCheckAgainst ~= value then
                        allUpgradesSameValue = false
                        break
                    end
                end
                if allUpgradesSameValue and row[1].level ~= Config.MaxLevel then
                    newLevel = row[1].level + 1
                    TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t("success.levelup"),newLevel), "success")
                    MySQL.Async.execute('UPDATE oilwell_database SET level = ? WHERE oilwell_id = ?', {
                        newLevel,
                        currentID
                    })
                end
                args = {currentID = currentID, newLevel = newLevel, currentSpeed = calculateEarning(row[1].durability,row[1].upgrade)[1]}
                TriggerClientEvent('qb-oil:client:upgradeMenu',src,args)
            else
                if row[1].level == Config.MaxLevel then
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("error.alreadymax"), "error")
                else
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("error.alreadydone"), "error")
                end
                args = {currentID = currentID}
                TriggerClientEvent('qb-oil:client:upgradeMenu',src,args)
            end
        else
            TriggerClientEvent('QBCore:Notify',src, Lang:t("error.not_enough"), "error")
            TriggerClientEvent('qb-oil:client:upgradeMenu',src,args)
        end
    end)
    
end)

RegisterNetEvent('qb-oil:server:sellItems', function()
    local source = source
    local price = 0
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] ~= nil then
                if Config.Sell[Player.PlayerData.items[k].name] ~= nil then
                    local random = math.random(Config.Sell[Player.PlayerData.items[k].name].price[1],Config.Sell[Player.PlayerData.items[k].name].price[2])
                    price = price + (random * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Player.PlayerData.items[k].name], "remove")
                end
            end
        end
        if price > 0 then
            TriggerClientEvent('QBCore:Notify', source, string.format(Lang:t("success.sold_for"),price),"success")
            Player.Functions.AddMoney("cash", price)
        else
            TriggerClientEvent('QBCore:Notify', source, Lang:t("error.nothing_to_sell"),"error")

        end
    else 
		TriggerClientEvent('QBCore:Notify', source, Lang:t("error.cant_sell"),"error")
	end
end)

RegisterNetEvent("qb-oil:server:collectItems",function(args)
    local src = source
        if args.oilAmountSel <= args.oilAmount then
            local Player = QBCore.Functions.GetPlayer(src)
            Player.Functions.AddItem(Config.Oil, args.oilAmountSel)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Oil], "add", args.oilAmountSel)
            MySQL.Async.execute('UPDATE oilwell_database SET oil = oil - ? WHERE oilwell_id = ?', {
                args.oilAmountSel,
                args.currentID
            })
            args.oilAmount = args.oilAmount-args.oilAmountSel
            TriggerClientEvent("qb-oil:client:collectItems",src,args)
            TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t("success.collected_oil"),args.oilAmountSel), "success")
        else
            TriggerClientEvent("qb-oil:client:collectItems",src,args)
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.not_enough"), "error")
        end
end)


RegisterNetEvent("qb-oil:server:sellWell",function(args)
    local currentID = args.currentID
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    local src = source
    local price = 0
    MySQL.Async.fetchAll('SELECT * FROM oilwell_database WHERE oilwell_id = ?', {currentID}, function(row)
        if args.quicksell then
            price = Config.OilWellCost*Config.LossWhenSell
                if row[1].citizenid == citizenid then
                    Player.Functions.AddMoney("bank", price, "Sold oil well")
                    MySQL.Async.execute("DELETE FROM oilwell_database WHERE oilwell_id = ?", {currentID}, function()
                        TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t("success.sold_for"),price), "success")
                    end)
        
                else
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("error.not_owner"), "error")
                end
        else
            if row[1].citizenid == citizenid then
                price = args.price
                if row[1].sellprice == 0 then
                    TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t("success.put_out"),price), "success")
                else
                    TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t("success.changed_price"),price), "success")
                end
                MySQL.Async.execute('UPDATE oilwell_database SET sellprice = ? WHERE oilwell_id = ?', {
                    price,
                    currentID
                })
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.not_owner"), "error")
            end
        end
    end)

end)

RegisterNetEvent('qb-oil:server:HireEmployee', function(args)
    local recruit = args.recruit
    local src = source
    local currentID = args.currentID

    if recruit ~= "none" then
        local Player = QBCore.Functions.GetPlayer(src)
        local Target = QBCore.Functions.GetPlayer(recruit)
        local citizenid = Player.PlayerData.citizenid

        MySQL.Async.fetchScalar('SELECT workers FROM oilwell_database WHERE oilwell_id = ?', {currentID}, function(existingIDs)
                list = json.decode(existingIDs) or {}
                local updatedID = Target.PlayerData.citizenid
                local existAlready = false
                for i=1,#list do
                    if list[i] == updatedID then
                        existAlready = true
                    end
                end
                if not existAlready then
                    list[#list+1] = updatedID
            
                    local jsonList = json.encode(list)
                
                    MySQL.Async.execute('UPDATE oilwell_database SET workers = ? WHERE oilwell_id = ?', {
                        jsonList,
                        currentID
                    })
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("success.hired"), "success")
                else
                    TriggerClientEvent('QBCore:Notify', src, Lang:t("error.already_hired"), "error")
                end
                
            
        end)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.none_around"), "error")

    end
    TriggerClientEvent('qb-oil:client:hireNew',src,args)

end)

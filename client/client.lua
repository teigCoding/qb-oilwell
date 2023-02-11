local QBCore = exports['qb-core']:GetCoreObject()

local currentLevel = 1
local currentSpeed = Config.StartDrop
local currentDurability = Config.Durability
local currentDamage = Config.DurabilityDamage


Citizen.CreateThread(function()
    while true do
      Citizen.Wait(Config.Update)
      TriggerServerEvent("qb-oil:server:updateOil")
    end
  end)

Citizen.CreateThread(function ()
    for i=1,#Config.OilWells do
        exports['qb-target']:AddBoxZone("oil"..i, Config.OilWells[i]["coords"], 10,  10, {
            name = "oil"..i,
            heading = 0,
            debugPoly = false,
        }, {
            options = {
                {
                    type = "Client",
                    icon = "fa-solid fa-oil-well",
                    event = "qb-oil:client:openMenu",
                    label = Lang:t("label.watch"),
                    currentID = i,
                }, 
            },
            distance = 2.5
        })
    end
end)

RegisterNetEvent("qb-oil:client:buyWell",function(args)
    TriggerServerEvent("qb-oil:server:buyWell",args)

end)

RegisterNetEvent("qb-oil:client:alreadyBought",function()
    TriggerEvent('QBCore:Notify', Lang:t("error.cantbuy"), "error")
end)

RegisterNetEvent('qb-oil:client:collectItems', function(args)
    local currentID = args.currentID
    local menu = {{header = Lang:t("label.oilwell").. " - "..args.oilAmount.."x "..Lang:t("label.oil"), txt = Lang:t("label.collect"), isMenuHeader = true}}
    for i, amount in ipairs(Config.CollectAmounts) do
        table.insert(menu, {
            header = amount .. "x "..Lang:t("label.oil"),
            icon = "fa-sharp fa-solid fa-octagon-check",
            txt = string.format(Lang:t("label.collect_oil"), amount),
            params = {
                isServer = true,
                event = "qb-oil:server:collectItems",
                args = {
                    currentID = currentID,
                    oilAmount = args.oilAmount,
                    oilAmountSel = amount,
                }
            }
        })
    end
    table.insert(menu, {
        header = Lang:t("label.goback"),
        params = {
            isServer = false,
            event = "qb-oil:client:openMenu",
            args = {
                currentID = currentID
            }
        }
    })
    exports['qb-menu']:openMenu(menu)
    
end)


local function displayAllRequired(table,repair)
    local newList = {}
    if repair == false then
        for i=1,#table do
            newList[#newList+1] = Config.UpgradeStartCost+(currentLevel-1)*Config.UpgradeCostIncrease.."x "..table[i]
        end
    elseif repair == true then
        for i=1,#table do
            newList[#newList+1] = Config.Repair["Repair"]["cost"]+Config.RepairIncrease*(currentLevel-1).."x "..table[i]
        end
    end
    
    local result = ""
    for i=1,#newList do
        if i > 1 then
            result = result .. ", "
        end
        result = result .. newList[i]
    end
    
    return result
end

local function checkIfResources(itemList,amount)
    for x=1,#itemList do
        if not QBCore.Functions.HasItem(itemList[x],amount) then
            return false
        end
    end
    return true
end



RegisterNetEvent("qb-oil:client:fixAndUpgrade",function(args)
    local src = source
    local displayText = args.displayText
    typeProgress = args.typeProgress
    local x = false
    if typeProgress == "repair" then
        x = checkIfResources(Config.Repair["Repair"]["items"],Config.Repair["Repair"]["cost"])
    else
        x = checkIfResources(Config.Upgrades[args.typeUpgrade]["items"],Config.UpgradeStartCost+(Config.UpgradeCostIncrease*currentLevel-1))
    end
        QBCore.Functions.TriggerCallback('qb-oil:server:checkIfUpgradeIsDone', function(result)
            if not result[1] then
                TriggerEvent('QBCore:Notify', result[2], "error")
                TriggerEvent('qb-oil:client:upgradeMenu',src,args)
            else
                if x then
                    ExecuteCommand("e mechanic4")
                    QBCore.Functions.Progressbar('fixandrepairprogress', displayText, 5000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                    }, {}, {}, function() 
                        ExecuteCommand("e c")
                        if typeProgress == "repair" then
                            TriggerServerEvent("qb-oil:server:fix",args)
                        else
                            TriggerServerEvent("qb-oil:server:upgrade",args)
                        end

                    end, function()
                    
                    end)
                else
                TriggerEvent('QBCore:Notify', Lang:t("error.not_enough"), "error")

                end
            end
        end,args)
   
    
end)





RegisterNetEvent('qb-oil:client:upgradeMenu', function(args)
    local currentID = args.currentID
    currentLevel = args.newLevel or currentLevel
    currentSpeed = args.currentSpeed or currentSpeed

    local goBack = args.goBack or "qb-oil:client:openMenu"
    
    local upgrades = {}
    for upgradeName, upgradeData in pairs(Config.Upgrades) do
        if args.custom then
            if upgradeData["performanceType"] == args.custom then
                upgrades[upgradeName] = upgradeData
            end
        else
            upgrades[upgradeName] = upgradeData
        end
    end
    
    local menu = {
            {
                header = Lang:t("label.oilwell"),
                txt = Lang:t("label.upgrade"),
                isMenuHeader = true,
            }
        }
    for upgradeName, upgradeData in pairs(upgrades) do
        table.insert(menu, {
            header = upgradeData["label"],
            icon = "fa-solid fa-screwdriver-wrench",
            txt = displayAllRequired(upgradeData["items"], false),
            params = {
                isServer = false,
                event = "qb-oil:client:fixAndUpgrade",
                args = {
                    currentID = currentID,
                    typeUpgrade = upgradeName,
                    displayText = Lang:t("label.upgrading"),
                }
            }
        })
    end

    table.insert(menu, {
        header = Lang:t("label.goback"),
        params = {
            isServer = false,
            event = goBack,
            args = {
                currentID = currentID
            }
        }
    })

    exports['qb-menu']:openMenu(menu)
end)


RegisterNetEvent('qb-oil:client:fixMenu', function(args)
    local currentID = args.currentID
    exports['qb-menu']:openMenu({
        {
            header = Lang:t("label.oilwell"),
            txt = Lang:t("label.repair"),
            isMenuHeader = true,
        },
        {
            header = Lang:t("label.fix"),
            icon = "fa-solid fa-screwdriver-wrench",
            txt = displayAllRequired(Config.Repair["Repair"]["items"],true),
            params = {
                isServer = false,
                            event = "qb-oil:client:fixAndUpgrade",
                            args = {
                                currentID = currentID,
                                displayText = Lang:t("label.repairing"),
                                currentLevel = currentLevel,
                                typeProgress = "repair",
                            }
            }},
           
            {
                header = Lang:t("label.goback"),
                params = {
                    isServer = false,
                    event = "qb-oil:client:upgradeMenu",
                    args = {
                        currentID = currentID
                    }

                }}})
end)

RegisterNetEvent("qb-oil:client:sellWellMenu",function(args)
        local dialog = exports['qb-input']:ShowInput({
            header = Lang:t("label.sellwell"),
            submitText = Lang:t("label.putout"),
            inputs = {
            
                {
                    text = Lang:t("label.price"),
                    name = "price",
                    type = "number",
                    isRequired = true,
                },
            },
        })
        
        if dialog ~= nil then
            for k,v in pairs(dialog) do
                args.price = math.ceil(tonumber(dialog["price"]))
                TriggerServerEvent("qb-oil:server:sellWell",args)
            end
        end

end)

RegisterNetEvent('qb-oil:client:sellWell', function(args)
    local currentID = args.currentID
    exports['qb-menu']:openMenu({
        {
            header = Lang:t("label.oilwell"),
            txt = Lang:t("label.sell"),
            isMenuHeader = true,
        },
        {
            header = Lang:t("label.putout_sale"),
            icon = "fa-sharp fa-solid fa-octagon-check",
            txt = Lang:t("label.sell_to_others"),
            params = {
                isServer = false,
                event = "qb-oil:client:sellWellMenu",
                args = {
                    quicksell = false,
                    currentID = currentID
                }
            }},
        {
            header = Lang:t("label.sell_quick"),
            icon = "fa-sharp fa-solid fa-octagon-check",
            txt = string.format(Lang:t("label.sell_for"),math.ceil(Config.OilWellCost*Config.LossWhenSell)),
            params = {
                isServer = true,
                event = "qb-oil:server:sellWell",
                args = {
                    quicksell = true,
                    currentID = currentID
                }
            }},
            {
                header = Lang:t("label.goback"),
                params = {
                    isServer = false,
                    event = "qb-oil:client:openMenu",
                    args = {
                        currentID = currentID
                    }

                }}})
end)
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end


RegisterNetEvent("qb-oil:client:infoMenu",function(args)
    local currentID = args.currentID
    local ms = Config.Update
    exports['qb-menu']:openMenu({
        {
            header = Lang:t("label.oilwell"),
            txt = Lang:t("label.info"),
            isMenuHeader = true,
        },
        {
            header = Lang:t("label.level")..currentLevel,
            txt = Lang:t("label.oilwell_level"),
            icon = "fa-solid fa-angles-up",
            params = {
                isServer = false,
                event = "qb-oil:client:upgradeMenu",
                args = {
                    currentID = currentID,
                    goBack = "qb-oil:client:infoMenu"
                }
            },
        },
        {
            header = Lang:t("label.speed") .. round(currentSpeed/(ms/1000),2) .. Lang:t("label.per_second"),
            txt = Lang:t("label.oilwell_speed"),
            icon = "fa-solid fa-bolt",
            params = {
                isServer = false,
                event = "qb-oil:client:upgradeMenu",
                args = {
                    currentID = currentID,
                    custom = "speed",
                    goBack = "qb-oil:client:infoMenu"
                }
            },
        },
        {
            header = Lang:t("label.damage") .. round((currentDamage/(ms/1000)),2) .. Lang:t("label.per_second"),
            txt = Lang:t("label.oilwell_damage"),
            icon = "fa-solid fa-heart-circle-xmark",
            params = {
                isServer = false,
                event = "qb-oil:client:upgradeMenu",
                args = {
                    currentID = currentID,
                    custom = "durability",
                    goBack = "qb-oil:client:infoMenu"
                }
            },
        },
        {
            header = Lang:t("label.durability")..(currentDurability/Config.Durability*100).."%",
            txt = Lang:t("label.oilwell_durability"),
            icon = "fa-solid fa-toolbox",
            params = {
                isServer = false,
                event = "qb-oil:client:fixMenu",
                args = {
                    currentID = currentID,
                    currentLevel = currentLevel,
                }
            },
        },
            {
                header = Lang:t("label.goback"),
                params = {
                    isServer = false,
                    event = "qb-oil:client:openMenu",
                    args = {
                        currentID = currentID,
                        goBack = "qb-oil:client:infoMenu"                    
                    }

                }}})

end)

RegisterNetEvent('qb-oil:client:hireNew', function(args)
    local currentID = args.currentID
    local HireMenu = {
        {
            header = Lang:t("label.oilwell"),
            txt = Lang:t("label.hire"),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
        },
    }
    QBCore.Functions.TriggerCallback('qb-oil:server:getplayers', function(players)
        for _, v in pairs(players) do
            if v and v ~= PlayerId() then
                HireMenu[#HireMenu + 1] = {
                    header = v.name,
                    txt = "CitizenID: ".. v.citizenid .. " - ID: " .. v.sourceplayer,
                    icon = "fa-solid fa-user-check",
                    params = {
                        isServer = true,
                        event = 'qb-oil:server:HireEmployee',
                        args = {
                            recruit = v.sourceplayer,
                            currentID = currentID,
                        }
                    }
                }
            end
        end
        if #HireMenu == 1 then
            HireMenu[#HireMenu + 1] = {
                header = Lang:t("label.no_match"),
                txt = Lang:t("label.no_found"),
                icon = "fa-solid fa-circle-exclamation",
                params = {
                    isServer = true,
                    event = 'qb-oil:server:HireEmployee',
                    args = {
                        recruit = "none",
                        currentID = currentId,
                    }
                }
            }
        end
        HireMenu[#HireMenu + 1] = {
            header = Lang:t("label.goback"),
                params = {
                    isServer = false,
                    event = "qb-oil:client:openArbeider",
                    args = {
                        currentID = currentID
                    }
                }
        }
        exports['qb-menu']:openMenu(HireMenu)
    end)
end)

RegisterNetEvent("qb-oil:client:openArbeider",function(args)
    local currentID = args.currentID

            exports['qb-menu']:openMenu({
                {
                    header = Lang:t("label.oilwell"),
                    txt = Lang:t("label.administrate"),
                    isMenuHeader = true,
                },
                {
                    header = Lang:t("label.hire_worker"),
                    icon = "fa-solid fa-user-plus",
                    txt = Lang:t("label.hire_worker_1"),
                    params = {
                        isServer = false,
                        event = "qb-oil:client:hireNew",
                        args = {
                            currentID = currentID,
                        }
                    }},
                    {
                        header = Lang:t("label.remove_worker"),
                        icon = "fa-solid fa-user-minus",
                        txt = Lang:t("label.remove_worker_1"),
                        params = {
                            isServer = true,
                            event = "qb-oil:server:deleteWorker",
                            args = {
                                currentID = currentID
                            }
                        }},
                    {
                        header = Lang:t("label.goback"),
                        params = {
                            event = "qb-oil:client:openMenu",
                            args = {
                                currentID = currentID
                            }

                        }}})

end)

RegisterNetEvent("qb-oil:client:deleteWorker",function(args)
    local currentID = args.currentID
    local workerList = args.workers
    local HireMenu1 = {}
    HireMenu1[#HireMenu1+1] = 
        {
            header = Lang:t("label.oilwell"),
            txt = Lang:t("label.remove_worker"),
            isMenuHeader = true,
        }
        for i=1,#workerList do
            HireMenu1[#HireMenu1 + 1] = {
                header = workerList[i],
                txt = "CitizenID: "..workerList[i],
                icon = "fa-solid fa-user-minus",
                params = {
                    isServer = true,
                    event = 'qb-oil:server:deleteWorkerFinal',
                    args = {
                        currentID = currentID,
                        worker = workerList[i],
                        workers = workerList,
                        index = i,
                    }
                }
            }
        end
        if #HireMenu1 == 1 then
            HireMenu1[#HireMenu1 + 1] = {
                header = Lang:t("label.no_match"),
                txt = Lang:t("label.no_found"),
                icon = "fa-solid fa-user-minus",
                params = {
                    isServer = false,
                    event = "qb-oil:client:deleteWorker",
                    args = {
                        currentID = args.currentID,
                        workers = args.workers,
                    }
                }
            }
        end
        HireMenu1[#HireMenu1 + 1] =
            {
                header = Lang:t("label.goback"),
                params = {
                    isServer = false,
                    event = "qb-oil:client:openArbeider",
                    args = {
                        currentID = args.currentID,
                        workers = args.workers,
                    }

                }}
    exports['qb-menu']:openMenu(HireMenu1)

                

end)



RegisterNetEvent("qb-oil:client:openMenu", function(args)
    local currentID = args.currentID
    QBCore.Functions.TriggerCallback('qb-oil:server:checkWhoOwns', function(access,level,speed,empty,price)
            Citizen.CreateThread(function ()
        if not access and empty ~= "empty" then
            exports['qb-menu']:openMenu({
                {
                    header = Lang:t("label.oilwell"),
                    txt = Config.OilWells[currentID]["location"],
                    isMenuHeader = true,
                },
                {
                    header = Lang:t("label.buy_well"),
                    icon = "fa-solid fa-cart-plus",
                    txt = string.format(Lang:t("label.buy_well_1"),math.ceil(Config.OilWellCost)),
                    params = {
                        isServer = false,
                        event = "qb-oil:client:buyWell",
                        args = {
                            currentID = currentID
                        }
                    }},
                    {
                        header = Lang:t("label.goback"),
                        params = {
                            isServer = false,
                            event = "",

                        }}})
        elseif not access and empty == "empty" then
            local theMenu = {}
            theMenu[#theMenu+1]=
            {
                    header = Lang:t("label.oilwell"),
                    txt = Config.OilWells[currentID]["location"],
                    isMenuHeader = true,
                }
                if price > 0 then
                    theMenu[#theMenu+1]=
                    {
                        header = Lang:t("label.buy_well"),
                        icon = "fa-solid fa-cart-plus",
                        txt = string.format(Lang:t("label.buy_well_player"),price),
                        params = {
                            isServer = false,
                            event = "qb-oil:client:buyWell",
                            args = {
                                currentID = currentID,
                                price = price,
                                boughtFromPlayer = true,
                            }
                        }}
                else
                    theMenu[#theMenu+1]={
                    header = Lang:t("label.already_owned"),
                    icon = "fa-solid fa-circle-exclamation",
                    txt = Lang:t("label.no_access"),
                    params = {
                        isServer = false,
                        event = "qb-oil:client:alreadyBought",
                        args = {
                        }
                    }}
                end
                theMenu[#theMenu+1]=
                {
                    header = Lang:t("label.exit"),
                    params = {
                        isServer = false,
                        event = "",

                    }}
                    exports['qb-menu']:openMenu(theMenu)
                    
                    
        else
            currentLevel = level
            currentSpeed = speed[1]
            currentDamage = speed[2]
            currentDurability = speed[3]
            exports['qb-menu']:openMenu({
                {
                    header = Lang:t("label.oilwell"),
                    txt = Config.OilWells[currentID]["location"],
                    isMenuHeader = true
                },
                {
                    header = Lang:t("label.collect"),
                    icon = "fa-solid fa-warehouse",
                    txt = Lang:t("label.collect_rs"),
                    params = {
                        isServer = true,
                        event = 'qb-oil:server:findOilAmount',
                        args = {
                            currentID = currentID,
                        }
                    }},
                {
                    header = Lang:t("label.upgrade"),
                    icon = "fa-solid fa-screwdriver-wrench",
                    txt = Lang:t("label.upgrade_well"),
                    params = {
                        isServer = false,
                        event = "qb-oil:client:upgradeMenu",
                        args = {
                            currentID = currentID,
                        }
                    }},
                    {
                        header = Lang:t("label.workers"),
                        icon = "fa-solid fa-user-gear",
                        txt = Lang:t("label.worker_administrate"),
                        params = {
                            isServer = false,
                            event = "qb-oil:client:openArbeider",
                            args = {
                                currentID = currentID,
                            }
                        }},
                        {
                            header = Lang:t("label.info"),
                            icon = "fa-solid fa-circle-info",
                            txt = Lang:t("label.info_well"),
                            params = {
                                isServer = false,
                                event = "qb-oil:client:infoMenu",
                                args = {
                                    currentID = currentID,
                                }
                            }},
                    {
                        header = Lang:t("label.sell"),
                        icon = "fa-solid fa-store-slash",
                        txt = Lang:t("label.sell_well"),
                        params = {
                            isServer = false,
                            event = "qb-oil:client:sellWell",
                            args = {
                                currentID = currentID,
                            }
                        }},
                    {
                        header = Lang:t("label.exit"),
                        params = {
                            isServer = false,
                            event = "",
                            args = {
                                currentID = currentID
                            }
                    }}})
                
                end  
        end)
        
    end,currentID)
end)



--Ped

local sellPed = {
	{Config.OilSellerLocation.x, Config.OilSellerLocation.y, Config.OilSellerLocation.z,"Sr Manel_1",Config.OilSellerHeading,0x867639D1,"s_m_y_dockwork_01"},

  }
  Citizen.CreateThread(function()
	  for _,v in pairs(sellPed) do
		  RequestModel(GetHashKey(v[7]))
		  while not HasModelLoaded(GetHashKey(v[7])) do
			  Wait(1)
		  end
		  sellPed_v = CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
		  SetEntityHeading(sellPed_v, v[5])
		  FreezeEntityPosition(sellPed_v, true)
		  SetEntityInvincible(sellPed_v, true)
		  SetBlockingOfNonTemporaryEvents(sellPed_v, true)
		  TaskStartScenarioInPlace(sellPed_v, "WORLD_HUMAN_AA_SMOKE", 0, true) 
	  end
  end)
  
  Citizen.CreateThread(function ()
  exports['qb-target']:AddBoxZone("OilSeller", Config.OilSellerLocation, 1.5, 1.5, {
    name = "OilSeller",
    heading = 0,
    debugPoly = false,
    minZ = 0,
    maxZ = 10,
}, {
    options = {
    {
      type = "server",
      event = 'qb-oil:server:sellItems',
      icon = "fa fa-usd",
      label = Lang:t("label.sell_oil"),
    },
    },
    distance = 2.0
})
end)
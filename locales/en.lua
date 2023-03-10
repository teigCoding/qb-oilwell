local Translations = {
    error = {
        cantbuy = "You cannot buy the oil well!",
        not_enough = "You don't have enough!",
        not_enough_cash = "You don't have enough cash!",
        alreadymax = "You have already max upgraded!",
        alreadydone = "The upgrade is already done!",
        nothing_to_sell = "You have nothing to sell!",
        cant_sell = "You couldn't sell!",
        not_owner = "You do not own the oil well!",
        already_hired = "The person is already hired!",
        none_around = "There is no one around you!",
    },
    success = {
        repair = "You have repaired the oil well!",
        remove_worker = "You removed the worker!",
        bought_well = "You bought the oil well!",
        levelup = "You are now level %d!",
        full_upgrade = "You have maxed out the upgrade!",
        upgrade = "You completed the upgrade!",
        sold_for = "You sold for $%d!",
        collected_oil = "You collected %d oil!",
        put_out = "You put the oil well up for $%d!",
        changed_price = "You changed the price to $%d!",
        hired = "You hired the person!",
    },
    label = {
        watch = 'Inspect',
        oilwell = "Oil Well",
        oil = "Oil",
        collect = "Fetch",
        collect_oil = "Collect %d oil from the oil well",
        goback = "Go back",
        upgrade = "Upgrade",
        upgrading = "Upgrading...",
        upgrade_well = "Upgrade the oil well",
        repair = "Repair",
        repairing = 'Repairing oil well..',
        fix = "Repair Oilwell",
        sellwell = "Sell Oil Well",
        putout = "Confirm",
        price = "Price",
        sell = "Sell",
        sell_well = "Sell the oil well",
        putout_sale = "Put up for sale",
        sell_to_others = "Sell oil well to other people",
        sell_quick = "Quick Sell",
        sell_for = "Sell oil well for $%d",
        info = "Information",
        info_well = "Information about the oil well",
        level = "Level: ",
        oilwell_level = "Oil well level",
        speed = "Speed: ",
        oilwell_speed = "Oil well speed",
        damage = "Damage: ",
        per_second = "/s",
        oilwell_damage = "Oil well damage",
        durability = "Condition: ",
        oilwell_durability = "Oil well condition",
        hire = "Hire",
        no_match = "No Match",
        no_found = "No people found.",
        administrate = "Manage employees",
        hire_worker = "Hire Worker",
        hire_worker_1 = "Add worker",
        remove_worker = "Fire Worker",
        remove_worker_1 = "Remove worker",
        buy_well = "Buy Oil Well",
        buy_well_1 = "Buy oil well for $%d!",
        buy_well_player = "Buy oil well from player for $%d!",
        already_owned = "Someone already owns it!",
        no_access = "You do not have access",
        exit = "Exit",
        sell_oil = "Sell Oil",
        collect = "Collect",
        collect_rs = "Collect raw materials",
        workers = "Workers",
        worker_administrate = "Manage Workers",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
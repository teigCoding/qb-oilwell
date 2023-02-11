Config = Config or {}

--HOW OFTEN SHOULD THE LOOP RUN (ms)
Config.Update = 5000

--ITEM NAME that drops from the oil well
Config.Oil = "oil"

Config.OilWellCost = 1000000

--The lower the number the more they lose
Config.LossWhenSell = 0.5

Config.Durability = 1000

--How much damage it takes every update
Config.DurabilityDamage = 2

--How much oil it drops every update
Config.StartDrop = 5
Config.MaxLevel = 10
Config.UpgradeStartCost = 25
Config.UpgradeCostIncrease = 10

Config.OilSellerLocation = vector3(558.66, -3116.12, 5.07)
Config.OilSellerHeading = 174.63

Config.Upgrades = {
        ["Beam Pump"] = {
            ["items"] = {
                "iron",
                "metalscrap",
            },
            ["performanceType"] = "speed",
            ["label"] = "Beam Pump",--"Pumpe"
        },
        ["Wellbore"] = {
            ["items"] = {
                "steel",
                "aluminum",
                "metalscrap",
            },
            ["performanceType"] = "speed",
            ["label"] = "Wellbore",--"Brønnhull"
        },
        ["Wellhead"] = {
            ["items"] = {
                "aluminum",
                "metalscrap",
            },
            ["performanceType"] = "durability",
            ["label"] = "Wellhead",--"Brønnhode" 
        },
        ["Pipes"] = {
            ["items"] = {
                "copper",
                "metalscrap",
            },
            ["performanceType"] = "durability",
            ["label"] = "Pipes",--"Rør"
        },
        -- ["CustomName"] = {
        --     ["items"] = {
        --         "copper",
        --         "metalscrap",
        --     },
        --     ["performanceType"] = "durability",
        --     ["label"] = "CustomName",--"Rør"
        -- },
}

Config.SpeedAndDurability = {
    ["speed"] = 0.1,
    ["durability"] = 0.025,
}

Config.RepairIncrease = 5
Config.Repair = {
    ["Repair"] = {
        ["items"] = {
            "metalscrap",
        },
        ["cost"] = 10
    }
}

Config.Sell = {
    ["oil"] = {
        ["price"] = {5, 10} --MIN AND MAX                            
    },
}

Config.CollectAmounts = {10, 25, 50, 100}

Config.OilWells = {
    [1] = {
        ["coords"] = vector3(695.62, 2886.36, 50.39),
        ["location"] = "Grand Senora Desert",
    },
    [2] = {
        ["coords"] = vector3(651.12, 2923.74, 42.55),
        ["location"] = "Grand Senora Desert",
    },
    [3] = {
        ["coords"] = vector3(610.81, 2856.33, 40.5),
        ["location"] = "Grand Senora Desert",
    },
    [4] = {
        ["coords"] = vector3(581.63, 2927.5, 41.44),
        ["location"] = "Grand Senora Desert",
    },
    [5] = {
        ["coords"] = vector3(542.3, 2877.3, 43.44),
        ["location"] = "Grand Senora Desert",
    },
    [6] = {
        ["coords"] = vector3(497.27, 2959.77, 42.64),
        ["location"] = "Grand Senora Desert",
    },
    [7] = {
        ["coords"] = vector3(598.66, 3019.78, 42.13),
        ["location"] = "Grand Senora Desert",
    },
    [8] = {
        ["coords"] = vector3(651.7, 3013.75, 43.82),
        ["location"] = "Grand Senora Desert",
    },
    [9] = {
        ["coords"] = vector3(1472.63, -1611.33, 71.24),
        ["location"] = "Murrieta Oil Field",
    },
    [10] = {
        ["coords"] = vector3(1486.81, -1596.44, 72.65),
        ["location"] = "Murrieta Oil Field",
    },
    [11] = {
        ["coords"] = vector3(1462.06, -1664.32, 66.45),
        ["location"] = "Murrieta Oil Field",
    },
    [12] = { -- stor
        ["coords"] = vector3(1454.84, -1711.93, 67.57),
        ["location"] = "Murrieta Oil Field",
    },
    [13] = {
        ["coords"] = vector3(1504.96, -1724.01, 79.21),
        ["location"] = "Murrieta Oil Field",
    },
    [14] = { -- Liten
        ["coords"] = vector3(1504.92, -1741.9, 78.85),
        ["location"] = "Murrieta Oil Field",
    },
    [15] = { -- Stor
        ["coords"] = vector3(1575.89, -1768.23, 88.63),
        ["location"] = "Murrieta Oil Field",
    },
    [16] = { -- Liten
        ["coords"] = vector3(1583.82, -1859.1, 94.41),
        ["location"] = "Murrieta Oil Field",
    },
    [17] = {
        ["coords"] = vector3(1681.88, -1450.92, 112.51),
        ["location"] = "Murrieta Oil Field",
    },
    [18] = {
        ["coords"] = vector3(1690.99, -1434.03, 112.91),
        ["location"] = "Murrieta Oil Field",
    },
    [19] = {
        ["coords"] = vector3(1774.0, -1319.08, 94.94),
        ["location"] = "Murrieta Oil Field",
    },
    [20] = {
        ["coords"] = vector3(1792.1, -1347.52, 99.74),
        ["location"] = "Murrieta Oil Field",
    },
    [21] = {
        ["coords"] = vector3(1714.04, -1677.0, 113.11),
        ["location"] = "Murrieta Oil Field",
    },
    [22] = {
        ["coords"] = vector3(1668.56, -1839.02, 109.94),
        ["location"] = "Murrieta Oil Field",
    },
    [23] = {
        ["coords"] = vector3(1671.86, -1856.29, 108.89),
        ["location"] = "Murrieta Oil Field",
    },
    [24] = {
        ["coords"] = vector3(1698.16, -1918.86, 115.69),
        ["location"] = "Murrieta Oil Field",
    },
    [25] = { -- Liten
        ["coords"] = vector3(1774.0, -1319.08, 94.94),
        ["location"] = "Murrieta Oil Field",
    },
    [26] = { -- S
        ["coords"] = vector3(1524.69, -2174.27, 77.78),
        ["location"] = "Murrieta Oil Field",
    },
    [27] = { -- L
        ["coords"] = vector3(1431.77, -2103.76, 55.73),
        ["location"] = "Murrieta Oil Field",
    },
    [28] = {
        ["coords"] = vector3(1436.18, -2085.79, 54.98),
        ["location"] = "Murrieta Oil Field",
    },
    [29] = {
        ["coords"] = vector3(1522.05, -2061.9, 77.84),
        ["location"] = "Murrieta Oil Field",
    },
    [30] = { -- S
        ["coords"] = vector3(1522.66, -2541.88, 57.27),
        ["location"] = "Murrieta Oil Field",
    },
    [31] = {
        ["coords"] = vector3(1774.0, -1319.08, 94.94),
        ["location"] = "Murrieta Oil Field",
    },
    [32] = {
        ["coords"] = vector3(1502.25, -2540.95, 56.13),
        ["location"] = "Murrieta Oil Field",
    },
    [33] = { -- L
        ["coords"] = vector3(1436.42, -2297.59, 67.19),
        ["location"] = "Murrieta Oil Field",
    },
    [34] = { -- S
        ["coords"] = vector3(1417.16, -2308.08, 67.02),
        ["location"] = "Murrieta Oil Field",
    },
    [35] = { -- L
        ["coords"] = vector3(1370.22, -2274.22, 61.71),
        ["location"] = "Murrieta Oil Field",
    },
    [36] = { -- S
        ["coords"] = vector3(1361.51, -2197.47, 60.65),
        ["location"] = "Murrieta Oil Field",
    },
    [37] = { -- S
        ["coords"] = vector3(1369.9, -2209.75, 61.07),
        ["location"] = "Murrieta Oil Field",
    },
    [38] = { -- S
        ["coords"] = vector3(1169.51, -2122.51, 43.32),
        ["location"] = "Murrieta Oil Field",
    },
    [39] = { -- S
        ["coords"] = vector3(1198.75, -2194.59, 41.67),
        ["location"] = "Murrieta Oil Field",
    },
    [40] = { -- S
        ["coords"] = vector3(1212.62, -2211.37, 41.66),
        ["location"] = "Murrieta Oil Field",
    },
    [41] = { -- L
        ["coords"] = vector3(1268.02, -2337.76, 51.05),
        ["location"] = "Murrieta Oil Field",
    },
    [42] = { -- S
        ["coords"] = vector3(1209.52, -2439.94, 45.02),
        ["location"] = "Murrieta Oil Field",
    },
    [43] = { -- S
        ["coords"] = vector3(1220.44, -2457.73, 45.01),
        ["location"] = "Murrieta Oil Field",
    },
    [44] = { -- S
        ["coords"] = vector3(1834.65, -1193.64, 92.64),
        ["location"] = "Murrieta Oil Field",
    },
    [45] = { -- L
        ["coords"] = vector3(1834.15, -1168.61, 91.75),
        ["location"] = "Murrieta Oil Field",
    },
    [46] = {
        ["coords"] = vector3(1867.97, -1127.79, 86.14),
        ["location"] = "Murrieta Oil Field",
    },
    [47] = { -- L
        ["coords"] = vector3(1834.15, -1168.61, 91.75),
        ["location"] = "Murrieta Oil Field",
    },
    [48] = { -- S
        ["coords"] = vector3(1870.8, -1037.09, 79.35),
        ["location"] = "Murrieta Oil Field",
    },
    [49] = { -- s
        ["coords"] = vector3(1881.91, -1022.84, 79.17),
        ["location"] = "Murrieta Oil Field",
    },
    [50] = { -- s
        ["coords"] = vector3(1834.15, -1168.61, 91.75),
        ["location"] = "Murrieta Oil Field",
    },
    [51] = { -- l
        ["coords"] = vector3(1662.08, -1520.91, 112.99),
        ["location"] = "Murrieta Oil Field",
    },
    [52] = { -- l
        ["coords"] = vector3(1134.43, -2454.31, 31.56),
        ["location"] = "Murrieta Oil Field",
    },
    [53] = { -- S
        ["coords"] = vector3(1444.02, -2266.34, 66.93),
        ["location"] = "Murrieta Oil Field",
    },
    [54] = { -- l
        ["coords"] = vector3(1297.27, -1964.02, 44.0),
        ["location"] = "Murrieta Oil Field",
    },
    [55] = { -- s
        ["coords"] = vector3(1258.04, -1956.05, 43.69),
        ["location"] = "Murrieta Oil Field",
    },
    [56] = { -- s
        ["coords"] = vector3(1250.98, -1941.27, 43.69),
        ["location"] = "Murrieta Oil Field",
    },
    [57] = { -- l
        ["coords"] = vector3(1257.27, -1913.67, 38.75),
        ["location"] = "Murrieta Oil Field",
    },
    [58] = { -- s 
        ["coords"] = vector3(1367.49, -1880.9, 57.28),
        ["location"] = "Murrieta Oil Field",
    },
    [59] = { -- l
        ["coords"] = vector3(1341.37, -1871.42, 57.38),
        ["location"] = "Murrieta Oil Field",
    },
    [60] = { -- s
        ["coords"] = vector3(1342.91, -1847.23, 57.63),
        ["location"] = "Murrieta Oil Field",
    },
    [61] = { -- l
        ["coords"] = vector3(1565.42, -1592.36, 91.19),
        ["location"] = "Murrieta Oil Field",
    },
    [62] = { -- s
        ["coords"] = vector3(1227.88, -1863.23, 38.87),
        ["location"] = "Murrieta Oil Field",
    },
    [63] = { -- s
        ["coords"] = vector3(1212.74, -1867.09, 38.87),
        ["location"] = "Murrieta Oil Field",
    },
    [63] = { -- l
        ["coords"] = vector3(1222.43, -1890.16, 38.84),
        ["location"] = "Murrieta Oil Field",
    },
    [64] = { -- s
        ["coords"] = vector3(1561.22, -1855.18, 92.82),
        ["location"] = "Murrieta Oil Field",
    },
}


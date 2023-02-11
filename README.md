# Preview : https://youtu.be/yGndMqQnpps

# Item : qb-core > shared > items.lua
['oil'] 						 = { ['name'] = 'oil', 						['label'] = 'Oil', 					['weight'] = 10, 		['type'] = 'item', 		['image'] = 'oil.png', 				['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Oil'},

## Installation
Installing the qb-oil into your FiveM can be done by following the listed steps below. 
1. Download the latest version of the resource from (https://github.com/teigCoding/qb-oilwell/)
2. Open the zip file and place the `qb-oilwell` folder into your server's resource folder
3. Open up your server configuration file and add `ensure qb-oilwell` to your resource start list
4. Import database.sql to your database. (For example into HeidiSQL)
5. Add the item to qb-core > shared > items.lua
6. Copy the oil.png from images folder and add to qb-inventory > html > images 


## Reporting issues/bugs
Open an issue if you encounter any problems with the resource, if applicable, try to include detailed information on the issue and how to reproduce it. This will make it much easier to find and fix. You can also create a ticket in Teig's Custom Scripts Discord (https://discord.gg/mAFcFpamZ9)

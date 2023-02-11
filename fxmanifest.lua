fx_version 'cerulean'
game 'gta5'

author 'teig'
description 'QB-Oil (Made by teig)'
version '1.1.0'

client_scripts {
    'client/*.lua'
}

server_scripts {'server/*.lua',    '@oxmysql/lib/MySQL.lua',}
shared_script { 	'@qb-core/shared/locale.lua',
'config.lua',
'locales/en.lua',
}
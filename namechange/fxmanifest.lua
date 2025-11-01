--      ____    ____    ____    ______   _____  ______     
--     /\  _`\ /\  _`\ /\  _`\ /\  _  \ /\___ \/\  _  \    
--     \ \,\L\_\ \ \L\_\ \ \L\_\ \ \L\ \\/__/\ \ \ \L\ \   
--      \/_\__ \\ \  _\L\ \  _\/\ \  __ \  _\ \ \ \  __ \  
--        /\ \L\ \ \ \L\ \ \ \/  \ \ \/\ \/\ \_\ \ \ \/\ \ 
--        \ `\____\ \____/\ \_\   \ \_\ \_\ \____/\ \_\ \_\
--         \/_____/\/___/  \/_/    \/_/\/_/\/___/  \/_/\/_/
--                   https://discord.gg/H7DUpKpDvw  

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Sefaja'
description 'Change Names and Plates'
version '2.0'

shared_scripts {
    '@es_extended/imports.lua',  
    '@ox_lib/init.lua',       
    'config.lua'            
}


client_scripts {
    '@es_extended/locale.lua',
    'client.lua'                
}

server_scripts {
    '@es_extended/locale.lua',
    '@oxmysql/lib/MySQL.lua',   
    'server.lua'                 
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql'
}

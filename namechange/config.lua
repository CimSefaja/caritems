--      ____    ____    ____    ______   _____  ______     
--     /\  _`\ /\  _`\ /\  _`\ /\  _  \ /\___ \/\  _  \    
--     \ \,\L\_\ \ \L\_\ \ \L\_\ \ \L\ \\/__/\ \ \ \L\ \   
--      \/_\__ \\ \  _\L\ \  _\/\ \  __ \  _\ \ \ \  __ \  
--        /\ \L\ \ \ \L\ \ \ \/  \ \ \/\ \/\ \_\ \ \ \/\ \ 
--        \ `\____\ \____/\ \_\   \ \_\ \_\ \____/\ \_\ \_\
--         \/_____/\/___/  \/_/    \/_/\/_/\/___/  \/_/\/_/
--                   https://discord.gg/H7DUpKpDvw  

Config = {}

Config.Lang = {
    ["input"] = {
        title = 'Sefaja Plate Changer',
        label = 'Change Plate',
        desc = 'Min - 3 characters, Max - 8 '
    },
    ["notify"] = {
        lenght = 'Min - 3 characters, Max - 8 ',
        owner = 'Your are not the owner!',
        nearby = 'You are not on the driver seat!',
        newlicenseplate = 'New Plate: ',
        sameplate = 'This plate already exists!'
    }
}

Config.Webhook = "" -- namechange

Config.Discord = {
    webhookURL = ""  -- platechange
}

return Config
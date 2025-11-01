--      ____    ____    ____    ______   _____  ______     
--     /\  _`\ /\  _`\ /\  _`\ /\  _  \ /\___ \/\  _  \    
--     \ \,\L\_\ \ \L\_\ \ \L\_\ \ \L\ \\/__/\ \ \ \L\ \   
--      \/_\__ \\ \  _\L\ \  _\/\ \  __ \  _\ \ \ \  __ \  
--        /\ \L\ \ \ \L\ \ \ \/  \ \ \/\ \/\ \_\ \ \ \/\ \ 
--        \ `\____\ \____/\ \_\   \ \_\ \_\ \____/\ \_\ \_\
--         \/_____/\/___/  \/_/    \/_/\/_/\/___/  \/_/\/_/
--                   https://discord.gg/H7DUpKpDvw  

ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory

local function sendPlateToDiscord(title, message, color)
    local embed = {{
        ["color"] = color or 3447003,
        ["title"] = title,
        ["description"] = message,
        ["footer"] = { ["text"] = os.date("%Y-%m-%d %H:%M:%S") },
    }}

    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Sefaja Platechanger",
        embeds = embed,
        avatar_url = 'https://i.postimg.cc/s2hrpQbW/adswsss.png'
    }), { ['Content-Type'] = 'application/json' })
end

lib.callback.register('s-platechanger:server:CheckOwnerVehicle', function(_, oldPlate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.single.await(
        'SELECT plate FROM owned_vehicles WHERE REPLACE (plate, " ", "") = ? AND owner = ?',
        {oldPlate, xPlayer.identifier}
    )
    if not result then return end
    return true
end)

RegisterNetEvent('s-platechanger:server:updatePlate', function(netID, oldPlate, newPlate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local checkPlate = MySQL.query.await('SELECT * FROM owned_vehicles WHERE plate = ?', {newPlate})
    if not checkPlate[1] then
        MySQL.query('SELECT plate, vehicle FROM owned_vehicles WHERE REPLACE (plate, " ", "") = ?', {oldPlate}, function(result)
            if result[1] then
                local veh = NetworkGetEntityFromNetworkId(netID)
                local vehicle = json.decode(result[1].vehicle)
                vehicle["plate"] = newPlate
                MySQL.update('UPDATE owned_vehicles SET vehicle = ? WHERE REPLACE (plate, " ", "") = ?', {json.encode(vehicle), oldPlate})
                MySQL.update('UPDATE owned_vehicles SET plate = ? WHERE REPLACE (plate, " ", "") = ?', {newPlate, oldPlate})
                SetVehicleNumberPlateText(veh, newPlate)
                TriggerClientEvent('s-platechanger:client:libNotify', src, Config.Lang['notify'].newlicenseplate .. newPlate, 'success')

                ox_inventory:RemoveItem(src, 'platechange', 1)

                sendPlateToDiscord(
                    "Tabela e makinës u ndryshua",
                    ("**Player:** %s\n**Old Plate:** %s\n**New Plate:** %s\n**License:** %s"):format(
                        GetPlayerName(src),
                        oldPlate,
                        newPlate,
                        xPlayer.identifier
                    ),
                    65280
                )
            end
        end)
    else
        TriggerClientEvent('s-platechanger:client:libNotify', src, Config.Lang['notify'].sameplate, 'error')
        sendPlateToDiscord(
            "Ndryshimi i targës dështoi",
            ("**Player:** %s tried to change the plate to an existing one, plate: %s"):format(GetPlayerName(src), newPlate),
            16711680
        )
    end
end)

ESX.RegisterUsableItem('platechange', function(source)
    TriggerClientEvent('platechange', source)
end)

RegisterNetEvent('s-namechange:event', function(fName, lName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.transaction({
            'UPDATE users SET firstname = @fName WHERE identifier = @newfirstname',
            'UPDATE users SET lastname = @lName WHERE identifier = @newsecondname',
        }, {
            ['fName'] = fName,
            ['newfirstname'] = xPlayer.identifier,
            ['lName'] = lName,
            ['newsecondname'] = xPlayer.identifier
        })

        TriggerClientEvent('ox_lib:notify', source, {
            title = nil,
            description = 'Your name has been changed, please leave the city and rejoin!',
            type = 'success',
            position = 'top',
            duration = 5000
        })

        local dmsg =
            '**Old Name:** ' .. xPlayer.name .. '\n' ..
            '**License:** ```' .. xPlayer.identifier .. '```' .. '\n' ..
            '**New Name:** \n**First Name**: ' .. fName .. '\n**Last Name**: ' .. lName

        PerformHttpRequest(Config.Discord.webhookURL, function(err, text, headers) end, 'POST',
            json.encode({ username = 'Sefaja Namechange', embeds = {{['color']=16753920, ['title']='Someone changed their name', ['description']=dmsg}} ,
            avatar_url = 'https://i.postimg.cc/s2hrpQbW/adswsss.png'}), { ['Content-Type'] = 'application/json' })

        ox_inventory:RemoveItem(source, 'namechange', 1)
    end
end)

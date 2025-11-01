--      ____    ____    ____    ______   _____  ______     
--     /\  _`\ /\  _`\ /\  _`\ /\  _  \ /\___ \/\  _  \    
--     \ \,\L\_\ \ \L\_\ \ \L\_\ \ \L\ \\/__/\ \ \ \L\ \   
--      \/_\__ \\ \  _\L\ \  _\/\ \  __ \  _\ \ \ \  __ \  
--        /\ \L\ \ \ \L\ \ \ \/  \ \ \/\ \/\ \_\ \ \ \/\ \ 
--        \ `\____\ \____/\ \_\   \ \_\ \_\ \____/\ \_\ \_\
--         \/_____/\/___/  \/_/    \/_/\/_/\/___/  \/_/\/_/
--                   https://discord.gg/H7DUpKpDvw  

local function giveVehicleOwnership(playerId, vehicleData)
    local src = playerId
    local model = vehicleData.model or 'adder'
    local plate = vehicleData.plate or ('CAR' .. math.random(1111, 9999))
    local props = vehicleData.props or {}

    if GetResourceState('esx_core') == 'started' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return end

        MySQL.Async.execute(
            'INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (@owner, @plate, @vehicle, @type, @stored)',
            {
                ['@owner'] = xPlayer.identifier,
                ['@plate'] = plate,
                ['@vehicle'] = json.encode({
                    model = model,
                    plate = plate,
                    props = props
                }),
                ['@type'] = 'car',
                ['@stored'] = 1
            }
        )

        TriggerClientEvent('lib:notify', src, { description = 'Vehicle ownership saved.' })

    elseif GetResourceState('qb-core') == 'started' then
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if not xPlayer then return end

        MySQL.Async.execute(
            'INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (@license, @citizenid, @vehicle, @hash, @mods, @plate, @garage, @state)',
            {
                ['@license'] = xPlayer.PlayerData.license,
                ['@citizenid'] = xPlayer.PlayerData.citizenid,
                ['@vehicle'] = model,
                ['@hash'] = joaat(model),
                ['@mods'] = json.encode(props),
                ['@plate'] = plate,
                ['@garage'] = 'pillboxgarage',
                ['@state'] = 1
            }
        )

        TriggerClientEvent('lib:notify', src, { description = 'Vehicle ownership saved.' })

    else
        print(("Sefaja-CarItems: No framework detected for player %s"):format(src))
    end
end

RegisterNetEvent('Sefaja-CarItems:giveVehicleOwnership', function(netId)
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(netId)

    if not DoesEntityExist(vehicle) then return end

    local model = GetEntityModel(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    local props = {}

    giveVehicleOwnership(src, {
        model = model,
        plate = plate,
        props = props
    })
end)

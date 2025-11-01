--      ____    ____    ____    ______   _____  ______     
--     /\  _`\ /\  _`\ /\  _`\ /\  _  \ /\___ \/\  _  \    
--     \ \,\L\_\ \ \L\_\ \ \L\_\ \ \L\ \\/__/\ \ \ \L\ \   
--      \/_\__ \\ \  _\L\ \  _\/\ \  __ \  _\ \ \ \  __ \  
--        /\ \L\ \ \ \L\ \ \ \/  \ \ \/\ \/\ \_\ \ \ \/\ \ 
--        \ `\____\ \____/\ \_\   \ \_\ \_\ \____/\ \_\ \_\
--         \/_____/\/___/  \/_/    \/_/\/_/\/___/  \/_/\/_/
--                   https://discord.gg/H7DUpKpDvw  

local Config = Config or {}
if not next(Config) then
    Config = LoadResourceFile(GetCurrentResourceName(), 'config.lua') and assert(load(LoadResourceFile(GetCurrentResourceName(), 'config.lua')))() or {}
end

local function spawnVehicle(vehicleName)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local model = joaat(vehicleName)

    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then
        lib.notify({ type = 'error', description = 'Invalid vehicle model.' })
        return
    end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    local currentVeh = GetVehiclePedIsIn(playerPed, false)
    if currentVeh ~= 0 then
        DeleteVehicle(currentVeh)
    end

    local vehicle = CreateVehicle(model, playerCoords.x, playerCoords.y, playerCoords.z + 1.0, GetEntityHeading(playerPed), true, false)

    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(vehicle), true)
    SetEntityAsMissionEntity(vehicle, true, false)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

    SetModelAsNoLongerNeeded(model)

    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerServerEvent('Sefaja-CarItems:giveVehicleOwnership', NetworkGetNetworkIdFromEntity(vehicle))

    lib.notify({ description = ('%s spawned successfully!'):format(vehicleName) })
end

exports('vehicleSpawn', function(data, slot)
    local itemName = data.name
    local vehicleInfo = Config.VehicleItems[itemName]

    if not vehicleInfo then
        lib.notify({ type = 'error', description = 'No vehicle linked to this item!' })
        return
    end

    exports.ox_inventory:useItem(data, function(success)
        if success then
            spawnVehicle(vehicleInfo.vehicle)
        else
            lib.notify({ type = 'error', description = 'Failed to use vehicle item.' })
        end
    end)
end)

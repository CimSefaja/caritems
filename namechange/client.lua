--      ____    ____    ____    ______   _____  ______     
--     /\  _`\ /\  _`\ /\  _`\ /\  _  \ /\___ \/\  _  \    
--     \ \,\L\_\ \ \L\_\ \ \L\_\ \ \L\ \\/__/\ \ \ \L\ \   
--      \/_\__ \\ \  _\L\ \  _\/\ \  __ \  _\ \ \ \  __ \  
--        /\ \L\ \ \ \L\ \ \ \/  \ \ \/\ \/\ \_\ \ \ \/\ \ 
--        \ `\____\ \____/\ \_\   \ \_\ \_\ \____/\ \_\ \_\
--         \/_____/\/___/  \/_/    \/_/\/_/\/___/  \/_/\/_/
--                   https://discord.gg/H7DUpKpDvw  

ESX = exports["es_extended"]:getSharedObject()

function mainFnc()
    local input = lib.inputDialog('Name Change Menu', {
        {
            type = 'input',
            label = 'First Name',
            placeholder = 'Type New First Name',
            icon = 'fa-solid fa-note-sticky',
            required = true,
            min = 2,
            max = 16,
        },
        {
            type = 'input',
            label = 'Last Name',
            placeholder = 'Type New Last Name',
            icon = 'fa-solid fa-note-sticky',
            required = true,
            min = 2,
            max = 16,
        },
        {
            type = 'checkbox',
            label = 'Are you sure?',
            required = true
        },
    })

    if input then
        local fName = input[1]
        local lName = input[2]
        TriggerServerEvent('s-namechange:event', fName, lName)
    end
end

exports('namechange', function()
    lib.progressBar({
        duration = 5000,
        label = "Change Name",
        useWhileDead = false,
        canCancel = true,
        disable = { car = false },
    })
    TriggerEvent('s-mainevent')
end)

RegisterNetEvent("s-mainevent")
AddEventHandler("s-mainevent", function()
    mainFnc()
end)

local function plateChangerFnc()
    local nearByVehicle = lib.getNearbyVehicles(GetEntityCoords(PlayerPedId()), 0.3, true)
    if nearByVehicle[1] then 
        local vehicle = nearByVehicle[1].vehicle
        local oldPlate = GetVehicleNumberPlateText(vehicle):gsub('[%p%c%s]', '')
        local checkOwner = lib.callback.await('s-platechanger:server:CheckOwnerVehicle', false, oldPlate)
        if checkOwner then 
            local plateChangerInput = lib.inputDialog(Config.Lang["input"].title, {{
                type = 'input',
                label = Config.Lang["input"].label,
                description = Config.Lang["input"].desc,
                icon = {'fa', 'clapperboard'}
            }})
            if not plateChangerInput then return end
            local newPlate = string.upper(plateChangerInput[1])
            if #newPlate >= 3 and #newPlate <= 8 then 
                TriggerServerEvent('s-platechanger:server:updatePlate', NetworkGetNetworkIdFromEntity(vehicle), oldPlate, newPlate)
            else
                lib.notify({title = Config.Lang["notify"].lenght, type = 'error'})
            end
        else
            lib.notify({title = Config.Lang["notify"].owner, type = 'error'})
        end
    else
        lib.notify({title = Config.Lang["notify"].nearby, type = 'error'})
    end
end

exports('platechange', function()
    plateChangerFnc()
end)

RegisterNetEvent('s-platechanger:client:libNotify', function(titleText, type)
    lib.notify({title = titleText, type = type})
end)

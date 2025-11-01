# CarItems
Vehicles as Items for OX Inventory
ESX and QB Core

Install:
Drag and Drop the file on your resources folder
Edit the config file to your liking, choose item name and set car spawn name 
Add the items in ox_inventory\data\items.lua  in this format: 

['zentorno'] = {
        label = 'Zentorno',
        weight = 500,
        stack = true,
        close = true,
        client = {
            export = 'Sefaja-CarItems.vehicleSpawn',
            usetime = 5000,    
            anim = { dict = 'amb@world_human_seat_wall_tablet@female@base', clip = 'base' },
            prop = {
                model = 'prop_cs_tablet',
                pos = { x = 0.17, y = 0.10, z = -0.13 },
                rot = { x = 20.0, y = 180.0, z = 180.0 },
                bone = 57005
            }
        }
    },

Start the resource 

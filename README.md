# Vehicles as Items for OX Inventory (ESX & QB Core)

Easily spawn vehicles as items in your OX Inventory system for ESX or QB Core.

---

## Installation

1. Drag and drop the folder into your `resources` directory.
2. Edit the `config` file to your preferences:
   - Choose your item name.
   - Set the car spawn name.
3. Add the items to `ox_inventory\data\items.lua` in the following format:

```lua
['zentorno'] = {
    label = 'Zentorno',
    weight = 500,
    stack = true,
    close = true,
    client = {
        export = 'Sefaja-CarItems.vehicleSpawn',
        usetime = 5000,
        anim = {
            dict = 'amb@world_human_seat_wall_tablet@female@base',
            clip = 'base'
        },
        prop = {
            model = 'prop_cs_tablet',
            pos = { x = 0.17, y = 0.10, z = -0.13 },
            rot = { x = 20.0, y = 180.0, z = 180.0 },
            bone = 57005
        }
    }
},

4. Start the resource

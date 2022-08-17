local VorpCore = {}
local loaded = false
local cooldown = {}
local items = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)
Inventory = exports.vorp_inventory:vorp_inventoryApi()

--############################## Server Callbacks ##############################--

--get all items related to the object
RegisterServerEvent('moonshiner:getItems')
AddEventHandler("moonshiner:getItems", function(value, label, items)
    local _source = source

    for k,v in pairs(items) do
        Wait(100)

        items[#items+1] = {object=value, lab=label, name=k, count=v}
    end
end)

--get all items related to the object
RegisterServerEvent('moonshiner:initPlants')
AddEventHandler("moonshiner:initPlants", function(point, plant)
    local _source = source
    cooldown[#cooldown+1] = {object=plant, x=point.x, y=point.y, z=point.z, cooldown=0}
end)

RegisterServerEvent('moonshiner:goToCheckPrompt')
AddEventHandler("moonshiner:goToCheckPrompt", function(distance)
    local _source = source
    TriggerClientEvent("moonshiner:checkPrompt", _source, distance)
end)

RegisterServerEvent('moonshiner:getPlants')
AddEventHandler("moonshiner:getPlants", function()
    local _src = source
    TriggerClientEvent("moonshiner:placePlants", _src, cooldown, items)
end)

-- check items for mash in inventory
RegisterServerEvent('moonshiner:check_mashItems')
AddEventHandler("moonshiner:check_mashItems", function(mash, itemArray, time, minXP, maxXP, message)
    local _source = source
    local hasAllItems = false
    for k,v in pairs(itemArray) do
        local count = Inventory.getItemCount(_source, k)
        if count >= v then
            hasAllItems = true
        else 
            hasAllItems = false
            break
        end
    end
    if hasAllItems then
        for k,v in pairs(itemArray) do
            Inventory.subItem(_source, k, v)
        end
        TriggerClientEvent("moonshiner:startMash", _source, mash, itemArray, time, minXP, maxXP, message)
    else
        TriggerClientEvent("vorp:TipBottom", _source, message, 4000)
    end
end)

-- check items for moonshine in inventory
RegisterServerEvent('moonshiner:check_moonshineItems')
AddEventHandler("moonshiner:check_moonshineItems", function(moonshine, itemArray, moonshineTime, message)
    local _source = source
    local hasAllItems = false
    for k,v in pairs(itemArray) do
        local count = Inventory.getItemCount(_source, k)
        if count >= v then
            hasAllItems = true
        else 
            hasAllItems = false
            break
        end
    end
    if hasAllItems then
        for k,v in pairs(itemArray) do
            Inventory.subItem(_source, k, v)
        end
        TriggerClientEvent("moonshiner:startBrewing", _source, moonshine, itemArray, moonshineTime)
    else
        TriggerClientEvent("vorp:TipBottom", _source, message, 4000)
    end
end)
--############################## END Server Callbacks ##############################--

--############################## Usable Items ##############################--
Citizen.CreateThread(function()
	Citizen.Wait(2000)
	Inventory.RegisterUsableItem(Config.brewProp, function(data)
        TriggerClientEvent("moonshiner:placeProp", data.source, Config.brewProp)
        Inventory.subItem(data.source, Config.brewProp, 1)
    end)
    Inventory.RegisterUsableItem(Config.mashProp, function(data)
        TriggerClientEvent("moonshiner:placeProp", data.source, Config.mashProp)
        Inventory.subItem(data.source, Config.mashProp, 1)
	end)
end)
--############################## END Usable Items ##############################--

--############################## Item Management ##############################--
RegisterServerEvent('moonshiner:giveMoonshine')
AddEventHandler("moonshiner:giveMoonshine", function(moonshineName, minXP, maxXP)
    local _source = source
    local xp = math.random(minXP, maxXP)
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    
    Inventory.addItem(_source, moonshineName, 1)
end)

RegisterServerEvent('moonshiner:giveMash')
AddEventHandler("moonshiner:giveMash", function(mashName, minXP, maxXP)
    local _source = source
    local xp = math.random(minXP, maxXP)
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier

    Inventory.addItem(_source, mashName, 1)
end)

RegisterServerEvent('moonshiner:givePropBack')
AddEventHandler("moonshiner:givePropBack", function(propName)
    local _source = source
    Inventory.addItem(_source, propName, 1)
end)

RegisterServerEvent('moonshiner:todb')
AddEventHandler("moonshiner:todb", function(propName, xpos, ypos, zpos)
    local _source = source

    exports.ghmattimysql:execute( "INSERT INTO moonshiner SET object = ? , xpos = ? , ypos = ? , zpos = ? ;",
    {
        propName,
        xpos,
        ypos,
        zpos
    })
end)

RegisterServerEvent('moonshiner:outdb')
AddEventHandler("moonshiner:outdb", function(id)
    local _source = source

    exports.ghmattimysql:execute( "DELETE FROM moonshiner WHERE id = ?",{
        id
    })

end)


RegisterServerEvent('moonshiner:giveHarvestItems')
AddEventHandler("moonshiner:giveHarvestItems", function(itemName, itemCount)
    local _source = source
    Inventory.addItem(_source, itemName, itemCount)
    TriggerClientEvent("vorp:TipBottom", _source, _U('got_Harvest_Item_Info', itemCount.." "..itemName), 4000)
end)


function initmoonshine()
    local shacks = {}

    exports.ghmattimysql:execute('SELECT * FROM moonshiner', {}, function(result)
        if(#result ~= 0)then
            shacks = result
        end
        for i,v in pairs(shacks) do
            TriggerClientEvent("moonshiner:placePropStart", -1, v.object, v.xpos, v.ypos, v.zpos)
            print("^2[Moonshiner]: placed object", v.xpos, v.ypos, v.zpos, v.object)
        end
    end)

end

function setInnactif(src, id, object, xpos, ypos, zpos)

    exports.ghmattimysql:execute( "UPDATE moonshiner SET actif = 0 WHERE id = ?", {
        id
    })
    TriggerClientEvent("moonshiner:deleteprop", src, id, object, xpos, ypos, zpos)

end


RegisterServerEvent('moonshiner:load')
AddEventHandler("moonshiner:load", function()
    if loaded == false then
        initmoonshine()
        print("Moonshiner reloaded!")
        loaded = true
    end
end)

RegisterServerEvent('moonshiner:getCoordsId')
AddEventHandler("moonshiner:getCoordsId", function(x, y, z)
    local _source = source
    local shacks = {}

    exports.ghmattimysql:execute('SELECT * FROM moonshiner', {}, function(result)
        if(#result ~= 0)then
            shacks = result
        end
        for i,v in pairs (shacks) do
            TriggerClientEvent("moonshiner:getId", _source, x, y, z, v.object, v.xpos, v.ypos, v.zpos)
        end
    end)

end)

RegisterServerEvent('moonshiner:updateProps')
AddEventHandler("moonshiner:updateProps", function()
    local _source = source
    local shacks = {}

    exports.ghmattimysql:execute('SELECT * FROM moonshiner', {}, function(result)
        if(#result ~= 0)then
            shacks = result
        end
        for i,v in pairs (shacks) do
            TriggerClientEvent("moonshiner:replaceProps", _source, v.object, v.xpos, v.ypos, v.zpos, v.actif)
        end
    end)

end)

RegisterServerEvent('moonshiner:innactif')
AddEventHandler("moonshiner:innactif", function(id, object, xpos, ypos, zpos)
    local ids = id
    local obj = object
    local x = xpos
    local y = ypos
    local z = zpos
    local _source = source

    exports.ghmattimysql:execute( "UPDATE moonshiner SET actif = 0 WHERE id = ?", {id})

    TriggerClientEvent("moonshiner:deleteprop", _source, ids, obj, x, y, z)
end)

RegisterServerEvent('moonshiner:getObjectId')
AddEventHandler("moonshiner:getObjectId", function(object, x, y, z)
    local _source = source
    local shacks = {}

    exports.ghmattimysql:execute('SELECT * FROM moonshiner WHERE object = ? AND xpos like ? AND ypos like ? AND zpos like ? ;', 
    {
        object,
        x,
        y,
        z
    }, function(result)

        if(#result ~= 0)then
            shacks = result
            for i,v in pairs (shacks) do
                --TriggerEvent("moonshiner:innactif", v.id, v.object, v.xpos, v.ypos, v.zpos)
                setInnactif(_source, v.id, v.object, v.xpos, v.ypos, v.zpos)
            end
        end
    end)
end)


--############################## END Item Management ##############################--
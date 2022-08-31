local VorpCore = {}
local loaded = false
local cooldown = {}
local plantsInitiated = false

TriggerEvent("getCore",function(core)
    VorpCore = core
end)
Inventory = exports.vorp_inventory:vorp_inventoryApi()

--############################## Server Callbacks ##############################--

--get all items related to the object



RegisterServerEvent('moonshiner:initPlants')
AddEventHandler("moonshiner:initPlants", function(pointx, pointy, pointz, plant, rid)
    cooldown[#cooldown+1] = {pedid = rid, object=plant, x=pointx, y=pointy, z=pointz, cooldown=0}
    print(#cooldown, cooldown[#cooldown].pedid, cooldown[#cooldown].object, cooldown[#cooldown].x, cooldown[#cooldown].z, cooldown[#cooldown].z, cooldown[#cooldown].cooldown)
end)

RegisterServerEvent('moonshiner:setCooldown')
AddEventHandler("moonshiner:setCooldown", function(hash, x, y, z, rid)
    local shacks = {}
    local _source = source
    print(hash, x, y, z)
    exports.ghmattimysql:execute('SELECT * FROM moonshiner_plants WHERE object = ? AND xpos like ? AND ypos like ? AND zpos like ? ;', 
    {
        hash,
        x,
        y,
        z
    }, function(result)

        if(#result ~= 0)then
            shacks = result
            for i,v in pairs (shacks) do
                --TriggerEvent("moonshiner:innactif", v.id, v.object, v.xpos, v.ypos, v.zpos)
                print(v.id)
                setPlantCooldown(_source, v.id, v.object, v.xpos, v.ypos, v.zpos)
            end
        end
    end)
end)

RegisterServerEvent('moonshiner:searchPlant')
AddEventHandler("moonshiner:searchPlant", function(hash, x, y, z, rid)
    local shacks = {}
    local _source = source
    exports.ghmattimysql:execute('SELECT * FROM moonshiner_plants', {}, function(result)

        if(#result ~= 0)then
            shacks = result
            for i,v in pairs (shacks) do
                print(v.xpos, v.ypos, v.zpos, v.object)
                TriggerClientEvent("moonshiner:comparePlantsCoords", _source, x, y, z, v.xpos, v.ypos, v.zpos, v.object)
            end
        end
    end)
end)

RegisterNetEvent("takeid")
AddEventHandler("takeid", function(netid)
	for _,player in pairs(GetPlayers()) do
		Wait(500)
		TriggerClientEvent("giveplayerid", player, player)
	end
end)

RegisterServerEvent('moonshiner:getPlants')
AddEventHandler("moonshiner:getPlants", function(rid)
    local _source = source

    for k,v in pairs(cooldown) do
        Wait(100)
        if rid == v.pedid then
            TriggerClientEvent("moonshiner:placePlants", _source, cooldown[k].object, cooldown[k].x, cooldown[k].y, cooldown[k].z, cooldown[k].cooldown)
            plantsInitiated = true
        end
    end
end)

RegisterServerEvent('moonshiner:cooldown60')
AddEventHandler("moonshiner:cooldown60", function(object, x, y, z)
    local _source = source
    local shacks = {}

    exports.ghmattimysql:execute('SELECT * FROM moonshiner_plants WHERE object = ? AND xpos like ? AND ypos like ? AND zpos like ? ;', 
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
                print("updated")
                resetCooldown(v.id, v.cooldown)
            end
        end
    end)
end)

RegisterServerEvent('moonshiner:updateCooldown')
AddEventHandler("moonshiner:updateCooldown", function(object, x, y, z)
    local _source = source
    local shacks = {}

    exports.ghmattimysql:execute('SELECT * FROM moonshiner_plants WHERE object = ? AND xpos like ? AND ypos like ? AND zpos like ? ;', 
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
                print("updated")
                updatePlantsCooldown(_source, v.id, v.cooldown)
            end
        end
    end)
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
    exports["ghmattimysql"]:execute("SELECT clanid FROM characters WHERE identifier = @identifier,charidentifier = @charidentifier", { ["@identifier"] = identifier,["@charidentifier"] = charidentifier }, function(result)
        if result[1].clanid ~= nil then
            local clanid = result[1].clanid
            local exp = xp
            exports.ghmattimysql:execute("UPDATE camp Set exp=exp+@exp WHERE clanid=@clanid", {['clanid'] = clanid,['exp'] = exp})
        end
    end)
    Inventory.addItem(_source, moonshineName, 1)
end)

RegisterServerEvent('moonshiner:giveMash')
AddEventHandler("moonshiner:giveMash", function(mashName, minXP, maxXP)
    local _source = source
    local xp = math.random(minXP, maxXP)
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local charidentifier = Character.charIdentifier
    exports["ghmattimysql"]:execute("SELECT clanid FROM characters WHERE identifier = @identifier,charidentifier = @charidentifier", { ["@identifier"] = identifier,["@charidentifier"] = charidentifier }, function(result)
        if result[1].clanid ~= nil then
            local clanid = result[1].clanid
            local exp = xp
            exports.ghmattimysql:execute("UPDATE camp Set exp=exp+@exp WHERE clanid=@clanid", {['clanid'] = clanid,['exp'] = exp})
        end
    end)
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

function updatePlantsCooldown(src, id, cooldown)
    local newcooldown = cooldown - 1 

    if cooldown > 0 then
        exports.ghmattimysql:execute( "UPDATE moonshiner_plants SET cooldown = ? WHERE id = ?", {
            newcooldown,
            id
        })
        TriggerClientEvent("moonshiner:deleteplant", src, id, object, xpos, ypos, zpos)
    end

end

function resetCooldown(id, cooldown)

    exports.ghmattimysql:execute( "UPDATE moonshiner_plants SET cooldown = 60 WHERE id = ?", {
        id
    })
    TriggerClientEvent("moonshiner:deleteplant", src, id, object, xpos, ypos, zpos)

end

function setPlantCooldown(src, id, object, xpos, ypos, zpos)

    exports.ghmattimysql:execute( "UPDATE moonshiner_plants SET cooldown = 60 WHERE id = ?", {
        id
    })
    print(id)
    TriggerClientEvent("moonshiner:deleteplant", src, id, object, xpos, ypos, zpos)

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

RegisterServerEvent('moonshiner:updatePlants')
AddEventHandler("moonshiner:updatePlants", function()
    local _source = source
    local shacks = {}

    exports.ghmattimysql:execute('SELECT * FROM moonshiner_plants', {}, function(result)
        if(#result ~= 0)then
            shacks = result
        end
        for i,v in pairs (shacks) do
            --print("eupodate")
            TriggerClientEvent("moonshiner:replacePlants", _source, v.object, v.xpos, v.ypos, v.zpos, v.cooldown)

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

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)


local Items = {
	--{item = "consumable_herb_chanterelles", name = "some Chanterelles", min = minimum you can collect, max = maximum you can collect},
	
	ginseng = {
        ginseng = "American_Ginseng", name = "American Ginseng!", min = 1, max = 3
    },

	bay = {
        bay = "Bay_Bolete", name = "Bay Bolete!", min = 1, max = 3
    },
    huck = {
	    huck = "Evergreen_Huckleberry", name = "Evergreen Huckleberry!", min = 1, max = 3
    },

    mint = {
        mint = "Wild_Mint", name = "Wild Mint!", min = 1, max = 3
    },

    algin ={
        algin = "Alaskan_Ginseng", name = "Alaskan Ginseng!", min = 1, max = 3
    },
    
	black = {
        black = "Black_Currant", name = "Black Currant!", min = 1, max = 3
    },
    
    blackberry = {
        blackberry = "Black_Berry", name = "Black Berry!", min = 1, max = 3
    },

    raspberry = {
        raspberry = "Red_Raspberry", name = "Red Raspberry!", min = 1, max = 3
    }
}



RegisterServerEvent('vorp_moonshine:addItemraspberry')
AddEventHandler('vorp_moonshine:addItemraspberry', function()
    local _source = source
    local FinalLoot = LootToGiveRaspberry(source)
	local User = VorpCore.getUser(source).getUsedCharacter
    for k,v in pairs(Items) do
        
		if v.raspberry == FinalLoot then
            local amount = math.random(v.min, v.max)
            local invAvailable = VorpInv.canCarryItems(_source, amount)
            if invAvailable ~= true then
                TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous ne pouvez pas porter plus de ~o~"..v.name, "INVENTORY_ITEMS", "consumable_herb_red_raspberry", 3000)
            else
                VorpInv.addItem(source, FinalLoot, amount)
			    LootsToGive = {}
			    TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous avez obtenu ~o~"..amount.." "..v.name, "INVENTORY_ITEMS", "consumable_herb_red_raspberry", 3000)
            end
		end
    end
end)

RegisterServerEvent('vorp_moonshine:addItembay')
AddEventHandler('vorp_moonshine:addItembay', function()
    local _source = source
    local FinalLoot = LootToGivebay(source)
	local User = VorpCore.getUser(source).getUsedCharacter
    for k,v in pairs(Items) do
        
		if v.bay == FinalLoot then
			local amount = math.random(v.min, v.max)
            local invAvailable = VorpInv.canCarryItems(_source, amount)
            if invAvailable ~= true then
                TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous ne pouvez pas porter plus de ~o~"..v.name, "INVENTORY_ITEMS", "consumable_herb_bay_bolete", 3000)
            else
                VorpInv.addItem(source, FinalLoot, amount)
			    LootsToGive = {}
			    TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous avez obtenu ~o~"..amount.." "..v.name, "INVENTORY_ITEMS", "consumable_herb_bay_bolete", 3000)
            end
		end
    end
end)

RegisterServerEvent('vorp_moonshine:addItemginseng')
AddEventHandler('vorp_moonshine:addItemginseng', function()
    local _source = source
    local FinalLoot = LootToGiveginseng(source)
	local User = VorpCore.getUser(source).getUsedCharacter
    for k,v in pairs(Items) do
        
		if v.ginseng == FinalLoot then
			local amount = math.random(v.min, v.max)
            local invAvailable = VorpInv.canCarryItems(_source, amount)
            if invAvailable ~= true then
                TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous ne pouvez pas porter plus de ~o~"..v.name, "INVENTORY_ITEMS", "consumable_herb_american_ginseng", 3000)
            else
                VorpInv.addItem(source, FinalLoot, amount)
			    LootsToGive = {}
			    TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous avez obtenu ~o~"..amount.." "..v.name, "INVENTORY_ITEMS", "consumable_herb_american_ginseng", 3000)
            end
		end
    end
end)

RegisterServerEvent('vorp_moonshine:addItemblackberry')
AddEventHandler('vorp_moonshine:addItemblackberry', function()
    local _source = source
    local FinalLoot = LootToGiveblackberry(source)
	local User = VorpCore.getUser(source).getUsedCharacter
    for k,v in pairs(Items) do
        
		if v.blackberry == FinalLoot then
			local amount = math.random(v.min, v.max)
            local invAvailable = VorpInv.canCarryItems(_source, amount)
            if invAvailable ~= true then
                TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous ne pouvez pas porter plus de ~o~"..v.name, "INVENTORY_ITEMS", "consumable_herb_black_berry", 3000)
            else
                VorpInv.addItem(source, FinalLoot, amount)
			    LootsToGive = {}
			    TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous avez obtenu ~o~"..amount.." "..v.name, "INVENTORY_ITEMS", "consumable_herb_black_berry", 3000)
            end
		end
    end
end)

RegisterServerEvent('vorp_moonshine:addItemmint')
AddEventHandler('vorp_moonshine:addItemmint', function()
    local _source = source
    local FinalLoot = LootToGivemint(source)
	local User = VorpCore.getUser(source).getUsedCharacter
    for k,v in pairs(Items) do
        
		if v.mint == FinalLoot then
			local amount = math.random(v.min, v.max)
            local invAvailable = VorpInv.canCarryItems(_source, amount)
            if invAvailable ~= true then
                TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous ne pouvez pas porter plus de ~o~"..v.name, "INVENTORY_ITEMS", "consumable_herb_wild_mint", 3000)
            else
                VorpInv.addItem(source, FinalLoot, amount)
			    LootsToGive = {}
			    TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous avez obtenu ~o~"..amount.." "..v.name, "INVENTORY_ITEMS", "consumable_herb_wild_mint", 3000)
            end
		end
    end
end)
RegisterServerEvent('vorp_moonshine:addItemhuck')
AddEventHandler('vorp_moonshine:addItemhuck', function()
    local _source = source
    local FinalLoot = LootToGivehuck(source)
	local User = VorpCore.getUser(source).getUsedCharacter
    for k,v in pairs(Items) do
        
		if v.huck == FinalLoot then
			local amount = math.random(v.min, v.max)
            local invAvailable = VorpInv.canCarryItems(_source, amount)
            if invAvailable ~= true then
                TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous ne pouvez pas porter plus de ~o~"..v.name, "INVENTORY_ITEMS", "consumable_herb_evergreen_huckleberry", 3000)
            else
                VorpInv.addItem(source, FinalLoot, amount)
			    LootsToGive = {}
			    TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous avez obtenu ~o~"..amount.." "..v.name, "INVENTORY_ITEMS", "consumable_herb_evergreen_huckleberry", 3000)
            end
		end
    end
end)
RegisterServerEvent('vorp_moonshine:addItemalgin')
AddEventHandler('vorp_moonshine:addItemalgin', function()
    local _source = source
    local FinalLoot = LootToGivealgin(source)
	local User = VorpCore.getUser(source).getUsedCharacter
    for k,v in pairs(Items) do
        
		if v.algin == FinalLoot then
			local amount = math.random(v.min, v.max)
            local invAvailable = VorpInv.canCarryItems(_source, amount)
            if invAvailable ~= true then
                TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous ne pouvez pas porter plus de ~o~"..v.name, "INVENTORY_ITEMS", "consumable_herb_alaskan_ginseng", 3000)
            else
                VorpInv.addItem(source, FinalLoot, amount)
			    LootsToGive = {}
			    TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous avez obtenu ~o~"..amount.." "..v.name, "INVENTORY_ITEMS", "consumable_herb_alaskan_ginseng", 3000)
            end
		end
    end
end)

RegisterServerEvent('vorp_moonshine:addItemblack')
AddEventHandler('vorp_moonshine:addItemblack', function()
    local _source = source
    local FinalLoot = LootToGiveblack(source)
	local User = VorpCore.getUser(source).getUsedCharacter
    for k,v in pairs(Items) do
        
		if v.black == FinalLoot then
			local amount = math.random(v.min, v.max)
            local invAvailable = VorpInv.canCarryItems(_source, amount)
            if invAvailable ~= true then
                TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous ne pouvez pas porter plus de ~o~"..v.name, "INVENTORY_ITEMS", "consumable_herb_black_currant", 3000)
            else
                VorpInv.addItem(source, FinalLoot, amount)
			    LootsToGive = {}
			    TriggerClientEvent("vorp:NotifyLeft",_source, "Collecte","Vous avez obtenu ~o~"..amount.." "..v.name, "INVENTORY_ITEMS", "consumable_herb_black_currant", 3000)
            end
		end
    end
end)

function LootToGiveRaspberry(source)
    local LootsToGive = {}
    for k,v in pairs(Items) do
		table.insert(LootsToGive,v.raspberry)
	end
    if LootsToGive[1] ~= nil then
		local value = math.random(1,#LootsToGive)
		local picked = LootsToGive[value]
		return picked
	end
end


function LootToGivebay(source)
    local LootsToGive = {}
    for k,v in pairs(Items) do
		table.insert(LootsToGive,v.bay)
	end
    if LootsToGive[1] ~= nil then
		local value = math.random(1,#LootsToGive)
		local picked = LootsToGive[value]
		return picked
	end
end

function LootToGivemint(source)
    local LootsToGive = {}
    for k,v in pairs(Items) do
		table.insert(LootsToGive,v.mint)
	end
    if LootsToGive[1] ~= nil then
		local value = math.random(1,#LootsToGive)
		local picked = LootsToGive[value]
		return picked
	end
end
function LootToGiveblackberry(source)
    local LootsToGive = {}
    for k,v in pairs(Items) do
		table.insert(LootsToGive,v.blackberry)
	end
    if LootsToGive[1] ~= nil then
		local value = math.random(1,#LootsToGive)
		local picked = LootsToGive[value]
		return picked
	end
end
function LootToGiveginseng(source)
    local LootsToGive = {}
    for k,v in pairs(Items) do
		table.insert(LootsToGive,v.ginseng)
	end
    if LootsToGive[1] ~= nil then
		local value = math.random(1,#LootsToGive)
		local picked = LootsToGive[value]
		return picked
	end
end
function LootToGiveblack(source)
    local LootsToGive = {}
    for k,v in pairs(Items) do
		table.insert(LootsToGive,v.black)
	end
    if LootsToGive[1] ~= nil then
		local value = math.random(1,#LootsToGive)
		local picked = LootsToGive[value]
		return picked
	end
end
function LootToGivealgin(source)
    local LootsToGive = {}
    for k,v in pairs(Items) do
		table.insert(LootsToGive,v.algin)
	end
    if LootsToGive[1] ~= nil then
		local value = math.random(1,#LootsToGive)
		local picked = LootsToGive[value]
		return picked
	end
end

function LootToGivehuck(source)
    local LootsToGive = {}
    for k,v in pairs(Items) do
		table.insert(LootsToGive,v.huck)
	end
    if LootsToGive[1] ~= nil then
		local value = math.random(1,#LootsToGive)
		local picked = LootsToGive[value]
		return picked
	end
end


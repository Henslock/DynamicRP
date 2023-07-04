-- Configure Player Stats and Inventory Management --

if SERVER then
	util.AddNetworkString( "craftingUpdateStats" )
	util.AddNetworkString( "craftingUpdateMaterials" )
	util.AddNetworkString( "craftingGiveEnt" )
	util.AddNetworkString( "craftingInitData" )
	util.AddNetworkString( "craftingUpdateViewModel" )
end

crafting = {} or crafting

/******************
* LOADING DATA
*******************/

function crafting.LoadPlayerInfo(ply, name)
	return file.Read("hens_crafting_mod/"..ply:UniqueID().."/"..name..".txt")
end

function crafting.SavePlayerInfo(ply, name, data)
	file.CreateDir("hens_crafting_mod")
	file.CreateDir("hens_crafting_mod/"..ply:UniqueID())
	file.Write("hens_crafting_mod/"..ply:UniqueID().."/"..name..".txt", data)
end

function crafting.LoadInventory(ply)
	local tbl = (file.Read("hens_crafting_mod/"..ply:UniqueID().."/inventory.txt"))
	if(tbl ~= nil) then
		return util.JSONToTable(file.Read("hens_crafting_mod/"..ply:UniqueID().."/inventory.txt"))
	else
		return nil
	end
end

function crafting.SaveInventory(ply, data)
	local tbl = util.TableToJSON(data)
	file.CreateDir("hens_crafting_mod")
	file.CreateDir("hens_crafting_mod/"..ply:UniqueID())
	file.Write("hens_crafting_mod/"..ply:UniqueID().."/inventory.txt", tbl)
end

-- Give Crafting XP
function crafting.GiveXP(ply, amnt)
	
	if(ply.crafting == nil) then crafting.InitializePlayers(ply) end
	if(CRFT_PRESTIGE_ENABLED == false) and (ply.crafting.level >= CRAFTING_MAX_LEVEL) then return end
	ply.crafting.experience = ply.crafting.experience + amnt;
	
	if(ply.crafting.experience >= CRAFTSMANSHIP_LEVELS[ply.crafting.level][1]) then
		crafting.LevelUp(ply)
	end
	
	crafting.SavePlayerInfo(ply, "crft_experience", ply.crafting.experience)
	crafting.SavePlayerInfo(ply, "crft_level", ply.crafting.level)
	crafting.UpdatePlayerInfo(ply)
end

-- Give Material
function crafting.GiveMaterial(ply, mat, quantity)
	
	if(ply.crafting == nil) then crafting.InitializePlayers(ply) end
	
	for _, v in pairs (CRAFTSMANSHIP_MATS) do
		if(mat == v.tag) then
			local incInv = ply:GetNWInt(mat, _) + quantity
			if(incInv >= v.basecarry) then
				incInv = v.basecarry
			end
			ply:SetNWInt(mat, math.max(0, incInv))
			ply.inv[mat] = math.max(0, incInv)
		end
	end
	
	crafting.SaveInventory(ply, ply.inv)
	
end

function crafting.LevelUp(ply)
	ply.crafting.experience = ply.crafting.experience - CRAFTSMANSHIP_LEVELS[ply.crafting.level][1]
	
	if(ply.crafting.level < CRAFTING_MAX_LEVEL) then
		ply.crafting.level = ply.crafting.level + 1
		--Update the player level!
		crafting.SavePlayerInfo(ply, "crft_level", ply.crafting.level)
		crafting.UpdatePlayerInfo(ply)
		hook.Call("Crafting_LevelUp", GAMEMODE, ply)
		
		ply:PlayerMsg(Color(255, 255, 255), "Congratulations "..ply:GetName().."! You are now a ", Color(176, 244, 135) ,"["..CRAFTSMANSHIP_LEVELS[ply.crafting.level][2].."]")
		if(ply.crafting.level == 10) then
			BroadcastMsg(Color(176, 244, 135), "["..ply:GetName().."]", Color(191, 255, 228), " is now a Master Craftsman, congratulations!")
		end
		
		crafting.PrintUpgradeMsg(ply)
		if(ply:HasWeapon("crft_axe") == true and (ply:GetActiveWeapon() == ply:GetWeapon("crft_axe"))) then
			hook.Call("crft_UpdateAxe", GAMEMODE, ply)
			
			net.Start("craftingUpdateViewModel")
			net.Send(ply)
		end
		
		if(ply.crafting.experience >= CRAFTSMANSHIP_LEVELS[ply.crafting.level][1]) then
			crafting.LevelUp(ply)
		end
	else
		ply:PlayerMsg(Color(255, 255, 255), "Congratulations "..ply:GetName().."! You have gained ", Color(176, 244, 135) ,"a perk point.")
		hook.Call("Crafting_RankUp", GAMEMODE, ply)
	end
end

function crafting.PrintUpgradeMsg(ply)
	if(ply.crafting.level == 3) then
		ply:PlayerMsg(Color(255, 255, 255), "You now have a ", Color(236, 128, 48), "[BRONZE]", Color(255, 255, 255)," Axe!")
		ply:PlayerMsg(Color(88, 219, 75), "+15% Chopping Speed")
	elseif(ply.crafting.level == 6) then
		ply:PlayerMsg(Color(255, 255, 255), "You now have a ", Color(175, 175, 200), "[IRON]", Color(255, 255, 255)," Axe!")
		ply:PlayerMsg(Color(88, 219, 75), "+15% Chopping Speed")
		ply:PlayerMsg(Color(88, 219, 75), "+Improved wood harvesting.")
		ply:PlayerMsg(Color(88, 219, 75), "+Chance to find Ancient Sap.")
		ply:PlayerMsg(Color(88, 219, 75), "+Chance to find Tree Cores.")
	elseif(ply.crafting.level == 10) then
		ply:PlayerMsg(Color(255, 255, 255), "You now have a ", Color(35, 214, 221), "[DIAMOND]", Color(255, 255, 255)," Axe!")
		ply:PlayerMsg(Color(88, 219, 75), "+15% Chopping Speed")
		if(CRFT_PRESTIGE_ENABLED == true) then
			ply:PlayerMsg(Color(255, 128, 58), "Every additional level will rank you up and grant you ", Color(255, 255, 255), "[1 PERK POINT]!", Color(255, 128, 58), " Spend them wisely at the crafting table to improve your stats.")
		end
	end
end

function crafting.UpdatePlayerInfo(ply)
	ply:SetNWInt("crft_experience", ply.crafting.experience)
	ply:SetNWInt("crft_level", ply.crafting.level)
end

function crafting.UpdatePlayerInventory(ply)
	for k, v in pairs(ply.inv) do
		ply:SetNWInt(k, v)
	end
end
---

-- INITIALIZE DATA
function crafting.InitializePlayers(ply)
	if not IsValid(ply) then return end

	ply.crafting = {
		level = tonumber(crafting.LoadPlayerInfo(ply, "crft_level") or 1),
		experience = tonumber(crafting.LoadPlayerInfo(ply, "crft_experience") or 0),
	}
	
	ply.inv = {} or ply.inv
	
	for _, v in pairs(CRAFTSMANSHIP_MATS) do
		local invItem = {[ v.tag ] = 0}
		table.Merge(ply.inv, invItem)
	end
	
	if(crafting.LoadInventory(ply) ~= nil) then
		ply.inv = crafting.LoadInventory(ply)
	end
	
	crafting.UpdatePlayerInfo(ply)
	
	crafting.UpdatePlayerInventory(ply)
	crafting.SaveInventory(ply, ply.inv)
	
end

net.Receive( "craftingUpdateStats", function( len, ply )
	local price = net.ReadFloat()
	local xp = net.ReadFloat()
	local tab = net.ReadFloat()
	crafting.GiveXP(ply, xp)
	--Deduct money
	if(tab == 1) then
		ply:addMoney(price)
	else
		ply:addMoney(price *-1)
	end
end )

net.Receive( "craftingUpdateMaterials", function( len, ply )
	local mats = net.ReadTable()
	for k, v in pairs(mats) do
		crafting.GiveMaterial(ply, k, v *-1)
	end
end )

net.Receive("craftingGiveEnt", function(len, ply)
	local ent = net.ReadString()
	
	// Give flamethrower extra ammo
	if(ent == "crft_flamethrower") and ply:HasWeapon(ent) then
		ply:GiveAmmo(1000, "crft_flame")
	end
	
	ply:Give(ent)
end)

net.Receive("craftingInitData", function()
	local ply = net.ReadEntity()

	crafting.InitializePlayers(ply)
end)

--==CONSOLE COMMAND FUNCTIONS==--

function crafting.ResetPlrStats(ply)

	print("Stats Reset")
	if(ply.crafting == nil) then crafting.InitializePlayers(ply) end
	ply.crafting.experience = 0
	ply.crafting.level = 1
	crafting.SavePlayerInfo(ply, "crft_level", ply.crafting.level)
	crafting.SavePlayerInfo(ply, "crft_experience", ply.crafting.experience)
	
	ply:SetNWInt("crft_level", ply.crafting.level)
	ply:SetNWInt("crft_experience", ply.crafting.experience)
	
	ply.inv = {} or ply.inv
	
	for _, v in pairs(CRAFTSMANSHIP_MATS) do
		local invItem = {[ v.tag ] = 0}
		table.Merge(ply.inv, invItem)
	end

	crafting.UpdatePlayerInventory(ply)
	
end

function crafting.MaxInventory(ply)

	print("Inventory Maxed")
	
	for _, v in ipairs(CRAFTSMANSHIP_MATS) do
		crafting.GiveMaterial(ply, v.tag, v.basecarry)
	end
	
end

function crafting.MaxPlrStats(ply)

	print("Stats Maxed")
	ply.crafting.experience = 0
	ply.crafting.level = 10
	crafting.SavePlayerInfo(ply, "crft_level", ply.crafting.level)
	crafting.SavePlayerInfo(ply, "crft_experience", ply.crafting.experience)
	
	ply:SetNWInt("crft_level", ply.crafting.level)
	ply:SetNWInt("crft_experience", ply.crafting.experience)
	
end

--==============--
--CONSOLE COMMANDS
--==============--

--RESET PLR STATS
concommand.Add("crafting_resetstats", function(ply)
	crafting.ResetPlrStats(ply)
end)

--MAX PLR STATS
concommand.Add("crafting_maxstats", function(ply)
	crafting.MaxPlrStats(ply)
end)

--MAX INVENTORY
concommand.Add("crafting_maxinventory", function(ply)
	crafting.MaxInventory(ply)
end)
--]]
--
--SERVER MSG PRINTS
if SERVER then
	local PLAYER = FindMetaTable("Player")
	util.AddNetworkString( "ColoredMessage" )
	function BroadcastMsg(...)
		local args = {...}
		net.Start("ColoredMessage")
		net.WriteTable(args)
		net.Broadcast()
	end
	function PLAYER:PlayerMsg(...)
		local args = {...}
		net.Start("ColoredMessage")
		net.WriteTable(args)
		net.Send(self)
	end
	elseif CLIENT then
	net.Receive("ColoredMessage",function(len)local msg = net.ReadTable()
		chat.AddText(unpack(msg))
		chat.PlaySound()
	end)
end

if SERVER then
	util.AddNetworkString( "pickaxePrestige" )
	util.AddNetworkString( "pickaxeGainPerk" )
end

--Coded by Hens <3--

pickaxe = {} or pickaxe

function pickaxe.LoadPlayerInfo(ply, name)
	return file.Read("mining_mod/"..ply:UniqueID().."/"..name..".txt")
end

function pickaxe.LoadPerkTable(ply)
	local tbl = (file.Read("mining_mod/"..ply:UniqueID().."/perks.txt"))
	if(tbl ~= nil) then
		return util.JSONToTable(file.Read("mining_mod/"..ply:UniqueID().."/perks.txt"))
	else
		return nil
	end
end

function pickaxe.SavePlayerInfo(ply, name, data)
	file.CreateDir("mining_mod")
	file.CreateDir("mining_mod/"..ply:UniqueID())
	file.Write("mining_mod/"..ply:UniqueID().."/"..name..".txt", data)
end

function pickaxe.SavePerkTable(ply, data)
	local tbl = util.TableToJSON(data)
	file.CreateDir("mining_mod")
	file.CreateDir("mining_mod/"..ply:UniqueID())
	file.Write("mining_mod/"..ply:UniqueID().."/perks.txt", tbl)
end

-- Give Pickaxe XP
function pickaxe.GiveXP(ply, amnt)
	
	if(ply.pickaxe == nil) then pickaxe.InitializePlayers(ply) end
	if(ply.pickaxe.level >= MAX_LEVEL) then return end
	ply.pickaxe.experience = ply.pickaxe.experience + amnt;
	
	if(ply.pickaxe.experience >= LEVELING_TABLE[ply.pickaxe.level][1]) then
		pickaxe.LevelUp(ply)
		local extralvlchance = (ply:GetNWInt("perk_powerlevel")*8/100)
		local chance = math.Rand(0,1)
		if(chance < extralvlchance) then
			ply.pickaxe.experience = LEVELING_TABLE[ply.pickaxe.level][1]
			pickaxe.LevelUp(ply)
			ply:PlayerMsg(Color(255, 255, 255), "You feel empowered, and gain an extra level!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer01.wav")
		end
	end
	
	pickaxe.SavePlayerInfo(ply, "experience", ply.pickaxe.experience)
	pickaxe.SavePlayerInfo(ply, "level", ply.pickaxe.level)
	pickaxe.UpdatePlayerInfo(ply)
end

function pickaxe.LevelUp(ply)
	ply.pickaxe.experience = ply.pickaxe.experience - LEVELING_TABLE[ply.pickaxe.level][1]
	
	if(ply.pickaxe.level < MAX_LEVEL) then
		ply.pickaxe.level = ply.pickaxe.level + 1
		--Update the player level!
		pickaxe.SavePlayerInfo(ply, "level", ply.pickaxe.level)
		pickaxe.UpdatePlayerInfo(ply)
		
		local fx = EffectData();
		fx:SetEntity(ply);
		fx:SetOrigin(ply:GetPos());
		util.Effect("levelfx",fx)
		
		local fx2 = EffectData();
		fx2:SetEntity(ply);
		fx2:SetMagnitude(3)
		fx2:SetOrigin(ply:GetPos());
		util.Effect("Explosion",fx2)
		
		if(ply.pickaxe.level ~= 35) then
			ply:EmitSound(LevelUpSound);
		else
			ply:EmitSound(LevelUpSoundMax);
		end
		
		ply:PlayerMsg(Color(255, 255, 255), "Congratulations "..ply:GetName().."! You are now level ", Color(244, 176, 66) ,"["..ply:GetNWInt("level").."]")
		pickaxe.PrintUpgradeMsg(ply)
		if(ply:HasWeapon("mgs_pickaxe") == true and (ply:GetActiveWeapon() == ply:GetWeapon("mgs_pickaxe"))) then
			hook.Call("pickaxe_UpdatePick", GAMEMODE, ply)
		end
		
		if(ply.pickaxe.experience >= LEVELING_TABLE[ply.pickaxe.level][1]) then
			pickaxe.LevelUp(ply)
		end
	end
end

function pickaxe.PrintUpgradeMsg(ply)
	if(ply.pickaxe.level == 5) then
		ply:PlayerMsg(Color(255, 255, 255), "You now have a ", Color(173, 131, 114), "[COPPER]", Color(255, 255, 255)," Pickaxe!")
		ply:PlayerMsg(Color(88, 219, 75), "+25% Mining Speed")
	elseif(ply.pickaxe.level == 10) then
		ply:PlayerMsg(Color(255, 255, 255), "You now have a ", Color(236, 128, 48), "[BRONZE]", Color(255, 255, 255)," Pickaxe!")
		ply:PlayerMsg(Color(88, 219, 75), "+20% Mining Speed")
		ply:PlayerMsg(Color(88, 219, 75), "+1 Ore per Vein")
	elseif(ply.pickaxe.level == 15) then
		ply:PlayerMsg(Color(255, 255, 255), "You now have a ", Color(198, 198, 198), "[IRON]", Color(255, 255, 255)," Pickaxe!")
		ply:PlayerMsg(Color(88, 219, 75), "[ You can now mine up to level 6 rocks! ]")
	elseif(ply.pickaxe.level == 20) then
		ply:PlayerMsg(Color(255, 255, 255), "You now have a ", Color(85, 85, 85), "[STEEL]", Color(255, 255, 255)," Pickaxe!")
		ply:PlayerMsg(Color(88, 219, 75), "+10% Mining Speed")
		ply:PlayerMsg(Color(88, 219, 75), "+Rare Artifact Chance")
		ply:PlayerMsg(Color(255, 78, 0), "+Double Damage to level 1 - 6 rocks")
	elseif(ply.pickaxe.level == 25) then
		ply:PlayerMsg(Color(255, 255, 255), "You now have a ", Color(160, 68, 212), "[OSMIUM]", Color(255, 255, 255)," Pickaxe!")
		ply:PlayerMsg(Color(88, 219, 75), "[ You can now mine up to level 9 rocks! ]")
		ply:PlayerMsg(Color(88, 219, 75), "+10% Mining Speed")
		ply:PlayerMsg(Color(88, 219, 75), "+Uncommon Artifact Chance")
	elseif(ply.pickaxe.level == 30) then
		
		--BroadcastMsg(Color(255, 255, 255), "["..ply:GetName().."]", Color(35, 214, 221), " has hit level 30 and acquired a Diamond Pickaxe!")
		
		ply:PlayerMsg(Color(255, 255, 255), "You now have a ", Color(35, 214, 221), "[DIAMOND]", Color(255, 255, 255)," Pickaxe!")
		ply:PlayerMsg(Color(88, 219, 75), "[ You can now mine up to level 15 rocks! ]")
		ply:PlayerMsg(Color(88, 219, 75), "+10% Mining Speed")
		ply:PlayerMsg(Color(88, 219, 75), "+5 Weapon Damage")
		ply:PlayerMsg(Color(88, 219, 75), "+Common Artifact Chance")
		
	elseif(ply.pickaxe.level == 35) then
	
		BroadcastMsg(Color(221, 102, 255), "["..ply:GetName().."]", Color(242, 198, 255), " has MAXED Mining, congratulations!")
		
		ply:PlayerMsg(Color(255, 255, 255), "You now have a ", Color(230, 40, 40), "[ASTRONIUM]", Color(255, 255, 255)," Pickaxe!")
		ply:PlayerMsg(Color(88, 219, 75), "[ You can now mine ANYTHING! ]")
		ply:PlayerMsg(Color(88, 219, 75), "+10% Mining Speed")
		ply:PlayerMsg(Color(88, 219, 75), "+10 Weapon Damage")
	end
end

function pickaxe.GetPickTier(ply)
	return LEVELING_TABLE[ply:GetNWInt("level")][2]
end

--Updates to PLR info and PLR perks
function pickaxe.UpdatePlayerInfo(ply)
	ply:SetNWInt("experience", ply.pickaxe.experience)
	ply:SetNWInt("level", ply.pickaxe.level)
	ply:SetNWInt("perkpts", ply.pickaxe.perkpts)
	ply:SetNWInt("prestigerank", ply.pickaxe.prestigerank)
end

function pickaxe.UpdatePlayerPerks(ply)
	for k, v in pairs(ply.perks) do
		
		--Perks can either be toggled [Booleans] or repeatable [Integers]
		if(isbool(v)) then
			ply:SetNWBool(k, v)
		else
			ply:SetNWInt(k, v)
		end
	end
end
---

function pickaxe.Prestige(ply)
	if(ply.pickaxe.level ~= 35) then return end 
	ply.pickaxe.experience = 0
	ply.pickaxe.level = 0
	ply.pickaxe.perkpts = ply:GetNWInt("perkpts") + 1
	pickaxe.SavePlayerInfo(ply, "experience", ply.pickaxe.experience)
	pickaxe.SavePlayerInfo(ply, "level", ply.pickaxe.level)
	pickaxe.SavePlayerInfo(ply, "perkpts", ply.pickaxe.perkpts)
	
	ply:SetNWInt("experience", ply.pickaxe.experience)
	ply:SetNWInt("level", ply.pickaxe.level)
	ply:SetNWInt("perkpts", ply.pickaxe.perkpts)
	
	pickaxe.UpdatePlayerInfo(ply)
	
	BroadcastMsg(Color(255, 255, 255), "["..ply:GetName().."]", Color(149, 212, 255), " has prestiged in mining, and is now rank " .. ply:GetNWInt("prestigerank") .."!")
	
	ply:EmitSound(PrestigeSound)
	ParticleEffectAttach("prestigefx_core", 1, ply,  0 )
	ply:EmitSound("npc/roller/mine/rmine_explode_shock1.wav")
	
	timer.Simple(2.25, function()
	ply:EmitSound("ambient/levels/canals/windchime5.wav")
	end)
	
	if(ply:HasWeapon("mgs_pickaxe") == true and (ply:GetActiveWeapon() == ply:GetWeapon("mgs_pickaxe"))) then
		hook.Call("pickaxe_UpdatePick", GAMEMODE, ply)
	end
	
	//CLEAN UP ARTIFACTS
	local entScan = ents.FindInSphere(ply:GetPos(), 2048)
	for k, v in pairs(entScan) do
		if(v:GetClass() == "mgs_artifact") then
			if v:GetNWInt("a_owner") == ply:UniqueID() then
				v:Remove()
			end
		end
	end
	//
end

--Toggle perk ownership to true
function pickaxe.GainPerk(ply, perk)

	local perkname = "Perk"
	local cost = 0
	
	for _, v in pairs (PERKS_TABLE) do
		if(perk == v[2]) then
			perkname = v[4]
			cost = v[7]
			
			if(v[8] == 1) then
				local stacks = ply:GetNWInt(perk)
				local costformula = (stacks * v[7]) + math.Round( (math.exp(0.5 * stacks) * v[7]), -4)
				
				stacks = stacks + 1
				ply:SetNWInt(perk, stacks)
				ply.perks[perk] = stacks
				cost = costformula
			else
				ply:SetNWBool(perk, true)
				ply.perks[perk] = true
			end
		end
	end
	
	ply.pickaxe.perkpts = ply:GetNWInt("perkpts") - 1
	ply:SetNWInt("perkpts", ply.pickaxe.perkpts )
	pickaxe.SavePerkTable(ply, ply.perks)
	pickaxe.SavePlayerInfo(ply, "perkpts", ply:GetNWInt("perkpts"))
	
	pickaxe.UpdatePrestigeRank(ply)
	ply:SetNWInt("prestigerank", ply.pickaxe.prestigerank )
	pickaxe.SavePlayerInfo(ply, "prestigerank", pickaxe.prestigerank)
	
	--Deduct money
	if (MGS_GM_VERSION <= 2.4) then
		ply:AddMoney(cost * -1)
	else
		ply:addMoney(cost * -1)
	end
	ply:EmitSound("ambient/levels/labs/coinslot1.wav", 100, 100)
	
	ply:PlayerMsg(Color(255,255,255), "You have gained the ", Color(255, 119, 0),"["..perkname.."]", Color(255,255,255)," perk, congratulations!")
	
	--UPDATE ABILITY / STAT PERKS--
	if(perk == "perk_agility") then
		hook.Call("pickaxe_UpdateAgility", GAMEMODE, ply)
	end
	
	if(perk == "perk_mspeed") then
		hook.Call("pickaxe_UpdatePick", GAMEMODE, ply)
	end
	
	if(perk == "perk_meleedmg") then
		hook.Call("pickaxe_UpdatePick", GAMEMODE, ply)
	end
	
	if(perk == "perk_largepick") then
		
		if(ply:HasWeapon("mgs_pickaxe") == true and (ply:GetActiveWeapon() == ply:GetWeapon("mgs_pickaxe"))) then
		
			wep = ply:GetActiveWeapon()
			wep.WorldModel = Model("models/weapons/w_largepick.mdl")
			
			if SERVER then
				local mdl = Model("models/weapons/w_largepick.mdl")
			
				net.Start("pickaxeLargePick")
					net.WriteEntity(wep)
					net.WriteString(mdl)
				net.Broadcast()
			end
		end		
	end
	
	if(perk == "perk_glow") then
		ParticleEffectAttach("aura_core", 1, ply,  0 )
	end
	
end

function pickaxe.UpdatePrestigeRank(ply)
	local perkcount = 0
	for k, v in pairs(ply.perks) do
		if (isbool(v)) then
			if(v == true) then
				perkcount = perkcount +1
			end
		else
			perkcount = perkcount + v
		end
	end
	
	ply.pickaxe.prestigerank = perkcount
end


function pickaxe.InitializePlayers(ply)
	if not IsValid(ply) then return end

	ply.pickaxe = {
		level = tonumber(pickaxe.LoadPlayerInfo(ply, "level") or 0),
		experience = tonumber(pickaxe.LoadPlayerInfo(ply, "experience") or 0),
		perkpts = tonumber(pickaxe.LoadPlayerInfo(ply, "perkpts") or 0),
		prestigerank = tonumber(pickaxe.LoadPlayerInfo(ply, "prestigerank") or 0)
	}
	
	ply.perks = {} or ply.perks
	
	print("Write tables")
	for _, v in pairs(PERKS_TABLE) do
		--Check for repeatable perks
		local prk = {[ v[2] ] = false}
		if(v[8] == 1) then
			prk = {[ v[2] ] = 0}
		end
		table.Merge(ply.perks, prk)
	end
	
	if(pickaxe.LoadPerkTable(ply) ~= nil) then
		ply.perks = pickaxe.LoadPerkTable(ply)
	end
	
	pickaxe.UpdatePrestigeRank(ply)
	pickaxe.UpdatePlayerInfo(ply)
	
	pickaxe.UpdatePlayerPerks(ply)
	pickaxe.SavePerkTable(ply, ply.perks)
	
end


net.Receive( "pickaxePrestige", function( len, ply )
	 pickaxe.Prestige(ply)
end )

net.Receive( "pickaxeGainPerk", function( len, ply )
	local perk = net.ReadString()
	 pickaxe.GainPerk(ply, perk)
end )



--==CONSOLE COMMAND FUNCTIONS==--

function pickaxe.ResetPlrStats(ply)

	print("Stats Reset")
	ply.pickaxe.experience = 0
	ply.pickaxe.level = 0
	ply.pickaxe.prestigerank = 0
	pickaxe.SavePlayerInfo(ply, "experience", ply.pickaxe.experience)
	pickaxe.SavePlayerInfo(ply, "level", ply.pickaxe.level)
	pickaxe.SavePlayerInfo(ply, "prestigerank", ply.pickaxe.prestigerank)
	
	ply:SetNWInt("experience", ply.pickaxe.experience)
	ply:SetNWInt("level", ply.pickaxe.level)
	ply:SetNWInt("prestigerank", ply.pickaxe.prestigerank)
	
	pickaxe.UpdatePlayerInfo(ply)
	
	ply.perks = {}
	
	for _, v in pairs(PERKS_TABLE) do
		--Check for repeatable perks
		local prk = {[ v[2] ] = false}
		if(v[8] == 1) then
			prk = {[ v[2] ] = 0}
		end
		table.Merge(ply.perks, prk)
	end
	
	pickaxe.UpdatePlayerPerks(ply)
	
	pickaxe.SavePerkTable(ply, ply.perks)
	
	
	if(ply:HasWeapon("mgs_pickaxe") == true and (ply:GetActiveWeapon() == ply:GetWeapon("mgs_pickaxe"))) then
		hook.Call("pickaxe_UpdatePick", GAMEMODE, ply)
	end
end

function pickaxe.MaxStats(ply)
	ply.pickaxe.experience = 0
	ply.pickaxe.level = 35
	ply.pickaxe.perkpts = ply:GetNWInt("perkpts")
	pickaxe.SavePlayerInfo(ply, "experience", ply.pickaxe.experience)
	pickaxe.SavePlayerInfo(ply, "level", ply.pickaxe.level)
	pickaxe.SavePlayerInfo(ply, "perkpts", ply.pickaxe.perkpts)
	
	ply:SetNWInt("experience", ply.pickaxe.experience)
	ply:SetNWInt("level", ply.pickaxe.level)
	ply:SetNWInt("perkpts", ply.pickaxe.perkpts)
	
	pickaxe.UpdatePlayerInfo(ply)
	
	if(ply:HasWeapon("mgs_pickaxe") == true and (ply:GetActiveWeapon() == ply:GetWeapon("mgs_pickaxe"))) then
		hook.Call("pickaxe_UpdatePick", GAMEMODE, ply)
	end	
end

function pickaxe.SetPerkPts(ply, pts)
	print("Perks points set to: "..pts)
	ply.pickaxe.perkpts = pts
	pickaxe.UpdatePlayerInfo(ply)
	pickaxe.SavePlayerInfo(ply, "perkpts", ply.pickaxe.perkpts)
end

function pickaxe.GivePerkPts(ply, target, pts)
	local plr = player.GetBySteamID64(target)
	print(plr)
	if(plr~=nil or plr~=false and plr:IsPlayer()) then
		
		plr.pickaxe = {
			level = tonumber(pickaxe.LoadPlayerInfo(plr, "level") or 0),
			experience = tonumber(pickaxe.LoadPlayerInfo(plr, "experience") or 0),
			perkpts = tonumber(pickaxe.LoadPlayerInfo(plr, "perkpts") or 0),
			prestigerank = tonumber(pickaxe.LoadPlayerInfo(plr, "prestigerank") or 0)
		}
	
		plr.pickaxe.perkpts = plr.pickaxe.perkpts + pts
		print(plr.pickaxe.perkpts)
		pickaxe.UpdatePlayerInfo(plr)
		pickaxe.SavePlayerInfo(plr, "perkpts", plr.pickaxe.perkpts)
	end
end

function pickaxe.CheckPerkPts(ply, target)
	print(util.SteamIDFrom64(target))
	local uniqueid =  (util.CRC( "gm_" .. util.SteamIDFrom64(target) .. "_gm" ))
	print("Unique ID: ".. uniqueid)
	local pts = file.Read("mining_mod/"..uniqueid.."/perkpts.txt")
	print(pts)
end

--==============--
--CONSOLE COMMANDS
--==============--

--[[
--RESET PLR STATS
concommand.Add("pickaxe_resetstats", function(ply)
	pickaxe.ResetPlrStats(ply)
end)

--MAX PLR STATS
concommand.Add("pickaxe_maxstats", function(ply)
	pickaxe.MaxStats(ply)
end)

--SET PERK PTS
concommand.Add("pickaxe_setperkpts", function(ply, cmd, args)
	pickaxe.SetPerkPts(ply, args[1])
end)
--]]

--GIVE PERK PTS
concommand.Add("pickaxe_giveperkpts", function(ply, cmd, args)
	pickaxe.GivePerkPts(ply, args[1], args[2])
end)

--CHECK UNSPENT PERK PTS
concommand.Add("pickaxe_checkperkpts", function(ply, cmd, args)
	pickaxe.CheckPerkPts(ply, args[1])
end)

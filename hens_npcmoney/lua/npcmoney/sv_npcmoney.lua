print("[[Money script for NPCs Initialized!]]")

hook.Add("OnNPCKilled", "grantMoney", function (victim, ent, weapon)
	if not ent then return end

    if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end
	
    if not ent:IsPlayer() then
        ent = Player(tonumber(ent.SID) or 0)
    end
	
	if(ent == NULL) then return end
	
	if(KILL_TABLE[victim:GetClass()]~=nil) then		
			
		local vicName = "monster"
		
		if(NPC_PHRASE[victim:GetClass()] ~= nil) then
			vicName = NPC_PHRASE[victim:GetClass()]
		end
		
		
		local money = 0
		local v = KILL_TABLE[victim:GetClass()]
		
		--Check if we have the fluctuate bool to give a money range instead of a consistant income value
		if(fluctuateMoney) then
			money = (v.money + (victim:GetMaxHealth()) + (math.random(-1, 4) * 5)) * MONEY_MULT
		else
			money = (v.money + (victim:GetMaxHealth())) * MONEY_MULT
		end
		
		if(ent:IsPlayer()) then
			ent:addMoney(money)
		end
		
		if(ent:IsPlayer() and ent:GetNWBool("leggy_buff")) then
			ent:SetArmor(math.Clamp(ent:Armor()+math.random(2,10), 0, 150))
		end
		
		--NOTIFY--
		--Grammar is important yo!
		local firstLetter = string.sub(vicName, 0, 1)
		if(string.lower(firstLetter) == "a" or string.lower(firstLetter) == "e" or string.lower(firstLetter) == "o" or string.lower(firstLetter) == "i" or string.lower(firstLetter) == "u") then
			DarkRP.notify(ent, 2, 4, "You've gained $"..string.Comma(money).." for killing an ".. vicName .."!")
		else
			DarkRP.notify(ent, 2, 4, "You've gained $"..string.Comma(money).." for killing a ".. vicName .."!")
		end
		
		--SPAWN LOOT
		if(npcsDropItems) then
			if(math.Rand(0, 1) > v.chance) then return end  
			local randloot = table.Random( v.loot_table )
			
			if(ents.Create(randloot) ~= NULL ) then
				local loot = ents.Create(randloot)
				local spawnpos = Vector(victim:GetPos())
				local newpos = Vector(spawnpos[1], spawnpos[2], spawnpos[3] + 10)
				loot:SetPos(newpos)
				loot:Spawn()
				
				timer.Simple(NPCLOOT_DESPAWN, function()
					if(loot:IsValid()) then
						loot:Remove()
					end
				end)
			end
		end
		
	end
end)

hook.Add("OnNPCKilled", "dropCraftsmanMats", function (victim, ent, weapon)
	if not (npc_craftsman_drops) then return end
	if not ent then return end

    if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end
	
    if not ent:IsPlayer() then
        ent = Player(tonumber(ent.SID) or 0)
    end
	
	if(ent == NULL) then return end
	if(ent:Team() ~= LUMBERJACK) then return end
	
	if(KILL_TABLE[victim:GetClass()]~=nil) then		
		if(npcsDropItems) then
			if(ents.Create("crft_cloth") ~= NULL) then
				if(math.random(1,3)==1) then
					local cloth = ents.Create("crft_cloth")
					local spawnpos = Vector(victim:GetPos())
					local newpos = Vector(spawnpos[1], spawnpos[2], spawnpos[3] + 15)
					cloth:SetPos(newpos)
					cloth:Spawn()
					
					local phys = cloth:GetPhysicsObject()
					phys:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(200, 400)))
				end
				
				if(math.random(1,2)==2) then
					local cloth = ents.Create("crft_monsterparts")
					local spawnpos = Vector(victim:GetPos())
					local newpos = Vector(spawnpos[1], spawnpos[2], spawnpos[3] + 15)
					cloth:SetPos(newpos)
					cloth:Spawn()
					
					local phys = cloth:GetPhysicsObject()
					phys:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(200, 400)))
				end
			end
			
		end
				
	end
	
end)

hook.Add("OnNPCKilled", "grantSpellBooks", function (victim, ent, weapon)
	if not (npc_drop_spellbooks) then return end
	if not ent then return end

    if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end
	
    if not ent:IsPlayer() then
        ent = Player(tonumber(ent.SID) or 0)
    end
	
	if(ent == NULL) then return end
	if not (ent:Team() == WIZARD) or (ent:Team() == nil) then return end

	if(KILL_TABLE[victim:GetClass()] ~= nil) then
		local chance = math.random(1, 100)
		if(NPC_SIMPLEBOOK_CHANCE > chance) then
			
			--Upgrade chance
			local chance = math.random(1, 100)
			if(NPC_SIMPLEBOOK_UPGRADECHANCE > chance) then
				local loot = ents.Create("entity_hpwand_advancedbook")
				local spawnpos = Vector(victim:GetPos())
				local newpos = Vector(spawnpos[1], spawnpos[2], spawnpos[3] + 10)
				loot:SetPos(newpos)
				loot:Spawn()
				
				timer.Simple(NPCLOOT_DESPAWN, function()
					if(loot:IsValid()) then
						loot:Remove()
					end
				end)			
			else
				local loot = ents.Create("entity_hpwand_simplebook")
				local spawnpos = Vector(victim:GetPos())
				local newpos = Vector(spawnpos[1], spawnpos[2], spawnpos[3] + 10)
				loot:SetPos(newpos)
				loot:Spawn()
				
				timer.Simple(NPCLOOT_DESPAWN, function()
					if(loot:IsValid()) then
						loot:Remove()
					end
				end)
			end
		end
	end
end)

--HALLOWEEN EVENT

local bossTable = {
	["npc_soma_deepseadiver"] = {
		candy = 5900,
		simpbooks = 1,
		advbooks = 0,
		guns = 1
	},
	["npc_soma_construct"] = {
		candy = 5900,
		simpbooks = 1,
		advbooks = 0,
		guns = 1
	},
	["npc_shaklin_l4d2witch_sit"] = {
		candy = 8800,
		simpbooks = 2,
		advbooks = 0,
		guns = 1
	},
	["npc_skeletonking"] = {
		candy = 8800,
		simpbooks = 1,
		advbooks = 1,
		guns = 1
	},
	["npc_tf2_merasmus"] = {
		candy = 12000,
		simpbooks = 2,
		advbooks = 1,
		guns = 1
	},
	["headless_hatman"] = {
		candy = 17500,
		simpbooks = 2,
		advbooks = 1,
		guns = 1
	},
	["npc_monstrum_fiend"] = {
		candy = 22000,
		simpbooks = 2,
		advbooks = 2,
		guns = 2
	},
	["npc_shaklin_scp096"] = {
		candy = 28000,
		simpbooks = 2,
		advbooks = 2,
		guns = 3
	}
}

local wandSkinDrops = {
"entity_hpwand_spell_dark_wand",
"entity_hpwand_spell_demonic_wand",
"entity_hpwand_spell_fork",
"entity_hpwand_spell_hands",
"entity_hpwand_spell_mind_wand",
"entity_hpwand_spell_soldering_iron"
}

local gunBossDrops = {
	"csgo_karambit_damascus", "csgo_karambit_tiger", "csgo_daggers_marblefade", "csgo_m9_damascus", "csgo_butterfly_damascus", "cw_tr09_ksg12", "cw_kimber_kw", "cw_kks_doi_mg42", "cw_xm1014", "cw_nen_beretta92fs", "cw_aacgsm", "cw_ak74", "cw_ar15", "cw_fiveseven", "cw_scarh", "cw_g3a3", "cw_g18", "cw_g36c", "cw_ump45", "cw_mp5", "cw_deagle", "cw_l115", "cw_l85a2", "cw_m14", "cw_m1911", "cw_m249_official", "cw_m3super90", "cw_mac11", "cw_mr96", "cw_p99", "cw_pkm", "cw_makarov", "cw_shorty", "cw_vss"
	}

hook.Add("OnNPCKilled", "grantHalloweenCandy", function (victim, ent, weapon)

	if not (npc_halloween_event) then return end
	if not ent then return end
    if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end
	
    if not ent:IsPlayer() then
        ent = Player(tonumber(ent.SID) or 0)
    end
	
	if(KILL_TABLE[victim:GetClass()]~=nil) then		
		--HALLOWEEN EVENT
		if(npcsDropItems) then
			if(ents.Create("he_halloween_candy") ~= NULL) then
				local randamnt = math.random(3, 5)
				for i = 1, randamnt do
					local cand = ents.Create("he_halloween_candy")
					local spawnpos = Vector(victim:GetPos())
					local newpos = Vector(spawnpos[1], spawnpos[2], spawnpos[3] + 15)
					cand:SetPos(newpos)
					cand:SetNWInt("he_candy_amnt", math.random(2, 5))
					
					cand:Spawn()
					
					local phys = cand:GetPhysicsObject()
					phys:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(200, 400)))
				end
			end
		end
				
	end
	
	
	// ** BOSSES ** //
	if(bossTable[victim:GetClass()] ~= nil) then
		local boss = bossTable[victim:GetClass()]
		print("BOSS DROPPING GOODIES~!")
		
		// RARE WAND SKINS
		local chance = 20
		local roll = math.random(1, 100)
		if roll <= chance then
			local wandDrop = ents.Create(table.Random(wandSkinDrops))
			wandDrop:SetPos(victim:GetPos() + Vector(math.random(-60,60),math.random(-60,60),60))
			wandDrop:Spawn()
			
			local phys = wandDrop:GetPhysicsObject()
			phys:SetVelocity(Vector(math.random(-200, 200), math.random(-200, 200), math.random(600, 800)))
			sound.Play( "garrysmod/balloon_pop_cute.wav", victim:GetPos(), 75, math.random(50,60),0.8 )
			timer.Simple(90, function()
				if(wandDrop == NULL or wandDrop == nil) then return end
				wandDrop:Remove()
			end)
		end
		//
		
		for i = 1, 12 do
			local yummi = ents.Create("he_halloween_candy")
			if(!IsValid(yummi)) then return end
				yummi:SetPos(victim:GetPos() + Vector(math.random(-60,60),math.random(-60,60),60))
				yummi:Spawn()
				yummi:SetNWInt("he_candy_amnt", math.Round(boss.candy/15, 0))
				
				local phys = yummi:GetPhysicsObject()
				phys:SetVelocity(Vector(math.random(-300, 300), math.random(-300, 300), math.random(400, 600)))
				sound.Play( "garrysmod/balloon_pop_cute.wav", victim:GetPos(), 75, math.random(50,60),0.8 )
		end
		
		if(boss.simpbooks >= 1) then
			for i = 1, boss.simpbooks do
				local book = ents.Create("entity_hpwand_simplebook")
				if(!IsValid(book)) then return end
				book:SetPos(victim:GetPos() + Vector(math.random(-60,60),math.random(-60,60),60))
				book:Spawn()
				
				local phys = book:GetPhysicsObject()
				phys:SetVelocity(Vector(math.random(-200, 200), math.random(-200, 200), math.random(600, 800)))
			end
		end
		
		if(boss.advbooks >= 1) then
			for i = 1, boss.advbooks do
				local book = ents.Create("entity_hpwand_advancedbook")
				if(!IsValid(book)) then return end
				book:SetPos(victim:GetPos() + Vector(math.random(-60,60),math.random(-60,60),60))
				book:Spawn()
				
				local phys = book:GetPhysicsObject()
				phys:SetVelocity(Vector(math.random(-200, 200), math.random(-200, 200), math.random(600, 800)))
			end
		end
		
		if(boss.guns >= 1) then
			for i = 1, boss.guns do
				local gun = ents.Create(table.Random(gunBossDrops))
				if(!IsValid(gun)) then return end
				gun:SetPos(victim:GetPos() + Vector(math.random(-60,60),math.random(-60,60),60))
				gun:Spawn()
				
				local phys = gun:GetPhysicsObject()
				phys:SetVelocity(Vector(math.random(-200, 200), math.random(-200, 200), math.random(600, 800)))
			end
		end
	end
	
end)

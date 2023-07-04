AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local ExtraSpawnTime = 20
local JChance = 0

function ENT:Initialize()
	self:SetModel(table.Random(MGS4_ROCK_MODELS))
	self:SetMaterial("models/props/de_inferno/roofbits.vtf");
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.Replace = false
	self:SetNWInt("health", MGS_ROCK_HEALTH)
	self:SetNWInt("distance", MGS_DISTANCE)
	self:SetNWInt("level", math.random(MGS4_MIN_LEVEL, MGS4_MAX_LEVEL))
end

function ENT:Think()
	if (!self.Replace) and (self:GetNWInt("health") <= 0)  then
		local ores = math.Rand(2, MGS_CREATE_ORE) --Minimum 2 ores for tier 3
		for i=1, math.Round(ores) do
			local ore = ents.Create("mgs_ore")
			--Set the correct tier for the rocks
			ore:SetNWInt("tier", 4);
			ore:SetNWInt("ore_owner", self:GetNWInt("rockkiller"))
			--Make sure we are using the appropriate level ranges
			ore:SetNWInt("flucVal", (self:GetNWInt("level") - MGS4_MIN_LEVEL) / (MGS4_MAX_LEVEL - MGS4_MIN_LEVEL))
			ore:SetPos(self:WorldSpaceCenter() + Vector(math.Rand(1,20), math.Rand(1,20),20))
			ore:Spawn()
		end
		
		--JACKPOT CHANCE
		local roll = math.Rand(0, 1)
		if(roll <= JChance*0.01) then
		
			sound.Play("vo/npc/male01/goodgod.wav", self:GetPos());
			
			local fx = EffectData();
			fx:SetEntity(self);
			fx:SetOrigin(self:GetPos());
			util.Effect("cball_explode",fx)
			
			--Create an artifact if they have the perk--
			local plr = player.GetByUniqueID(self:GetNWInt("rockkiller"))
			if(plr:GetNWBool("perk_jackpotart")== true) then
				local artifact = ents.Create("mgs_artifact")
				artifact:SetPos(self:GetPos() + Vector(math.Rand(1,20), math.Rand(1,20),20))
				artifact:SetNWInt("a_owner", plr:UniqueID())
				artifact:Spawn()
			end	
			
			for i=1, 5 do
				local ore = ents.Create("mgs_ore")
				ore:SetNWInt("tier", 4);
				ore:SetNWInt("ore_owner", self:GetNWInt("rockkiller"))
				ore:SetNWInt("flucVal", (self:GetNWInt("level") - MGS4_MIN_LEVEL) / (MGS4_MAX_LEVEL - MGS4_MIN_LEVEL))
				ore:SetPos(self:WorldSpaceCenter() + Vector(math.Rand(1,20), math.Rand(1,20),20))
				ore:Spawn()
			end
		end
		--
		// HALLOWEEN EVENT
		if(PERK_HALLOWEEN_EVENT == true) then
			local plr = player.GetByUniqueID(self:GetNWInt("rockkiller"))
			if(IsValid(plr)) then
				if(plr:GetNWBool("perk_candy")) then
					local roll = math.Rand(0, 1)
					if(roll > 0.5) then
						for i=1, 3 do
							local cand = ents.Create("he_halloween_candy")
							cand:SetNWInt("he_candy_amnt", math.random(8, 16))
							cand:SetPos(self:GetPos() + Vector(math.Rand(1,20), math.Rand(1,20),20))
							cand:Spawn()
							local phys = cand:GetPhysicsObject()
							phys:SetVelocity(Vector(math.random(-100, 100), math.random(-100, 100), math.random(200, 400)))
						end
					end
				end
			end
		end
		--
		self.Replace = true
		self.ReplaceTime = CurTime() + MGS_ROCK_REPLACE_TIMER + ExtraSpawnTime
		self.Pos = self:GetPos()
		self:SetPos(self:GetPos() + Vector(0,0,-3000))
		self:SetNWInt("level", math.random(MGS4_MIN_LEVEL, MGS4_MAX_LEVEL))
	end;
	
	if (self.Replace) and (self.ReplaceTime < CurTime()) then
		self:SetNWInt("health", MGS_ROCK_HEALTH)
		self.Replace = false
		self:SetColor(Color(255,255,255))
		self:SetPos(self.Pos)
	end
end

function ENT:OnTakeDamage(dmg)
	if(dmg:GetInflictor():IsPlayer()) then
		if table.HasValue(MGS_MINING_TOOLS, dmg:GetInflictor():GetClass()) or table.HasValue(MGS_MINING_TOOLS, dmg:GetAttacker():GetActiveWeapon():GetClass()) then
			local plr = dmg:GetInflictor()
			
			
			if(plr:GetNWInt("level") >= 30) then
				self:SetNWInt("health", self:GetNWInt("health")-1)
				
				if(plr:GetNWInt("perk_powersmash") >= 1) then
					chance = (plr:GetNWInt("perk_powersmash")*5/100)
					local roll = math.Rand(0, 1)
					if (roll < chance) then
						self:EmitSound("physics/glass/glass_largesheet_break" .. math.random(1,3) .. ".wav", math.random(20,90), math.random(100,130), 1)
						self:SetNWInt("health", 0)
					end
				end
				
				--Extra 5 damage perk
				if(plr:GetNWBool("perk_bonusrockdmg") == true) then
					local newhp = self:GetNWInt("health")-0.5
						if(newhp < 0) then newhp = 0 end
					self:SetNWInt("health", newhp)
				end

				-- MINING SMOOTHIES YUM
				if(plr:GetNWBool("HasMiningBoost") == true) then
					local newhp = self:GetNWInt("health")-0.5
					if(newhp < 0) then newhp = 0 end
					self:SetNWInt("health", newhp)
				end
				
				--Rock painter perk
				if(plr:GetNWBool("perk_rcolor") == true) then
					if(math.random(1,2) ==2) then
						self:SetColor(HSVToColor(RealTime() * 100 % 360, 0.8, 1))
					end
				end
				
			else
				self:SetNWInt("health", self:GetNWInt("health")-0.1)
			end
			if(self:GetNWInt("health") <= 0) then
			
				--XP Reward
				local xpreward = self:GetNWInt("level")
				if(plr:GetNWBool("perk_rxp") == true) then
					xpreward = xpreward *2.5
				end
				
				if(plr:GetNWInt("perk_enhancedmining") >= 1) then
					xpreward = math.Round(xpreward * (1 + (plr:GetNWInt("perk_enhancedmining")*30/100)), 0)
				end
				
				pickaxe.GiveXP(plr, xpreward)
				
				JChance = LEVELING_TABLE[plr:GetNWInt("level")][3]

				--HEAVENLY JACKPOT PERK
				if(plr:GetNWInt("perk_heavenlyjackpots") >= 1) then
					JChance = JChance + (plr:GetNWInt("perk_heavenlyjackpots")*1.5)
				end
				
				--Store the rock killer for bonus ore prices
				self:SetNWInt("rockkiller", plr:UniqueID())
				
				--BRONZE BONUS
				if(plr:GetNWInt("level") > 10) then
					local ore = ents.Create("mgs_ore")
					ore:SetNWInt("tier", 4);
					ore:SetNWInt("ore_owner", plr:UniqueID())
					ore:SetNWInt("flucVal", (self:GetNWInt("level") - MGS4_MIN_LEVEL) / (MGS4_MAX_LEVEL - MGS4_MIN_LEVEL))
					ore:SetPos(self:GetPos() + Vector(math.Rand(1,20), math.Rand(1,20),20))
					ore:Spawn()
				end
				
				--ARTIFACT CHANCE
				local roll = math.Rand(0, 1)
				local artchance = (LEVELING_TABLE[plr:GetNWInt("level")][4]*0.01)
				
				--ARTIFACT BOOST PERK
				if(plr:GetNWBool("perk_artboost") == true) then
					artchance = artchance + 0.05
				end
				
				if(roll <= artchance) then
					local artifact = ents.Create("mgs_artifact")
					artifact:SetPos(self:GetPos() + Vector(math.Rand(1,20), math.Rand(1,20),20))
					artifact:SetNWInt("a_owner", plr:UniqueID())
					artifact:Spawn()
				end
			end
		end
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end
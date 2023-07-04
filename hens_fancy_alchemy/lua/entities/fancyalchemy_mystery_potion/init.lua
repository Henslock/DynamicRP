AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
function ENT:Initialize()
	
	if (self:GetQuality() == 0) then self:SetQuality(math.random(1,5)) end
	self:SetQualityModel()

	local index = (self:GetSubMaterialIndex())
	if(index ~= nil) then
		self:SetSubMaterial(index, "fancyalchemy/potion_white")
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	self:DrawShadow(true)
	local phys = self:GetPhysicsObject()
	
	phys:Wake()
	self:SetNWString("mystPot_selection", table.Random{"health", "poison", "speed", "slow", "wealth", "poverty", "gravity", "heavy", "armor", "frail"})
	
	if (self:GetQuality() == 5) then
		timer.Simple(1, function()
			ParticleEffectAttach("rainbow_glow_particles", 1, self,  0 )
		end)
	end

end

function ENT:OnRemove()
end

function ENT:Think()
end

function ENT:Use(ply)
	local quality = self:GetQuality()
	local mysteryselection = self:GetNWString("mystPot_selection")
	DarkRP.notify(ply, 0, 4, "You've consumed a [ " .. string.upper(mysteryselection) .. " ] potion!")
	//////////////////////////////////////////
	if(quality == 1) then // SIMPLE
	//////////////////////////////////////////
	
		//HEALTH
		if(mysteryselection == "health") then
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			if(ply:Health() <= 100) then
				ply:SetHealth(math.Clamp(ply:Health() + 10, 0, 100))
			else
				ply:SetHealth(math.Clamp(ply:Health() + 10, 0, 200))
			end
		
		
		//POISON
		elseif(mysteryselection == "poison") then
			ply:EmitSound("vo/npc/male01/moan0" .. math.random(1,5) ..".wav", 100, 100, 1)
			timer.Create("Falch_PoisonPotion", 0.25, 20, function()
				ply:SetHealth(ply:Health() - 1)
				if(ply:Health() == 0) then ply:Kill(); timer.Remove("Falch_PoisonPotion") end
			end)

		
		//SPEED
		elseif(mysteryselection == "speed") then
			local timer_name = "Falch_SpeedPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a speed boost!")
				return
			end
			ply:SetRunSpeed(600)
			ply:SetWalkSpeed(300)
			DarkRP.notify(ply, 2, 4, "You have a speed boost for 15 seconds!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 15, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetRunSpeed(400)
				ply:SetWalkSpeed(200)
				timer.Remove(timer_name)
			end)
		
		//SLOW
		elseif(mysteryselection == "slow") then
			local timer_name = "Falch_SpeedPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a speed boost!")
				return
			end
			ply:SetRunSpeed(100)
			ply:SetWalkSpeed(50)
			DarkRP.notify(ply, 2, 4, "You have a speed debuff for 15 seconds!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 15, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetRunSpeed(400)
				ply:SetWalkSpeed(200)
				timer.Remove(timer_name)
			end)

				
		//WEALTH
		elseif(mysteryselection == "wealth") then
			local money = self:MoneyRoll()
			ply:addMoney(money)
			ply:ChatPrint("You have earned $".. string.Comma(money) .. " from the potion!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)

		//POVERTY
		elseif(mysteryselection == "poverty") then
			local money = self:MoneyRoll()
			ply:addMoney(money/100)
			ply:ChatPrint("You have earned $".. string.Comma(money/100) .. " from the potion!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
		
		//GRAVITY
		elseif(mysteryselection == "gravity") then
			local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
				return
			end
			ply:SetGravity(0.5)
			DarkRP.notify(ply, 2, 4, "You have low gravity for 15 seconds!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 15, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetGravity(1)
				timer.Remove(timer_name)
			end)
			
		//HEAVY
		elseif(mysteryselection == "heavy") then
			local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
				return
			end
			ply:SetGravity(1.5)
			DarkRP.notify(ply, 2, 4, "You have high gravity for 15 seconds!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 15, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetGravity(1)
				timer.Remove(timer_name)
			end)
	
		
		//ARMOR
		elseif(mysteryselection == "armor") then
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			if(ply:Armor() <= 100) then
				ply:SetArmor(math.Clamp(ply:Armor() +15, 0, 100))
			else
				ply:SetArmor(math.Clamp(ply:Armor() +15, 0, 200))
			end
		
		//FRAIL
		elseif(mysteryselection == "frail") then
			ply:SetArmor(math.Clamp(ply:Armor() -15, 0, 200))
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
		end
		
	//////////////////////////////////////////	
	elseif(quality == 2) then // ADVANCED
	//////////////////////////////////////////
	
		//HEALTH
		if(mysteryselection == "health") then
			if not IsValid(ply) or (ply == nil) then return end
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			if(ply:Health() <= 100) then
				ply:SetHealth(math.Clamp(ply:Health() + 25, 0, 100))
			else
				ply:SetHealth(math.Clamp(ply:Health() + 25, 0, 200))
			end	
		
		
		//POISON
		elseif(mysteryselection == "poison") then
			ply:EmitSound("vo/npc/male01/moan0" .. math.random(1,5) ..".wav", 100, 100, 1)
			timer.Create("Falch_PoisonPotion", 0.25, 20, function()
				ply:SetHealth(ply:Health() - 2)
				if(ply:Health() == 0) then ply:Kill(); timer.Remove("Falch_PoisonPotion") end
			end)

		
		//SPEED
		elseif(mysteryselection == "speed") then
			local timer_name = "Falch_SpeedPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a speed boost!")
				return
			end
			ply:SetRunSpeed(600)
			ply:SetWalkSpeed(300)
			DarkRP.notify(ply, 2, 4, "You have a speed boost for 30 seconds!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 30, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetRunSpeed(400)
				ply:SetWalkSpeed(200)
				timer.Remove(timer_name)
			end)
		
		//SLOW
		elseif(mysteryselection == "slow") then
			local timer_name = "Falch_SpeedPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a speed boost!")
				return
			end
			ply:SetRunSpeed(100)
			ply:SetWalkSpeed(50)
			DarkRP.notify(ply, 2, 4, "You have a speed debuff for 30 seconds!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 30, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetRunSpeed(400)
				ply:SetWalkSpeed(200)
				timer.Remove(timer_name)
			end)

				
		//WEALTH
		elseif(mysteryselection == "wealth") then
			local money = self:MoneyRoll()
			ply:addMoney(money)
			ply:ChatPrint("You have earned $".. string.Comma(money) .. " from the potion!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)

		//POVERTY
		elseif(mysteryselection == "poverty") then
			local money = self:MoneyRoll()
			ply:addMoney(money/100)
			ply:ChatPrint("You have earned $".. string.Comma(money/100) .. " from the potion!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
		
		//GRAVITY
		elseif(mysteryselection == "gravity") then
			local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
				return
			end
			ply:SetGravity(0.4)
			DarkRP.notify(ply, 2, 4, "You have low gravity for 30 seconds!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 30, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetGravity(1)
				timer.Remove(timer_name)
			end)
			
		//HEAVY
		elseif(mysteryselection == "heavy") then
			local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
				return
			end
			ply:SetGravity(1.5)
			DarkRP.notify(ply, 2, 4, "You have high gravity for 30 seconds!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 30, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetGravity(1)
				timer.Remove(timer_name)
			end)
	
		
		//ARMOR
		elseif(mysteryselection == "armor") then
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			if(ply:Armor() <= 100) then
				ply:SetArmor(math.Clamp(ply:Armor() +35, 0, 100))
			else
				ply:SetArmor(math.Clamp(ply:Armor() +35, 0, 200))
			end
		
		//FRAIL
		elseif(mysteryselection == "frail") then
			ply:SetArmor(math.Clamp(ply:Armor() -35, 0, 200))
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
		end
	
	//////////////////////////////////////////
	elseif(quality == 3) then // SUPERB
	//////////////////////////////////////////
	
		//HEALTH
		if(mysteryselection == "health") then
			local timer_name = "Falch_HealthPotion_" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a health potion effect!")
				return
			end
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			if(ply:Health() <= 100) then
				ply:SetHealth(math.Clamp(ply:Health() + 50, 0, 100))
				timer.Create(timer_name, 0.25, 20, function()
					if not IsValid(ply) or (ply == nil) then return end
					if(ply:Alive() == false) then return end
					ply:SetHealth(math.Clamp(ply:Health() + 1, 0, 100))
				end)
			else
				ply:SetHealth(math.Clamp(ply:Health() + 50, 0, 200))
				timer.Create(timer_name, 0.25, 20, function()
					if not IsValid(ply) or (ply == nil) then return end
					if(ply:Alive() == false) then return end
					ply:SetHealth(math.Clamp(ply:Health() + 1, 0, 200))
				end)
			end
			timer.Simple(5, function()
				timer.Remove(timer_name)
			end)
		
		
		//POISON
		elseif(mysteryselection == "poison") then
			ply:EmitSound("vo/npc/male01/moan0" .. math.random(1,5) ..".wav", 100, 100, 1)
			timer.Create("Falch_PoisonPotion", 0.25, 20, function()
				ply:SetHealth(ply:Health() - 5)
				if(ply:Health() == 0) then ply:Kill(); timer.Remove("Falch_PoisonPotion") end
			end)

		
		//SPEED
		elseif(mysteryselection == "speed") then
			local timer_name = "Falch_SpeedPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a speed boost!")
				return
			end
			ply:SetRunSpeed(800)
			ply:SetWalkSpeed(400)
			DarkRP.notify(ply, 2, 4, "You have a super speed boost for 45 seconds!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 45, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetRunSpeed(400)
				ply:SetWalkSpeed(200)
				timer.Remove(timer_name)
			end)
		
		//SLOW
		elseif(mysteryselection == "slow") then
			local timer_name = "Falch_SpeedPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a speed boost!")
				return
			end
			ply:SetRunSpeed(80)
			ply:SetWalkSpeed(40)
			DarkRP.notify(ply, 2, 4, "You have a speed debuff for 45 seconds!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 45, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetRunSpeed(400)
				ply:SetWalkSpeed(200)
				timer.Remove(timer_name)
			end)

				
		//WEALTH
		elseif(mysteryselection == "wealth") then
			local money = self:MoneyRoll()
			ply:addMoney(money)
			ply:ChatPrint("You have earned $".. string.Comma(money) .. " from the potion!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)

		//POVERTY
		elseif(mysteryselection == "poverty") then
			local money = self:MoneyRoll()
			ply:addMoney(money/100)
			ply:ChatPrint("You have earned $".. string.Comma(money/100) .. " from the potion!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
		
		//GRAVITY
		elseif(mysteryselection == "gravity") then
			local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
				return
			end
			ply:SetGravity(0.4)
			DarkRP.notify(ply, 2, 4, "You have low gravity for 60 seconds!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 60, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetGravity(1)
				timer.Remove(timer_name)
			end)
			
		//HEAVY
		elseif(mysteryselection == "heavy") then
			local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
				return
			end
			ply:SetGravity(1.75)
			DarkRP.notify(ply, 2, 4, "You have high gravity for 60 seconds!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 60, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetGravity(1)
				timer.Remove(timer_name)
			end)
	
		
		//ARMOR
		elseif(mysteryselection == "armor") then
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			if(ply:Armor() <= 100) then
				ply:SetArmor(math.Clamp(ply:Armor() +75, 0, 100))
			else
				ply:SetArmor(math.Clamp(ply:Armor() +75, 0, 200))
			end
		
		//FRAIL
		elseif(mysteryselection == "frail") then
			ply:SetArmor(math.Clamp(ply:Armor() -75, 0, 200))
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
		end
		
	//////////////////////////////////////////
	elseif(quality == 4) then // ILLUSTRIOUS
	//////////////////////////////////////////
	
		//HEALTH
		if(mysteryselection == "health") then
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			ply:SetHealth(math.Clamp(ply:Health() + 100, 0, 150))
		
		
		//POISON
		elseif(mysteryselection == "poison") then
			ply:EmitSound("vo/npc/male01/moan0" .. math.random(1,5) ..".wav", 100, 100, 1)
			ply:SetHealth(math.Round(ply:Health() *0.1))

		
		//SPEED
		elseif(mysteryselection == "speed") then
			local timer_name = "Falch_SpeedPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a speed boost!")
				return
			end
			ply:SetRunSpeed(800)
			ply:SetWalkSpeed(400)
			DarkRP.notify(ply, 2, 4, "You have a super speed boost for 60 seconds!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 60, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetRunSpeed(400)
				ply:SetWalkSpeed(200)
				timer.Remove(timer_name)
			end)
		
		//SLOW
		elseif(mysteryselection == "slow") then
			local timer_name = "Falch_SpeedPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a speed boost!")
				return
			end
			ply:SetRunSpeed(50)
			ply:SetWalkSpeed(25)
			DarkRP.notify(ply, 2, 4, "You have a speed debuff for 60 seconds!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 60, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetRunSpeed(400)
				ply:SetWalkSpeed(200)
				timer.Remove(timer_name)
			end)

				
		//WEALTH
		elseif(mysteryselection == "wealth") then
			local money = self:MoneyRoll()
			ply:addMoney(money)
			ply:ChatPrint("You have earned $".. string.Comma(money) .. " from the potion!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)

		//POVERTY
		elseif(mysteryselection == "poverty") then
			local money = self:MoneyRoll()
			ply:addMoney(money/100)
			ply:ChatPrint("You have earned $".. string.Comma(money/100) .. " from the potion!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
		
		//GRAVITY
		elseif(mysteryselection == "gravity") then
			local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
				return
			end
			ply:SetGravity(0.3)
			ply:SetJumpPower(300)
			DarkRP.notify(ply, 2, 4, "You have super low gravity for 120 seconds!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 120, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetGravity(1)
				ply:SetJumpPower(200)
				timer.Remove(timer_name)
			end)
			
		//HEAVY
		elseif(mysteryselection == "heavy") then
			local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
				return
			end
			ply:SetGravity(2)
			DarkRP.notify(ply, 2, 4, "You have super high gravity for 120 seconds!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 120, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetGravity(1)
				timer.Remove(timer_name)
			end)
	
		
		//ARMOR
		elseif(mysteryselection == "armor") then
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			if(ply:Armor() <= 100) then
				ply:SetArmor(math.Clamp(ply:Armor() +125, 0, 100))
			else
				ply:SetArmor(math.Clamp(ply:Armor() +125, 0, 200))
			end
		
		//FRAIL
		elseif(mysteryselection == "frail") then
			ply:SetArmor(math.Clamp(ply:Armor() -125, 0, 200))
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
		end
		
	//////////////////////////////////////////
	elseif(quality == 5) then // FANATICAL
	//////////////////////////////////////////
	
		//HEALTH
		if(mysteryselection == "health") then
			local timer_name = "Falch_HealthPotion_" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a health potion effect!")
				return
			end
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			ply:SetHealth(200)
			timer.Create(timer_name, 0.25, 30, function()
				if not IsValid(ply) or (ply == nil) then return end
				if(ply:Alive() == false) then return end
				ply:SetHealth(math.Clamp(ply:Health() + 10, 0, 200))
			end)
			timer.Simple(7.5, function()
				timer.Remove(timer_name)
			end)
		
		
		//POISON
		elseif(mysteryselection == "poison") then
			ply:EmitSound("vo/npc/male01/moan0" .. math.random(1,5) ..".wav", 100, 100, 1)
			util.BlastDamage(ply, ply, ply:GetPos(), 256, 350)
			local fx2 = EffectData();
			fx2:SetEntity(ply);
			fx2:SetMagnitude(30)
			fx2:SetOrigin(ply:GetPos());
			util.Effect("Explosion",fx2, true, true)

		
		//SPEED
		elseif(mysteryselection == "speed") then
			local timer_name = "Falch_SpeedPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a speed boost!")
				return
			end
			ply:SetRunSpeed(1500)
			ply:SetWalkSpeed(750)
			DarkRP.notify(ply, 2, 4, "You have a super speed boost for 120 seconds!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 120, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetRunSpeed(400)
				ply:SetWalkSpeed(200)
				timer.Remove(timer_name)
			end)
		
		//SLOW
		elseif(mysteryselection == "slow") then
			local timer_name = "Falch_SpeedPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a speed boost!")
				return
			end
			ply:SetRunSpeed(20)
			ply:SetWalkSpeed(10)
			DarkRP.notify(ply, 2, 4, "You have a massive speed debuff for 60 seconds!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 60, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetRunSpeed(400)
				ply:SetWalkSpeed(200)
				timer.Remove(timer_name)
			end)

				
		//WEALTH
		elseif(mysteryselection == "wealth") then
			local money = self:MoneyRoll()
			ply:addMoney(money*8)
			ply:ChatPrint("You have earned $".. string.Comma(money*8) .. " from the potion!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)

		//POVERTY
		elseif(mysteryselection == "poverty") then
			local money = self:MoneyRoll()
			ply:addMoney(1)
			ply:ChatPrint("You have earned $1 from the potion! Yikes.")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
		
		//GRAVITY
		elseif(mysteryselection == "gravity") then
			local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
				return
			end
			ply:SetGravity(0.3)
			ply:SetJumpPower(400)
			DarkRP.notify(ply, 2, 4, "You have super low gravity for 10 minutes!")
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 600, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetGravity(1)
				ply:SetJumpPower(200)
				timer.Remove(timer_name)
			end)
			
		//HEAVY
		elseif(mysteryselection == "heavy") then
			local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
			if (timer.Exists(timer_name)) then
				DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
				return
			end
			ply:SetGravity(10)
			DarkRP.notify(ply, 2, 4, "You have super-massive high gravity for 120 seconds!")
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
			timer.Create(timer_name, 120, 0, function()
				if not IsValid(ply) or (ply == nil) then return end
				ply:SetGravity(1)
				timer.Remove(timer_name)
			end)
	
		
		//ARMOR
		elseif(mysteryselection == "armor") then
			ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
			ply:SetArmor(200)
		
		//FRAIL
		elseif(mysteryselection == "frail") then
			ply:SetArmor(0)
			ply:SetHealth(1)
			ply:EmitSound("vo/npc/Barney/ba_no0" ..math.random(1,2) ..".wav", 100, 100, 1)
		end
	end
	ply:EmitSound("falch_drink_potion")
	self:Remove()
end

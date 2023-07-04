AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	if (self:GetQuality() == 0) then self:SetQuality(math.random(1,5)) end
	self:SetQualityModel()
	
	local index = (self:GetSubMaterialIndex())
	if(index ~= nil) then
		self:SetSubMaterial(index, "fancyalchemy/potion_red")
	end	
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	self:DrawShadow(true)
	local phys = self:GetPhysicsObject()
	
	phys:Wake()
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
	local timer_name = "Falch_HealthPotion_" .. ply:UniqueID()
	if (timer.Exists(timer_name)) then
		DarkRP.notify(ply, 2, 4, "You already have a health potion effect!")
		return
	end
	
	if(quality == 1) then // SIMPLE
		timer.Create(timer_name, 0.25, 20, function()
			if not IsValid(ply) or (ply == nil) then return end
			if(ply:Alive() == false) then return end
			if(ply:Health() <= 100) then
				ply:SetHealth(math.Clamp(ply:Health() + 1, 0, 100))
			else
				ply:SetHealth(math.Clamp(ply:Health() + 1, 0, 200))
			end
		end)
		timer.Simple(5, function()
			timer.Remove(timer_name)
		end)
	elseif (quality == 2) then // ADVANCED
		if not IsValid(ply) or (ply == nil) then return end
		if(ply:Health() <= 100) then
			ply:SetHealth(math.Clamp(ply:Health() + 25, 0, 100))
		else
			ply:SetHealth(math.Clamp(ply:Health() + 25, 0, 200))
		end	
	elseif (quality == 3) then // SUPERB
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
	elseif (quality == 4) then // ILLUSTRIOUS
		if(ply:Health() < 150) then
			ply:SetHealth(math.Clamp(ply:Health() + 100, 0, 150))
		else
			ply:SetHealth(math.Clamp(ply:Health() + 100, 0, 200))
		end
	elseif (quality == 5) then // FANATICAL
		ply:SetHealth(200)
		timer.Create(timer_name, 0.25, 30, function()
			if not IsValid(ply) or (ply == nil) then return end
			if(ply:Alive() == false) then return end
			ply:SetHealth(math.Clamp(ply:Health() + 10, 0, 200))
		end)
		timer.Simple(7.5, function()
			timer.Remove(timer_name)
		end)
	end
	ply:EmitSound("falch_drink_potion")
	self:Remove()
end

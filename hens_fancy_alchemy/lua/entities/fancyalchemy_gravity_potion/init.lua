AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	if (self:GetQuality() == 0) then self:SetQuality(math.random(1,5)) end
	self:SetQualityModel()
	
	local index = (self:GetSubMaterialIndex())
	if(index ~= nil) then
		self:SetSubMaterial(index, "fancyalchemy/potion_purple")
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
	local timer_name = "Falch_GravityPotion" .. ply:UniqueID()
	if (timer.Exists(timer_name)) then
		DarkRP.notify(ply, 2, 4, "You already have a gravity effect!")
		return
	end
	
	if(quality == 1) then // SIMPLE
		ply:SetGravity(0.5)
		DarkRP.notify(ply, 2, 4, "You have low gravity for 15 seconds!")
		timer.Create(timer_name, 15, 0, function()
			if not IsValid(ply) or (ply == nil) then return end
			ply:SetGravity(1)
			timer.Remove(timer_name)
		end)
		
	elseif (quality == 2) then // ADVANCED
		ply:SetGravity(0.4)
		DarkRP.notify(ply, 2, 4, "You have low gravity for 30 seconds!")
		timer.Create(timer_name, 30, 0, function()
			if not IsValid(ply) or (ply == nil) then return end
			ply:SetGravity(1)
			timer.Remove(timer_name)
		end)
		
	elseif (quality == 3) then // SUPERB
		ply:SetGravity(0.3)
		DarkRP.notify(ply, 2, 4, "You have low gravity for 60 seconds!")
		timer.Create(timer_name, 60, 0, function()
			if not IsValid(ply) or (ply == nil) then return end
			ply:SetGravity(1)
			timer.Remove(timer_name)
		end)
		
	elseif (quality == 4) then // ILLUSTRIOUS
		ply:SetGravity(0.2)
		ply:SetJumpPower(300)
		DarkRP.notify(ply, 2, 4, "You have super low gravity for 120 seconds!")
		timer.Create(timer_name, 120, 0, function()
			if not IsValid(ply) or (ply == nil) then return end
			ply:SetGravity(1)
			ply:SetJumpPower(200)
			timer.Remove(timer_name)
		end)
		
	elseif (quality == 5) then // FANATICAL
		ply:SetGravity(0.3)
		ply:SetJumpPower(400)
		DarkRP.notify(ply, 2, 4, "You have super low gravity for 5 minutes!")
		timer.Create(timer_name, 300, 0, function()
			if not IsValid(ply) or (ply == nil) then return end
			ply:SetGravity(1)
			ply:SetJumpPower(200)
			timer.Remove(timer_name)
		end)
	end
	ply:EmitSound("falch_drink_potion")
	self:Remove()
end

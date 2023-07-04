AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	if (self:GetQuality() == 0) then self:SetQuality(math.random(1,5)) end
	self:SetQualityModel()
	
	local index = (self:GetSubMaterialIndex())
	if(index ~= nil) then
		self:SetSubMaterial(index, "fancyalchemy/potion_blue")
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

function ENT:Use(ply)
	local quality = self:GetQuality()
	if(quality == 1) then // SIMPLE
		ply:SetArmor(math.Clamp(ply:Armor() +15, 0, 150))
	elseif (quality == 2) then // ADVANCED
		ply:SetArmor(math.Clamp(ply:Armor() +35, 0, 150))
	elseif (quality == 3) then // SUPERB
		ply:SetArmor(math.Clamp(ply:Armor() +75, 0, 150))
	elseif (quality == 4) then // ILLUSTRIOUS
		ply:SetArmor(math.Clamp(ply:Armor() +125, 0, 150))
	elseif (quality == 5) then // FANATICAL
		ply:SetArmor(190)
	end
	ply:EmitSound("falch_drink_potion")
	self:Remove()
end

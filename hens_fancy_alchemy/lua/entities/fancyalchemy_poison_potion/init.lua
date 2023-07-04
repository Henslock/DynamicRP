AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	if (self:GetQuality() == 0) then self:SetQuality(math.random(1,5)) end
	self:SetQualityModel()
	
	local index = (self:GetSubMaterialIndex())
	if(index ~= nil) then
		self:SetSubMaterial(index, "fancyalchemy/potion_red_fake")
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
	if(quality == 1) then // SIMPLE
		ply:EmitSound("vo/npc/male01/moan0" .. math.random(1,5) ..".wav", 100, 100, 1)
		timer.Create("Falch_PoisonPotion", 0.25, 20, function()
			ply:SetHealth(ply:Health() - 1)
			if(ply:Health() <= 0) then ply:Kill(); timer.Remove("Falch_PoisonPotion") end
		end)
	elseif (quality == 2) then // ADVANCED
		ply:EmitSound("vo/npc/male01/moan0" .. math.random(1,5) ..".wav", 100, 100, 1)
		timer.Create("Falch_PoisonPotion", 0.25, 20, function()
			ply:SetHealth(ply:Health() - 2)
			if(ply:Health() <= 0) then ply:Kill(); timer.Remove("Falch_PoisonPotion") end
		end)
	elseif (quality == 3) then // SUPERB
		ply:EmitSound("vo/npc/male01/moan0" .. math.random(1,5) ..".wav", 100, 100, 1)
		timer.Create("Falch_PoisonPotion", 0.25, 20, function()
			ply:SetHealth(ply:Health() - 5)
			if(ply:Health() <= 0) then ply:Kill(); timer.Remove("Falch_PoisonPotion") end
		end)
	elseif (quality == 4) then // ILLUSTRIOUS
		ply:EmitSound("vo/npc/male01/moan0" .. math.random(1,5) ..".wav", 100, 100, 1)
		ply:SetHealth(math.Round(ply:Health() *0.1))
	elseif (quality == 5) then // FANATICAL
		ply:EmitSound("vo/npc/male01/moan0" .. math.random(1,5) ..".wav", 100, 100, 1)
		util.BlastDamage(ply, ply, ply:GetPos(), 256, 250)
		local fx2 = EffectData();
		fx2:SetEntity(ply);
		fx2:SetMagnitude(30)
		fx2:SetOrigin(ply:GetPos());
		util.Effect("Explosion",fx2, true, true)
	end
	ply:ChatPrint("The potion is poisoned!")
	ply:EmitSound("falch_drink_potion")
	self:Remove()
end
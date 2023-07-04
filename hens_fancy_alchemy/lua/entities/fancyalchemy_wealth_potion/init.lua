AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	if (self:GetQuality() == 0) then self:SetQuality(math.random(1,5)) end
	self:SetQualityModel()

	local index = (self:GetSubMaterialIndex())
	if(index ~= nil) then
		self:SetSubMaterial(index, "fancyalchemy/potion_yellow")
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
	local money = self:MoneyRoll()
	ply:addMoney(money)
	ply:ChatPrint("You have earned $".. string.Comma(money) .. " from the potion!")
	if(self:GetQuality()==5) then 
		ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0" .. math.random(1,4) ..".wav", 100, 100, 1)
	end
	ply:EmitSound("falch_drink_potion")
	self:Remove()
end

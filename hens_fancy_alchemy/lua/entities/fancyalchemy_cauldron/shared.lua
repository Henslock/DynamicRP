ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Alchemist Cauldron"
ENT.Author = "Henslock"
ENT.Category = "[Hens] Fancy Alchemy"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity",1,"owning_ent")
	self:NetworkVar("Bool", 1, "Mixing")
	self:NetworkVar("Float", 0, "StartMixingTime")
	self:NetworkVar("Float", 1, "MixingTime")
	self:NetworkVar("Float", 2, "TotalMixingTime")
	self:NetworkVar("String", 0, "IngredientOne")
	self:NetworkVar("String", 1, "IngredientTwo")
	self:NetworkVar("String", 2, "IngredientThree")
end

function ENT:Initialize()
end

function ENT:Think()
	if CLIENT then
		local dlight = DynamicLight( self:EntIndex())
		if ( dlight ) then
			dlight.pos = self.Entity:GetPos() + Vector(0,0,30)
			dlight.r = 0
			dlight.g = 255
			dlight.b = 0
			dlight.brightness = 1
			dlight.size = 512
			dlight.decay = 0
			dlight.style = 5
			dlight.dietime = CurTime() + 1
		end
	end
end
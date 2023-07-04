ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Gravity Potion"
ENT.Author = "Henslock"
ENT.Category = "[Hens] Fancy Alchemy"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",1,"Quality")
end

function ENT:GetQualityName()
	local quality = self:GetQuality()
	local qualitytbl = {
	[1] = "Simple",
	[2] = "Advanced",
	[3] = "Superb",
	[4] = "Illustrious",
	[5] = "Fanatical",
	}
	if qualitytbl[quality] == nil then return "Mysterious" end
	return qualitytbl[quality]
end

function ENT:GetQualityColour()
	local quality = self:GetQuality()
	local qualitytbl = {
	[1] = Color(255,255,255),
	[2] = Color(102, 255, 168),
	[3] = Color(147, 201, 255),
	[4] = Color(119, 255, 106),
	[5] = Color(251, 147, 255)
	}
	if qualitytbl[quality] == nil then return (Color(0,0,0)) end
	return qualitytbl[quality]
end

function ENT:SetQualityModel()
	local quality = self:GetQuality()
	local qualitytbl = {
	[1] = "models/potions/potion_simple.mdl",
	[2] = "models/potions/potion_advanced.mdl",
	[3] = "models/potions/potion_superb.mdl",
	[4] = "models/potions/potion_illustrious.mdl",
	[5] = "models/potions/potion_fanatical.mdl"
	}
	
	self:SetModel(qualitytbl[quality])
end

-- Due to some dumb modelling errors, submaterial indicies arent consistent
function ENT:GetSubMaterialIndex()
	local quality = self:GetQuality()
	local qualitytbl = {
	[1] = 1,
	[2] = 1,
	[3] = 0,
	[4] = 2,
	[5] = 1
	}
	
	if qualitytbl[quality] == nil then return nil end
	return qualitytbl[quality]
end

function ENT:Think()
	if CLIENT then
		if(self:GetQuality() == 5) then
			local dlight = DynamicLight( self:EntIndex())
			if ( dlight ) then
				dlight.pos = self.Entity:GetPos() + Vector(0,0,10)
				dlight.r = 232
				dlight.g = 66
				dlight.b = 244
				dlight.brightness = 1
				dlight.size = 256
				dlight.decay = 0
				dlight.style = 5
				dlight.dietime = CurTime() + 1
			end
		end
	end
end
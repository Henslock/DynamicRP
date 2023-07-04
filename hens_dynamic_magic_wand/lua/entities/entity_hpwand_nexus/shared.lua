ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Enchanted Nexus"
ENT.Author = "Henslock"
ENT.Category = "Harry Potter Nexus"
ENT.Spawnable = true

function ENT:Think()
	if CLIENT then
		local dlight = DynamicLight( self:EntIndex())
		local dlight2 = DynamicLight( self:EntIndex() + 1)
		if ( dlight ) then
			dlight.pos = self.Entity:GetPos() + Vector(0,0,20)
			dlight.r = 255
			dlight.g = 0
			dlight.b = 0
			dlight.brightness = 1
			dlight.size = 188
			dlight.decay = 0
			dlight.style = 5
			dlight.dietime = CurTime() + 1
		end
		
		if ( dlight2 ) then
			dlight2.pos = self.Entity:GetPos() + Vector(0,0,50)
			dlight2.r = 125
			dlight2.g = 0
			dlight2.b = 0
			dlight2.brightness = 1
			dlight2.size = 256
			dlight2.decay = 0
			dlight2.style = 5
			dlight2.dietime = CurTime() + 1
		end
	end
end
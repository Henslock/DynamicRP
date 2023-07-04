ENT.Type = "anim"
ENT.PrintName = "Grimoire_ent"
ENT.Author = "Hens"

ENT.DoNotDuplicate = true 
ENT.DisableDuplicator = true

function ENT:Think()
	if CLIENT then
		local dlight = DynamicLight( self:EntIndex())
		if ( dlight ) then
			dlight.pos = self.Entity:GetPos() + Vector(0,0,10)
			dlight.r = 175
			dlight.g = 0
			dlight.b = 0
			dlight.brightness = 1
			dlight.size = 200
			dlight.decay = 0
			dlight.style = 5
			dlight.dietime = CurTime() + 1
		end
	end
end
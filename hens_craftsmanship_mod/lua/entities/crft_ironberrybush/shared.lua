ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Ironberry Bush"
ENT.Category = "[Hens] Craftsmanship"
ENT.Author = "Henslock"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Supply Crate"
ENT.Author = "Henslock"
ENT.Category = "[Hens] Craftsmanship"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity",5,"EntOwner")
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
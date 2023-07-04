ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cart"
ENT.Author = "Henslock"
ENT.Category = "[Hens] Craftsmanship"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity",5,"owning_ent")
	self:NetworkVar("Int",0,"Woods")
	self:NetworkVar("Int",1,"Width")
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
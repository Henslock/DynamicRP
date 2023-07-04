ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Sawmill"
ENT.Category = "[Hens] Craftsmanship"
ENT.Author = "Henslock"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"Woods")
	self:NetworkVar("Int",1,"Width")
	self:NetworkVar("Int",2,"Timer")
	self:NetworkVar("Entity",0,"Cart")
	self:NetworkVar("Entity",1,"Saw")
	self:NetworkVar("Int",3,"GetWoods")
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
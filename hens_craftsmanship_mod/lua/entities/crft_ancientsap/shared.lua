ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Ancient Sap"
ENT.Author = "Henslock"
ENT.Category = "[Hens] Craftsmanship"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",1,"owning_ent")
end
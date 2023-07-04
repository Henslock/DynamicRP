ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "[Hens] Wooden Cart"
ENT.Author = "Hens"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",0,"owning_ent")
end
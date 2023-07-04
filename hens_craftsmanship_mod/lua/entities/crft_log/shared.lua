ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Log"
ENT.Category = "[Hens] Craftsmanship"
ENT.Author = "Henslock"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity",1,"owning_ent")
end
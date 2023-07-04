ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Level Text"
ENT.Spawnable = false 
ENT.Category = "[Hens] Craftsmanship"

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "MessageText")

end
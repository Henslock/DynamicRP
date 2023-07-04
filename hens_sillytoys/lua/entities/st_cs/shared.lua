ENT.Type = "anim"
ENT.PrintName = "CarvingStone_ent"
ENT.Author = "Hens"

ENT.DoNotDuplicate = true 
ENT.DisableDuplicator = true

ENT.DefaultTimer	= 3

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"CSState")
end
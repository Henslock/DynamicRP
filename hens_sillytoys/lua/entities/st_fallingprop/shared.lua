ENT.Type = "anim"
ENT.PrintName = "ST_fallingProp"
ENT.Author = "Hens"

ENT.DoNotDuplicate = true 
ENT.DisableDuplicator = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"FallingTime")
end
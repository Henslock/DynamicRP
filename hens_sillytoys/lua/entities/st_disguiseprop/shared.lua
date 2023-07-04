ENT.Type = "anim"
ENT.PrintName = "ST_disguiseProp_ent"
ENT.Author = "Hens"

ENT.DoNotDuplicate = true 
ENT.DisableDuplicator = true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "RotAmount" )
end
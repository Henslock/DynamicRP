ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Sci Fi Vendor"
ENT.Author = "Henslock"
ENT.Spawnable = true
ENT.Category = "[Hens] Sci Fi Vendor"
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance( anim )
	self.AutomaticFrameAdvance = anim
end 
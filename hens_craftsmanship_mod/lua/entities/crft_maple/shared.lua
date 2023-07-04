ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Maple Tree"
ENT.Category = "[Hens] Craftsmanship"
ENT.Author = "Henslock"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"TreeHealth")
	self:NetworkVar("Int",1,"IgniteDamage")
	self:NetworkVar("Bool",0,"IsIgnited")
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

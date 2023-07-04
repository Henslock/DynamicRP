ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "AnchorProp"
ENT.Author = "Hens"
ENT.Spawnable = false

if SERVER then
	AddCSLuaFile("shared.lua")
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()

	self:SetModel("models/hunter/plates/plate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)

end

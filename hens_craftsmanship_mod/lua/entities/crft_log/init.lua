AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	local logtype = self:GetNWString("LogType")
	if(logtype == "") then
		logtype = "mat_oakwood"
		self:SetNWString("LogType", "mat_oakwood")
		self:SetMaterial("crafting/log")
	end
	self:SetModel(CRAFTSMANSHIP_MATS_DROP[logtype].dropmodel)
	
	if(logtype == "mat_birchwood") then
		self:SetMaterial("crafting/log_birch")
	elseif (logtype == "mat_maplewood") then
		self:SetMaterial("crafting/log_maple")
	end
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Touched = false

	self.RemovingTime = CurTime() + SWM_LOG_REMOVE_TIME
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end

function ENT:Think()
	if !self.Touched and self.RemovingTime <= CurTime() then
		self:Remove()
	end
end

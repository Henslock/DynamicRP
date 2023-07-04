AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/props_soho/trashbag001.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(true)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

local potions = {
["fancyalchemy_armor_potion"] = true,
["fancyalchemy_gravity_potion"] = true,
["fancyalchemy_health_potion"] = true,
["fancyalchemy_mystery_potion"] = true,
["fancyalchemy_poison_potion"] = true,
["fancyalchemy_speed_potion"] = true,
["fancyalchemy_wealth_potion"] = true
}

function ENT:Touch(item)
	if(item:IsPlayer()) then return end
	
	if(potions[item:GetClass()] == true) then
		item:Remove()
		self:EmitSound("physics/glass/glass_bottle_break" .. math.random(1,2) .. ".wav", 90, math.random(85, 115), 1)
	end
end

function ENT:OnRemove()
end

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local DROPPROPS = {
	"models/props_furniture/piano.mdl", 
	"models/props_c17/furniturestove001a.mdl", 
	"models/props_c17/gravestone_cross001a.mdl", 
	"models/props_vehicles/car001a_hatchback.mdl",
	"models/props_c17/statue_horse.mdl",
	"models/props/cs_militia/militiarock01.mdl",
	"models/props_trainstation/train001.mdl",
	"models/props_vehicles/truck001a.mdl",
	}

function ENT:Initialize()
	local propmdl = table.Random(DROPPROPS)
	self.Entity:SetModel(propmdl) 
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	
	if(self:GetFallingTime() == 0) then self:SetFallingTime(2) end
	
	local selfcheck = self
	
	timer.Simple(self:GetFallingTime() + 3, function()
		if(!IsValid(selfcheck)) then return end
		self:Remove()
	end)
end
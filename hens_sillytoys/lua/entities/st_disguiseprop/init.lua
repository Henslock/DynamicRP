AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local randProps = {"models/props_c17/oildrum001.mdl", "models/props_interiors/Furniture_Lamp01a.mdl", "models/props_c17/FurnitureChair001a.mdl", "models/props_c17/FurnitureWashingmachine001a.mdl", "models/props/CS_militia/barstool01.mdl", "models/props_junk/TrafficCone001a.mdl", "models/props_wasteland/kitchen_shelf001a.mdl", "models/props_interiors/VendingMachineSoda01a.mdl", "models/props_junk/cardboard_box001a_gib01.mdl", "models/props_wasteland/controlroom_filecabinet002a.mdl", "models/props_trainstation/trashcan_indoor001a.mdl", "models/props_borealis/bluebarrel001.mdl", "models/props_combine/breenbust.mdl", "models/props_combine/breenglobe.mdl", "models/props_junk/PushCart01a.mdl", "models/props_trainstation/payphone001a.mdl", "models/props/cs_assault/firehydrant.mdl"}

local rpProps = {"models/props_c17/oildrum001.mdl", "models/props_interiors/Furniture_Lamp01a.mdl", "models/props_c17/FurnitureChair001a.mdl", "models/props_c17/FurnitureWashingmachine001a.mdl", "models/props/CS_militia/barstool01.mdl", "models/props_junk/TrafficCone001a.mdl", "models/props_wasteland/kitchen_shelf001a.mdl", "models/props_interiors/VendingMachineSoda01a.mdl", "models/props_junk/cardboard_box001a_gib01.mdl", "models/props_wasteland/controlroom_filecabinet002a.mdl", "models/props_trainstation/trashcan_indoor001a.mdl", "models/props_borealis/bluebarrel001.mdl", "models/props_combine/breenbust.mdl", "models/props_combine/breenglobe.mdl", "models/props_junk/PushCart01a.mdl", "models/props_trainstation/payphone001a.mdl", "models/props/cs_assault/firehydrant.mdl", "models/wilderness/lamp6.mdl", "models/Highrise/lobby_chair_01.mdl", "models/scenery/furniture/coffeetable1/vestbl.mdl", "models/props_interiors/copymachine01.mdl", "models/props_urban/plastic_chair001.mdl", "models/props_junk/trashcluster01a_corner.mdl", "models/env/furniture/bstoolred/bstoolred.mdl", "models/props_unique/wheelchair01.mdl", "models/props_interiors/chair01.mdl", "models/props_interiors/water_cooler.mdl"}

function ENT:Initialize()

	//Roleplay Props Support
	local propChoice = randProps
	if(file.Exists("models/env/furniture/wc_double_cupboard/wc_double_cupboard.mdl", "GAME")) then  
		propChoice = rpProps
	end
	
	self.Entity:SetModel(table.Random(propChoice)) 
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	

	self.Entity:DrawShadow( true )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end
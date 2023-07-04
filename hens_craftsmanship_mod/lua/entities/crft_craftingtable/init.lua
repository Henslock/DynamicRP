AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.AddNetworkString("craftingtable_open")

function ENT:Initialize()
	self:SetModel( "models/crafting/craftingtable.mdl" )
	self:SetUseType( SIMPLE_USE )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:AcceptInput(name, activator, caller)
	net.Start("craftingtable_open")
	net.Send(caller)
end
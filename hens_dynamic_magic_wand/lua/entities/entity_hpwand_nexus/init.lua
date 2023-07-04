AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("hpwr_nexusmenu_open")
util.AddNetworkString("hpwr_nexusmenu_buyspell")

function ENT:Initialize()
	
	self:SetModel("models/dyn_magicnexus/nexus.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	
	local phys = self:GetPhysicsObject()
	
	phys:Wake()
	
	local seq = self:LookupSequence("idle")
	self:ResetSequence(seq)
	
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end

function ENT:AcceptInput(name, activator, caller)
	net.Start("hpwr_nexusmenu_open")
	net.Send(caller)
end

net.Receive("hpwr_nexusmenu_buyspell", function(len, ply)
	local mutatiocost = net.ReadFloat()
	local spell = net.ReadString()
	
	local mutatio = ply:GetNWInt("hp_mutatio")
	ply:SetNWInt("hp_mutatio", mutatio - mutatiocost)
	
	HpwRewrite:PlayerGiveLearnableSpell(ply, spell, false)
end)
	



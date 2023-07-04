AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.AddNetworkString("scifi_menu_open")

function ENT:Initialize()
	self:SetModel( SCIFI_NPC_MODEL )
	print(SCIFI_NPC_MODEL)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetUseType( SIMPLE_USE )
	self:SetBloodColor(BLOOD_COLOR_RED)
	self:SetSolid(SOLID_BBOX)
end

function ENT:AcceptInput(name, activator, caller)
	self:EmitSound(table.Random(VENDOR_INTRO_VO), 70, 80, 1, CHAN_VOICE)
	net.Start("scifi_menu_open")
	net.Send(caller)
end

net.Receive( "scifi_givewep", function( len, ply )
	local wep = net.ReadString()
	local cost = net.ReadString()
	
	ply:EmitSound("ambient/levels/labs/coinslot1.wav", 100, 100)
	ply:Give(wep, false)
	ply:addMoney(cost * -1)
end )
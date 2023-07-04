AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.AddNetworkString("leggy_menu_open")

local purrcounter = 0
local response = {"vo/eli_lab/al_gooddoggie.wav", "vo/Citadel/eli_mygirl.wav", "vo/k_lab/kl_mygoodness01.wav", "vo/k_lab2/al_goodboy.wav", "vo/k_lab2/kl_lamarr.wav", "vo/k_lab/kl_lamarr.wav", "vo/k_lab2/kl_cantleavelamarr.wav"}

function ENT:Initialize()
	self:SetModel( "models/headcrabblack.mdl" )
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetUseType( SIMPLE_USE )
	self:SetBloodColor(BLOOD_COLOR_RED)
	self:SetSolid(SOLID_BBOX)
end

function ENT:AcceptInput(name, activator, caller)

	if(caller:Crouching()) then
		self:EmitSound("npc/headcrab_poison/ph_warning" ..math.random(1,3) .. ".wav", 70, math.random(80,120), 1, CHAN_VOICE)
		purrcounter = (purrcounter +1 )
		if(purrcounter>= 6) then
			purrcounter = 0
			caller:EmitSound( table.Random(response), 70, 100, 1, CHAN_VOICE)
		end
		return
	end
	self:EmitSound("npc/headcrab_poison/ph_idle".. math.random(1,3) ..".wav", 70, math.random(80,120), 1, CHAN_VOICE)
	
	net.Start("leggy_menu_open")
	net.Send(caller)
end
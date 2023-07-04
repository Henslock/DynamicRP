AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "Gestures";
	SWEP.Slot = 2;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	
end

SWEP.Instructions = "Right click to play animations.";
SWEP.Author = "Hens"
SWEP.Category = "[Hens] Silly Toys"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "";
SWEP.WorldModel = "";
SWEP.ViewModelFOV = 62
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Delay = 0

if SERVER then
	util.AddNetworkString("ST_gestureAnims")
	util.AddNetworkString("ST_gestureAnimsDistribute")
	util.AddNetworkString("ST_openAnimsMenu")
end

function SWEP:Deploy()
end

function SWEP:Initialize()
self:SetHoldType("normal")
end


function SWEP:Reload()
end

function SWEP:DrawHUD()
end


function SWEP:PrimaryAttack()
	return false
end

function SWEP:SecondaryAttack()
	local ply = self.Owner
	if SERVER then
		net.Start("ST_openAnimsMenu")
		net.Send(ply)
	end
	return false
end


net.Receive("ST_gestureAnims", function(len, ply)
	local anim = net.ReadFloat()
	local loop = net.ReadBool()

	if SERVER then
		net.Start("ST_gestureAnimsDistribute")
			net.WriteEntity(ply)
			net.WriteFloat(anim)
			net.WriteBool(loop)
		net.Broadcast()
	end
end)

net.Receive("ST_gestureAnimsDistribute", function()
	local ply = net.ReadEntity()
	local anim = net.ReadFloat()
	local loop = net.ReadBool()
	
	ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
	ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM,  anim, !loop)
end)

function SWEP:Think()
end

function SWEP:DrawWorldModel()
end
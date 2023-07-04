AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "Young White Branch";
	SWEP.Slot = 2;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = true;
	
end

if SERVER then
	util.AddNetworkString("ST_ywbAnims")
end

SWEP.Instructions = "Left click to toggle your disguise. Right click to taunt. Reload to rotate.";
SWEP.Author = "Hens"
SWEP.Category = "[Hens] Silly Toys"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "";
SWEP.WorldModel = "models/props_junk/garbage_milkcarton001a.mdl";
SWEP.HoldType = "normal"
SWEP.ViewModelFOV = 75
SWEP.UseHands = true
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Delay = 3

SWEP.Secondary.Delay = 4

function SWEP:SetupDataTables()
	self:NetworkVar("Entity",1,"BranchProp")
	self:NetworkVar("Bool",1,"Camoflauge")
end

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID("vgui/sillytoys/selection/ywb_ico")
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		x = x + wide / 2
		y = y + tall / 2

		tall = tall * 0.75

		x = x - tall / 2
		y = y - tall / 2 - 10

		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetTexture(self.WepSelectIcon)

		surface.DrawTexturedRect(x, y, tall, tall)
	end
	
end

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
	self:SetCamoflauge(false)
	self.Owner:SetNoDraw(false)

end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetCamoflauge(false)
end

function SWEP:PrimaryAttack()

	if SERVER then
		if(self.Weapon:GetNextPrimaryFire() <= CurTime() ) then
			self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			local ply = self.Owner
			if(self:GetCamoflauge() == true) then
				ply:SetNoDraw(false)
				ply:EmitSound("buttons/combine_button5.wav", 80, math.random(140,150), 1, CHAN_AUTO)
				self:SetCamoflauge(false)
				
				local prop = self:GetBranchProp()
				if(IsValid(prop)) then
					prop:Remove()
				end
			else
				ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_SIGNAL_GROUP, true)
				ply:EmitSound("ambient/levels/canals/windchime4.wav", 90, math.random(80,90), 1, CHAN_AUTO)
				ParticleEffectAttach("st_ywb_aura", PATTACH_ABSORIGIN_FOLLOW, ply, 0)
				net.Start("ST_ywbAnims")
					net.WriteEntity(ply)
				net.Broadcast()
				local wep = self.Weapon
				local timerName = "st_ywb_timer_" .. wep:EntIndex()
				timer.Create(timerName, 1.5, 1, function()
					if(!IsValid(ply)) then return end
					if(!IsValid(wep)) then return end

					ply:SetNoDraw(true)
					ply:EmitSound("buttons/combine_button1.wav", 80, math.random(140,150), 1, CHAN_AUTO)
					self:SetCamoflauge(true)

					local prop = ents.Create("st_disguiseprop")
					local min, max = prop:GetModelBounds()
					prop:SetParent(ply)
					prop:SetPos(ply:GetPos())
					prop:Spawn()
					
					self:SetBranchProp(prop)
				end)
			end
		end
	end

end

function SWEP:Holster()

	if IsValid(self:GetBranchProp()) then
		local prop = self:GetBranchProp()
		prop:Remove()
	end
	self:SetCamoflauge(false)
	self.Owner:SetNoDraw(false)
	self.Owner:EmitSound("buttons/combine_button5.wav", 80, math.random(140,150), 1, CHAN_AUTO)
	
	local timerName = "st_ywb_timer_" .. self.Weapon:EntIndex()
	if(timer.Exists(timerName)) then
		timer.Remove(timerName)
	end
	return true
end

function SWEP:OnRemove()
	if(IsValid(self:GetBranchProp())) then
		self:GetBranchProp():Remove()
		self.Owner:SetNoDraw(false)
	end
end

local randTaunts = {"vo/Citadel/eli_dontstruggle.wav", "vo/Citadel/eli_dontworryboutme.wav", "vo/trainyard/kl_verywell.wav", "vo/trainyard/ba_privacy.wav", "vo/ravenholm/madlaugh01.wav", "vo/ravenholm/madlaugh03.wav", "vo/trainyard/al_overhere.wav", "ambient/voices/f_scream1.wav"}

function SWEP:SecondaryAttack()
	if(self:GetCamoflauge()) then
		self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
		self.Weapon:EmitSound(table.Random(randTaunts), 60, 100, 1, CHAN_AUTO)
	end
	return false
end

function SWEP:Reload()
	if(!IsValid(self:GetBranchProp()) or self:GetCamoflauge()==false) then return end
	if(self.Weapon:GetNextSecondaryFire() <= CurTime() ) then
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		local ent = self:GetBranchProp()
		local rot = ent:GetRotAmount()
		ent:SetRotAmount((rot + 45) % 360)
		if CLIENT then
			self.Weapon:EmitSound("UI/buttonclick.wav")
		end
		return
	end
end

function SWEP:DrawWorldModel()
	if(!IsValid(self.Owner)) then
		self:DrawModel()
	end
end

net.Receive("ST_ywbAnims", function()
	local ply = net.ReadEntity()
	ParticleEffectAttach("st_ywb_aura", PATTACH_ABSORIGIN_FOLLOW, ply, 0)
	ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_SIGNAL_GROUP, true)
end)
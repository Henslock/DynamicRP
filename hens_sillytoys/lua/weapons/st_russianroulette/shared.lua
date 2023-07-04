AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "Russian Roulette Gun";
	SWEP.Slot = 2;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = true;
	
end

SWEP.Instructions = "Roll the barrel and shoot the gun. You have a 1/6 chance of living. The gun is dropped if you live.";
SWEP.Author = "Hens"
SWEP.Category = "[Hens] Silly Toys"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/w_357.mdl";
SWEP.WorldModel = "models/weapons/w_357.mdl";
SWEP.ViewModelFOV = 75
SWEP.HoldType = "revolver"
SWEP.UseHands = false
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Delay = 10

if SERVER then
	util.AddNetworkString("ST_vicRRdance")
	util.AddNetworkString("ST_vicRRdance2")
end

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
	self:SetNWInt("RR_chamberbullet", math.random(1,6))
end

function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_HOLSTER);
end

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID("vgui/sillytoys/selection/rr_ico")
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

function SWEP:PrimaryAttack()
	if(self.Weapon:GetNextPrimaryFire() <= CurTime() ) then
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		if SERVER then
			local ply = self.Owner
			local wep = self.Weapon
			local chamberbullet = self:GetNWInt("RR_chamberbullet")
			
			if(IsValid(ply)) then
			
				local roll = math.random(1,6)
				ply:EmitSound("st_rr_cylinder")
				ply:EmitSound("st_rr_drumroll")
				timer.Simple(4, function()
					if(ply == NULL or ply == nil) then return end
					if(wep == nil or wep == NULL or !IsValid(wep)) then return end
					if(!IsValid(ply)) then return end
					if(ply:Alive() == false ) then return end
					
					if(roll == chamberbullet) then
						local gamemode_name = GAMEMODE_NAME
						
						if(wep ~= nil) then
							if(gamemode_name == "darkrp") then
								ply:dropDRPWeapon(wep)
							end
						end

						ply:EmitSound("vo/npc/Barney/ba_pain0"..math.random(2,8)..".wav")
						ply:EmitSound("weapons/pistol/pistol_fire2.wav")
						ply:SetVelocity(ply:GetAimVector():GetNormalized() * -3150)
						timer.Simple(0.1, function()
							ply:EmitSound("st_rr_cancer")
							ply:Kill()
						end)
						
					else
						if(wep ~= nil) then 
							ply:EmitSound("weapons/pistol/pistol_empty.wav")
							ply:EmitSound("vo/coast/odessa/male01/nlo_cheer0"..math.random(1,4)..".wav")
							local gamemode_name = GAMEMODE_NAME
							if(gamemode_name == "darkrp") then
								ply:dropDRPWeapon(wep)
							end
							ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_TAUNT_CHEER , true)
							
							net.Start("ST_vicRRdance")
							net.Send(ply)							
							
							net.Start("ST_vicRRdance2")
								net.WriteEntity(ply)
							net.Broadcast()
						end
						
						return
					end

				end)
				
			end
		end
		
		return
	end
end

net.Receive("ST_vicRRdance", function()
	LocalPlayer():AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_TAUNT_CHEER , true)
end)

net.Receive("ST_vicRRdance2", function()
	local ply = net.ReadEntity()
	ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_TAUNT_CHEER , true)
end)

function SWEP:SecondaryAttack()
	return false
end

local vmat = Matrix()

function SWEP:DrawWorldModel()
	//Had to reference a figet spinner to figure out how to flip the gun, feelsbadman
	//This block of code isn't mine
	ply = self.Owner
	if(IsValid(ply))then
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand") or 0
		
		local opos = self:GetPos()
		local oang = self:GetAngles()
		local bp,ba = ply:GetBonePosition(bone)
		if(bp)then opos = bp end
		if(ba)then oang = ba end
		

		opos = opos + oang:Right()*3
		opos = opos + oang:Forward()*6
		opos = opos + oang:Up()*-1

		oang:RotateAroundAxis(oang:Up(), 180)
		self:SetupBones()
		
		oscl = Vector(0.8,0.8,0.8)

		local mrt = self:GetBoneMatrix(0)
		if(mrt)then
			mrt:SetTranslation(opos)
			mrt:SetAngles(oang)
			mrt:SetScale(oscl)
			self:SetBoneMatrix(0, mrt )
		end

		local mrt = self:GetBoneMatrix(1)
		if(mrt)then
			mrt:SetTranslation(opos)
			mrt:SetAngles(oang)
			mrt:SetScale(oscl)
			self:SetBoneMatrix(1, mrt )
		end
		
	end
	self:DrawModel()
end

if CLIENT then
	function SWEP:GetViewModelPosition( pos, ang )
		pos = pos + ang:Right()*17
		pos = pos + ang:Up()*-7
		pos = pos + ang:Forward()*30
		ang:RotateAroundAxis(ang:Up(), 140)
		pos = pos + ang:Forward()*0.2
		return pos, ang 
	end
end
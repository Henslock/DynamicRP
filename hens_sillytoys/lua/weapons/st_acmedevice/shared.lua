AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "ACME Device";
	SWEP.Slot = 2;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	
end

SWEP.Instructions = "Summons comedy.";
SWEP.Author = "Hens"
SWEP.Category = "[Hens] Silly Toys"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/sillytoys/acmedevice/v_acmedevice.mdl";
SWEP.WorldModel = "models/sillytoys/acmedevice/acmedevice.mdl";
SWEP.ViewModelFOV = 55
SWEP.HoldType = "slam"
SWEP.UseHands = false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Delay = 10

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
end

function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_HOLSTER);
end

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID("vgui/sillytoys/selection/acme_ico")
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


function SWEP:Reload()
end

function SWEP:DrawHUD()
end

function SWEP:PrimaryAttack()
	local ply = self.Owner
	if(self.Weapon:GetNextPrimaryFire() <= CurTime() ) then
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:EmitSound("buttons/combine_button1.wav", 65, 100, 1, CHAN_SWEP) 
		
		
		if SERVER then
			ply:EmitSound("st_whistle")
			
			ply:SetRunSpeed(0)
			ply:SetWalkSpeed(0)
			ply:SetCrouchedWalkSpeed(0)
			ply:SetVelocity(ply:GetVelocity() * -1)
				
			timer.Simple(3, function()
				if(!IsValid(ply)) then return end
				local fallingtime = 2
			
				local fallingprop = ents.Create("st_fallingprop")
				fallingprop:Spawn()
				local bounds = fallingprop:GetCollisionBounds()
				fallingprop:SetPos(ply:GetPos() + Vector(0,0, (math.abs(bounds.z))))
				fallingprop:SetFallingTime(fallingtime)
				ply:PrecacheGibs()
				timer.Simple(fallingtime - (fallingtime*0.05), function()
					if(!IsValid(ply)) then return end
									
	
					ply:Kill()
					ply:EmitSound("st_splat")
					ply:EmitSound("physics/flesh/flesh_bloody_impact_hard1.wav", 80, math.random(90,110), 1, CHAN_STATIC)
					ply:SetRunSpeed(400)
					ply:SetWalkSpeed(200)
				end)
			end)
		end
		
		return true
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()
end

function SWEP:DrawWorldModel()
	self:DrawModel()
end
AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "Jihad Toy";
	SWEP.Slot = 2;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	
end

SWEP.Instructions = "Surprise your racially judgemental friends with this neat party gag!";
SWEP.Author = "Hens"
SWEP.Category = "[Hens] Silly Toys"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_c4.mdl";
SWEP.WorldModel = "models/weapons/w_c4.mdl";
SWEP.ViewModelFOV = 75
SWEP.HoldType = "physgun"
SWEP.UseHands = true
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Delay = 8

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
end

function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_HOLSTER);
end

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID("vgui/sillytoys/selection/c4_ico")
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
	if(self.Weapon:GetNextPrimaryFire() <= CurTime() ) then
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		if SERVER then
			local ply = self.Owner
			ply:EmitSound("st_jihad")
			timer.Simple(6.5, function()
				if(ply == NULL or ply == nil) then return end
				if(ply:Alive() == false ) then return end
				
				ply:SetVelocity(Vector(0,0,5000))
				ply:Kill()
				local fx2 = EffectData();
				fx2:SetEntity(ply);
				fx2:SetMagnitude(30)
				fx2:SetOrigin(ply:GetPos());
				util.Effect("Explosion",fx2, true, true)
			end)
		end
		
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
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
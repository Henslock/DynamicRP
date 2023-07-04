AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "Ancient Grimoire";
	SWEP.Slot = 2;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	
end

SWEP.Instructions = "Summons undead from the damned hells.";
SWEP.Author = "Hens"
SWEP.Category = "[Hens] Silly Toys"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/sillytoys/grimoire/v_grimoire.mdl";
SWEP.WorldModel = "models/sillytoys/grimoire/grimoire.mdl";
SWEP.ViewModelFOV = 50
SWEP.HoldType = "slam"
SWEP.UseHands = true
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Delay = 2.5

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
end

function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_HOLSTER);
end

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID("vgui/sillytoys/selection/grimoire_ico")
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
	if SERVER then
		local grimoire = ents.Create("st_grimoire_ent")
		grimoire:SetPos(ply:GetPos() + Vector(0, 0, 3))
		grimoire:Spawn()
		print(ply:GetPos())
		
		ply:SetVelocity(ply:GetAimVector()*-150 + Vector(0,0,220))
		self:Remove()
	end
	
	return false
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()
end

function SWEP:DrawWorldModel()
	self:DrawModel()
end
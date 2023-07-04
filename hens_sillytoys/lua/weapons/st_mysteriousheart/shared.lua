AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "Myserious Heart";
	SWEP.Slot = 5;
	SWEP.SlotPos = 3;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	
end

SWEP.Instructions = "Looks familiar, I wonder what it does.";
SWEP.Author = "Hens"
SWEP.Category = "[Hens] Silly Toys"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "";
SWEP.WorldModel = "models/Gibs/HGIBS.mdl";
SWEP.ViewModelFOV = 75
SWEP.HoldType = "magic"
SWEP.UseHands = false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
end

function SWEP:Initialize()
end

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID("vgui/sillytoys/selection/heart_ico")
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		x = x + wide / 2
		y = y + tall / 2

		tall = tall * 0.5

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
	return false
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()
end

function SWEP:DrawWorldModel()
	--self:DrawModel()
end

hook.Add("PlayerSay", "SansTakesOver", function(ply, text, tm)
	if ply:HasWeapon("st_mysteriousheart") then
		if(math.random(1,2)==1) then
			ply:EmitSound("st_sans")
		end
	end
end)

hook.Add("PlayerDeath", "UndertaleMemeDeath", function(vic, inf, att)
	if vic:HasWeapon("st_mysteriousheart") then 
		vic:EmitSound("st_gameover")
	end
end)
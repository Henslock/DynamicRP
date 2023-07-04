AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "Carving Stone";
	SWEP.Slot = 2;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	
	//Created HUD font
	surface.CreateFont( "CS_HUDFont", {
		font = "Calibri",
		extended = false,
		size = 64,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = true,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false ,
	} )
	
end

SWEP.Instructions = "A mysterious carving stone that can speak! Right click to change your options.";
SWEP.Author = "Hens"
SWEP.Category = "[Hens] Silly Toys"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "";
SWEP.WorldModel = "";
SWEP.ViewModelFOV = 75
SWEP.HoldType = "slam"
SWEP.UseHands = true
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Delay = 2.5

local stoneState = 0

local stoneTags = {
[0] = "Hello",
[1] = "Very Good!",
[2] = "Help Me!",
[3] = "I'm Sorry!",
[4] = "Thank you!",
}

function SWEP:Deploy()
	stoneState = 0
	self:SetNWInt("cs_state", 0)
end

function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_HOLSTER);
	stoneState = 0
	self:SetNWInt("cs_state", 0)
end

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID("vgui/sillytoys/selection/carving_ico")
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
	draw.SimpleTextOutlined("''" ..stoneTags[stoneState].. "''", "CS_HUDFont", ScrW()*0.75, ScrH() * 0.85, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(75, 75, 75, 255))
end

function SWEP:PrimaryAttack()
	if(self.Weapon:GetNextPrimaryFire() <= CurTime() ) then
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		if SERVER then
		
			local cs_ent = ents.Create("st_cs")
			cs_ent:SetPos((self.Owner:EyePos() - Vector(0,0,2)) + (self.Owner:GetForward() * 24)) 
			cs_ent:SetAngles(Angle(math.random(0, 360),math.random(0, 360),0))
			cs_ent:Spawn()
			
			local state = self:GetNWInt("cs_state")
			cs_ent:SetCSState(state)
			
			local csphys = cs_ent:GetPhysicsObject()
			csphys:Wake()
			csphys:AddAngleVelocity(Vector(math.random(400,800), 10, math.random(400,800)))
			if (self.Owner:EyeAngles():Forward():Dot(self.Owner:GetVelocity():GetNormalized()) > 0) == true then
				csphys:SetVelocity(self.Owner:GetAimVector():GetNormalized() * 150 + self.Owner:GetVelocity())
			else
				csphys:SetVelocity(self.Owner:GetAimVector():GetNormalized() * 150)
			end
		
		end
		
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
		return true
	end
end

function SWEP:SecondaryAttack()
	if(self.SwapDelay == nil) then self.SwapDelay = 0 end
	if(self.SwapDelay <= CurTime()) then
	
		self.SwapDelay = CurTime() + 0.25
		local state = self:GetNWInt("cs_state")
		state = (state + 1) % 4
		self:SetNWInt("cs_state", state)
		stoneState = state
		
		if CLIENT then
			LocalPlayer():EmitSound("UI/buttonclick.wav")
		end
	end
	return false
end

function SWEP:Think()
end

function SWEP:DrawWorldModel()
	self:DrawModel()
end
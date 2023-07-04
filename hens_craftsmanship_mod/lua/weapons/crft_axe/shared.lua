include("sv_plrstats.lua")

if CLIENT then
	SWEP.PrintName = "Chopping Axe"
	SWEP.Slot = 1
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true

end

local crft_UI_cross =  Material( "materials/UI/CraftCross.png","smooth"  )

-- Variables that are used on both client and server

SWEP.Author = "Henslock"
SWEP.Instructions = "Left click to cut wood"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 63
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_chopping_axe/v_chopping_axe.mdl")
SWEP.WorldModel = Model("models/weapons/w_chopping_axe/w_chopping_axe.mdl")
SWEP.HoldType = "melee";

SWEP.UseHands = false

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "[Hens] Crafting"

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = true;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 100;
SWEP.Primary.Delay = 0.6;
SWEP.Primary.Ammo = "";
SWEP.StoredRank = 0

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID("vgui/crafting/selection/crft_ico")
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

-- Level Up 
function LevelUp(msg, ply)
	local lvl = ents.Create("crft_lvltxt")
	lvl:SetPos(ply:GetActiveWeapon():GetPos())
	lvl:SetAngles(ply:GetAngles())
	lvl:SetMessageText(msg)
	lvl:SetParent(ply:GetActiveWeapon())
	lvl:SetLocalPos(Vector(0, 0, 60))
	lvl:Spawn()
	
	ply:EmitSound("crft_lvlup")
	
	if(ply:GetNWInt("crft_level") == 10) then
		ply:EmitSound("crft_maxlvl")
	end
	ParticleEffectAttach("crft_lvlup_vfx", 1, ply,  0 )
	
	timer.Simple(5, function()
		if(lvl~=NULL) then
			lvl:Remove()
		end
	end)
end

hook.Add( "Crafting_LevelUp", "LevelUp", function(ply)

	local plyLvl = ply:GetNWInt("crft_level")
	if(plyLvl == 0) then plyLvl = 1 end
	LevelUp(CRAFTSMANSHIP_LEVELS[plyLvl][2], ply)
	
end)

-- Rank up
function RankUp(ply)
	local lvl = ents.Create("crft_ranktxt")
	lvl:SetPos(ply:GetActiveWeapon():GetPos())
	lvl:SetAngles(ply:GetAngles())
	lvl:SetParent(ply:GetActiveWeapon())
	lvl:SetLocalPos(Vector(0, 0, 60))
	lvl:Spawn()
	
	ply:EmitSound("crft_lvlup")
	ParticleEffectAttach("crft_lvlup_vfx", 1, ply,  0 )
	
	timer.Simple(5, function()
		if(lvl~=NULL) then
			lvl:Remove()
		end
	end)
end

hook.Add( "Crafting_RankUp", "RankUp", function(ply)
	RankUp(ply)	
end)


function SWEP:Deploy()

	if(self:GetOwner().crafting == nil) then crafting.InitializePlayers(self:GetOwner()) end
	self:SetHoldType(self.HoldType)
	UpdateAxe(self:GetOwner())
	if SERVER then
		if(math.random(1, 2) == 1) then
			self:GetOwner():PlayerMsg(Color(155, 255, 255), "[Tip] ", Color(255, 255, 255), table.Random(CRAFTSMANSHIP_TIPS).."")
		end
	end

end

function UpdateAxe(ply)
	wep = ply:GetActiveWeapon()
	local plyLvl = ply:GetNWInt("crft_level")
	if(plyLvl < 3) then
		wep.Primary.Delay = 0.9
		wep.Primary.Damage = 1
		wep:SetColor(Color(255, 255, 255))
		wep:SetMaterial("models/weapons/axe_basic")
		wep.StoredRank = 0
	elseif(plyLvl>=3 and plyLvl<6) then
		wep.Primary.Delay = 0.75
		wep.Primary.Damage = 10
		wep:SetColor(Color(255, 255, 255))
		wep:SetMaterial("models/weapons/axe_bronze")
		wep.StoredRank = 1
	elseif(plyLvl>=6 and plyLvl<10) then
		wep.Primary.Delay = 0.6
		wep.Primary.Damage = 45
		wep:SetColor(Color(255, 255, 255))
		wep:SetMaterial("models/weapons/axe_iron")
		wep.StoredRank = 2
	elseif(plyLvl>=10) then
		wep.Primary.Delay = 0.45
		wep.Primary.Damage = 90
		wep:SetColor(Color(255, 255, 255))
		wep:SetMaterial("models/weapons/axe_diamond")
		wep.StoredRank = 3
	end
end

hook.Add("crft_UpdateAxe", "Update Player Axe", UpdateAxe)

function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_HOLSTER);
end

function SWEP:DoHitEffects()
	local trace = self.Owner:GetEyeTraceNoCursor();
	
	if (((trace.Hit or trace.HitWorld) and self.Owner:GetShootPos():Distance(trace.HitPos) <= 110)) then
		self:SendWeaponAnim(ACT_VM_HITCENTER);
		self:EmitSound("weapons/crossbow/hitbod2.wav", 80, math.random(80, 120), 1, CHAN_AUTO);
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER);
		self:EmitSound("npc/vort/claw_swing2.wav");
	end;
end;

function SWEP:DoAnimations(idle)
	if (!idle) then
		self.Owner:SetAnimation(PLAYER_ATTACK1);
	end;
end;

--[[-------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
	self:DoAnimations();
	self:DoHitEffects();
	
	if (SERVER) then
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(true);
		end;
		
		local trace = self.Owner:GetEyeTraceNoCursor();
		
		if (self.Owner:GetShootPos():Distance(trace.HitPos) <= 110) then
			if (IsValid(trace.Entity)) then
				local dmg = self.Primary.Damage
				if(trace.Entity:IsPlayer()) then
					dmg = dmg/10
				end
				self.Owner:FireBullets({
					Spread = Vector(0, 0, 0),
					Damage = dmg,
					Tracer = 0,
					Force = 1,
					Num = 1,
					Src = self.Owner:GetShootPos(),
					Dir = self.Owner:GetAimVector()
				});
			end;
		end;
		
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(false);
		end;
	end;
end

function SWEP:Holster()
	return true
end

function SWEP:Think()
end

local XPLerpAnim = 0

function SWEP:DrawHUD()
	
	local ply = self:GetOwner()
	local plyLvl = ply:GetNWInt("crft_level")
	if(plyLvl == 0) then plyLvl = 1 end
	
	local XPCurveAdj = 180 - ((ply:GetNWInt("crft_experience") / CRAFTSMANSHIP_LEVELS[plyLvl][1])*180)
	if(plyLvl >= CRAFTING_MAX_LEVEL) and (CRFT_PRESTIGE_ENABLED == false) then
		XPCurveAdj = 0
	end
	
	XPLerpAnim = Lerp(FrameTime()*3, XPLerpAnim, XPCurveAdj)
	
	local XPArc = surface.PrecacheArc(ScrW()/2,ScrH() + 25,150,35,XPLerpAnim,180,5)
	local XPArcBG = surface.PrecacheArc(ScrW()/2,ScrH() + 25,155,45,0,180,5)

	local OuterRing = surface.PrecacheArc(ScrW()/2,ScrH() + 25,165,2,0,180,5)
	local InnerRing = surface.PrecacheArc(ScrW()/2,ScrH() + 25,105,2,0,180,5)

	-- Draw UI Images --
	surface.SetDrawColor(Color(0, 0, 0, 255))
	surface.SetMaterial(crft_UI_cross)
	surface.DrawTexturedRect(ScrW()/2 - 87.5, ScrH() - 215, 175, 175)

	-- Draw Rings --
	draw.NoTexture()
	surface.SetDrawColor(Color(20, 20, 20, 255))
	draw.Circle( ScrW()/2,ScrH() + 25, 135, 50)

	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawArc(OuterRing)
	
	
	if (plyLvl == 10) then
		surface.SetDrawColor(Color(84, 201, 150, 255))
	else
		surface.SetDrawColor(Color(84, 211, 100, 255))
	end
	surface.DrawArc(InnerRing)

	surface.SetDrawColor(Color(0, 0, 0, 185))
	surface.DrawArc(XPArcBG)

	if (plyLvl == 10) then
		surface.SetDrawColor(Color(84, 201, 150, 255))
	else
		surface.SetDrawColor(Color(84, 211, 100, 255))
	end
	surface.DrawArc(XPArc)
	
	-- Text Draw --

	surface.SetFont("CRFT_StatFont")
	local statTag = "CRAFTING STATS"
	local statTagSize = surface.GetTextSize(statTag)
	draw.SimpleTextOutlined(statTag, "CRFT_StatFont", ScrW()/2  - statTagSize*0.5, ScrH() - 150, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(24, 68, 29, 255))

		-- Level
	surface.SetFont("CRFT_LevelFont")
	local statTag = "Lv. " ..plyLvl
	local statTagSize = surface.GetTextSize(statTag)
	draw.SimpleTextOutlined(statTag, "CRFT_LevelFont", ScrW()/2  - statTagSize*0.5, ScrH() - 75, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, Color(24, 68, 29, 255))

		-- Title
	surface.SetFont("CRFT_RankFont")
	local statTag = CRAFTSMANSHIP_LEVELS[plyLvl][2]
	local statTagSize = surface.GetTextSize(statTag)
	draw.SimpleTextOutlined(statTag, "CRFT_RankFont", ScrW()/2  - statTagSize*0.5, ScrH() - 60, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(24, 68, 29, 255))

		-- XP
	surface.SetFont("CRFT_XPFont")
	local statTag = ply:GetNWInt("crft_experience").." / "..CRAFTSMANSHIP_LEVELS[plyLvl][1]
	if(CRFT_PRESTIGE_ENABLED == false) and (plyLvl >= CRAFTING_MAX_LEVEL) then
		statTag = "MAX"
	end
	local statTagSize = surface.GetTextSize(statTag)
	draw.SimpleTextOutlined(statTag, "CRFT_XPFont", ScrW()/2  - statTagSize*0.5, ScrH() - 30, Color(149, 226, 158, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, Color(24, 68, 29, 255))

end

function SWEP:SecondaryAttack()
end


local storedRankMats = {
[0] = "models/weapons/axe_basic",
[1] = "models/weapons/axe_bronze",
[2] = "models/weapons/axe_iron",
[3] = "models/weapons/axe_diamond",
}

// Update the client's ViewModel when he levels and gets a new axe
net.Receive("craftingUpdateViewModel", function()
	local wep = ply:GetActiveWeapon()
	if(wep:GetClass() == "crft_axe") then
		local plyLvl = ply:GetNWInt("crft_level") +1
		if(plyLvl < 3) then
			wep.StoredRank = 0
		elseif(plyLvl>=3 and plyLvl<6) then
			wep.StoredRank = 1
		elseif(plyLvl>=6 and plyLvl<10) then
			wep.StoredRank = 2
		elseif(plyLvl>=10) then
			wep.StoredRank = 3
		end	
	end
end)

function SWEP:PreDrawViewModel(vm, wep, ply)
	vm:SetSubMaterial(0, storedRankMats[self.StoredRank])
end

function SWEP:PostDrawViewModel(vm, wep, ply)
	vm:SetSubMaterial(0, vm:GetSubMaterial(0))
end


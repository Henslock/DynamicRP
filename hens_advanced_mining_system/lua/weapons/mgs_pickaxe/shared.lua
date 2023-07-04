include("sv_playerinfo.lua")

if CLIENT then
	SWEP.PrintName = "Pickaxe"
	SWEP.Slot = 1
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	
end

sound.Add( {
	name = "tp_charge_sfx",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 70,
	sound = "ambient/levels/labs/teleport_preblast_suckin1.wav"
} )

if SERVER then
	util.AddNetworkString( "pickaxeLargePick" )
	util.AddNetworkString( "pickaxeTPSound" )
end

-- Variables that are used on both client and server

SWEP.Author = ""
SWEP.Instructions = "Left click to mine rocks!"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_mgs_pickaxe.mdl")
SWEP.WorldModel = Model("models/weapons/w_mgs_pickaxe.mdl")
SWEP.HoldType = "melee"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "DarkRP (Utility)"

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = true;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 1;
SWEP.Primary.Delay = 1.0;
SWEP.Primary.Ammo = "";
SWEP.MinSpeed = 0.25;

--[[-------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------]]
function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_HOLSTER);	
end

function SWEP:Deploy()
	if(self:GetOwner().pickaxe == nil) then pickaxe.InitializePlayers(self:GetOwner()) end
	UpdatePick(self:GetOwner())
	
	self:SetHoldType(self.HoldType)
	self:GetOwner():SetNWInt("currlevel", self:GetOwner():GetNWInt("level"))
	self:GetOwner():SetNWBool("a_lvl", false)
	self:GetOwner():SetNWFloat("a_alpha", 0)
	self:GetOwner():SetNWFloat("a_rise", 0)
	self:GetOwner():SetNWFloat("a_size", 0.7)
	
	--TP Perk charge time
	self:GetOwner():SetNWFloat("tp_charge", 0)
	--self:GetOwner():SetNWFloat("tp_cd", 0)
	self:GetOwner():SetNWBool("tp_istping", false)
	
	if(math.random(1,5) == 1) then
		if CLIENT then
			chat.AddText(Color(155, 255, 255), "[Tip]", Color(255, 255, 255), " open your Prestige Menu with the 'N' key.")
		end
	end
	
	local ply = self:GetOwner()
	
	self:SetPos(Vector(0, 0, 0))
	
	if(ply:GetNWBool("perk_agility") == true) then
		UpdateAgility(ply)
	end
	
	--LARGE PICK PERK
	if(self:GetOwner():GetNWBool("perk_largepick") == true) then
		self.WorldModel = Model("models/weapons/w_largepick.mdl")
		if SERVER then
			net.Start("pickaxeLargePick")
				net.WriteEntity(self)
				net.WriteString("models/weapons/w_largepick.mdl")
			net.Broadcast()
		end
		
	else
		self.WorldModel = Model("models/weapons/w_mgs_pickaxe.mdl")
		if SERVER then
			net.Start("pickaxeLargePick")
				net.WriteEntity(self)
				net.WriteString("models/weapons/w_mgs_pickaxe.mdl")
			net.Broadcast()
		end
	end
	
	if(ply:GetNWBool("perk_glow") == true) then
		ParticleEffectAttach("aura_core", 1, ply,  0 )
	end
	
	
end

function ClientUpdatePickModel(self)
	if(self.WorldModel == "models/weapons/w_largepick.mdl") then
		return
	else
		self.WorldModel = Model("models/weapons/w_largepick.mdl")
		ClientUpdatePickModel(self)
	end
end

net.Receive( "pickaxeLargePick", function()
	local wpn = net.ReadEntity()
	local model = net.ReadString()
	wpn.WorldModel = Model(model)

end )

--Hacky fix for the large pickaxe perk
function SWEP:DoDrawCrosshair(x, y)
	if(self:GetOwner():GetNWBool("perk_largepick") == true) then
		ClientUpdatePickModel(self)
	end
end

function UpdateAgility(ply)
	ply:SetRunSpeed(ply:GetRunSpeed()*1.5)
	ply:SetWalkSpeed( ply:GetWalkSpeed() *1.5 )
end

hook.Add("pickaxe_UpdateAgility", "Update Player Agility", UpdateAgility)

function UpdatePick(ply)
--Change pick based on tier
	--COPPER
	wep = ply:GetActiveWeapon()
	local swingboost = 0
	local dmgboost = 0
	
	if(ply:GetNWBool("perk_mspeed") == true) then
		swingboost = -0.10
	end
	
	if(ply:GetNWBool("perk_meleedmg") == true) then
		dmgboost = 25
	end
	
	if(pickaxe.GetPickTier(ply) == "Basic") then
		wep.Primary.Delay = 1.1 + swingboost
		wep.Primary.Damage = 1 + dmgboost
		wep:SetColor(Color(255, 255, 255))
		wep:SetMaterial("materials/models/props_mining/pickaxenew")
		
	elseif(pickaxe.GetPickTier(ply) == "Copper") then
		wep.Primary.Delay = 0.90 + swingboost
		wep.Primary.Damage = 1 + dmgboost
		wep:SetColor(Color(255, 255, 255))
		wep:SetMaterial("models/props_pipes/GutterMetal01a")	
	
	--BRONZE
	elseif(pickaxe.GetPickTier(ply) == "Bronze") then
		wep.Primary.Delay = 0.75 + swingboost
		wep.Primary.Damage = 1 + dmgboost
		wep:SetColor(Color(255, 185, 185))
		wep:SetMaterial("models/props_pipes/GutterMetal01a")	
	
	--IRON
	elseif(pickaxe.GetPickTier(ply) == "Iron") then
		wep.Primary.Delay = 0.75 + swingboost
		wep.Primary.Damage = 1 + dmgboost
		wep:SetColor(Color(255, 255, 255))
		wep:SetMaterial("models/props_canal/canal_bridge_railing_01c")	
	
	--STEEL
	elseif(pickaxe.GetPickTier(ply) == "Steel") then
		wep.Primary.Delay = 0.6 + swingboost
		wep.Primary.Damage = 1 + dmgboost
		wep:SetColor(Color(255, 255, 255))
		wep:SetMaterial("phoenix_storms/Pro_gear_side")	
	
	--OSMIUM
	elseif(pickaxe.GetPickTier(ply) == "Osmium") then
		wep.Primary.Delay = 0.5 + swingboost
		wep.Primary.Damage = 1 + dmgboost
		wep:SetColor(Color(255, 0, 255))
		wep:SetMaterial("models/props_combine/stasisfield_beam")
	
	--DIAMOND
	elseif(pickaxe.GetPickTier(ply) == "Diamond") then
		wep.Primary.Delay = 0.4 + swingboost
		wep.Primary.Damage = 5 + dmgboost
		wep:SetColor(Color(0, 250, 255))
		wep:SetMaterial("models/player/shared/ice_player")	
	
	--ASTRONIUM
	elseif(pickaxe.GetPickTier(ply) == "Astronium") then
		wep.Primary.Delay = 0.3 + swingboost
		wep.Primary.Damage = 15 + dmgboost
		wep:SetColor(Color(255, 255, 255))
		wep:SetMaterial("models/XQM/LightLinesRed_tool")	
	end
end

hook.Add("pickaxe_UpdatePick", "Update Player Pick", UpdatePick)

function SWEP:DoHitEffects()
	local trace = self.Owner:GetEyeTraceNoCursor();
	local hitdist = 94
	
	if(self:GetOwner():GetNWBool("perk_largepick") == true) then
		hitdist = 130
	end
	
	if (((trace.Hit or trace.HitWorld) and self.Owner:GetShootPos():Distance(trace.HitPos) <= hitdist)) then
		self:SendWeaponAnim(ACT_VM_HITCENTER);
		self:EmitSound("weapons/crossbow/hitbod2.wav", 70, math.random(80, 135), 0.8);
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER);
		self:EmitSound("npc/vort/claw_swing2.wav", 70, math.random(90, 110), 0.8);
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
		local hitdist = 94
	
		if(self:GetOwner():GetNWBool("perk_largepick") == true) then
			hitdist = 130
		end
		
		if (self.Owner:GetShootPos():Distance(trace.HitPos) <= hitdist) then
			if (IsValid(trace.Entity)) then
				local dmg = self.Primary.Damage
				if(trace.Entity:IsPlayer()) then
					dmg = dmg/2
				end
				
				self.Owner:FireBullets({
					Spread = Vector(0, 0, 0),
					Damage = dmg,
					Tracer = 0,
					Force = 1,
					Num = 1,
					Distance = 100,
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

	local ply = self:GetOwner()
	ply:StopParticles()
	ply:SetWalkSpeed( 200 )
	ply:SetRunSpeed( 400 )
	return true
end

function SWEP:Think()

	--Teleport CD
	if(self.Owner:KeyDown(IN_ATTACK2)) then
		
		if(self:GetOwner():GetNWFloat("tp_cd") < CurTime()) then
			if(self:GetOwner():GetNWFloat("tp_charge") < CurTime() && self:GetOwner():GetNWBool("tp_istping") == true ) then
			
				--SUCCESSFUL CHANNEL
				ParticleEffectAttach("tp_base", 0, self:GetOwner(),  0 )
				
				self.Owner:EmitSound("ambient/machines/teleport4.wav", 100, 200, 0.75);
				
				self:GetOwner():SetNWBool("tp_istping", false)
				self:GetOwner():SetNWFloat("tp_cd", (CurTime() + PERK_TP_COOLDOWN))
				self:GetOwner():SetNWFloat("tp_charge", 0)
				timer.Simple(0.1, function()
				self.Owner:SetPos(PERK_TP_POS)
				end)
			end
		end
		
	else
		self:GetOwner():SetNWFloat("tp_charge", 0)
		self:GetOwner():SetNWBool("tp_istping", false)
		self:GetOwner():StopSound("tp_charge_sfx")

		if((self:GetOwner():GetNWFloat("tp_cd") - CurTime())<= 0) then
			self:GetOwner():SetNWFloat("tp_cd", 0)
		end
	end
	
	---
	

	if(self:GetOwner():GetNWInt("level") ~= self:GetOwner():GetNWInt("currlevel") and self:GetOwner():GetNWInt("level") ~= nil) then
		self:GetOwner():SetNWFloat("a_alpha", 255)
		self:GetOwner():SetNWFloat("a_size", 0.7)
		self:GetOwner():SetNWFloat("a_rise", 0)
		self:GetOwner():SetNWBool("a_lvl", true)
		self:GetOwner():SetNWInt("currlevel", self:GetOwner():GetNWInt("level"))
	end


	if(self:GetOwner():GetNWBool("a_lvl") == true ) then
	
		if(self:GetOwner():GetNWFloat("a_alpha")  >= 0) then
			self:GetOwner():SetNWFloat("a_alpha", (self:GetOwner():GetNWFloat("a_alpha") - 1))
		else
			self:GetOwner():SetNWBool("a_lvl", false)
		end
		
		if(self:GetOwner():GetNWFloat("a_size")  >= 0.4) then
			self:GetOwner():SetNWFloat("a_size", (self:GetOwner():GetNWFloat("a_size") - 0.0005))
		end
		
		if(self:GetOwner():GetNWFloat("a_rise")  <= 50) then
			self:GetOwner():SetNWFloat("a_rise", (self:GetOwner():GetNWFloat("a_rise") + 0.1))
		end
		
	end
end

SWEP.RenderGroup = RENDERGROUP_BOTH

function SWEP:DrawWorldModelTranslucent()
	self:DrawModel()
	self:SetRenderMode(RENDERMODE_NORMAL)
	local Pos = self:GetPos()
	local Eye1 = EyeAngles() 
	local PosOffset = Vector(0, 0, 0)
	local Ang = Angle(0, Eye1.y, 0)

	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 180)
	
	surface.SetFont("Trebuchet24")
	local lvlUptxt = "LEVEL "..self:GetOwner():GetNWInt("currlevel")
	local TextWidth = surface.GetTextSize(lvlUptxt)
	
	cam.Start3D2D(Pos+Vector(0,0, self:GetOwner():GetNWFloat("a_rise"))+Ang:Up()+Ang:Right()*-50, Ang, self:GetOwner():GetNWInt("a_size"))
		draw.SimpleTextOutlined( lvlUptxt, "Trebuchet24", -TextWidth*0.5, -30, Color(255, 225, 0, self:GetOwner():GetNWFloat("a_alpha")), 0, 0, 1, Color(222,117,31, self:GetOwner():GetNWFloat("a_alpha")) )
	cam.End3D2D()
	
	--Teleport Bar
	local width = 300
	local tpText = "Teleporting..."
	local tpTextWidth = surface.GetTextSize(tpText)
	local barAnim = 1 - ((self:GetOwner():GetNWFloat("tp_charge") - CurTime()) / PERK_TP_CHARGETIME)
	if(barAnim >= 1) then
		barAnim = 0
	end
	
	if( self:GetOwner():GetNWBool("tp_istping") == true) then
		cam.Start3D2D(Pos+Ang:Up()+Ang:Right()*-50, Ang, 0.13)
			draw.SimpleTextOutlined( "Teleporting...", "Trebuchet24", -(tpTextWidth*0.5), 10, Color(255, 255, 255, 255), 0, 0, 1, Color(0, 0, 0, 125) )
			draw.RoundedBox( 2, -(width/2) , 47, width, 12, Color(0,0,0, 125))
			draw.RoundedBox( 2, -(width/2) , 50, width*barAnim, 4, Color(125,210,190, 255))
		cam.End3D2D()
	end
	
	--End teleport bar

end

// *********** //
// DRAW CALLS
// *********** //

function FetchPickColor(str)
	if (str == "Basic") then
		return Color(255, 255, 255)
	elseif (str == "Copper") then
		return Color(193, 157, 124)
	elseif (str == "Bronze") then
		return Color(219, 156, 114)
	elseif (str == "Iron") then
		return Color(186, 186, 186)
	elseif (str == "Steel") then
		return Color(159, 175, 204)
	elseif (str == "Osmium") then
		return Color(206, 130, 216)
	elseif (str == "Diamond") then
		return Color(136, 224, 224)
	elseif (str == "Astronium") then
		return Color(255, 117, 53)
	else
		return Color(125, 125, 125)
	end
end

local xpBar = 0

function SWEP:DrawHUD()
	local plr = self:GetOwner()
	
	-- General Info
	draw.RoundedBox( 10, 500, ScrH() - 110, 250, 100, Color(0, 0, 0, 150) )
	draw.SimpleTextOutlined("Mining Stats", "statFont", 515, ScrH() - 135, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	draw.SimpleTextOutlined("Lv. "..plr:GetNWInt("level"), "xpFont", 515, ScrH() - 105, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	--
	
	--XP BAR
	local barWid = 225
	local inset = 5
	local prog = (plr:GetNWInt("experience") / LEVELING_TABLE[plr:GetNWInt("level")][1])
	
	if(plr:GetNWInt("level") == 35) then
		prog = 1
	end
	
	xpBar = Lerp(FrameTime()*4, xpBar, prog*barWid - (inset*2))
	draw.RoundedBox( 4, 510, ScrH() - 85, barWid, 30, Color(20, 50, 50, 150) )
	draw.RoundedBox( 4, 510 + inset, ScrH() - 80, xpBar, 20, Color(80, 255, 130, 180) )
	
		--Fetch text
	surface.SetFont("xpFont")
	local xptxt = ""
	if(plr:GetNWInt("level") ~= 35) then
		xptxt = plr:GetNWInt("experience").." / "..LEVELING_TABLE[plr:GetNWInt("level")][1]
	else
		xptxt = "MAX"
	end
	local textWidth = surface.GetTextSize(xptxt)
		--Color / Display text
	if(plr:GetNWInt("level") ~= 35) then
		draw.SimpleTextOutlined(xptxt, "xpFont", ((510*2 + barWid)/2) - textWidth*0.5, ScrH() - 80, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 180))
	else
		draw.SimpleTextOutlined(xptxt, "xpFont", ((510*2 + barWid)/2) - textWidth*0.5, ScrH() - 80, HSVToColor(RealTime() * 100 % 360, 0.5, 1), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 180))
	end
	--
	
	--Pickaxe Details
	local picktype_str = LEVELING_TABLE[plr:GetNWInt("level")][2]
	draw.SimpleTextOutlined(picktype_str.. " Pickaxe", "Trebuchet24", 515, ScrH() - 55, FetchPickColor(picktype_str), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	
	if(plr:GetNWInt("level") >= 0 and plr:GetNWInt("level") < 15) then
		draw.SimpleTextOutlined("Mines Lv. 1 ~ 3", "Trebuchet18", 515, ScrH() - 30, Color(255,252,224,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	elseif(plr:GetNWInt("level") >= 15 and plr:GetNWInt("level") < 25) then
		draw.SimpleTextOutlined("Mines Lv. 4 ~ 6", "Trebuchet18", 515, ScrH() - 30, Color(185, 255, 158, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	elseif(plr:GetNWInt("level") >= 25 and plr:GetNWInt("level") < 30) then
		draw.SimpleTextOutlined("Mines Lv. 7 ~ 9", "Trebuchet18", 515, ScrH() - 30, Color(200, 136, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	elseif(plr:GetNWInt("level") >= 30 and plr:GetNWInt("level") < 35) then
		draw.SimpleTextOutlined("Mines Lv. 10 ~ 15", "Trebuchet18", 515, ScrH() - 30, Color(243, 153, 47, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	elseif(plr:GetNWInt("level") == 35) then
		draw.SimpleTextOutlined("Mines Everything!", "Trebuchet18", 515, ScrH() - 30, Color(255, 53, 181), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	end
	
end

function SWEP:SecondaryAttack()
	local plr = self:GetOwner()
	
	if(plr:GetNWBool("perk_tp") == true) then
		if(plr:isWanted()) then return end
		if(plr:GetNWFloat("tp_cd") == 0) then --If the CD is off
			
			plr:SetNWBool("tp_istping", true)
			
			plr:EmitSound("npc/scanner/scanner_scan4.wav", 100, 100, 1);
			
			plr:SetNWFloat("tp_charge", CurTime() + PERK_TP_CHARGETIME)
			
		else
		
			local result = math.ceil(self:GetOwner():GetNWFloat("tp_cd") - CurTime())
			plr:PrintMessage(HUD_PRINTCENTER, "Cooldown: ".. result .." seconds")
			
		end
	end
end

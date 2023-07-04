AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "Diamond Sword";
	SWEP.Slot = 2;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	
	killicon.Add( "st_diamondsword", "HUD/killicons/mcsword_ki", Color(237, 124, 49, 255 ) )
end

SWEP.Instructions = "Kills creeps and creepers.";
SWEP.Author = "Hens"
SWEP.Category = "[Hens] Silly Toys"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/sillytoys/v_mcSword.mdl";
SWEP.WorldModel = "models/sillytoys/w_mcSword.mdl";
SWEP.ViewModelFOV = 58
SWEP.HoldType = "melee2"
SWEP.UseHands = false
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = true;
SWEP.Primary.Delay = 0.5

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
end

function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_HOLSTER);
end

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID("vgui/sillytoys/selection/mcsword_ico")
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		x = x + wide / 2
		y = y + tall / 2

		tall = tall * 0.65

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

function SWEP:DoHitEffects()
	local hitdist = 80
	
	local tracehull = util.TraceHull( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * hitdist ),
		filter = self.Owner,
		mins = Vector( -10, -10, -2 ),
		maxs = Vector( 10, 10, 5 ),
		mask = MASK_SHOT_HULL
	} )
	
	if (((tracehull.Hit or tracehull.HitWorld) and self.Owner:GetShootPos():Distance(tracehull.HitPos) <= hitdist)) then
		self:SendWeaponAnim(ACT_VM_HITCENTER);
		if(tracehull.Entity:IsPlayer()) then
			self:EmitSound("st_mc_hitsfx");
		else
			self:EmitSound("weapons/crossbow/hitbod2.wav", 70, math.random(120, 140), 0.4);
		end
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER);
		self:EmitSound("npc/vort/claw_swing2.wav", 70, math.random(120, 140), 0.4);
	end;
end;

function SWEP:DoAnimations(idle)
	if (!idle) then
		self.Owner:SetAnimation(PLAYER_ATTACK1);
	end;
end;

function SWEP:PrimaryAttack()
	self:DoAnimations();
	self:DoHitEffects();
	
	if(self.Weapon:GetNextPrimaryFire() <= CurTime() ) then
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		
		if (SERVER) then
			if (self.Owner.LagCompensation) then
				self.Owner:LagCompensation(true);
			end;
			local hitdist = 80
			
			local tracehull = util.TraceHull( {
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * hitdist ),
				filter = self.Owner,
				mins = Vector( -10, -10, -2 ),
				maxs = Vector( 10, 10, 5 ),
				mask = MASK_SHOT_HULL
			} )
			
			if (IsValid(tracehull.Entity)) then
				local tar = tracehull.Entity
				local dmg = math.random(16,26)
				if(tar:IsPlayer()) then
					if(tar:GetActiveWeapon():GetClass() == "st_diamondsword") then
						dmg = math.random(12,20)
						local vec = self.Owner:GetAimVector():GetNormalized()
						tar:SetVelocity(Vector(0,0,200) + (Vector(vec.x, vec.y, 0.2)*200))
						tar:TakeDamage(dmg, self.Owner, self)
					else
						dmg = 0
					end
				else
					tar:TakeDamage(dmg, self.Owner, self)
				end

			end;
			
			if (self.Owner.LagCompensation) then
				self.Owner:LagCompensation(false);
			end;
		end;
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

hook.Add("GetFallDamage", "ST_MC_oof", function(ply, _)
	if(ply:GetActiveWeapon() == NULL) then return end
	local wep = (ply:GetActiveWeapon():GetClass())
	if(wep ~= "st_diamondsword") then return end
	
	ply:EmitSound("st_mc_oof")
end)
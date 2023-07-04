
// This is the original HL2 Beta Flamethrower, repurposed for crafting!

local sndAttackLoop = Sound("fire_large")
local sndSprayLoop = Sound("ambient.steam01")
local sndAttackStop = Sound("ambient/_period.wav")

if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

end

if ( CLIENT ) then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 58
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	
	SWEP.Category 		= "[Hens] Crafting"
	SWEP.PrintName			= "Crafting Flamethrower"		
	SWEP.Instructions = "Burns down trees into a crisp"	
	SWEP.Author				= "Valve"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 2

	--SWEP.WepSelectIcon = surface.GetTextureID("HUD/swepicons/weapon_immolator") 

end
SWEP.HoldType			= "physgun"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "Models/weapons/v_cremato2.mdl"
SWEP.WorldModel			= "Models/weapons/w_immolator.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.02
SWEP.Primary.BurnDelay	= 0.5

game.AddAmmoType( { name = "crft_flame" } )
if ( CLIENT ) then language.Add( "crft_flame_ammo", "Petroleum Gas" ) end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 1000
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "crft_flame"


local targetTrees = {
["crft_birch"] = true,
["crft_oak"] = true,
["crft_maple"] = true,
}

function SWEP:Initialize()

	self:SetWeaponHoldType(self.HoldType)
	self.EmittingSound = false

end

function SWEP:Reload()
end

function SWEP:Think()
	if self.Owner:KeyReleased(IN_ATTACK) or self.Owner:KeyReleased(IN_ATTACK2) then
		self:StopSounds()
	end

end

function SWEP:PrimaryAttack()
	if ( self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		local curtime = CurTime()
		local InRange = false
		
		self.Weapon:SetNextPrimaryFire( curtime + self.Primary.Delay )
		
		if self.Owner:WaterLevel() > 1 then 
		self:StopSounds() 
		return end
		
		if not self.EmittingSound then
			self.Weapon:EmitSound(sndAttackLoop)
			self.EmittingSound = true
		end
		
		self.Owner:MuzzleFlash()
		self:TakePrimaryAmmo(1)
		
		local PlayerVel = self.Owner:GetVelocity()
		local PlayerPos = self.Owner:GetShootPos()
		local PlayerAng = self.Owner:GetAimVector()
		
		local trace = {}
		trace.start = PlayerPos
		trace.endpos = PlayerPos + (PlayerAng*2048)
		trace.filter = self.Owner
		
		local traceRes = util.TraceLine(trace)
		local hitpos = traceRes.HitPos
		
		local jetlength = (hitpos - PlayerPos):Length()
		if jetlength > 568 then jetlength = 568 end
		if jetlength < 6 then jetlength = 6 end
		
		if SERVER then
			if (self.Owner.LagCompensation) then
				self.Owner:LagCompensation(true)
			end
			if(self.Weapon.CanBurn == nil) then self.Weapon.CanBurn = true end
			if(self.Weapon.CanBurn == false) then
				if(self.Weapon.BurnCD == nil) then self.Weapon.BurnCD = curtime end
				if curtime >= self.Weapon.BurnCD then
					self.Weapon.CanBurn = true
				end
			end
			local hitdist = 400
			
			local tracehull = util.TraceHull( {
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * hitdist ),
				filter = self.Owner,
				collisiongroup = COLLISION_GROUP_WEAPON,
				mins = Vector( -10, -10, -2 ),
				maxs = Vector( 10, 10, 5 ),
				mask = MASK_SHOT_HULL
			} )

			if (IsValid(tracehull.Entity)) then
				local tar = tracehull.Entity
				if(targetTrees[tar:GetClass()]) then
					if(self.Weapon.CanBurn) then
						local hp = tar:GetTreeHealth()
						local ignhp = tar:GetIgniteDamage()
						tar:SetTreeHealth(hp - 0.5)
						tar:SetIgniteDamage(ignhp + math.random(1,3))
						self.Weapon.CanBurn = false
						self.Weapon.BurnCD = curtime + self.Primary.BurnDelay
					end
				end
			end;
			
			if (self.Owner.LagCompensation) then
				self.Owner:LagCompensation(false)
			end
		end

		if self.Owner:Alive() then
			local effectdata = EffectData()
			effectdata:SetEntity( self.Weapon )
			effectdata:SetStart( PlayerPos )
			effectdata:SetNormal( PlayerAng )
			effectdata:SetScale( jetlength )
			effectdata:SetAttachment( 1 )
			util.Effect( "bp_flamepuffs", effectdata )
		end
	else
		self:StopSounds()
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:DrawHUD()
	local ammo = self:Ammo1()
	local ammoratio = math.Clamp(ammo / self.Primary.DefaultClip, 0, 1)
	
	draw.RoundedBox(0, (ScrW()/2) - 150, ScrH()*0.85, 300, 31, Color(0,0,0,125))
	draw.RoundedBox(0, ((ScrW()/2) - 150) +2, ScrH()*0.85 + 2, 296 * ammoratio, 27, Color(244, 110, 66,255))
	draw.SimpleTextOutlined("FUEL", "CRFT_RankFont", ScrW()/2, ScrH()*0.85 - 30, Color(255,255,255), 1, 0, 1, Color(0,0,0))
	
	if(ammo > self.Primary.DefaultClip) then
		draw.SimpleTextOutlined(ammo .. " (+ " .. ammo- self.Primary.DefaultClip .. ")", "CT_StatFont", ScrW()/2, ScrH()*0.85, Color(255,255,255), 1, 0, 1, Color(0,0,0))
	else
		draw.SimpleTextOutlined(ammo, "CT_StatFont", ScrW()/2, ScrH()*0.85, Color(255,255,255), 1, 0, 1, Color(0,0,0))
	end
end

function SWEP:StopSounds()
	if self.EmittingSound then
		self.Weapon:StopSound(sndAttackLoop)
		self.Weapon:StopSound(sndSprayLoop)
		self.Weapon:EmitSound(sndAttackStop)
		self.EmittingSound = false
	end	
end


function SWEP:Holster()
	self:StopSounds()
	return true
end

function SWEP:OnRemove()
	self:StopSounds()
	return true
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW);
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration())
	return true
end
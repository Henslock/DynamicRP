
// Silly's Bat modified by Hens

SWEP.HoldType = "melee2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.ShowViewModel = true
SWEP.UseHands = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -26.994, 0) },
	["v_weapon.Knife_Handle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 3.403), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(8.178, 4.046, 6.994), angle = Angle(-46.744, -28.446, 76.347) },
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.047, 12.956, 4.587) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -23.066, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-4.153, -5.849, -3.435), angle = Angle(33.363, 1.567, 1.123) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(16.929, 23.065, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -14.051, 0) }
}
SWEP.VElements = {
	["bat"] = { type = "Model", model = "models/weapons/melee/w_bat.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(0, 0, -1.351), angle = Angle(0, 0, 0), size = Vector(0.819, 0.819, 0.819), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["bat"] = { type = "Model", model = "models/weapons/melee/w_bat.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.281, 1.312, 8.831), angle = Angle(-167.043, 2.161, -3.87), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.Purpose = "Beat things to a pulp."
SWEP.AutoSwitchTo = true
SWEP.Contact = ""
SWEP.Author = "Hens"		// Original Author - Silly
SWEP.FiresUnderwater = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.Instructions = ""
SWEP.AutoSwitchFrom = false
SWEP.base = "weapon_base"
SWEP.Category = "[Hens] Crafting"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.PrintName = "Bat"

SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage				= 0
SWEP.Primary.NumShots			= 0
SWEP.Primary.Cone				= 0	
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic   		= true
SWEP.Primary.Ammo         		= "none"
SWEP.Primary.Delay				= 0.65

SWEP.chargeSound = nil

function SWEP:SetupDataTables()
	self:NetworkVar("Bool",1,"Charged")
	self:NetworkVar("Float",1,"Focus")
end

function SWEP:PrimaryAttack()
	if(self.Owner:KeyDown(IN_ATTACK2)) then return end
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	
	if (self.Owner.LagCompensation) then
		self.Owner:LagCompensation(true);
	end;
	
	local trace = self.Owner:GetEyeTrace()
	
	local dmg = math.random(19, 24)
	if(self:GetCharged() == true) then
		dmg = math.random(74, 96)
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 2.5)
		if CLIENT then
			util.ScreenShake(self.Owner:GetPos(), 10, 10, 0.75, 100)
		end
	else
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
	
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 105 then
		bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 2
		bullet.Damage = dmg
		
		self.Owner:FireBullets(bullet)
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		
		if(self:GetCharged() == true) then
			self.Weapon:EmitSound("physics/body/body_medium_impact_hard6.wav", 90, math.random(80, 90), 1, CHAN_SWEP)
			if(IsValid(trace.Entity) and (trace.Entity:IsNPC() or trace.Entity:IsPlayer()) ) then
				
				local ent = trace.Entity
				
				ent:EmitSound("physics/flesh/flesh_squishy_impact_hard" .. math.random(1,4) ..".wav", 80, math.random(70, 80), 1, CHAN_AUTO)
				
				local gibfx = EffectData()
				gibfx:SetOrigin(ent:GetPos() + Vector(0,0,5))
				gibfx:SetEntity(ent)
				gibfx:SetScale(5)
				util.Effect("StriderBlood", gibfx)
			end
		
		end
	else
		if(self:GetCharged()) then
			self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 90, math.random(30, 40), 1, CHAN_SWEP)
		else
			self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 90, math.random(70, 80), 1, CHAN_SWEP)
		end
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	
	if (self.Owner.LagCompensation) then
		self.Owner:LagCompensation(false);
	end;
	
	self:SetCharged(false)
	local wep = self
	timer.Simple(0.5, function()
		if(!IsValid(wep) or !IsValid(wep.Owner)) then return end
		if(!wep.Owner:Alive()) then return end
		self:SetHoldType("melee")
	end)
end


function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
	self:SetFocus(0)
	self:SetCharged(false)
	self.chargeSound = CreateSound(self.Weapon,	"ambient/levels/citadel/field_loop2.wav")
	self:SetHoldType("melee")
	return true
end 

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()

	if(self.Owner:KeyDown(IN_ATTACK2) and self:GetNextPrimaryFire() <= CurTime()) then
		if(self:GetCharged() == false) then
			self:SetFocus(math.Clamp(self:GetFocus() + 1.5, 0, 100))
			if(self:GetFocus() >= 100) then
				self:SetCharged(true)
				self:SetHoldType("melee2")
				self.chargeSound:Stop()
				self.Weapon:EmitSound("physics/wood/wood_box_footstep2.wav", 90, math.random(130, 150), 0.4, CHAN_SWEP)
			end
		end
		
		if CLIENT then
			if(self.chargeSound ~= nil) and (self:GetCharged() == false) then
				self.chargeSound:Play()
				self.chargeSound:ChangePitch(5 + ((self:GetFocus() / 100) * 50))
				self.chargeSound:ChangeVolume(self:GetFocus() / 100)
			end
		end
		
	else
		self.chargeSound:Stop()
		if(self:GetCharged() == false) then
			local decrement = (self:GetFocus() / 100) * 6
			self:SetFocus(math.Clamp(self:GetFocus() - decrement, 0, 100))
		end
	end
	
end

function SWEP:Initialize()
	self:SetFocus(0)
	self:SetCharged(false)
	self:SetHoldType("melee")
	
	self.chargeSound = CreateSound(self.Weapon, "ambient/wind/wind_moan1.wav")
	
	if CLIENT then

		self:SetWeaponHoldType( self.HoldType )	
		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end
		end
		
	end
end

function SWEP:Holster()
	self:SetFocus(0)
	self:SetCharged(false)
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

function SWEP:DrawHUD()

	local x = ScrW() / 2.0
	local y = ScrH() / 2.0
	
	local scaleMod = 1
	if(self:GetFocus() ~= nil) then
		scaleMod = 1 - (self:GetFocus() / 100)
	end
	
	surface.SetDrawColor( 255, 255, 255, 255 )

	surface.DrawCircle(x, y, 40 * scaleMod + 4, 255, 255 * scaleMod, 255 * scaleMod, 5)
	surface.DrawCircle(x, y, 39 * scaleMod + 4, 255, 255 * scaleMod, 255 * scaleMod, 5)
	
	if(self:GetCharged()) == true then
		surface.DrawCircle(x, y, 5, 255, 0, 0, 25)
	end
end

SWEP.Primary.Cone = 0.2


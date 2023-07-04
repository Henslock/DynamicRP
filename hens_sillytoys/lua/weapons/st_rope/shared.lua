AddCSLuaFile()

if CLIENT then

	SWEP.PrintName = "Noose";
	SWEP.Slot = 3;
	SWEP.SlotPos = 2;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	
end

SWEP.Instructions = "Guess i'll die.";
SWEP.Author = "Hens"
SWEP.Category = "[Hens] Silly Toys"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "";
SWEP.WorldModel = "";
SWEP.ViewModelFOV = 75
SWEP.UseHands = false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.RespawnTimer = 8
SWEP.Primary.Delay = 2.5

function SWEP:Deploy()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:Initialize()
	self:SetHoldType("normal")
end

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID("vgui/sillytoys/selection/rope_ico")
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

if SERVER then
	
	local function CreateRagdoll(ply)
		local mdl = ply:GetModel()
		local rag = ents.Create("prop_ragdoll")
		rag:SetPos(ply:GetPos())
		rag:SetModel(mdl)
		rag:SetAngles(ply:GetAngles())
		rag:SetSkin(ply:GetSkin())
		rag:SetColor(ply:GetColor())
		rag:Spawn()
		rag:Activate()
		rag:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		rag.PhysgunPickup = false
		rag.CanTool = false
		rag.MaxPenetration = ply:GetMaxHealth()

		local phys = rag:GetPhysicsObject()
		if not IsValid(phys) then SafeRemoveEntity(rag) return end

		local name = "ST_noose_" .. rag:EntIndex()
		hook.Add("PhysgunPickup", name, function(ply, ent)
			if not IsValid(rag) then hook.Remove("PhysgunPickup", name) return end
			if ent == rag then return false end
		end)

		hook.Add("CanTool", name, function(ply, tr, tool)
			if not IsValid(rag) then hook.Remove("CanTool", name) return end
			if IsValid(tr.Entity) and tr.Entity == rag then return false end
		end)

		return rag, phys
	end
		

	function SWEP:PrimaryAttack()
		
		if ! (self.Weapon:GetNextPrimaryFire() <= CurTime() ) then return end
		
		local ply = self.Owner
		if(!IsValid(ply)) then return end
		// Create our ragdoll from player
		local rag, ragphys = CreateRagdoll(ply)
		if not rag then return end
		rag:SetPos(rag:GetPos() + Vector(0,0,100))
		
		//Create a floating anchor point
		local anchor = ents.Create("prop_physics")
		anchor:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		anchor:SetPos(ply:GetPos() + Vector(0,0,150))
		anchor:SetNoDraw(true)
		anchor:Spawn()
		
		local aphys = anchor:GetPhysicsObject()
		aphys:Wake()
		aphys:EnableMotion(false)
		
		//Create rope
		local const, rop = constraint.Rope(rag, anchor, 10, 0, Vector(0,0,0), Vector(0,0,0), 50, 0, 0, 2,"cable/rope", true)
		
		
		if ply:InVehicle() then ply:ExitVehicle() end
		
		local weps = { }
		for k, v in pairs(ply:GetWeapons()) do 
			table.insert(weps, v:GetClass()) 
		end

		ply:SetParent(rag)
		ply:SetNWEntity("ST_RopeRagdoll", rag)
		ply:Spectate(OBS_MODE_CHASE)
		ply:SpectateEntity(rag)
		ply:DrawViewModel(false)
		ply:SetNoDraw(true)
		ply:StripWeapons()
		
		local hp = ply:Health()
		local armor = ply:Armor()
		local eyes = ply:EyeAngles()
		
		local ST_DH = "ST_DH_"..rag:EntIndex()
		local ST_SUICIDE = "ST_SUICIDE_"..rag:EntIndex()
		local ST_ragTimer = "ST_Respawn_"..rag:EntIndex()
		
		local function endRagdoll()
			timer.Remove(ST_ragTimer)
			hook.Remove("DoPlayerDeath", ST_DH)
			hook.Remove("CanPlayerSuicide", ST_SUICIDE)
			
			local pos = 0
			
			if IsValid(rag) then 
				pos = rag:GetPos()
				rag:Remove()
			end
			
			if IsValid(ply) then
				ply:SetParent()
				ply:UnSpectate()
				ply:Spawn()

				ply:SetHealth(hp)
				ply:SetArmor(armor)
				ply:DrawViewModel(true)
				ply:SetNoDraw(false)
				ply:SetEyeAngles(eyes)

				for k, v in pairs(weps) do 
					ply:Give(v) 
				end
			end
			
			ply:SetPos(pos + Vector(0,0,-48)) 
			rag = nil

		end
		
		//Hooks to end the ragdollize
		hook.Add("DoPlayerDeath", ST_DH, function(victim)
			if not IsValid(rag) then 
				hook.Remove("DoPlayerDeath", ST_DH) 
				return 
			end
			if victim == ply then endRagdoll() end
		end)


		hook.Add("CanPlayerSuicide", ST_SUICIDE, function(victim)
			if not IsValid(rag) then 
				hook.Remove("CanPlayerSuicide", ST_SUICIDE) 
				return 
			end
			if victim == ply then return false end
		end)
		
		ply:EmitSound("st_oof")
		
		timer.Create(ST_ragTimer, self.RespawnTimer, 1, endRagdoll)

		timer.Simple(self.RespawnTimer, function()
			if(!IsValid(anchor)) or (anchor == NULL) then return end
			anchor:Remove()
		end)

		return false
	end
	
end

	function SWEP:SecondaryAttack()
		return false
	end



function SWEP:Reload()
end

function SWEP:DrawHUD()
end


function SWEP:Think()
end

function SWEP:DrawWorldModel()
	self:DrawModel()
end
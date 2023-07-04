AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
util.AddNetworkString("sendNotification")

local LOG_TYPE = "mat_oakwood"

function ENT:Initialize()
	self:SetModel(table.Random(TREE_MODELS.OAK))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	if(CRFT_HOLIDAYTREES) then 
	self:SetSubMaterial(1, "crafting/oaktreeMat_frosted")
	self:SetSubMaterial(0, "crafting/oakleafMatFrosted")
	else
	self:SetSubMaterial(0, table.Random({"crafting/oakleafMat", "crafting/oakleafMatBrightGreen", "crafting/oakleafMatYellow"}))
	end
	
	local phys = self:GetPhysicsObject()
	self.Replace = false
	phys:Wake()
	self:SetTreeHealth(SWM_TREE_HEALTH)
	self:SetIgniteDamage(0)
	self:SetNWInt("distance", SWM_DISTANCE);
end

function ENT:CreateLog()
	self:EmitSound(table.Random(TREE_WOODSPAWN_SFX), 90, math.random(80, 110), 1, CHAN_AUTO)
	local crft_log = ents.Create('crft_log')
	crft_log:SetNWString("LogType", LOG_TYPE)
	crft_log:SetPos(self:GetPos()+Vector(math.random(-20, 20),math.random(-20, 20),60))
	crft_log:Spawn()
end

function ENT:Think()
	local ign_timername = "CRFT_Oak_Ign_".. self:EntIndex()
		
	if (!self.Replace) and (self:GetTreeHealth() <= 0)  then
		self.Replace = true
		timer.Remove(ign_timername)
		self.ReplaceTime = CurTime() + SWM_TREE_REPLACE_TIMER
		self:SetMaterial("Models/effects/vol_light001");
		self:SetCollisionGroup(10)
		self.Pos = self:GetPos()
		for i=1,math.random(3,5) do
			self:CreateLog()
		end
		
		if(self:GetIsIgnited() == true) then
			if(math.random(1,3) == 1) then	// 33.3% chance of getting an ember core when you burn a tree
				local crft_emb = ents.Create('crft_embercore')
				crft_emb:SetPos(self:GetPos()+Vector(math.random(-20, 20),math.random(-20, 20),60))
				crft_emb:Spawn()
			end
		end
		
		self:SetPos(self.Pos + Vector(0,0,-1000))
	end;
	
	// Tree Ignited
	local tree = self
	if (!self.Replace) and (self:GetIgniteDamage()>=10) then
		if(!timer.Exists(ign_timername)) then
			self:SetSubMaterial(1, "crafting/oaktreeMat_burnt")
			self:SetSubMaterial(0, "crafting/oakleafMatBurnt")
			self:SetIsIgnited(true)
			self:EmitSound("ambient/fire/ignite.wav", 65, math.random(70,85), 1, CHAN_STATIC)
			timer.Create(ign_timername, 0.25, 0, function()
				if(!IsValid(tree) or tree == nill) then 
					timer.Remove(ign_timername)
					return
				end
				tree:SetTreeHealth(tree:GetTreeHealth() - 1)
			end)
		end
	end
	
	if (self.Replace) and (self.ReplaceTime < CurTime()) then
		self:SetTreeHealth( SWM_TREE_HEALTH)
		self:SetIgniteDamage(0)
		self:SetIsIgnited(false)
		
		if(CRFT_HOLIDAYTREES) then 
			self:SetSubMaterial(1, "crafting/oaktreeMat_frosted")
			self:SetSubMaterial(0, "crafting/oakleafMatFrosted")
		else
			self:SetSubMaterial(0, table.Random({"crafting/oakleafMat", "crafting/oakleafMatBrightGreen", "crafting/oakleafMatYellow"}))
		end
		self.Replace = false
		self:SetMaterial();
		self:SetCollisionGroup(0)
		self:SetPos(self.Pos)
	end
end

function ENT:OnTakeDamage(dmg)
	if(dmg:GetInflictor():IsPlayer()) then
		if (dmg:GetInflictor():GetClass() == "crft_axe") or (dmg:GetAttacker():GetActiveWeapon():GetClass() == "crft_axe") then
			self:SetTreeHealth( self:GetTreeHealth() - 1) 
			
			--Chance of log
			local ply = dmg:GetInflictor()
			local gainChance = (CRAFTSMANSHIP_LEVELS[ply:GetNWInt("crft_level")][3] / 100)
			local roll = math.Rand(0, 1)
			if(roll <= gainChance) then
				self:CreateLog()
				if(CRFT_PRESTIGE_ENABLED == false) and (ply.crafting.level >= CRAFTING_MAX_LEVEL) then
				else
					crafting.GiveXP(ply, 1)
					net.Start("sendNotification")
						net.WriteString("+1 XP")
						net.WriteInt(1, 2)
					net.Send(ply)
				end
			end

			--Chance of Ancient Sap
			roll = math.Rand(0, 1)
			gainChance = (CRAFTSMANSHIP_LEVELS[ply:GetNWInt("crft_level")][4] / 100)
			if(roll <= gainChance) then
				local sap = ents.Create("crft_ancientsap")
				sap:SetPos(self:GetPos()+Vector(math.random(-20, 20),math.random(-20, 20),60))
				sap:Spawn()
				
				if(CRFT_PRESTIGE_ENABLED == false) and (ply.crafting.level >= CRAFTING_MAX_LEVEL) then
				else
					crafting.GiveXP(ply, 3)
					net.Start("sendNotification")
						net.WriteString("+3 XP")
						net.WriteInt(1, 2)
					net.Send(ply)
				end
			end	
			
			if(self:GetTreeHealth()<=0) then
				for i=1,5 do
					if(CRFT_PRESTIGE_ENABLED == false) and (ply.crafting.level >= CRAFTING_MAX_LEVEL) then
					else
						crafting.GiveXP(ply, 1)
						net.Start("sendNotification")
							net.WriteString("+1 XP")
							net.WriteInt(1, 2)
						net.Send(ply)
					end
				end
			end

			if(self:GetTreeHealth() <= 0) then
				local roll = math.Rand(0, 1)
				if(roll <= 0.25) then
				
					local treecore = ents.Create("crft_treecore")
					treecore:SetPos(self:GetPos()+Vector(math.random(-20, 20),math.random(-20, 20),60))
					treecore:Spawn()
				
					if(CRFT_PRESTIGE_ENABLED == false) and (ply.crafting.level >= CRAFTING_MAX_LEVEL) then
					else
						crafting.GiveXP(ply, 5)
						net.Start("sendNotification")
							net.WriteString("+5 XP")
							net.WriteInt(1, 2)
						net.Send(ply)
					end
				end
			end
			
		end
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end

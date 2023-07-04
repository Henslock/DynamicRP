AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
util.AddNetworkString("sendNotification")

local DISTCHECK = 120

function ENT:Initialize()
	self:SetModel("models/props/de_inferno/largebush02.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	local phys = self:GetPhysicsObject()
	self:SetUseType( SIMPLE_USE )
	self.Replace = false
	self:SetNWBool("crft_isinuse", false)
	self.HarvestTimer = 0
	phys:Wake()
end

function ENT:CreateIronberryOre()
	local crft_ib = ents.Create('crft_ironberryore')
	crft_ib:SetPos(self:GetPos()+Vector(math.random(-5, 5),math.random(-5, 5), 10))
	crft_ib:Spawn()
end

function ENT:Think()
	if(self:GetNWBool("crft_isinuse") == true) then
		local ply = self:GetNWEntity("crft_harvester")
		
		if(CurTime() > self.HarvestTimer) and (!self.Replace) then
			self.Replace = true
			self.ReplaceTime = CurTime() + SWM_TREE_REPLACE_TIMER *3
			self:EmitSound("crft_rockcrumble", 90, math.random(90, 110), 1.2, CHAN_AUTO)
			
			local giveAmnt = math.random(2, 3)
			for i=1, giveAmnt do
				self:CreateIronberryOre()
				if(IsValid(ply)) then
					if(CRFT_PRESTIGE_ENABLED == false) and (ply.crafting.level >= CRAFTING_MAX_LEVEL) then
					else
						crafting.GiveXP(self:GetNWEntity("crft_harvester"), 1)
						net.Start("sendNotification")
							net.WriteString("+1 XP")
							net.WriteInt(1, 2)
						net.Send(ply)
					end
				end
			end
			
			self:SetNWEntity("crft_harvester", NULL)
			
			self.Pos = self:GetPos()
			self:SetPos(self.Pos + Vector(0,0,-1000))
			self:EmitSound("crft_rockcrumble", 110, math.random(90, 110), 2, CHAN_AUTO)
			self:SetNWBool("crft_isinuse", false)
			self:SetNWFloat("crft_harvesttime", -1)
		end
		
			--Player must maintain eyesight on the BUUUSH
		if not ( (self:GetPos() - ply:EyePos()):GetNormalized():Dot(ply:EyeAngles():Forward()) > 0.75) or (self:GetPos():Distance(ply:GetPos()) > DISTCHECK) then
			self:SetNWEntity("crft_harvester", NULL)
			self:SetNWBool("crft_isinuse", false)
			self:SetNWFloat("crft_harvesttime", -1)
			print("Cancelled")
		end
		
	end
	
	if (self.Replace) and (self.ReplaceTime < CurTime()) then
		self.Replace = false
		self:SetPos(self.Pos)
	end
end

function ENT:Use(activator, caller)
	if(activator:Team() ~= LUMBERJACK) then return end
	if(self:GetNWBool("crft_isinuse") == false) and (self:GetPos():Distance(activator:GetPos()) < DISTCHECK) then
		
		if (activator:GetNWInt("crft_level")<6) then
			activator:PlayerMsg(Color(255, 155, 155), "You must be level 6 or higher to harvest this.")
			return
		end
		self:EmitSound("crft_bushfx", 110, math.random(90, 110), 2, CHAN_AUTO)
		self:SetNWBool("crft_isinuse", true)
		self.HarvestTimer = CurTime() + IRONBERRY_HARVESTTIME
		self:SetNWEntity("crft_harvester", activator)
		self:SetNWFloat("crft_harvesttime", CurTime() + IRONBERRY_HARVESTTIME)
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_cart002.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetPos(self:GetPos() + Vector(0,0,20))
	self.jailWall = true
	self.CanUse = true
	self.wood = {}
	
	self:SetNWInt("mat_oakwood", 0)
	self:SetNWInt("mat_maplewood", 0)
	self:SetNWInt("mat_birchwood", 0)
	
end

function ENT:Touch(hitEnt)
	if not IsValid(hitEnt) then return end
	
	if (self.CanUse) then
		if (hitEnt:GetClass() == "crft_log") and (self:GetWoods() < SWM_CART_MAX_LOGS) then
			local logtype = hitEnt:GetNWString("LogType")
			self:SetNWInt(logtype, self:GetNWInt(logtype) +1)
				if (self:GetWoods() >= 6) then
					local Ang = self:GetAngles()
					hitEnt:SetAngles(Angle(55, Ang.y, Ang.r))
					hitEnt:SetParent(self)
					hitEnt:Remove()
				else 
					local Ang = self:GetAngles()
					if (self:GetWoods() == 0) then 
						hitEnt:SetPos(self:GetPos() + Ang:Right()*10 + Ang:Up()*1 + Ang:Forward()*math.random(0, 10))
						self.wood[1]=hitEnt;
					end;
					if (self:GetWoods() == 1) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*0 + Ang:Up()*1 + Ang:Forward()*math.random(0, 10))
						self.wood[2]=hitEnt;
					end;
					if (self:GetWoods() == 2) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*-10 + Ang:Up()*1 + Ang:Forward()*math.random(0, 10))
						self.wood[3]=hitEnt;
					end;
					if (self:GetWoods() == 3) then 
						hitEnt:SetPos(self:GetPos() + Ang:Right()*10 + Ang:Up()*10 + Ang:Forward()*math.random(0, 10))
						self.wood[4]=hitEnt;
					end;
					if (self:GetWoods() == 4) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*0 + Ang:Up()*10 + Ang:Forward()*math.random(0, 10))
						self.wood[5]=hitEnt;
					end;
					if (self:GetWoods() == 5) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*-10 + Ang:Up()*10 + Ang:Forward()*math.random(0, 10))
						self.wood[6]=hitEnt;
					end;
					hitEnt:SetAngles(Angle(math.random(0, 15), Ang.y + math.random(-5, 5), Ang.r))
					hitEnt:SetCollisionGroup(4)
					hitEnt:SetParent(self)
				end;
				hitEnt.Touched = true
				self:SetWoods( 1+self:GetWoods())
		else 
			if (hitEnt:GetClass() == "crft_log") then
				hitEnt:SetPos(self:GetPos()+Vector(20,20,20))
			end
		end
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end

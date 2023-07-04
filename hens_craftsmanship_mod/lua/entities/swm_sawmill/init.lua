
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/reciever_cart.mdl")
	
	timer.Simple(0.5, function()
		local prop1 = ents.Create("swm_sawmill_part1")
		prop1:SetPos(self:GetPos() + self:GetAngles():Up()*34 + self:GetAngles():Right()*26)
		prop1:SetAngles(self:GetAngles())
		prop1:Spawn()
		prop1:Activate()
		prop1:SetParent(self)
		prop1:SetSolid(SOLID_VPHYSICS)
	end)
	timer.Simple(0.5, function()	
		local prop2 = ents.Create("swm_sawmill_part2")
		prop2:SetPos(self:GetPos() + self:GetAngles():Up()*-30 + self:GetAngles():Right()*26)
		prop2:SetAngles(self:GetAngles())
		prop2:Spawn()
		prop2:Activate()
		prop2:SetParent(self)
		prop2:SetSolid(SOLID_VPHYSICS)
	end)
	timer.Simple(0.5, function()	
		local Angles = self:GetAngles()
		Angles:RotateAroundAxis(Angles:Forward(), 90)
		
		local prop3 = ents.Create("swm_sawmill_part3")
		prop3:SetPos(self:GetPos() + self:GetAngles():Right()*40 + self:GetAngles():Up()*15)
		prop3:SetAngles(Angles)
		prop3:Spawn()
		prop3:Activate()
		prop3:SetParent(self)
		self:SetSaw(prop3)
	end)	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetWoods(0)
	self:SetWidth(215)
	self:SetGetWoods(0)
	self:SetPos(self:GetPos())
	self.CanUse = true
	self.JailWall = true
end

function ENT:Touch(hitEnt)
	if not IsValid(hitEnt) then return end
	
	if self.CanUse then
		if (hitEnt:GetClass() == "crft_cart") and (hitEnt:GetWoods() > 0) and (!hitEnt:IsPlayerHolding()) then
			hitEnt:SetPos(self:GetPos() + self:GetAngles():Right()*40 + self:GetAngles():Up()*-6)
			hitEnt:SetAngles(self:GetAngles())
			hitEnt:SetParent(self)
			self.CanUse = false
			self.SumTime = SWM_SAW_TIME * hitEnt:GetWoods()
			self.Time = CurTime() + self.SumTime
			self:SetTimer(self.Time)
			self:SetCart(hitEnt)
			self:SetGetWoods(hitEnt:GetWoods())
			self.EffectTime = CurTime() + 1
			self.SupplyWoods = {hitEnt:GetNWInt("mat_oakwood"), hitEnt:GetNWInt("mat_birchwood"), hitEnt:GetNWInt("mat_maplewood")}
			hitEnt.CanUse = false
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:Think()
	if !self.CanUse then
		local width = ((100/self.SumTime)*(205/100))/10
		self:SetWidth(self:GetWidth() - width);
		self:NextThink(CurTime()+0.1)
		
		local saw = self:GetSaw()
		local Angles = saw:GetAngles()
		Angles:RotateAroundAxis(Angles:Up(), CurTime()*10)
		saw:SetAngles(Angles)
		
		if (SWM_SAW_EFFECT) and (self.EffectTime <= CurTime()) then
			self:EmitSound("physics/wood/wood_box_impact_hard"..math.random(1, 3)..".wav");	
					
			local effectData = EffectData();
			effectData:SetStart(self:GetPos()+self:GetAngles():Right()*40);
			effectData:SetOrigin(self:GetPos()+self:GetAngles():Right()*40);
			effectData:SetScale(8);	
			util.Effect("GlassImpact", effectData, true, true);
			self.EffectTime = CurTime() + 1
		end;
		
		if self.Time <= CurTime() then
			self:SetWidth(205);
			local cart = self:GetCart()
			if (cart != NULL) then
				local selfAng = self:GetAngles()
				cart:SetWoods(0)
				cart:SetParent()
				cart:SetPos(self:GetPos() + selfAng:Right()*90)
				cart.CanUse = true
				
				local log1 = cart.wood[1]
				local log2 = cart.wood[2]
				local log3 = cart.wood[3]
				local log4 = cart.wood[4]
				local log5 = cart.wood[5]
				local log6 = cart.wood[6]
				if IsValid(log1) then log1:Remove() end
				if IsValid(log2) then log2:Remove() end
				if IsValid(log3) then log3:Remove() end
				if IsValid(log4) then log4:Remove() end
				if IsValid(log5) then log5:Remove() end
				if IsValid(log6) then log6:Remove() end
				
				local supplycrate = ents.Create('crft_supplycrate')
				supplycrate:SetEntOwner(cart:Getowning_ent())
				supplycrate:SetPos(self:GetPos()+Vector(math.random(-20, 20),math.random(-20, 20),60))
				supplycrate:SetNWInt("mat_oakwood", self.SupplyWoods[1])
				supplycrate:SetNWInt("mat_birchwood", self.SupplyWoods[2])
				supplycrate:SetNWInt("mat_maplewood", self.SupplyWoods[3])
				supplycrate:Spawn()
				
				
				self.CanUse = true
				self:SetGetWoods(0)
				cart:SetNWInt("mat_oakwood", 0)
				cart:SetNWInt("mat_maplewood", 0)
				cart:SetNWInt("mat_birchwood", 0)
			else
				self.CanUse = true
			end
		end
		return true
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end


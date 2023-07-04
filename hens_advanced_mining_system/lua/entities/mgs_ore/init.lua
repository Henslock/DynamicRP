AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

if SERVER then

	local Chance
	function Chance(ore, var, mul) 
		while type(ore) == "table" do
			if ((ore[5] + (ore[8]*mul)) < math.Rand(0, 1)) then
				return ore
			else
				return Chance(table.Random(var), var, mul)
			end
		end
	end

	function ENT:Initialize()
		
		self:SetModel(table.Random(MGS_ORE_MODELS))
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
		local phys = self:GetPhysicsObject()
		local tiernum = self:GetNWInt("tier");
		local oretable = GetOreType(tiernum);
		
		phys:Wake()
		self.Ore = Chance(table.Random(oretable), oretable, self:GetNWInt("flucVal"));
		if(self.Ore[7] ~= "") then
			self:SetMaterial(self.Ore[7]);
		end
		
		if(self.Ore[8] ~= "") then
			self:SetModel(self.Ore[9]);
			self:PhysicsInit(SOLID_VPHYSICS)
			self:GetPhysicsObject():Wake();
			self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetSolid(SOLID_VPHYSICS)
		end
		
		if(self.Ore[10] == RARITY_LEGENDARY) then
			self:EmitSound("vo/ravenholm/madlaugh01.wav", 75, math.random(225, 255))
		end
		
		self:SetNWInt("ore", 1)
		self:SetNWInt("distance", MGS_DISTANCE)
		self:SetNWString("type", self.Ore[1])
		
		--Ore price perk
		local plr = player.GetByUniqueID(self:GetNWInt("ore_owner"))
		local priceboost = self.Ore[3]
		
		if (plr~=false) and (plr:GetNWBool("perk_oreprice")== true) then
			priceboost = priceboost*1.25
		end
		
		if (plr~=false) and (plr:GetNWInt("perk_voidore")>= 1) then
			priceboost = priceboost * (1 + ((plr:GetNWInt("perk_voidore") * 5)/100) )
		end
		
		self:SetNWInt("price", priceboost)
		
		self:SetNWInt("mass", self.Ore[4])
		self:SetNWInt("time", self.Ore[6])
		self:SetNWInt("rarity", self.Ore[10])
		self:SetNWString("type", self.Ore[1])
		self.Touched = false
		self.RemovingTime = CurTime() + MGS_ORE_REMOVE_TIME
		self:SetColor(self.Ore[2])
		
		self.ThinkNext = 0
	end

	function ENT:OnRemove()
		if not IsValid(self) then return end
	end

	function ENT:Think()
		if !self.Touched and self.RemovingTime <= CurTime() then
			self:Remove()
		end
		
		if(self:GetNWString("type")=="Diamond") then
		
			if self.ThinkNext < CurTime() then
				self:EmitSound("ambient/levels/canals/windchime5.wav", 75, math.random(100, 255))
				self.ThinkNext = CurTime() + 3
			end
			
		end
	end
end 


function GetOreType(tier)
	if(tier ~= nil) then
		if(tier == 1) then
			return MGS1_ORE_TYPES
		elseif( tier == 2) then
			return MGS2_ORE_TYPES
		elseif( tier == 3) then
			return MGS3_ORE_TYPES
		elseif( tier == 4) then
			return MGS4_ORE_TYPES
		else
			return MGS4_ORE_TYPES
		end
	end
end

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("weapons/mgs_pickaxe/sv_playerinfo.lua")

if SERVER then

	function ENT:Initialize()
		
		self:SetModel(table.Random(MGS_ARTIFACT_MODELS))
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		
		phys:Wake()
		
		self:SetNWInt("distance", MGS_DISTANCE)
		self:SetNWInt("a_price", math.random(MGS_ARTIFACT_MIN_PRICE, MGS_ARTIFACT_MAX_PRICE))
		self:SetNWInt("a_exp", math.random(MGS_ARTIFACT_MIN_EXP, MGS_ARTIFACT_MAX_EXP))
		
		if(player.GetByUniqueID(self:GetNWInt("a_owner")) ~= false) then
			local ply = player.GetByUniqueID(self:GetNWInt("a_owner"))
			
			--FORBIDDEN ARTIFACTS
			if(ply:GetNWBool("perk_axp") == true) then
				self:SetNWInt("a_exp", math.Round(self:GetNWInt("a_exp")*1.5), 0)
			end
			
			--VOID ARTIFACT CHANCE BOOST
			if(ply:GetNWInt("perk_voidartifacts") >= 1) then
				local bonus = 1 + (ply:GetNWInt("perk_voidartifacts")*20 / 100)
				self:SetNWInt("a_exp", math.Round(self:GetNWInt("a_exp")* bonus, 0))
			end
			
			if(ply:GetNWBool("perk_artprice") == true) then
				self:SetNWInt("a_price", math.Round(math.random(MGS_ARTIFACT_MIN_PRICE, MGS_ARTIFACT_MAX_PRICE)*1.2))
			end
		end
		
		self.Touched = false
		self.RemovingTime = CurTime() + MGS_ORE_REMOVE_TIME * 2
		
		self.ThinkNext = 0
	end

	function ENT:OnRemove()
		if not IsValid(self) then return end
	end

	function ENT:Think()
		if !self.Touched and self.RemovingTime <= CurTime() then
			self:Remove()
		end
		
		if self.ThinkNext < CurTime() then
			self:EmitSound("ambient/levels/canals/windchime4.wav", 75, math.random(100, 255))
			local ply = player.GetByUniqueID(self:GetNWInt("a_owner"))
			
			local glimfx = EffectData();
			glimfx:SetEntity(self);
			glimfx:SetOrigin(self:GetPos());
			if(ply ~= false and ply:GetNWInt("perk_voidartifacts") >= 1 ) then
				util.Effect("voidglimmer",glimfx)
			else
				util.Effect("glimmer",glimfx)
			end
			self.ThinkNext = CurTime() + 3
		end
			
	end
	
	function ENT:Use(ply)
	
		if(ply:UniqueID() == self:GetNWInt("a_owner") or self:GetNWInt("a_owner") == 0) then
		self:EmitSound("ambient/levels/labs/coinslot1.wav", 100, 100)
		
			if (MGS_GM_VERSION <= 2.4) then
				ply:AddMoney(self:GetNWInt("a_price"))
			else
				ply:addMoney(self:GetNWInt("a_price"))
			end
			
			pickaxe.GiveXP(ply, self:GetNWInt("a_exp"))
			
			ply:PlayerMsg(Color(255,255,255), "You sold the Artifact for ", Color(150, 255, 150), "$"..self:GetNWInt("a_price").."", Color(255,255,255)," and gained ", Color(123,204,255),"".. self:GetNWInt("a_exp") .."", Color(255,255,255)," experience!")
			
			self:Remove();
		end
	end
	
end 


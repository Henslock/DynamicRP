AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("weapons/crft_axe/sv_plrstats.lua")

if SERVER then

	function ENT:Initialize()
		
		self:SetModel("models/props_junk/wood_crate001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		
		phys:Wake()
		
		self.Touched = false
		self.RemovingTime = CurTime() + SWM_LOG_REMOVE_TIME * 10
		
	end

	function ENT:OnRemove()
		if not IsValid(self) then return end
	end

	function ENT:Think()
		if !self.Touched and self.RemovingTime <= CurTime() then
			self:Remove()
		end
	end
	
	function ENT:Use(ply)
		if(self:GetEntOwner() == ply or self:GetEntOwner() == NULL) then
			local suppOakCount = self:GetNWInt("mat_oakwood")
			local suppBirchCount = self:GetNWInt("mat_birchwood")
			local suppMapleCount = self:GetNWInt("mat_maplewood")
			
			if(self:GetEntOwner() == NULL) then
				suppOakCount = 20
				suppBirchCount = 20
				suppMapleCount = 20
			end
			
			if(suppOakCount >= 1) then
				crafting.GiveMaterial(ply, "mat_oakwood", suppOakCount)
				net.Start("sendNotification")
					net.WriteString("+"..suppOakCount.." Oak Wood")
					net.WriteInt(0, 2)
					net.WriteString(CRAFTSMANSHIP_MATS_DROP["mat_oakwood"].dropicon)
				net.Send(ply)
			end
			
			if(suppBirchCount >= 1) then
				crafting.GiveMaterial(ply, "mat_birchwood", suppBirchCount)		
				net.Start("sendNotification")
					net.WriteString("+"..suppBirchCount.." Birch Wood")
					net.WriteInt(0, 2)
					net.WriteString(CRAFTSMANSHIP_MATS_DROP["mat_birchwood"].dropicon)
				net.Send(ply)
			end
			
			if(suppMapleCount >= 1) then
				crafting.GiveMaterial(ply, "mat_maplewood", suppMapleCount)
				net.Start("sendNotification")
					net.WriteString("+"..suppMapleCount.." Maple Wood")
					net.WriteInt(0, 2)
					net.WriteString(CRAFTSMANSHIP_MATS_DROP["mat_maplewood"].dropicon)
				net.Send(ply)
			end
			
			self:EmitSound("crft_supplysfx")
			
			self:Remove()
		end
	end
	
end 


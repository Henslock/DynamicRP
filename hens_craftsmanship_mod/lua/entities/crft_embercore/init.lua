AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("weapons/crft_axe/sv_plrstats.lua")

if SERVER then

	function ENT:Initialize()
		
		self:SetModel(CRAFTSMANSHIP_MATS_DROP["mat_embercore"].dropmodel)
		self:SetMaterial(CRAFTSMANSHIP_MATS[9].mat)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType( SIMPLE_USE )
		local phys = self:GetPhysicsObject()
		
		phys:Wake()
		
		self.Touched = false
		self.RemovingTime = CurTime() + SWM_LOG_REMOVE_TIME
		
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
		if(ply:Team() ~= LUMBERJACK) then return end
		local matCount = ply:GetNWInt("mat_embercore")
		if(matCount >= CRAFTSMANSHIP_MATS[9].basecarry) then
			net.Start("sendNotification")
				net.WriteString("You can't carry any more Ember Cores.")
				net.WriteInt(0, 2)
				net.WriteString("")
			net.Send(ply)
			
			self:EmitSound("crft_woodsfx")
		else
			crafting.GiveMaterial(ply, "mat_embercore", 1)
			net.Start("sendNotification")
				net.WriteString("+1 Ember Core")
				net.WriteInt(0, 2)
				net.WriteString(CRAFTSMANSHIP_MATS_DROP["mat_embercore"].dropicon)
			net.Send(ply)
			
			self:EmitSound("crft_woodsfx")
			self:Remove()
		end
	end
	
end 


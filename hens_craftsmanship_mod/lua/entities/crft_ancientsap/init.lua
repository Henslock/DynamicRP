AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("weapons/crft_axe/sv_plrstats.lua")

if SERVER then

	function ENT:Initialize()
		
		self:SetModel(CRAFTSMANSHIP_MATS_DROP["mat_ancientsap"].dropmodel)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType( SIMPLE_USE )
		local phys = self:GetPhysicsObject()
		
		phys:Wake()
		
		self.Touched = false
		self.RemovingTime = CurTime() + SWM_LOG_REMOVE_TIME * 3
		
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
		local matCount = ply:GetNWInt("mat_ancientsap")
		if(matCount >= CRAFTSMANSHIP_MATS[4].basecarry) then
			net.Start("sendNotification")
				net.WriteString("You can't carry any more Ancient Sap.")
				net.WriteInt(0, 2)
				net.WriteString("")
			net.Send(ply)
			
			self:EmitSound("crft_watersfx")
			
		else
			crafting.GiveMaterial(ply, "mat_ancientsap", 1)
			net.Start("sendNotification")
				net.WriteString("+1 Ancient Sap")
				net.WriteInt(0, 2)
				net.WriteString(CRAFTSMANSHIP_MATS_DROP["mat_ancientsap"].dropicon)
			net.Send(ply)
			
			self:EmitSound("crft_watersfx")
			self:Remove()
		end
	end
	
end 


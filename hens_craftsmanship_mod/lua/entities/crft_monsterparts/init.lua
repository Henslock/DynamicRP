AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("weapons/crft_axe/sv_plrstats.lua")

if SERVER then

	function ENT:Initialize()
		
		self:SetModel(table.Random(CRAFTSMANSHIP_MATS_DROP["mat_monsterparts"].dropmodel))
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		
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
		local matCount = ply:GetNWInt("mat_monsterparts")
		if(matCount >= CRAFTSMANSHIP_MATS[8].basecarry) then
			net.Start("sendNotification")
				net.WriteString("You can't carry any more Monster Parts.")
				net.WriteInt(0, 2)
				net.WriteString("")
			net.Send(ply)
			
			self:EmitSound("crft_slime")
			self:Remove()
		else
			local giveamnt = math.random(1, 3)
			crafting.GiveMaterial(ply, "mat_monsterparts", giveamnt)
			net.Start("sendNotification")
				net.WriteString("+"..giveamnt.." Monster Parts")
				net.WriteInt(0, 2)
				net.WriteString(CRAFTSMANSHIP_MATS_DROP["mat_monsterparts"].dropicon)
			net.Send(ply)
			
			self:EmitSound("crft_slime")
			self:Remove()
		end
	end
	
end 


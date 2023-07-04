local Spell = { }
Spell.LearnTime = 60
Spell.ApplyFireDelay = 0.2
Spell.AccuracyDecreaseVal = 0.3
Spell.Category = HpwRewrite.CategoryNames.Physics
Spell.OnlyIfLearned = { "Arresto Momentum" }
Spell.SpriteColor = Color(255, 0, 0)
Spell.Description = [[
	Used to launch the object or player up 
	into the air.
]]

Spell.NodeOffset = Vector(283, 361, 0)

function Spell:OnFire(wand)
	local ent = wand:HPWGetAimEntity(1000, Vector(-10, -10, -4), Vector(10, 10, 4))

	if IsValid(ent) then
		if ent:IsVehicle() then return end
		if ent:IsPlayer() or ent:IsNPC() then
			
			if(ent:IsPlayer() and !(self.Owner == ent)) then
				if(!ent:GetNWBool("hpwr_pvptoggle")) then return end
			end
			
			if (ent:GetNWBool("hpwr_pvptoggle") and self.Owner:GetNWBool("hpwr_pvptoggle") == false) then
				self.Owner:SetNWBool("hpwr_pvptoggle", true)
				self.Owner:SetNWFloat("hpwr_pvptogglecd", CurTime() + HPWR_PVPCD)
				self.Owner:ChatPrint("[WARNING] Attacking flagged players toggles you for PVP!")
				sound.Play("hpwrewrite/pvpdrums.mp3", self.Owner:GetPos(), 80, math.random(100, 110))
			end
			
			ent:SetVelocity(Vector(0, 0, 600))
		else
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:ApplyForceCenter(vector_up * phys:GetMass() * (math.max(0, 500 - ent:GetModelRadius())))
			end
		end
	end

	sound.Play("npc/antlion/idle3.wav", wand:GetPos(), 55, math.random(240, 255))
end

HpwRewrite:AddSpell("Alarte Ascendare", Spell)
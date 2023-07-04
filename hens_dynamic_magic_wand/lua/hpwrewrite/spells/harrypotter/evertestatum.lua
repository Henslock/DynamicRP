local Spell = { }
Spell.LearnTime = 60
Spell.Category = HpwRewrite.CategoryNames.Physics
Spell.Description = [[
	Causes opponent to fly back 
	several feet. Being casted
	on object will push it away.

	Note that it doesn't deal 
	any damage!
]]

Spell.ApplyDelay = 0.4
Spell.AccuracyDecreaseVal = 0.25
Spell.FlyEffect = "hpw_confringo_main"
Spell.OnlyIfLearned = { "Alarte Ascendare" }
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_5 }
Spell.SpriteColor = Color(255, 165, 0)

Spell.NodeOffset = Vector(309, 214, 0)
Spell.LeaveParticles = true

function Spell:Draw(spell)
	--self:DrawGlow(spell)
end

function Spell:OnSpellSpawned(wand, spell)
	wand:PlayCastSound()
end

function Spell:OnFire(wand)
	return true
end

function Spell:AfterCollide(spell, data)
	local ent = data.HitEntity
	if IsValid(ent) then
		if(ent:IsPlayer()) then
			if !(ent:GetNWBool("hpwr_pvptoggle")) and !(self.Owner == ent) then return end
		end
		
		if(ent:IsVehicle()) then return end
		
		if (ent:GetNWBool("hpwr_pvptoggle") and self.Owner:GetNWBool("hpwr_pvptoggle") == false) then
			self.Owner:SetNWBool("hpwr_pvptoggle", true)
			self.Owner:SetNWFloat("hpwr_pvptogglecd", CurTime() + HPWR_PVPCD)
			self.Owner:ChatPrint("[WARNING] Attacking flagged players toggles you for PVP!")
			sound.Play("hpwrewrite/pvpdrums.mp3", self.Owner:GetPos(), 80, math.random(100, 110))
		end
			
		local a, b, c, d = HpwRewrite:ThrowEntity(ent, spell:GetFlyDirection(), 3000, 2)
		if d then hook.Remove("EntityTakeDamage", d) end
		if IsValid(a) then sound.Play("weapons/crossbow/bolt_fly4.wav", data.HitPos, 70, 80) end

		if IsValid(ent:GetPhysicsObject()) and not ent:IsPlayer() and not ent:IsNPC() then
			if ent:GetModelRadius() > 400 then return end

			local phys = ent:GetPhysicsObject()
			local mass = phys:GetMass()
			if mass > 2000 then return end

			phys:ApplyForceCenter(vector_up * mass * 100)
			phys:ApplyForceOffset(spell:GetFlyDirection() * mass * 600, spell:GetPos())
		end
	end
end

HpwRewrite:AddSpell("Everte Statum", Spell)
local Spell = { }
Spell.LearnTime = 30
Spell.Category = HpwRewrite.CategoryNames.Physics
Spell.Description = [[
	Stabilizes the object 
	in the air.
]]

Spell.ApplyFireDelay = 0.2
Spell.AccuracyDecreaseVal = 0.3
Spell.OnlyIfLearned = { "Accio", "Depulso" }
Spell.CanSelfCast = true

Spell.NodeOffset = Vector(156, 447, 0)

function Spell:OnFire(wand)
	local ent = wand:HPWGetAimEntity(2500, Vector(-10, -10, -10), Vector(10, 10, 10))
	
	if IsValid(ent) and IsValid(ent:GetPhysicsObject()) and not ent:IsNPC() and not ent:IsVehicle() then
		local phys = ent:GetPhysicsObject()

		if phys:GetVelocity():Length() > 200 then
			sound.Play("ambient/wind/wind_snippet1.wav", ent:GetPos(), 86, 255)
		end

		local inverse = false
		local val = 0

		local dieTime = CurTime() + 6
		local name = "hpwrewrite_arrestomomentum_handler" .. ent:EntIndex()
		if(ent:IsPlayer() and ent:GetNWBool("hpwr_pvptoggle") or (self.Owner == ent)) then
			hook.Add("Think", name, function()
				if not ent:IsValid() or CurTime() > dieTime then 
					hook.Remove("Think", name) 
					return 
				end

				if inverse then
					val = math.Approach(val, 0, FrameTime()/2)
				else
					val = math.Approach(val, 1, FrameTime()/2)
					if val >= 1 then inverse = true end
				end

				ent:SetVelocity(-ent:GetVelocity() * val *0.90)
			end)

		else
			hook.Add("Think", name, function()
				if not ent:IsValid() or not phys:IsValid() or CurTime() > dieTime then 
					hook.Remove("Think", name) 
					return 
				end

				if inverse then
					val = math.Approach(val, 0, FrameTime()/2)
				else
					val = math.Approach(val, 1, FrameTime()/2)
					if val >= 1 then inverse = true end
				end

				phys:ApplyForceCenter(-phys:GetVelocity() * phys:GetMass() * val)
				phys:AddAngleVelocity(-phys:GetAngleVelocity() * val)
			end)
		end
	end
end

HpwRewrite:AddSpell("Arresto Momentum", Spell)
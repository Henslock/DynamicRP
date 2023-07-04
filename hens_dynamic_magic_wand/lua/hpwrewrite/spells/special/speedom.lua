local Spell = { }
Spell.LearnTime = 60
Spell.ApplyFireDelay = 0.3
Spell.InstantLearn = true
Spell.AccuracyDecreaseVal = 0.25
Spell.Category = HpwRewrite.CategoryNames.General
Spell.Description = [[
	Increases your speed
	and jump height.
	Prevents fall damage.
]]

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_5 }
Spell.DoSelfCastAnim = true
Spell.NodeOffset = Vector(245, -714, 0)
Spell.ShouldReverseSelfCast = true

function Spell:OnFire(wand)
	local ent = wand:GetOwner()
	sound.Play("hpwrewrite/spells/lumos.wav", wand:GetOwner():GetPos(), 75, 80)
	if(math.random(1,2) == 1) then
		sound.Play("hpwrewrite/spells/speedom.wav", wand:GetOwner():GetPos(), 115, math.random(80,115))
	end
	if IsValid(ent) then
		if ent:IsPlayer() then
			local name = "hpwrewrite_speedom_handler" .. ent:EntIndex()
	
			if not timer.Exists(name) then
				local oldspeed = ent:GetRunSpeed()
				local oldwalkspeed = ent:GetWalkSpeed()
				local newspeed = oldspeed * 2
				local newwalkspeed = oldwalkspeed * 2
				
				ent:SetRunSpeed(newspeed)
				ent:SetWalkSpeed(newwalkspeed)
				ent:SetJumpPower(400)
				hook.Add("GetFallDamage", "hpwrewrite_speedom_handler", function(ent, speed)
					return 0
				end)
				
				ent.speedom_trail = util.SpriteTrail(ent, ent:LookupAttachment("chest"), Color(0,255,125), true, 30, 0, 2, 1/(15+1)*0.5, "trails/laser.vmt")
				timer.Create(name, 10, 1, function()
					if IsValid(ent) then
						ent:SetRunSpeed(400)
						ent:SetWalkSpeed(200)
						ent:SetJumpPower(200)
						hook.Remove("GetFallDamage", "hpwrewrite_speedom_handler")
						if(IsValid(ent.speedom_trail)) then ent.speedom_trail:Remove() end
					end
				end)
			end
			--[[
			local oldspeed = ent:GetRunSpeed()
			local oldwalkspeed = ent:GetWalkSpeed()
			local newspeed = oldspeed * 3
			local newwalkspeed = oldwalkspeed * 3
	
			ent:SetRunSpeed(newspeed)
			ent:SetWalkSpeed(newwalkspeed)
			timer.Simple(5, function()
				ent:SetRunSpeed(oldspeed)
				ent:SetWalkSpeed(oldwalkspeed)
			end)
			--]]
		end
	end
end

HpwRewrite:AddSpell("Speedom", Spell)
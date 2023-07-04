local Spell = { }
Spell.LearnTime = 60
Spell.ApplyFireDelay = 0.6
Spell.Category = { HpwRewrite.CategoryNames.Protecting, HpwRewrite.CategoryNames.Special }
Spell.Description = [[
	Blocks the first instance
	of fall damage.
]]

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_3 }
Spell.NodeOffset = Vector(372, -805, 0)
Spell.ShouldReverseSelfCast = true
Spell.DoSelfCastAnim = false

function Spell:OnFire(wand)
	sound.Play("weapons/iceaxe/iceaxe_swing1.wav", wand:GetPos(), 70, 120)
	local ent = wand:GetOwner()

	local name = "hpwrewrite_legimmio_handler" .. self.Owner:EntIndex()
	
	if timer.Exists(name) then return end
	
	hook.Add("GetFallDamage", "hpwrewrite_legimmio_handler", function(ply, speed)
		if IsValid(ent) and ply == ent then
			sound.Play("npc/antlion/land1.wav", ply:GetPos(), 65, 215)
			HpwRewrite.MakeEffect("hpw_protego_main", ent:GetPos() - vector_up * 8, Angle(90, 0, 0))

			hook.Remove("GetFallDamage", "hpwrewrite_legimmio_handler")
			timer.Remove(name)

			return 0
		end
	end)

	timer.Create(name, 0.75, 1, function()
		hook.Remove("GetFallDamage", name)
	end)
end

HpwRewrite:AddSpell("Legimmio", Spell)

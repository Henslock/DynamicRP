local Spell = { }
Spell.LearnTime = 90
Spell.Description = [[
	Simple damaging spell.
]]
Spell.FlyEffect = "hpw_blue_main"
Spell.ImpactEffect = "hpw_blue_impact"
Spell.ApplyDelay = 0.5
Spell.AccuracyDecreaseVal = 0.02
Spell.Category = { HpwRewrite.CategoryNames.Fight, HpwRewrite.CategoryNames.Special }
Spell.AnimSpeedCoef = 1.28
Spell.ShouldSay = false
Spell.ForceDelay = 0.54

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_1, ACT_VM_PRIMARYATTACK_5 }
Spell.SpriteColor = Color(0, 0, 255)
Spell.NodeOffset = Vector(699, -830, 0)

function Spell:OnSpellSpawned(wand, spell)
	wand:PlayCastSound()
end

function Spell:Draw(spell)
	self:DrawGlow(spell)
end

function Spell:OnFire(wand)
	return true
end

function Spell:OnCollide(spell, data)
	local ent = data.HitEntity
	
	if IsValid(ent) then
		if !(ent:GetNWBool("hpwr_pvptoggle")) and !ent:IsNPC() and !(self.Owner == ent) then return end
		
		if (ent:GetNWBool("hpwr_pvptoggle") and self.Owner:GetNWBool("hpwr_pvptoggle") == false) then
			self.Owner:SetNWBool("hpwr_pvptoggle", true)
			self.Owner:SetNWFloat("hpwr_pvptogglecd", CurTime() + HPWR_PVPCD)
			self.Owner:ChatPrint("[WARNING] Attacking flagged players toggles you for PVP!")
			sound.Play("hpwrewrite/pvpdrums.mp3", self.Owner:GetPos(), 80, math.random(100, 110))
		end
		
		ent:TakeDamage(math.random(18,26), self.Owner, HpwRewrite:GetWand(self.Owner))
	end
end

HpwRewrite:AddSpell("Mostro", Spell)
local Spell = { }
Spell.LearnTime = 5
Spell.ApplyFireDelay = 0.3
Spell.Description = [[
	Just green sparks.
]]

Spell.FlyEffect = "hpw_greensparks_main"
Spell.Category = HpwRewrite.CategoryNames.Fight
Spell.NodeOffset = Vector(-1133, -696, 0)
Spell.AccuracyDecreaseVal = 0
Spell.DoSparks = true
Spell.SpriteColor = Color(0, 255, 0)
Spell.LeaveParticles = true
Spell.CanSelfCast = false
Spell.ShouldSay = false

function Spell:OnFire(wand)
	return true
end

function Spell:SpellThink(spell)
	if SERVER then return end

	local dlight = DynamicLight(spell:EntIndex())
	if dlight then
		dlight.pos = spell:GetPos()
		dlight.r = 0
		dlight.g = 255
		dlight.b = 0
		dlight.brightness = 2
		dlight.Decay = 600
		dlight.Size = 500
		dlight.DieTime = CurTime() + 1
	end
end

function Spell:OnCollide(spell, data)
	local ent = data.HitEntity
	if !(ent:GetNWBool("hpwr_pvptoggle")) and !ent:IsNPC() and !(self.Owner == ent) then return end
	if IsValid(ent) then
		if (ent:GetNWBool("hpwr_pvptoggle") and self.Owner:GetNWBool("hpwr_pvptoggle") == false) then
			self.Owner:SetNWBool("hpwr_pvptoggle", true)
			self.Owner:SetNWFloat("hpwr_pvptogglecd", CurTime() + HPWR_PVPCD)
			self.Owner:ChatPrint("[WARNING] Attacking flagged players toggles you for PVP!")
			sound.Play("hpwrewrite/pvpdrums.mp3", self.Owner:GetPos(), 80, math.random(100, 110))
		end
		ent:TakeDamage(math.random(9,19), self.Owner, HpwRewrite:GetWand(self.Owner))
	end
end

HpwRewrite:AddSpell("Green Sparks", Spell)



local Spell = { }
Spell.Base = "Green Sparks"
Spell.Description = [[
	Just red sparks.
]]

Spell.FlyEffect = "hpw_redsparks_main"
Spell.Category = HpwRewrite.CategoryNames.Fight
Spell.NodeOffset = Vector(-984, -783, 0)
Spell.SpriteColor = Color(255, 0, 0)

function Spell:OnFire(wand)
	return true
end

function Spell:SpellThink(spell)
	if SERVER then return end

	local dlight = DynamicLight(spell:EntIndex())
	if dlight then
		dlight.pos = spell:GetPos()
		dlight.r = 255
		dlight.g = 0
		dlight.b = 0
		dlight.brightness = 2
		dlight.Decay = 600
		dlight.Size = 500
		dlight.DieTime = CurTime() + 1
	end
end

HpwRewrite:AddSpell("Red Sparks", Spell)
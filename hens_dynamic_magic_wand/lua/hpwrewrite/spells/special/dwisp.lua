local Spell = { }
Spell.LearnTime = 240
Spell.Description = [[
	More dangerous damaging 
	spell.
]]
Spell.FlyEffect = "hpw_tarantal_main"
Spell.ImpactEffect = "hpw_dwisp_impact"
Spell.ApplyDelay = 0.33
Spell.AccuracyDecreaseVal = 0.09
Spell.Category = { HpwRewrite.CategoryNames.Fight, HpwRewrite.CategoryNames.Special }
Spell.AnimSpeedCoef = 1.8
Spell.ForceDelay = 0.2
Spell.AutoFire = false
Spell.Fightable = true
Spell.ShouldSay = false
Spell.LeaveParticles = true
Spell.OnlyIfLearned = { "Mostro" }

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_7 }
Spell.SpriteColor = Color(55, 255, 55)
Spell.NodeOffset = Vector(799, -930, 0)

local mat = Material("models/laser/greenlaser")
local mat2 = Material("cable/xbeam")
Spell.FightingEffect = function(nPoints, points) 
	render.SetMaterial(mat) 
	render.StartBeam(nPoints)
		for k, v in pairs(points) do
			render.AddBeam(v, (k / nPoints) * 32, math.Rand(0, 1), color_white)
		end
	render.EndBeam()

	render.StartBeam(nPoints)
		for k, v in pairs(points) do
			render.AddBeam(v, (k / nPoints) * 46, math.Rand(0, 1), color_white)
		end
	render.EndBeam()


	render.SetMaterial(mat2)
	render.StartBeam(nPoints)
		for k, v in pairs(points) do
			render.AddBeam(v, (k / nPoints) * 4, math.Rand(0, 1), color_white)
		end
	render.EndBeam()

	render.StartBeam(nPoints)
		for k, v in pairs(points) do
			render.AddBeam(v, (k / nPoints) * 10, math.Rand(0, 1), color_white)
		end
	render.EndBeam()

	for k, v in pairs(points) do
		if math.random(1, (1 / RealFrameTime()) * 3) == 1 then HpwRewrite.MakeEffect("hpw_dwisp_impact", v, AngleRand()) end
	end
end

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
		ent:TakeDamage(math.random(30,42), self.Owner, HpwRewrite:GetWand(self.Owner))
	end
end

HpwRewrite:AddSpell("Dwisp", Spell)
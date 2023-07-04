AddCSLuaFile()
--Teaches a random simple spell
ENT.Type = "anim"
ENT.Base = "entity_hpwand_bookbase"
ENT.PrintName = "Advanced Spell Book"
ENT.Category = "Harry Potter Spell Packs"
ENT.Author = "Wand"
ENT.AdminOnly = false

ENT.Model = "models/hpwrewrite/books/book1.mdl"

ENT.Spawnable =  true

local advancedSpells = {
"Deprimo",
"Arrow-shooting spell",
"Dwisp",
"Immobulus",
"Rictusempra",
"Stupefy",
"Colloshoo",
"Colovaria",
"Obscuro",
"Unbreakable Charm",
"Vulnera Sanentur",
"Color lumos",
"Lumos Maxima",
"Lux Bulbus",
"Everte Statum",
"Acriea",
"Heyedillio",
"Hocus",
"Punchek Duo",
}

function ENT:GiveSpells(activator, caller)
	print(activator)
	local randSpell = table.Random(advancedSpells)
	local check = HpwRewrite:PlayerHasLearnableSpell(activator, randSpell) or HpwRewrite:PlayerHasSpell(activator, randSpell)
	net.Start("hp_newspell_prompt")
		net.WriteBool(check)
		net.WriteString(randSpell)
	net.Send(activator)
	
	if(check) then
		local mutatio = activator:GetNWInt("hp_mutatio")
		activator:SetNWInt("hp_mutatio", mutatio + 1)
	end
	
	HpwRewrite:PlayerGiveLearnableSpell(activator, randSpell, true)
	return true
end
AddCSLuaFile()
--Teaches a random simple spell
ENT.Type = "anim"
ENT.Base = "entity_hpwand_bookbase"
ENT.PrintName = "Simple Spell Book"
ENT.Category = "Harry Potter Spell Packs"
ENT.Author = "Wand"
ENT.AdminOnly = false

ENT.Model = "models/hpwrewrite/books/book2.mdl"

ENT.Spawnable =  true

local simpleSpells = {
"Speedom",
"Reducto",
"Expelliarmus",
"Impedimenta",
"Mostro",
"Avis",
"Green Sparks",
"Inflatus",
"Periculum",
"Purple Firecrackers",
"Red Sparks",
"Episkey",
"Lumos",
"Accio",
"Alarte Ascendare",
"Arresto Momentum",
"Carpe Retractum",
"Depulso",
"Flarus",
"Speedavec",
"Wingardium Leviosa",
"Legimmio",
"Protego",
"Propositum Charm",
"Punchek",
"Walkspeeden"
}

if SERVER then

	util.AddNetworkString("hp_newspell_prompt")

end

net.Receive("hp_newspell_prompt", function()
	local check = net.ReadBool()
	print(check)
	local spellname = net.ReadString()
	if(check) then
		chat.AddText(Color(238, 166, 252), "The book contains the spell ... ", Color(255, 255, 255), "[" .. spellname .. "]", Color(238, 166, 252)," You already know this spell though...")
		chat.AddText(Color(255, 55, 55), "[ You've gained some Mutatio! ]")
	else
		chat.AddText(Color(238, 166, 252), "The book contains the spell ... ", Color(255, 255, 255), "[" .. spellname .. "]", Color(238, 166, 252)," Congratulations!")
	end
end)

function ENT:GiveSpells(activator, caller)
	local randSpell = table.Random(simpleSpells)
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
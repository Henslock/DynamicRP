

if SERVER then
	AddCSLuaFile("vendor/cl_scifivendor.lua")
else
	AddCSLuaFile("vendor/cl_scifivendor.lua")
	include("vendor/cl_scifivendor.lua")
end

if SERVER then
	util.AddNetworkString( "scifi_givewep" )
end

----------------------------------
/**********************
**	GENERAL CONFIG	**
***********************/
----------------------------------

SCIFI_NPC_MODEL = "models/vortigaunt.mdl"

SCIFI_WEPS = {

{"weapon_fidget", 5, "High Quality Fidget Spinner", "Forged in the High Heavens, this metallic god-weapon will cut down your foes into tiny meat cubes. Made in China.", "vgui/entities/pocket.vmt"},
}

LEGGY_BUFFCOST = 20000

----------------------------------
/**********************
**	LANGUAGE			**
***********************/
----------------------------------

VENDOR_GREET_MSGS = {
"Well, we have officially ran out of stock. Good thing I have this endless supply of fidget spinners.",
"I am not proud of this...",
"We're restocking, until then have some high-quality fidget spinners."
}

----------------------------------
/**********************
**	SOUND FILES		**
***********************/
----------------------------------

VENDOR_INTRO_VO = {
"vo/npc/vortigaunt/vanswer05.wav",
"vo/npc/vortigaunt/vanswer13.wav",
"vo/npc/vortigaunt/vanswer14.wav",
"vo/npc/vortigaunt/mystery.wav",
"vo/npc/vortigaunt/stillhere.wav",
"vo/npc/vortigaunt/vques05.wav",
"vo/npc/vortigaunt/vques06.wav",
"vo/npc/vortigaunt/vques08.wav",
"vo/npc/vortigaunt/vques10.wav",
"vo/npc/vortigaunt/wewillhelp.wav",
}

VENDOR_PURCHASE_VO = {
"vo/npc/vortigaunt/gladly.wav",
"vo/npc/vortigaunt/satisfaction.wav",
"vo/npc/vortigaunt/livetoserve.wav",
"vo/npc/vortigaunt/pleasure.wav",
"vo/npc/vortigaunt/certainly.wav",
"vo/npc/vortigaunt/vanswer09.wav",
"vo/npc/vortigaunt/vanswer08.wav",
"vo/npc/vortigaunt/vanswer16.wav",
}
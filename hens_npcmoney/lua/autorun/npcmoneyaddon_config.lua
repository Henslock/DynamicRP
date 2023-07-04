--CODED BY HENS--

print("[[Money script loading - BY HENS]]")

if SERVER then
	AddCSLuaFile("npcmoney/sv_npcmoney.lua")
else
	AddCSLuaFile("npcmoney/sv_npcmoney.lua")
end

include("npcmoney/sv_npcmoney.lua")

/**************
*= NPC TABLE =*
**************/


-- If set to true, the amount of money you get from killing an NPC will be randomized around the base income, instead of being a consistent number
fluctuateMoney = true
npcsDropItems = true

--Toggle for Halloween Event
npc_halloween_event = false
npc_craftsman_drops = true
npc_drop_spellbooks = true

NPC_SIMPLEBOOK_CHANCE = 15
NPC_SIMPLEBOOK_UPGRADECHANCE = 30 --If a simple book drops, it has a 30% chance to proc as a advanced  book.

MONEY_MULT = 1.5
NPCLOOT_DESPAWN = 60 --Time in seconds before loot despawns


LOOT_TABLE = {

--[1] Standard HP and ammo
{"sfi_health"},
--[2] Contains HP, Power orbs, and Supply orbs, as well as ammo
{"sfi_shield", "sfi_health", "sfi_upgrade", "sfi_supplies"},
--[3] Shield, health, and artifact drops
{"sfi_shield", "sfi_health", "mgs_artifact"},
--[4] Drops sci-fi grenades and sci-fi orbs
{"sfi_health", "sfi_supplies", "sfi_upgrade", "weapon_sh_electricgrenade", "weapon_sh_healgrenade", "weapon_sh_percussiongrenade"}

}

--[[
{ENEMY, BASE PRICE, LOOT TABLE, DROP CHANCE (0 to 1)}
]]--

KILL_TABLE = {
	["npc_zombie"] = {
		money = 175,
		loot_table = LOOT_TABLE[2],
		chance = 0.65
	},	
	["npc_headcrab"] = {
		money = 55,
		loot_table = LOOT_TABLE[1],
		chance = 0.35
	},	
	["npc_headcrab_fast"] = {
		money = 75,
		loot_table = LOOT_TABLE[1],
		chance = 0.35
	},	
	["npc_poisonzombie"] = {
		money = 245,
		loot_table = LOOT_TABLE[2],
		chance = 0.85
	},	
	["npc_headcrab_poison"] = {
		money = 90,
		loot_table = LOOT_TABLE[2],
		chance = 0.5
	},	
	["npc_zombie_torso"] = {
		money = 55,
		loot_table = LOOT_TABLE[1],
		chance = 0.25
	},	
	["npc_headcrab_black"] = {
		money = 105,
		loot_table = LOOT_TABLE[2],
		chance = 0.65
	},	
	["npc_antlion"] = {
		money = 155,
		loot_table = LOOT_TABLE[3],
		chance = 0.55
	},	
	["npc_antlionguard"] = {
		money = 955,
		loot_table = LOOT_TABLE[3],
		chance = 0.55
	},	
	["npc_fastzombie"] = {
		money = 215,
		loot_table = LOOT_TABLE[2],
		chance = 0.85
	},
}

NPC_PHRASE = {
	
	["npc_zombie"] 					= "Sewer Zombie",
	["npc_zombie_torso"]			= "Sewer Crawler",
	["npc_headcrab"]				= "Sewer Headcrab",
	["npc_headcrab_fast"]		= "Fast Headcrab",
	["npc_poisonzombie"]			= "Poison Zombie",
	["npc_headcrab_black"]		= "Darkbite Headcrab",
	["npc_antlion"]					= "Antlion",
	["npc_soma_deepseadiver"]	= "Deep Sea Diver",
	["npc_soma_construct"]		= "Construct",
	["npc_soma_flesher"]			= "Flesher",
	["npc_headcrab_poison"]	= "Poison Zombie Headcrab",
	["npc_fastzombie"]				= "Sewer Frenzy Zombie"
}

--CODED BY HENS--

/*****************
* CONFIGURATIONS - PICKAXE
******************/

if SERVER then
	resource.AddWorkshop("1341451819")
	AddCSLuaFile("weapons/mgs_pickaxe/sv_playerinfo.lua")
	AddCSLuaFile("weapons/mgs_pickaxe/cl_perkmenu.lua")
	AddCSLuaFile("mining/mining_particleprecache.lua")
else

	AddCSLuaFile("weapons/mgs_pickaxe/sv_playerinfo.lua")
	AddCSLuaFile("weapons/mgs_pickaxe/cl_perkmenu.lua")
	AddCSLuaFile("mining/mining_particleprecache.lua")
	
	include("weapons/mgs_pickaxe/cl_perkmenu.lua")
	concommand.Add("pickaxe_prestige_menu", function() 
		pickaxe.PrestigeMenu = vgui.Create("Pickaxe:Menu") 
		pickaxe.PrestigeMenu:SetVisible(true) 
	end)
end

LevelUpSound 		= "levelup/sad_party_horn_01.wav"
LevelUpSoundMax 	= "levelup/funky_monkey_dance.wav"
PrestigeSound 	= "prestige/prestigesfx.wav"

if (!game.SinglePlayer() && SERVER) then
	resource.AddSingleFile("sound/"..LevelUpSound)
	resource.AddSingleFile("sound/"..LevelUpSoundMax)
	resource.AddSingleFile("sound/"..PrestigeSound)
end

-- precache
hook.Add( "InitPostEntity", "pickaxeInitSoundFiles", function()
	util.PrecacheSound( LevelUpSound );
	util.PrecacheSound( LevelUpSoundMax );
	util.PrecacheSound( PrestigeSound );
end );

/*****************
* ADDON CONFIG
******************/
----------------------------------
	-- PLEASE SET BASE OF YOUR GAMEMODE ( 2.5 (2.5.0 or 2.5.1) or 2.4 (2.4.3))
	MGS_GM_VERSION = 2.5
	-- Draw distance
	MGS_DISTANCE = 512
	-- Tools which helps players break rocks.
	MGS_MINING_TOOLS = {"mgs_pickaxe"}

	-- NEW -- Set 'true' to set new method of changing time in factory. Time will be set by ore's times which you will set in ore settings.
	MGS_NEW_TIME = true
	

----------------------------------
/*****************
* PERKS CONFIG
******************/
----------------------------------

-- rp_downtown_tits: Mine
-- 3504.130127 4478.659180 -924.696289

PERK_TP_POS = Vector(3685.971191, 4229.791504, -925.782776)
--PERK_TP_POS = Vector(0, 0, 0)

PERK_TP_CHARGETIME = 5

PERK_TP_COOLDOWN = 150

PERK_HALLOWEEN_EVENT = false

--[[
{ID, NAME ID,  ICON IMAGE, POINT_COST, MONEY_COST, REPEATABLE}
]]--

PERKS_TABLE = {

{0, "perk_tp", "icons/ico_tp", "TELEPORTATION", "Hold right click to teleport to the caves. 5min Cooldown.", 1, 250000, 0},
{1, "perk_rxp", "icons/ico_rockxp", "BONUS MINING XP", "Mining rocks now grant 2.5x experience.", 1, 100000, 0},
{2, "perk_axp", "icons/ico_artxp", "BONUS ARTIFACT XP", "Artifacts grant an additional 50% experience.", 1, 100000, 0},
{3, "perk_artboost", "icons/ico_artboost", "ARTIFACT CHANCE BOOST", "Base chance of discovering an artifact increased by 5%.", 1, 250000, 0},
{4, "perk_oreprice", "icons/ico_oreprice", "BONUS ORE PRICES", "Ores are worth 25% more.", 1, 100000, 0},
{5, "perk_artprice", "icons/ico_artmoney", "BONUS ARTIFACT PRICES", "Artifacts are worth 15% more.", 1, 150000, 0},
{6, "perk_magicmoney", "icons/ico_magicmoney", "MAGIC MONEY", "Money from factories automatically goes into your wallet.", 1, 250000, 0},
{7, "perk_chronofactories", "icons/ico_chronofactories", "CHRONO FACTORIES", "Reduces factory processing time by 80%.", 1, 250000, 0},
{8, "perk_jackpotart", "icons/ico_jackpotart", "JACKPOT ARTIFACTS", "Getting a jackpot guarantees an artifact spawn.", 1, 75000, 0},
{9, "perk_bonusrockdmg", "icons/ico_bonusrockdmg", "BONUS ROCK DAMAGE", "Deal an extra 5 damage to rocks per swing.", 1, 150000, 0},
{10, "perk_largepick", "icons/ico_largepick", "LARGE PICKAXE", "Your pickaxe is now massive and has extended reach. Woah.", 1, 500000, 0},
{11, "perk_agility", "icons/ico_agility", "AGILITY", "Increases movement speed by 25%.",1, 200000, 0},
{12, "perk_mspeed", "icons/ico_speed", "MINING SPEED", "Increases your base mining speed by 10%.", 1, 150000, 0},
{13, "perk_meleedmg", "icons/ico_bonusdmg", "BONUS MELEE DAMAGE", "Your pickaxe deals extra damage to enemies.", 1, 250000, 0},
{14, "perk_rcolor", "icons/ico_rcolor", "PAINTBRUSH PICKAXE", "Mining rocks has a chance to change the rocks color.", 1, 500000, 0},
{15, "perk_glow", "icons/ico_glow", "OMINOUS GLOW", "Your character has an ominous glow while holding your pickaxe.", 1, 2500000, 0},
{16, "perk_voidore", "icons/ico_voidore", "VOID ORES", "Increases ore prices by 5% per stack. Repeatable.", 1, 20000, 1},
{17, "perk_voidartifacts", "icons/ico_voidartifacts", "VOID ARTIFACTS", "Increases artifact experience by 20% per stack. Repeatable.", 1, 15000, 1},
{18, "perk_heavenlyjackpots", "icons/ico_heavenlyjackpot", "HEAVENLY JACKPOTS", "Increases jackpot chances by 1.5% per stack. Repeatable.", 1, 21500, 1},
{19, "perk_enhancedmining", "icons/ico_enhancedmining", "ENHANCED MINING", "Increases experience from mining rocks by 30% per stack. Repeatable.", 1, 40000, 1},
{20, "perk_powersmash", "icons/ico_powersmash", "POWER SMASH", "Increases your chance to instantly break a mineable rock, at 5% per stack. Repeatable", 1, 50000, 1},
{21, "perk_powerlevel", "icons/ico_powerlevel", "POWER LEVELING", "Increases your chance to level twice by 8% per stack. Repeatable.", 1, 550000, 1},
{22, "perk_candy", "icons/ico_candy", "CANDY MINING", "Mining rocks now has a chance to spawn candy.", 1, 150000, 0},
}

----------------------------------
/*****************
* PICKAXE CONFIG
******************/
----------------------------------

--[[
EXP TABLE BREAKDOWN:

LEVEL, EXP NEEDED TO LEVEL, PICK NAME, JACKPOT CHANCE, ARTIFACT CHANCE
]]--

MAX_LEVEL = 35

LEVELING_TABLE = {
[0] = {3, "Basic", 				0,			0},
[1] = {6, "Basic", 				0,			0},
[2] = {8, "Basic", 				0,			0},
[3] = {10, "Basic", 			0,			0},
[4] = {12, "Basic", 			0,			0},
[5] = {14, "Copper", 			0.1,		0},
[6] = {16, "Copper", 			0.1,		0},
[7] = {18, "Copper", 			0.1,		0},
[8] = {20, "Copper", 			0.1,		0},
[9] = {22, "Copper", 			0.1,		0},
[10] = {24, "Bronze", 		0.25,		1},
[11] = {26, "Bronze", 		0.25,		1},
[12] = {28, "Bronze", 		0.25,		1},
[13] = {30, "Bronze", 		0.25,		1},
[14] = {35, "Bronze", 		0.25,		1},
[15] = {80, "Iron", 			1,			1},
[16] = {120, "Iron", 			1.25,		1},
[17] = {150, "Iron", 			1.5,		1},
[18] = {200, "Iron", 			1.75,		1},
[19] = {250, "Iron", 			1.9,		1},
[20] = {300, "Steel", 			2,			3},
[21] = {450, "Steel", 			2.25,		3.5},
[22] = {500, "Steel", 			2.5,		4},
[23] = {550, "Steel", 			2.75,		4.25},
[24] = {600, "Steel", 			2.9,		4.75},
[25] = {700, "Osmium", 	3.5,		5},
[26] = {850, "Osmium", 	3.85,		7},
[27] = {900, "Osmium", 	4,			9},
[28] = {1050, "Osmium", 	4.25,		12},
[29] = {1200, "Osmium", 	4.5,		13},
[30] = {1550, "Diamond", 	5,			16},
[31] = {1800, "Diamond", 	5.5,		17},
[32] = {2000, "Diamond", 	6,			18},
[33] = {2350, "Diamond", 	6.5,		19},
[34] = {2750, "Diamond", 	7,			20},
[35] = {1, "Astronium", 		7.5,		30},
}
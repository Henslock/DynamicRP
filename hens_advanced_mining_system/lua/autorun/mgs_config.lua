/*****************
* CONFIGURATIONS FOR ROCKS
******************/


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
	
	CART_MAX_ORES = 20
----------------------------------
/*****************
* ROCKS CONFIG
******************/
----------------------------------
	--Tier 1 Rocks
	MGS1_MIN_LEVEL = 1
	
	MGS1_MAX_LEVEL = 3
	
		--Tier 2 Rocks
	MGS2_MIN_LEVEL = 4
	
	MGS2_MAX_LEVEL = 6
	
		--Tier 3 Rocks
	MGS3_MIN_LEVEL = 7
	
	MGS3_MAX_LEVEL = 9
	
		--Tier 4 Rocks
	MGS4_MIN_LEVEL = 10
	
	MGS4_MAX_LEVEL = 15
	
	-- Set Maximum number of ores which will be spawned.
	MGS_CREATE_ORE = 3
	-- Set rocks' health.
	MGS_ROCK_HEALTH = 10
	-- Respawning rocks time.
	MGS_ROCK_REPLACE_TIMER = 15

	--Custom models for rocks.
	MGS1_ROCK_MODELS = {"models/props/cs_militia/militiarock05.mdl", "models/props_canal/rock_riverbed02b.mdl", "models/props_canal/rock_riverbed02c.mdl", "models/props/de_inferno/de_inferno_boulder_01.mdl", "models/props/de_inferno/de_inferno_boulder_03.mdl"}
	MGS2_ROCK_MODELS = {"models/props_wasteland/rockgranite02c.mdl", "models/props_wasteland/rockgranite02a.mdl", "models/props_wasteland/rockgranite03c.mdl", "models/props/de_inferno/de_inferno_boulder_03.mdl"}
	MGS3_ROCK_MODELS = {"models/props_wasteland/rockgranite03a.mdl", "models/props_wasteland/rockgranite02c.mdl", "models/props_wasteland/rockcliff01k.mdl", "models/props_wasteland/rockcliff01b.mdl"}
	MGS4_ROCK_MODELS = {"models/props_canal/rock_riverbed02c.mdl", "models/props/cs_militia/militiarock03.mdl", "models/props/cs_militia/militiarock02.mdl", "models/props_wasteland/rockcliff01k.mdl"}
----------------------------------
/*****************
* ORES CONFIG
******************/
----------------------------------
	-- Removing ore time which isn't used.
	MGS_ORE_REMOVE_TIME = 30
	
	JACKPOT_CHANCE = 3

	-- Custom models for ores
	MGS_ORE_MODELS = {"models/props_junk/rock001a.mdl"}

	-- Ore types
	-- Example: "Gold" - name for ore,
	--		   	"Color(255,255,0)" -- color,
	--		   	"10" - cost for one kg,
	--		  	"math.Rand(7,15)" - random mass also you can use "15" or another integer value.
	--    NEW   "0.5" - chance between 0 and 1. Less this number, more likely that ore will be spawned.
	--    NEW   "20" - time for ore to be broken.
	--	   CUSTOM "material" for each ore
	--    FLUCTUATION VARIABLE controls how much the drop rate changes (up or down) when you encounter a higher level rock
	--	  CUSTOM MODEL
	--	  RARITY
	
	RARITY_COMMON 		= 0
	RARITY_UNCOMMON 	= 1
	RARITY_RARE 			= 2
	RARITY_EPIC			= 3
	RARITY_LEGENDARY 	= 4

	MGS1_ORE_TYPES = {
		{"Stone", Color(255,255,255), 5, math.Rand(1, 10), 0.1, 1, "", 0.9, "", RARITY_COMMON},
		{"Coal", Color(5,5,5), 10, math.Rand(4, 7), 0.25, 3, "", 0.75, "", RARITY_COMMON},
		{"Copper", Color(194,138,94), 12, math.Rand(3, 5), 0.8, 5, "", -0.7, "", RARITY_COMMON},
		{"Tin", Color(192,192,192), 12, math.Rand(3, 5), 0.8, 5, "models/player/player_chrome1.vtf", -0.7, "", RARITY_COMMON},
		{"Old Shoe", Color(255,255,255), 5, math.Rand(1, 1), 0.2, 1, "", 0.8, "models/props_junk/shoe001a.mdl", RARITY_COMMON},
		{"Broken Radio", Color(255,255,255), 5, math.Rand(1, 1), 0.2, 1, "", 0.8, "models/props/cs_office/radio.mdl", RARITY_COMMON},
		{"Bobby", Color(255,255,255), 10, math.Rand(4, 8), 0.3, 3, "", 0.6, "models/props/cs_office/Snowman_face.mdl", RARITY_UNCOMMON},
		{"Crooked's Melon", Color(255,255,255), 15, math.Rand(5, 10), 1.0, 3, "", -0.1, "models/props_junk/watermelon01.mdl", RARITY_RARE},
		{"Blanca's Dinner", Color(255,255,255), 15, math.Rand(5, 10), 1.0, 3, "", -0.1, "models/props_junk/garbage_takeoutcarton001a.mdl", RARITY_RARE},
		{"Volt's Newspaper", Color(255,255,255), 15, math.Rand(5, 10), 1.0, 3, "", -0.1, "models/props_junk/garbage_newspaper001a.mdl", RARITY_RARE},
		{"Mannstein's Steam", Color(255,255,255), 15, math.Rand(5, 10), 1.0, 3, "", -0.1, "models/props_interiors/pot01a.mdl", RARITY_RARE},
		{"Yo WTF", Color(255,255,255), 15, math.Rand(5, 10), 1.0, 3, "", -0.1, "models/props_lab/jar01b.mdl", RARITY_RARE},
		{"Frying Pan", Color(255,255,255), 25, math.Rand(2, 4), 0.7, 5, "", -0.1, "models/props_c17/metalPot002a.mdl", RARITY_UNCOMMON},
		{"Family Photo", Color(255,255,255), 65, math.Rand(1, 1), 1.0, 3, "", -0.3, "models/props_lab/frame002a.mdl", RARITY_UNCOMMON},
		{"Chillstone", Color(255,255,255), 185, math.Rand(3, 6), 1.0, 10, "models/props/de_inferno/offwndwb_break.vtf", -0.05, "", RARITY_LEGENDARY},
		
	}
	
	MGS2_ORE_TYPES = {
		{"Iron", Color(255,255,255), 15, math.Rand(5, 15), 0.5, 5, "models/props_canal/coastmap_sheet.vtf", -0.25, "", RARITY_UNCOMMON},
		{"Silver", Color(255,255,255), 18, math.Rand(5, 10), 0.5, 3, "phoenix_storms/Fender_Chrome.vtf", -0.25, "", RARITY_UNCOMMON},
		{"Gold", Color(255,255,0), 25, math.Rand(5, 12), 0.85, 5, "models/player/shared/gold_player.vtf", -0.45, "", RARITY_UNCOMMON},
		{"Adamantium", Color(255,97,0), 20, math.Rand(5, 10), 0.6, 3, "models/props_combine/prtl_sky_sheet.vtf", -0.1, "", RARITY_UNCOMMON},
		{"Copper", Color(194,138,94), 12, math.Rand(3, 5), 0.15, 5, "", 0.85, "", RARITY_COMMON},
		{"Tin", Color(192,192,192), 12, math.Rand(3, 5), 0.15, 5, "models/player/player_chrome1.vtf", 0.85, "", RARITY_COMMON},
		{"Family Photo", Color(255,255,255), 65, math.Rand(1, 1), 0.9, 3, "", 0.05, "models/props_lab/frame002a.mdl", RARITY_UNCOMMON},
		{"Steel Frying Pan", Color(255,255,255), 55, math.Rand(2, 4), 0.9, 5, "models/gibs/metalgibs/metal_gibs.vtf", -0.1, "models/props_c17/metalPot002a.mdl", RARITY_RARE},
		{"Phasmium", Color(255,255,255), 205, math.Rand(3, 6), 1.0, 10, "models/props_combine/stasisshield_sheet.vtf", -0.05, "", RARITY_LEGENDARY},
		{"Ducky", Color(255,255,255), 55, math.Rand(3, 6), 0.9, 3, "", -0.1, "models/props/cs_militia/fishriver01.mdl", RARITY_RARE},
	}
	
	MGS3_ORE_TYPES = {
		{"Silver", Color(255,255,255), 18, math.Rand(5, 10), 0.15, 3, "phoenix_storms/Fender_Chrome.vtf", 0.65, "", RARITY_UNCOMMON},
		{"Osmium", Color(170,0,255), 20, math.Rand(5, 12), 0.25, 7, "models/shiny.vtf", 0.55, "", RARITY_RARE},
		{"Gold", Color(255,255,0), 21, math.Rand(5, 12), 0.25, 5, "models/player/shared/gold_player.vtf", 0.55, "", RARITY_UNCOMMON},
		{"Ruby", Color(255,0,0), 32, math.Rand(5, 12), 0.75, 10, "", -0.50, "", RARITY_RARE},
		{"Sapphire", Color(0,0,255), 32, math.Rand(5, 12), 0.75, 10, "", -0.50, "", RARITY_RARE},
		{"Legato's Cheese", Color(255,255,255), 100, math.Rand(5, 10), 1.0, 3, "", -0.1, "models/foodnhouseholditems/cheesewheel1b.mdl", RARITY_EPIC},
		{"Husky's Musk", Color(255,255,255), 100, math.Rand(5, 10), 1.0, 3, "", -0.1, "models/foodnhouseholditems/winebottle2.mdl", RARITY_EPIC},
		{"Obsidian", Color(140,0,255), 45, math.Rand(7, 15), 0.95, 7, "models/props/CS_militia/RoofEdges.vtf", -0.05, "", RARITY_EPIC},
		{"Platinum", Color(255,255,255), 35, math.Rand(4, 15), 0.8, 10, "models/player/shared/ice_player.vtf", -0.10, "", RARITY_RARE},
		{"Diamond", Color(0,255,255), 55, math.Rand(7, 15), 0.95, 12, "phoenix_storms/trains/track_beamtop.vtf", -0.05, "", RARITY_EPIC},
		{"Crofthart", Color(255,255,255), 250, math.Rand(3, 8), 1.0, 10, "models/props_combine/tprings_globe.vtf", -0.03, "", RARITY_LEGENDARY},
	}
	
	MGS4_ORE_TYPES = {
		{"Ruby", Color(255,0,0), 32, math.Rand(5, 12), 0.15, 10, "", 0.70, "", RARITY_RARE},
		{"Sapphire", Color(0,0,255), 32, math.Rand(5, 12), 0.15, 10, "", 0.70, "", RARITY_RARE},
		{"Platinum", Color(255,255,255), 35, math.Rand(12, 18), 0.25, 10, "models/player/shared/ice_player.vtf", 0.10, "", RARITY_RARE},
		{"Obsidian", Color(140,0,255), 45, math.Rand(7, 15), 0.65, 7, "models/props/CS_militia/RoofEdges.vtf", -0.45, "", RARITY_EPIC},
		{"Diamond", Color(0,255,255), 55, math.Rand(10, 20), 0.75, 12, "phoenix_storms/trains/track_beamtop.vtf", -0.55, "", RARITY_EPIC},
		{"Uranium", Color(255,255,255), 60, math.Rand(12, 15), 0.90, 12, "models/props_lab/xencrystal_sheet.vtf", -0.25, "", RARITY_EPIC},
		{"Husky's Musk", Color(255,255,255), 100, math.Rand(5, 10), 1.0, 3, "", -0.1, "models/foodnhouseholditems/winebottle2.mdl", RARITY_EPIC},
		{"Henslock's Hat", Color(255,255,255), 150, math.Rand(5, 10), 1.0, 1, "", -0.08, "models/props_junk/TrafficCone001a.mdl", RARITY_EPIC},
		{"Fairy Stone", Color(255,255,255), 200, math.Rand(10, 20), 1.0, 1, "models/props/cs_office/clouds.vtf", -0.06, "", RARITY_LEGENDARY},
		{"Astronium", Color(255,255,255), 300, math.Rand(10, 20), 1.0, 1, "models/XQM/LightLinesRed.vtf", -0.04, "", RARITY_LEGENDARY},
		{"Holy Hula Girl", Color(255,255,255), 800, math.Rand(10, 20), 1.0, 1, "", -0.02, "models/props_lab/huladoll.mdl", RARITY_LEGENDARY}
	}
	
----------------------------------
/*****************
* ARTIFACT CONFIG
******************/
----------------------------------
MGS_ARTIFACT_MODELS = {"models/props_c17/pottery06a.mdl", "models/props_c17/pottery05a.mdl", "models/props_c17/pottery09a.mdl", "models/props_c17/pottery03a.mdl", "models/props_c17/pottery_large01a.mdl", "models/props_combine/breenbust.mdl", "models/props_combine/breenglobe.mdl", "models/props_junk/bicycle01a.mdl", "models/props_lab/monitor01a.mdl", "models/props_citizen_tech/guillotine001a_wheel01.mdl", "models/Gibs/HGIBS.mdl", "models/weapons/w_crossbow.mdl", "models/Combine_Helicopter/helicopter_bomb01.mdl", "models/props_lab/cactus.mdl", "models/props_c17/BriefCase001a.mdl"}

MGS_ARTIFACT_MIN_PRICE = 500
MGS_ARTIFACT_MAX_PRICE = 1050

MGS_ARTIFACT_MIN_EXP = 25
MGS_ARTIFACT_MAX_EXP = 40

----------------------------------
/*****************
* FACTORY CONFIG
******************/
----------------------------------
	-- Crushing time.
	MGS_CRUSH_TIME = 10
	-- Safe mode. If you sets 'false' it will spawn money as entity, else money would be add to player.
	MGS_SAFEMODE = true
	-- Enable crush effects.
	MGS_CRUSH_EFFECT = true
----------------------------------

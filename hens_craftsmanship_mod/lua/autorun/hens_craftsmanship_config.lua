/*****************
* CONFIGURATIONS
******************/

if SERVER then
	resource.AddWorkshop("1393335901")
	AddCSLuaFile("weapons/cl_inventory.lua")
	AddCSLuaFile("drawarc.lua")
else
	AddCSLuaFile("drawarc.lua")
	AddCSLuaFile("weapons/crft_axe/sv_plrstats.lua")
	AddCSLuaFile("weapons/crft_axe/cl_inventory.lua")
	
	include("drawarc.lua")
	include("weapons/crft_axe/sv_plrstats.lua")
	include("weapons/crft_axe/cl_inventory.lua")
	
	
	concommand.Add("crafting_inventory_menu", function() 
		crafting.InvMenu = vgui.Create("Crafting:InventoryMain") 
		crafting.InvMenu:SetVisible(true) 
	end)
end

/*****************
* ADDON CONFIG
******************/
----------------------------------
	-- PLEASE SET BASE OF YOUR GAMEMODE ( 2.6 or 2.5 or 2.4 (2.4.3))
	SWM_GM_VERSION    = 2.6
	-- Draw distance
	SWM_DISTANCE      = 512
	-- Tools which helps players cut trees.
	SWM_CUTTING_TOOLS = {"crft_axe"}
	
	PERMITTED_TEAM = LUMBERJACK
	
	CRFT_HOLIDAYTREES = false
	
	CRFT_PRESTIGE_ENABLED = false
	
	
	-- Configure Material Drops
	CRAFTSMANSHIP_MATS_DROP = {
		["mat_oakwood"] = {
			name = "Oak Log",
			dropicon = ("materials/UI/maticons/ico_wood.png"),
			dropmodel = "models/crafting/log.mdl",
			dropcolor = Color(232, 212, 148, 255)
		},
		["mat_birchwood"] = {
			name = "Birch Log",
			dropicon = ("materials/UI/maticons/ico_wood.png"),
			dropmodel = "models/crafting/log.mdl",
			dropcolor = Color(201, 201, 201, 255)
		},
		["mat_maplewood"] = {
			name = "Maple Log",
			dropicon = ("materials/UI/maticons/ico_wood.png"),
			dropmodel = "models/crafting/log.mdl",
			dropcolor = Color(232, 165, 158, 255)
		},
		["mat_ancientsap"] = {
			name = "Sap Bottle",
			dropicon = ("materials/UI/maticons/ico_jar.png"),
			dropmodel = "models/foodnhouseholditems/winebottle2.mdl",
			dropcolor = Color(195, 122, 255, 255)
		},
		["mat_ironberry"] = {
			name = "Ironberry Nugget",
			dropicon = ("materials/UI/maticons/ico_ironberry.png"),
			dropmodel = "models/crafting/ironberry.mdl",
			dropcolor = Color(162, 217, 249, 255)
		},
		["mat_treecore"] = {
			name = "Tree Core",
			dropicon = ("materials/UI/maticons/ico_treecore.png"),
			dropmodel = "models/crafting/treecore.mdl",
			dropcolor = Color(126, 255, 86, 255)
		},
		["mat_cloth"] = {
			name = "Cloth Piece",
			dropicon = ("materials/UI/maticons/ico_cloth.png"),
			dropmodel = "models/crafting/cloth.mdl",
			dropcolor = Color(255, 255, 255, 255)
		},
		["mat_monsterparts"] = {
			name = "Monster Parts",
			dropicon = ("materials/UI/maticons/ico_monsterparts.png"),
			dropmodel = {"models/Gibs/HGIBS.mdl"},
			dropcolor = Color(252, 75, 75, 255)
		},
		["mat_embercore"] = {
			name = "Ember Core",
			dropicon = ("materials/UI/maticons/ico_treecore.png"),
			dropmodel = "models/crafting/treecore.mdl",
			dropcolor = Color(245, 75, 105, 255)
		},
	}
	
	
	-- Configure Material Details
	CRAFTSMANSHIP_MATS = {
	
		[1] =  {
		tag = 	"mat_oakwood", 
		name = "Oak Wood", 
		desc = 	"Standard oak wood. Used in many crafting recipes.", 
		model = "models/crafting/log.mdl",
		mat = "crafting/log",
		ui_vec = Vector(-18, -10, 15),
		basecarry = 20
		},
		
		[2] =  {
		tag = 	"mat_birchwood", 
		name = "Birch Wood", 
		desc = 	"Standard birch wood. Used in many crafting recipes.", 
		model = "models/crafting/log.mdl",
		mat = "crafting/log_birch",
		ui_vec = Vector(-18, -10, 15),
		basecarry = 20
		},
		
		[3] =  {
		tag = 	"mat_maplewood", 
		name = "Maple Wood", 
		desc = 	"Standard maple wood. Used in many crafting recipes.", 
		model = "models/crafting/log.mdl",
		mat = "crafting/log_maple",
		ui_vec = Vector(-18, -10, 15),
		basecarry = 20
		},
		
		[4] =  {
		tag = 	"mat_ancientsap", 
		name = "Ancient Sap", 
		desc = 	"A rare ingredient found from common trees. Used as a binding agent for advanced crafting recipes.", 
		model = "models/foodnhouseholditems/winebottle2.mdl",
		ui_vec = Vector(-5, 20, 0),
		basecarry = 5
		},
		
		[5] =  {
		tag = 	"mat_ironberry", 
		name = "Ironberry Ore", 
		desc = 	"Plucked from the Ironberry Bush, this peculiar material makes for a fine crafting reagent in metal-based recipes.", 
		model = "models/crafting/ironberry.mdl",
		ui_vec = Vector(-2, 7.5, 5),
		basecarry = 20
		},
		
		[6] =  {
		tag = 	"mat_treecore", 
		name = "Tree Core", 
		desc = 	"The core of a tree is what gives it life and nourishment. Used as an ingredient in advanced crafting recipes.", 
		model = "models/crafting/treecore.mdl",
		ui_vec = Vector(-5, 20, 0),
		basecarry = 5
		},		
		
		[7] =  {
		tag = 	"mat_cloth", 
		name = "Cloth", 
		desc = 	"A soft fabric that can be woven together for many crafts.", 
		model = "models/crafting/cloth.mdl",
		ui_vec = Vector(-5, 10, 10),
		basecarry = 10
		},
		
		[8] =  {
		tag = 	"mat_monsterparts", 
		name = "Monster Parts", 
		desc = 	"Parts of a monster, gross. Could be useful in specific crafts.", 
		model = "models/Gibs/HGIBS.mdl",
		ui_vec = Vector(-5, 5, 7),
		basecarry = 35
		},
		
		[9] =  {
		tag = 	"mat_embercore", 
		name = "Ember Core", 
		desc = 	"An ashen tree core, still emanating heat from its central core. Used as an ingredient in advanced crafting recipes.", 
		model = "models/crafting/treecore.mdl",
		mat = "crafting/embercore",
		ui_vec = Vector(-5, 20, 0),
		basecarry = 3
		},

	 }
----------------------------------
/*****************
* AXE CONFIG
******************/
----------------------------------

CRAFTING_MAX_LEVEL = 10

--[[ { LEVEL, RANK_NAME, LOG_CHANCE, SAP_CHANCE} ]]

CRAFTSMANSHIP_LEVELS = {
[0] = 	{10, 		"Novice"	,							20,		0},
[1] = 	{25, 		"Beginner"	,							20,		0},
[2] = 	{50, 	"Wood Chopper",						20,		0},
[3] = 	{125, 	"Handyman",							22.5,		0},
[4] = 	{175, 	"Novice Woodsmith",				25,		0},
[5] = 	{225, 	"Carpenter",							27.5,		0},
[6] = 	{350, 	"Specialist",							30,		2},
[7] = 	{500, 	"Crafting Artisan",					32.5,		2},
[8] = 	{625, 	"Expert Woodsmith",				35,		4},
[9] = 	{850, 	"Master Craftsman",				37.5,		4},
[10] = 	{1000, 	"Grandmaster Craftsman",		40,		6}
}

CRAFTSMANSHIP_TIPS = {

"Open your inventory with the 'N' key.",
"You can purchase perks to enhancing your woodcutting or craftsmanship.",
--"High demand furniture can sell for more than the regular alternatives.",
"Once a tree is completely broken it drops a bundle of wood.",
"Some craftable items can be sold to other players!",
--"You can increase your inventory space with perks.",
"Experience can be gained from both woodcutting and crafting.",
"Toys can be crafted once you are a Master Craftsman, try them out!",
"Ember Cores come from burning trees.",
--"After becoming a Master Craftsman, you can keep leveling up to earn new perk points.",

}
----------------------------------
/*****************
* TREES CONFIG
******************/
----------------------------------
	-- Set tree's health.
	SWM_TREE_HEALTH            = 25
	-- Respawning trees time.
	SWM_TREE_REPLACE_TIMER     = 30

	--Custom models for standart trees
	TREE_MODELS = 
	{
		OAK = {"models/crafting/oaktree.mdl"},
		BIRCH = "models/crafting/birchtree.mdl",
		MAPLE = "models/crafting/mapletree.mdl",
	}
	
	TREE_WOODSPAWN_SFX = {
	"physics/wood/wood_box_break1.wav",
	"physics/wood/wood_crate_impact_hard4.wav",
	"physics/wood/wood_plank_impact_hard1.wav",
	"physics/wood/wood_solid_impact_bullet1.wav",
	"physics/wood/wood_strain3.wav",
	"physics/wood/wood_strain2.wav",
	"physics/wood/wood_box_impact_soft1.wav",
	"physics/wood/wood_box_Impact_hard4.wav",
	"physics/wood/wood_furniture_break1.wav"
	}
	
	IRONBERRY_HARVESTTIME = 2

----------------------------------
/*****************
* LOGS CONFIG
******************/
----------------------------------
	-- Price for one Log.
	SWM_LOG_PRICE       = 90
	-- Removing log time which isn't used
	SWM_LOG_REMOVE_TIME = 25
	-- Maximum logs in cart.
	SWM_CART_MAX_LOGS   = 20
----------------------------------
/*****************
* SAWMILL CONFIG
******************/
----------------------------------
	-- Sawing time.
	SWM_SAW_TIME   = 3
	-- Safe mode. If you sets 'false' it will spawn money as entity, else money would be add to player.
	SWM_SAFEMODE   = false
	-- Enable sawing effects.
	SWM_SAW_EFFECT = true
----------------------------------

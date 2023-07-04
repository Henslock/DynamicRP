//**CONFIG**//

/*
							  -
		HENSLOCK's FANCY ALCHEMY ADDON
							  -
*/

FANCYALCHEMY_BATMULT = 0.5 			-- Amount that the bat familiar reduces prices by, default is 50%
FANCYALCHEMY_FELINECHANCE = 25 	-- Chance to double potions if you have a feline familiar
FANCYALCHEMY_OWLMULT = 1.5			-- Amount that the owl familiar multiplies experience gains
FANCYALCHEMY_TOADMULT = 0.5			-- Amount that the toad familiar reduces brewing times
FANCYALCHEMY_CROWCHANCE = 25 		-- Chance that potions will increase in quality by 1 with the crow familiar

// Configure experience required for each level
FANCYALCHEMY_LEVELTABLE = {
[1] = 3,
[2] = 8,
[3] = 10,
[4] = 14,
[5] = 18,
[6] = 25,
[7] = 35,
[8] = 50,
[9] = 75,
[10] = 100,
[11] = 120,
[12] = 150,
[13] = 175,
[14] = 200,
[15] = 250,
[16] = 300,
[17] = 350,
[18] = 500,
[19] = 650,
[20] = 1000,
}

// Configure the list of ingredients
FANCYALCHEMY_INGREDIENTS = {

	[1] = {
			tag = "delicious_fruit",
			model = "models/props/cs_italy/bananna_bunch.mdl",
			desc = "A basic ingredient found in many recipes. Useful in many healing potions.",
			reqlvl = 1,
			cost = 500,
			name = "Delicious Fruit",
			ui_vec = Vector(10, 10, 7),
			look_vec = Vector(0, 0, 0)
			},
	
	[2]  ={
			tag = "simple_mushroom",
			model = "models/food/mushroom/mushroom.mdl",
			desc = "A basic ingredient found in many recipes. Mushrooms are said to enhance agility.",
			reqlvl = 1,
			cost = 500,
			name = "Simple Mushroom",
			ui_vec =  Vector(7, 7, 12),
			look_vec = Vector(0, 0, 5)
			},	
	
	[3] = {
			tag = "garlic", 
			model = "models/food/garlic/garlic.mdl",
			desc = "A basic ingredient found in many recipes. The properties of garlic, when brewed correctly into a potion, can make the user feel lighter.",
			reqlvl = 1,
			cost = 750,
			name = "Garlic",
			ui_vec =  Vector(8, 8, 15),
			look_vec = Vector(0, 0, 7)
			},	
	
	[4] = {
			tag = "evergreen_fern", 
			model = "models/props/de_inferno/bushgreensmall.mdl",
			desc = "A useful ingredient for it's stamina and agility properties.",
			reqlvl = 3,
			cost = 1000,
			name = "Evergreen Fern",
			ui_vec = Vector(22, 22, 14),
			look_vec = Vector(0, 0, 0)
			},	
	
	[5] = {
			tag = "strange_catalyst",
			model = "models/mosi/skyrim/fooddrink/stew.mdl",
			desc = "This catalyst can be combined with many other ingredients to bring out their strengths.",
			reqlvl = 5,
			cost = 1000,
			name = "Strange Catalyst",
			ui_vec = Vector(5, 5, 6),
			look_vec = Vector(0, 0, 2)
			},	
	
	[6] =  {
			tag = "rich_tomato",
			model = "models/mosi/skyrim/fooddrink/tomato.mdl",
			desc = "It's oozing with a rich flavour, perhaps it can live up to its name?",
			reqlvl = 7,
			cost = 1250,
			name = "Rich Tomato",
			ui_vec = Vector(5, 5, 5),
			look_vec = Vector(0, 0, 2)
			},	
	
	[7] = {
			tag = "poison_brittleshroom",
			model = "models/food/mushroom_blue/mushroom_blue.mdl",
			desc = "Poisonous on its own, but its poison can be nullified when brewed together with other ingredients.",
			reqlvl = 9,
			cost = 1750,
			name = "Poison Brittleshroom",
			ui_vec = Vector(13, 13, 5),
			look_vec = Vector(0, 0, 5)
			},	
	
	[8] = {
			tag = "sweet_roll",
			model = "models/mosi/skyrim/fooddrink/sweetroll.mdl",
			desc = "What is this doing here? The sweet roll is a delicious snack that works best when mixed with other food-based ingredients.",
			reqlvl = 10,
			cost = 2250,
			name = "Sweet Roll",
			ui_vec = Vector(8, 8, 5),
			look_vec = Vector(0, 0, 5)
			},	
	
	[9] = {
			tag = "cursed_skull",
			model = "models/Gibs/HGIBS.mdl",
			desc = "The cursed skull can enhance many of the base ingredients to bring out a more potent product.",
			reqlvl = 12,
			cost = 3000,
			name = "Cursed Skull",
			ui_vec = Vector(12, 12, 5),
			look_vec = Vector(0, 0, 5)
			},	
	
	[10] = {
			tag = "headcrab_carcass",
			model = "models/headcrabclassic.mdl",
			desc = "Its exoskeleton may be very useful for armour potions.",
			reqlvl = 14,
			cost = 3500,
			name = "Headcrab Carcass",
			ui_vec = Vector(20, 20, 10),
			look_vec = Vector(0, 0, 5)
			},	
	
	[11] = {
			tag = "black_wine",
			model = "models/mosi/skyrim/fooddrink/blackbriarreserve.mdl",
			desc = "Excellent for enhancing poison potions, and it also works well as an enhancer liquid.",
			reqlvl = 15,
			cost = 3800,
			name = "Black Wine",
			ui_vec = Vector(9, 9, 4),
			look_vec = Vector(0, 0, 5)
			},	
	
	[12] = {
			tag = "rotten_pumpkin",
			model = "models/food/pumpkin/pumpkin01.mdl",
			desc = "Probably not a good idea to eat this, unless you are very careful.",
			reqlvl = 16,
			cost = 4000,
			name = "Rotten Pumpkin",
			ui_vec = Vector(20, 20, 20),
			look_vec = Vector(0, 0, 10)
			},	
	
	[13] = {
			tag = "windlegrench_heart",
			model = "models/mosi/skyrim/fooddrink/heart.mdl",
			desc = "A very potent ingredient used to create powerful potions.",
			reqlvl = 17,
			cost = 4400,
			name = "Windlegrench Heart",
			ui_vec = Vector(4, 4, 8),
			look_vec = Vector(0, 0, 3)
			},	
	
	[14] = {
			tag = "wicker_doll",
			model = "models/food/smoked_baby/cr_wickerdoll.mdl",
			desc = "The wicker doll is unique in that it greatly enhances the speed of successful brewings.",
			reqlvl = 18,
			cost = 12500,
			name = "Wicker Doll",
			ui_vec = Vector(15, 15, 20),
			look_vec = Vector(0, 0, 10)
			},	
	
	[15] = {
			tag = "pig_head",
			model = "models/food/boarhead/pig_head.mdl",
			desc = "The pig head contains a lot of potential in bringing out the most powerful brewings. Works well to create all types of potions.",
			reqlvl = 19,
			cost = 8500,
			name = "Pig Head",
			ui_vec = Vector(15, 15, 20),
			look_vec = Vector(0, 0, 5)
			},	
	
	[16] = {
			tag = "infant",
			model = "models/props_c17/doll01.mdl",
			desc = "Is this legal? Children, when sacrificed, offer the alchemist a large sum of experience. Additionally, they produce only the most powerful potions available.",
			reqlvl = 20,
			cost = 20000,
			name = "Infant",
			ui_vec = Vector(10, 10, 10),
			look_vec = Vector(0, 0, 0)
			},

}

FANCYALCHEMY_FAMILIARS = {

	[1] = {
		tag = "fa_familiar_fastbrew",
		icon = "materials/fancyalchemy/ui/ico_toad.png",
		name = "Toad Familiar",
		desc = "This familiar will make all future brewings 50% faster for this cauldron.",
		sound = "falch_fam_toad",
		reqlvl = 5,
		cost = 15000
	},	
	
	[2] = {
		tag = "fa_familiar_doublepotions",
		icon = "materials/fancyalchemy/ui/ico_cat.png",
		name = "Feline Familiar",
		desc = "Adopting this familiar gives you a chance to double your potions.",
		sound = "falch_fam_feline",
		reqlvl = 8,
		cost = 25000
	},	
	
	[3] = {
		tag = "fa_familiar_exp",
		icon = "materials/fancyalchemy/ui/ico_owl.png",
		name = "Owl Familiar",
		desc = "The wise owl familiar allows you to earn more experience from potions.",
		sound = "falch_fam_owl",
		reqlvl = 10,
		cost = 75000
	},	
	
	[4] = {
		tag = "fa_familiar_quality",
		icon = "materials/fancyalchemy/ui/ico_crow.png",
		name = "Crow Familiar",
		desc = "With a crow by your side, brewed potions have a chance to increase in quality.",
		sound = "falch_fam_crow",
		reqlvl = 15,
		cost = 15000
	},	
	
	[5] = {
		tag = "fa_familiar_reducedmaterials",
		icon = "materials/fancyalchemy/ui/ico_bat.png",
		name = "Bat Familiar",
		desc = "The bat familiar will allow you to brew more efficiently, reducing all material costs.",
		sound = "falch_fam_bat",
		reqlvl = 20,
		cost = 55000
	},
	
}

FANCYALCHEMY_RECIPES = {
	[1] = {
		recipe = {delicious_fruit = 3},
		reward = "fancyalchemy_health_potion",
		time = 8,
		xp = 3,
		quality = 1
	},	
	
	[2] = {
		recipe = {garlic = 2, delicious_fruit = 1},
		reward = "fancyalchemy_health_potion",
		time = 10,
		xp = 4,
		quality = 1
	},

	[3] = {
		recipe = {delicious_fruit = 1, garlic = 1, simple_mushroom =1},
		reward = "fancyalchemy_health_potion",
		time = 10,
		xp = 3,
		quality = 1
	},	
	
	[4] = {
		recipe = {simple_mushroom = 2, evergreen_fern =1},
		reward = "fancyalchemy_speed_potion",
		time = 10,
		xp = 3,
		quality = 1
	},	
	
	[5] = {
		recipe = {delicious_fruit = 1, evergreen_fern =2},
		reward = "fancyalchemy_health_potion",
		time = 8,
		xp = 4,
		quality = 1
	},		
	
	[6] = {
		recipe = {delicious_fruit = 2, evergreen_fern = 1},
		reward = "fancyalchemy_health_potion",
		time = 8,
		xp = 4,
		quality = 1
	},	
	
	[7] = {
		recipe = {simple_mushroom = 1, evergreen_fern =1, garlic =1},
		reward = "fancyalchemy_speed_potion",
		time = 8,
		xp = 4,
		quality = 1
	},	
	
	[8] = {
		recipe = {strange_catalyst = 1, simple_mushroom =1, evergreen_fern =1},
		reward = "fancyalchemy_mystery_potion",
		time = 12,
		xp = 5,
		quality = 1
	},		
	
	[9] = {
		recipe = {strange_catalyst = 1, garlic =2},
		reward = "fancyalchemy_gravity_potion",
		time = 10,
		xp = 4,
		quality = 1
	},		
	
	[10] = {
		recipe = {strange_catalyst = 1, delicious_fruit =1, simple_mushroom=1},
		reward = "fancyalchemy_health_potion",
		time = 10,
		xp = 6,
		quality = 2
	},		
	
	[11] = {
		recipe = {rich_tomato = 1, strange_catalyst =1, simple_mushroom=1},
		reward = "fancyalchemy_wealth_potion",
		time = 16,
		xp = 5,
		quality = 1
	},		
	
	[12] = {
		recipe = {rich_tomato = 1, strange_catalyst =1, delicious_fruit=1},
		reward = "fancyalchemy_wealth_potion",
		time = 16,
		xp = 5,
		quality = 1
	},		
	
	[13] = {
		recipe = {rich_tomato = 3},
		reward = "fancyalchemy_wealth_potion",
		time = 22,
		xp = 5,
		quality = 2
	},		
	
	[14] = {
		recipe = {rich_tomato = 1, delicious_fruit=1, simple_mushroom=1},
		reward = "fancyalchemy_health_potion",
		time = 16,
		xp = 5,
		quality = 2
	},		
	
	[15] = {
		recipe = {poison_brittleshroom = 3},
		reward = "fancyalchemy_poison_potion",
		time = 16,
		xp = 6,
		quality = 2
	},		
	
	[16] = {
		recipe = {poison_brittleshroom = 1, delicious_fruit = 1, simple_mushroom=1},
		reward = "fancyalchemy_poison_potion",
		time = 16,
		xp = 5,
		quality = 1
	},		
	
	[17] = {
		recipe = {poison_brittleshroom = 1, delicious_fruit = 2},
		reward = "fancyalchemy_poison_potion",
		time = 16,
		xp = 5,
		quality = 1
	},		
	
	[18] = {
		recipe = {poison_brittleshroom = 1, strange_catalyst = 1, garlic=1},
		reward = "fancyalchemy_gravity_potion",
		time = 12,
		xp = 6,
		quality = 2
	},		
	
	[19] = {
		recipe = {poison_brittleshroom = 1, strange_catalyst = 1, evergreen_fern=1},
		reward = "fancyalchemy_mystery_potion",
		time = 18,
		xp = 6,
		quality = 2
	},		
	
	[20] = {
		recipe = {poison_brittleshroom = 1, strange_catalyst = 1, simple_mushroom=1},
		reward = "fancyalchemy_speed_potion",
		time = 12,
		xp = 6,
		quality = 2
	},		
	
	[21] = {
		recipe = {poison_brittleshroom = 1, rich_tomato =2},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 7,
		quality = 3
	},		
	
	[22] = {
		recipe = {sweet_roll = 1, rich_tomato =2},
		reward = "fancyalchemy_wealth_potion",
		time = 22,
		xp = 7,
		quality = 2
	},		
	
	[23] = {
		recipe = {sweet_roll = 1, delicious_fruit =2},
		reward = "fancyalchemy_health_potion",
		time = 12,
		xp = 7,
		quality = 2
	},		
	
	[24] = {
		recipe = {sweet_roll = 1, strange_catalyst =1, evergreen_fern=1},
		reward = "fancyalchemy_speed_potion",
		time = 12,
		xp = 7,
		quality = 2
	},		
	
	[25] = {
		recipe = {sweet_roll = 1, strange_catalyst =1, garlic=1},
		reward = "fancyalchemy_gravity_potion",
		time = 12,
		xp = 7,
		quality = 2
	},		
	[26] = {
		recipe = {sweet_roll = 1, delicious_fruit =1, simple_mushroom=1},
		reward = "fancyalchemy_health_potion",
		time = 12,
		xp = 7,
		quality = 3
	},		
	[27] = {
		recipe = {sweet_roll = 1, strange_catalyst =1, rich_tomato=1},
		reward = "fancyalchemy_wealth_potion",
		time = 30,
		xp = 7,
		quality = 3
	},		
	[28] = {
		recipe = {sweet_roll = 1, strange_catalyst =1, poison_brittleshroom=1},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 7,
		quality = 3
	},		
	[29] = {
		recipe = {cursed_skull = 1, strange_catalyst =1, poison_brittleshroom=1},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 7,
		quality = 3
	},		
	[30] = {
		recipe = {cursed_skull = 1, poison_brittleshroom=2},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 7,
		quality = 3
	},		
	[31] = {
		recipe = {cursed_skull = 1, strange_catalyst=1, garlic=1},
		reward = "fancyalchemy_gravity_potion",
		time = 12,
		xp = 7,
		quality = 3
	},		
	[32] = {
		recipe = {cursed_skull = 1, strange_catalyst=1, evergreen_fern=1},
		reward = "fancyalchemy_speed_potion",
		time = 12,
		xp = 7,
		quality = 3
	},			
	[33] = {
		recipe = {cursed_skull = 1, strange_catalyst=1, simple_mushroom=1},
		reward = "fancyalchemy_speed_potion",
		time = 12,
		xp = 7,
		quality = 3
	},		
	[34] = {
		recipe = {cursed_skull = 1, strange_catalyst=1, delicious_fruit=1},
		reward = "fancyalchemy_health_potion",
		time = 12,
		xp = 7,
		quality = 3
	},		
	[35] = {
		recipe = {cursed_skull = 1, strange_catalyst=1, rich_tomato=1},
		reward = "fancyalchemy_wealth_potion",
		time = 30,
		xp = 7,
		quality = 3
	},		
	[36] = {
		recipe = {headcrab_carcass = 3},
		reward = "fancyalchemy_armor_potion",
		time = 8,
		xp = 4,
		quality = 1
	},		
	[37] = {
		recipe = {headcrab_carcass = 1, strange_catalyst=1, cursed_skull=1},
		reward = "fancyalchemy_armor_potion",
		time = 18,
		xp = 8,
		quality = 3
	},		
	[38] = {
		recipe = {headcrab_carcass = 2, strange_catalyst=1},
		reward = "fancyalchemy_armor_potion",
		time = 14,
		xp = 6,
		quality = 2
	},		
	[39] = {
		recipe = {headcrab_carcass = 2, cursed_skull=1},
		reward = "fancyalchemy_armor_potion",
		time = 14,
		xp = 6,
		quality = 2
	},		
	[40] = {
		recipe = {headcrab_carcass = 1, simple_mushroom=2},
		reward = "fancyalchemy_armor_potion",
		time = 8,
		xp = 4,
		quality = 1
	},		
	[41] = {
		recipe = {headcrab_carcass = 2, simple_mushroom=1},
		reward = "fancyalchemy_armor_potion",
		time = 8,
		xp = 4,
		quality = 1
	},			
	[42] = {
		recipe = {headcrab_carcass = 1, simple_mushroom=1, delicious_fruit=1},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 10,
		quality = 3
	},		
	[43] = {
		recipe = {headcrab_carcass = 1, delicious_fruit=2},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 10,
		quality = 3
	},		
	[44] = {
		recipe = {black_wine = 1, poison_brittleshroom=1, strange_catalyst=1},
		reward = "fancyalchemy_poison_potion",
		time = 18,
		xp = 15,
		quality = 4
	},		
	[45] = {
		recipe = {black_wine = 1, poison_brittleshroom=2},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 10,
		quality = 3
	},	
	[46] = {
		recipe = {black_wine = 1, delicious_fruit=1, simple_mushroom=1},
		reward = "fancyalchemy_health_potion",
		time = 12,
		xp = 10,
		quality = 3
	},	
	[47] = {
		recipe = {black_wine = 1, strange_catalyst=1, sweet_roll=1},
		reward = "fancyalchemy_mystery_potion",
		time = 30,
		xp = 30,
		quality = 3
	},		
	[48] = {
		recipe = {black_wine = 1, strange_catalyst=1, simple_mushroom=1},
		reward = "fancyalchemy_speed_potion",
		time = 12,
		xp = 10,
		quality = 3
	},		
	[49] = {
		recipe = {black_wine = 1, strange_catalyst=1, headcrab_carcass=1},
		reward = "fancyalchemy_armor_potion",
		time = 12,
		xp = 10,
		quality = 3
	},		
	[50] = {
		recipe = {rotten_pumpkin = 3},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 10,
		quality = 3
	},		
	[51] = {
		recipe = {rotten_pumpkin = 1, poison_brittleshroom =1, black_wine =1},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 15,
		quality = 4
	},			
	[52] = {
		recipe = {rotten_pumpkin = 1, headcrab_carcass =1, black_wine =1},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 15,
		quality = 4
	},	
	[53] = {
		recipe = {rotten_pumpkin = 1, headcrab_carcass =1, black_wine =1},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 15,
		quality = 4
	},		
	[54] = {
		recipe = {rotten_pumpkin = 1, delicious_fruit =1, simple_mushroom =1},
		reward = "fancyalchemy_health_potion",
		time = 12,
		xp = 15,
		quality = 3
	},			
	[55] = {
		recipe = {rotten_pumpkin = 1, strange_catalyst =1, black_wine =1},
		reward = "fancyalchemy_mystery_potion",
		time = 30,
		xp = 30,
		quality = 3
	},		
	[56] = {
		recipe = {rotten_pumpkin = 1, strange_catalyst =1, evergreen_fern =1},
		reward = "fancyalchemy_mystery_potion",
		time = 30,
		xp = 30,
		quality = 3
	},		
	[57] = {
		recipe = {windlegrench_heart = 1, strange_catalyst =1, black_wine =1},
		reward = "fancyalchemy_poison_potion",
		time = 15,
		xp = 15,
		quality = 4
	},			
	[58] = {
		recipe = {windlegrench_heart = 1, strange_catalyst =1, evergreen_fern =1},
		reward = "fancyalchemy_speed_potion",
		time = 15,
		xp = 15,
		quality = 4
	},		
	[59] = {
		recipe = {windlegrench_heart = 1, strange_catalyst =1, simple_mushroom =1},
		reward = "fancyalchemy_speed_potion",
		time = 15,
		xp = 15,
		quality = 4
	},			
	[60] = {
		recipe = {windlegrench_heart = 1, strange_catalyst =1, garlic =1},
		reward = "fancyalchemy_gravity_potion",
		time = 15,
		xp = 15,
		quality = 4
	},	
	[61] = {
		recipe = {windlegrench_heart = 1, strange_catalyst =1, delicious_fruit =1},
		reward = "fancyalchemy_health_potion",
		time = 15,
		xp = 15,
		quality = 4
	},		
	[62] = {
		recipe = {windlegrench_heart = 1, cursed_skull =1, garlic =1},
		reward = "fancyalchemy_mystery_potion",
		time = 10,
		xp = 45,
		quality = 2
	},	
	[63] = {
		recipe = {wicker_doll = 1, delicious_fruit =1, simple_mushroom =1},
		reward = "fancyalchemy_health_potion",
		time = 1,
		xp = 15,
		quality = 3
	},		
	[64] = {
		recipe = {wicker_doll = 1, strange_catalyst =1, simple_mushroom =1},
		reward = "fancyalchemy_health_potion",
		time = 1,
		xp = 15,
		quality = 3
	},		
	[65] = {
		recipe = {wicker_doll = 1, strange_catalyst =1, delicious_fruit =1},
		reward = "fancyalchemy_health_potion",
		time = 1,
		xp = 15,
		quality = 3
	},		
	[66] = {
		recipe = {wicker_doll = 1, strange_catalyst =1, black_wine =1},
		reward = "fancyalchemy_mystery_potion",
		time = 3,
		xp = 15,
		quality = 3
	},			
	[67] = {
		recipe = {wicker_doll = 1, strange_catalyst =1, evergreen_fern =1},
		reward = "fancyalchemy_speed_potion",
		time = 1,
		xp = 15,
		quality = 3
	},		
	[68] = {
		recipe = {wicker_doll = 1, rotten_pumpkin =1, black_wine =1},
		reward = "fancyalchemy_poison_potion",
		time = 1,
		xp = 15,
		quality = 3
	},	
	[69] = {
		recipe = {wicker_doll = 1, strange_catalyst =1, headcrab_carcass =1},
		reward = "fancyalchemy_armor_potion",
		time = 1,
		xp = 15,
		quality = 3
	},			
	[70] = {
		recipe = {wicker_doll = 1, windlegrench_heart =1, cursed_skull =1},
		reward = "fancyalchemy_gravity_potion",
		time = 1,
		xp = 15,
		quality = 3
	},	
	[71] = {
		recipe = {wicker_doll = 1, strange_catalyst =1, garlic =1},
		reward = "fancyalchemy_gravity_potion",
		time = 1,
		xp = 15,
		quality = 3
	},	
	[72] = {
		recipe = {pig_head = 1, strange_catalyst =1, garlic =1},
		reward = "fancyalchemy_gravity_potion",
		time = 18,
		xp = 20,
		quality = 4
	},	
	[73] = {
		recipe = {pig_head = 1, strange_catalyst =1, delicious_fruit =1},
		reward = "fancyalchemy_health_potion",
		time = 18,
		xp = 20,
		quality = 4
	},		
	[74] = {
		recipe = {pig_head = 1, strange_catalyst =1, simple_mushroom =1},
		reward = "fancyalchemy_speed_potion",
		time = 18,
		xp = 20,
		quality = 4
	},	
	[75] = {
		recipe = {pig_head = 1, strange_catalyst =1, evergreen_fern =1},
		reward = "fancyalchemy_speed_potion",
		time = 18,
		xp = 20,
		quality = 4
	},		
	[76] = {
		recipe = {pig_head = 1, strange_catalyst =1, headcrab_carcass =1},
		reward = "fancyalchemy_armor_potion",
		time = 18,
		xp = 20,
		quality = 4
	},		
	[77] = {
		recipe = {pig_head = 1, strange_catalyst =1, rich_tomato =1},
		reward = "fancyalchemy_wealth_potion",
		time = 50,
		xp = 30,
		quality = 4
	},	
	[78] = {
		recipe = {pig_head = 1, strange_catalyst =1, black_wine =1},
		reward = "fancyalchemy_poison_potion",
		time = 18,
		xp = 20,
		quality = 4
	},		
	[79] = {
		recipe = {pig_head = 1, strange_catalyst =1, poison_brittleshroom =1},
		reward = "fancyalchemy_poison_potion",
		time = 40,
		xp = 20,
		quality = 4
	},		
	[80] = {
		recipe = {pig_head = 1, windlegrench_heart =1, wicker_doll =1},
		reward = "fancyalchemy_mystery_potion",
		time = 5,
		xp = 50,
		quality = 3
	},	
	[81] = {
		recipe = {infant = 1, windlegrench_heart =1, wicker_doll =1},
		reward = "fancyalchemy_mystery_potion",
		time = 40,
		xp = 125,
		quality = 4
	},		
	[82] = {
		recipe = {infant = 1, strange_catalyst =1, delicious_fruit =1},
		reward = "fancyalchemy_health_potion",
		time = 20,
		xp = 75,
		quality = 4
	},	
	[83] = {
		recipe = {infant = 1, strange_catalyst =1, evergreen_fern =1},
		reward = "fancyalchemy_speed_potion",
		time = 20,
		xp = 75,
		quality = 4
	},		
	[84] = {
		recipe = {infant = 1, strange_catalyst =1, garlic =1},
		reward = "fancyalchemy_gravity_potion",
		time = 20,
		xp = 75,
		quality = 4
	},		
	[85] = {
		recipe = {infant = 1, strange_catalyst =1, rich_tomato =1},
		reward = "fancyalchemy_wealth_potion",
		time = 40,
		xp = 75,
		quality = 4
	},		
	[86] = {
		recipe = {infant = 1, strange_catalyst =1, poison_brittleshroom =1},
		reward = "fancyalchemy_poison_potion",
		time = 20,
		xp = 75,
		quality = 4
	},	
	[87] = {
		recipe = {infant = 3},
		reward = "fancyalchemy_health_potion",
		time = 10,
		xp = 165,
		quality = 1
	},	
	[88] = {
		recipe = {strange_catalyst =1, simple_mushroom=2},
		reward = "fancyalchemy_speed_potion",
		time = 10,
		xp = 5,
		quality = 2
	},	
	[89] = {
		recipe = {simple_mushroom=3},
		reward = "fancyalchemy_speed_potion",
		time = 10,
		xp = 3,
		quality = 1
	},	
	[90] = {
		recipe = {garlic=3},
		reward = "fancyalchemy_gravity_potion",
		time = 10,
		xp = 3,
		quality = 1
	},		
	[91] = {
		recipe = {strange_catalyst=1, delicious_fruit=2},
		reward = "fancyalchemy_health_potion",
		time = 10,
		xp = 5,
		quality = 1
	},		
	[92] = {
		recipe = {simple_mushroom=2, poison_brittleshroom=1},
		reward = "fancyalchemy_speed_potion",
		time = 12,
		xp = 7,
		quality = 2
	},		
	[93] = {
		recipe = {infant=1, strange_catalyst=1, simple_mushroom=1},
		reward = "fancyalchemy_speed_potion",
		time = 18,
		xp = 75,
		quality = 4
	},	
	[94] = {
		recipe = {wicker_doll=1, strange_catalyst=1, rich_tomato=1},
		reward = "fancyalchemy_wealth_potion",
		time = 10,
		xp = 15,
		quality = 3
	},		
	[95] = {
		recipe = {infant=1, strange_catalyst=1, headcrab_carcass=1},
		reward = "fancyalchemy_armor_potion",
		time = 24,
		xp = 75,
		quality = 4
	},		
	[96] = {
		recipe = {pig_head=3},
		reward = "fancyalchemy_health_potion",
		time = 20,
		xp = 18,
		quality = 4
	},		
	[97] = {
		recipe = {strange_catalyst=1, poison_brittleshroom=2},
		reward = "fancyalchemy_poison_potion",
		time = 14,
		xp = 10,
		quality = 3
	},		
	[98] = {
		recipe = {strange_catalyst=1, poison_brittleshroom=1, windlegrench_heart=1},
		reward = "fancyalchemy_poison_potion",
		time = 20,
		xp = 15,
		quality = 4
	},		
	[99] = {
		recipe = {sweet_roll=3},
		reward = "fancyalchemy_health_potion",
		time = 14,
		xp = 6,
		quality = 2
	},		
	[100] = {
		recipe = {evergreen_fern=2, simple_mushroom=1},
		reward = "fancyalchemy_speed_potion",
		time = 10,
		xp = 5,
		quality = 1
	},		
	[101] = {
		recipe = {cursed_skull=1, headcrab_carcass=1, black_wine=1},
		reward = "fancyalchemy_poison_potion",
		time = 14,
		xp = 32,
		quality = 3
	},		
	[102] = {
		recipe = {pig_head=1, rotten_pumpkin=1, black_wine=1},
		reward = "fancyalchemy_mystery_potion",
		time = 40,
		xp = 85,
		quality = 4
	},		
	[103] = {
		recipe = {infant=1, headcrab_carcass=1, pig_head=1},
		reward = "fancyalchemy_armor_potion",
		time = 22,
		xp = 85,
		quality = 4
	},		
	[104] = {
		recipe = {infant=1, wicker_doll=1, strange_catalyst=1},
		reward = "fancyalchemy_mystery_potion",
		time = 20,
		xp = 100,
		quality = 4
	},		
	[105] = {
		recipe = {rotten_pumpkin=1, headcrab_carcass=1, cursed_skull=1},
		reward = "fancyalchemy_armor_potion",
		time = 14,
		xp = 35,
		quality = 3
	},	
	[106] = {
		recipe = {poison_brittleshroom=2, simple_mushroom=1},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 15,
		quality = 2
	},	
	[107] = {
		recipe = {poison_brittleshroom=2, sweet_roll=1},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 18,
		quality = 2
	},	
	[108] = {
		recipe = {poison_brittleshroom=1, sweet_roll=2},
		reward = "fancyalchemy_poison_potion",
		time = 12,
		xp = 18,
		quality = 2
	},	
	[109] = {
		recipe = {strange_catalyst=1, rich_tomato=2},
		reward = "fancyalchemy_wealth_potion",
		time = 24,
		xp = 25,
		quality = 2
	},	
	[110] = {
		recipe = {strange_catalyst=1, rich_tomato=1, black_wine=1},
		reward = "fancyalchemy_mystery_potion",
		time = 20,
		xp = 30,
		quality = 2
	},	
	[111] = {
		recipe = {garlic=2, simple_mushroom=1},
		reward = "fancyalchemy_gravity_potion",
		time = 10,
		xp = 8,
		quality = 1
	},	
	[112] = {
		recipe = {wicker_doll=1, poison_brittleshroom=1, black_wine=1},
		reward = "fancyalchemy_poison_potion",
		time = 3,
		xp = 30,
		quality = 3
	},	
	[113] = {
		recipe = {wicker_doll=1, sweet_roll=1, delicious_fruit=1},
		reward = "fancyalchemy_health_potion",
		time = 3,
		xp = 65,
		quality = 1
	},	
	[114] = {
		recipe = {wicker_doll=1, rotten_pumpkin=1, rich_tomato=1},
		reward = "fancyalchemy_wealth_potion",
		time = 8,
		xp = 45,
		quality = 3
	},	
	[115] = {
		recipe = {wicker_doll=1, cursed_skull=1, strange_catalyst=1},
		reward = "fancyalchemy_mystery_potion",
		time = 20,
		xp = 20,
		quality = 4
	},	
	[116] = {
		recipe = {wicker_doll=1, cursed_skull=1, garlic=1},
		reward = "fancyalchemy_gravity_potion",
		time = 5,
		xp = 15,
		quality = 4
	},	
	[117] = {
		recipe = {wicker_doll=1, cursed_skull=1, evergreen_fern=1},
		reward = "fancyalchemy_speed_potion",
		time = 5,
		xp = 15,
		quality = 4
	},	
	[118] = {
		recipe = {windlegrench_heart=3},
		reward = "fancyalchemy_health_potion",
		time = 20,
		xp = 45,
		quality = 2
	},	
	[119] = {
		recipe = {windlegrench_heart=1, black_wine=1, poison_brittleshroom=1},
		reward = "fancyalchemy_poison_potion",
		time = 16,
		xp = 35,
		quality = 4
	},	
	[120] = {
		recipe = {windlegrench_heart=1, strange_catalyst=1, rich_tomato=1},
		reward = "fancyalchemy_wealth_potion",
		time = 26,
		xp = 55,
		quality = 4
	},	
	[121] = {
		recipe = {wicker_doll=1, strange_catalyst=1, poison_brittleshroom=1},
		reward = "fancyalchemy_poison_potion",
		time = 2,
		xp = 16,
		quality = 3
	},	
	[122] = {
		recipe = {wicker_doll=1, strange_catalyst=1, sweet_roll=1},
		reward = "fancyalchemy_health_potion",
		time = 2,
		xp = 18,
		quality = 3
	},	
	[123] = {
		recipe = {wicker_doll=1, strange_catalyst=1, rotten_pumpkin=1},
		reward = "fancyalchemy_poison_potion",
		time = 2,
		xp = 20,
		quality = 4
	},	
	[124] = {
		recipe = {pig_head=1, windlegrench_heart=1, black_wine=1},
		reward = "fancyalchemy_health_potion",
		time = 12,
		xp = 120,
		quality = 4
	},
	[125] = {
		recipe = {wicker_doll=1, simple_mushroom=1, evergreen_fern=1},
		reward = "fancyalchemy_speed_potion",
		time = 3,
		xp = 18,
		quality = 3
	}
}

if SERVER then

	for _, v in ipairs(FANCYALCHEMY_INGREDIENTS) do
		util.PrecacheModel(v.model)
	end
end
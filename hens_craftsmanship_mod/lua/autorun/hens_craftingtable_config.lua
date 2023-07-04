// CRAFTING TABLE SET-UP //

CRAFTING_FURNITURE_TBL = {
	[1] = {
		name = "Broken Chair",
		reqlevel = 1,
		crafttime = 1,
		price = 1000,
		xp = 5,
		materials = {
			["mat_oakwood"] = 2
		},
		model = "models/props/de_inferno/chairantique_damage_02.mdl",
		viewvec = Vector(20, 0 ,20)
	},
	[2] = {
		name = "Worn-down Table",
		reqlevel = 1,
		crafttime = 1,
		price = 1250,
		xp = 7,
		materials = {
			["mat_oakwood"] = 4
		},
		model = "models/props_c17/furnituretable003a.mdl",
		viewvec = Vector(50, 0 ,30)
	},	
	[3] = {
		name = "Drawer Piece",
		reqlevel = 1,
		crafttime = 1,
		price = 750,
		xp = 4,
		materials = {
			["mat_maplewood"] = 1
		},
		model = "models/props_c17/FurnitureDrawer001a_Chunk01.mdl",
		viewvec = Vector(40, 0 ,20)
	},
	
	[4] = {
		name = "Small Round Table",
		reqlevel = 2,
		crafttime = 2,
		price = 1750,
		xp = 7,
		materials = {
			["mat_maplewood"] = 2
		},
		model = "models/props_c17/FurnitureTable001a.mdl",
		viewvec = Vector(40, 0 ,40)
	},	
	[5] = {
		name = "Bar Stool",
		reqlevel = 2,
		crafttime = 2,
		price = 1550,
		xp = 8,
		materials = {
			["mat_oakwood"] = 1,
			["mat_maplewood"] = 1
		},
		model = "models/props/cs_militia/barstool01.mdl",
		viewvec = Vector(40, 0 ,40),
		viewoffset = Vector(0, 0, 20)
	},	
	[6] = {
		name = "Barrel",
		reqlevel = 2,
		crafttime = 2,
		price = 1750,
		xp = 10,
		materials = {
			["mat_birchwood"] = 3
		},
		model = "models/props/de_inferno/wine_barrel.mdl",
		viewvec = Vector(60, 0 ,40),
		viewoffset = Vector(0, 0, 20)
	},
	
	[7] = {
		name = "Dresser",
		reqlevel = 3,
		crafttime = 2,
		price = 2250,
		xp = 10,
		materials = {
			["mat_oakwood"] = 4
		},
		model = "models/props/de_inferno/furnituredrawer001a.mdl",
		viewvec = Vector(50, 0 ,30)
	},	
	[8] = {
		name = "Nightstand",
		reqlevel = 3,
		crafttime = 2,
		price = 2000,
		xp = 14,
		materials = {
			["mat_oakwood"] = 2,
			["mat_maplewood"] = 2
		},
		model = "models/props_c17/FurnitureDrawer002a.mdl",
		viewvec = Vector(50, 0 ,30)
	},	
	
	[9] = {
		name = "Antique Chair",
		reqlevel = 4,
		crafttime = 2,
		price = 3000,
		xp = 18,
		materials = {
			["mat_birchwood"] = 2,
			["mat_maplewood"] = 2,
			["mat_oakwood"] = 2,
		},
		model = "models/props/de_inferno/chairantique.mdl",
		viewvec = Vector(40, 0 ,30),
		viewoffset = Vector(0, 0, 20)
	},	
	[10] = {
		name = "Painting Frame",
		reqlevel = 4,
		crafttime = 2,
		price = 3500,
		xp = 15,
		materials = {
			["mat_oakwood"] = 6
		},
		model = "models/props_c17/Frame002a.mdl",
		viewvec = Vector(30, 0 ,15),
	},	
	[11] = {
		name = "Coffee Table",
		reqlevel = 4,
		crafttime = 2,
		price = 3750,
		xp = 20,
		materials = {
			["mat_oakwood"] = 4,
			["mat_birchwood"] = 2,
		},
		model = "models/props/cs_office/table_coffee.mdl",
		viewvec = Vector(30, 40 ,45),
		viewoffset = Vector(0, 0, 10)
	},	
	[12] = {
		name = "Wooden Shelf",
		reqlevel = 5,
		crafttime = 2,
		price = 4550,
		xp = 22,
		materials = {
			["mat_maplewood"] = 8
		},
		model = "models/props_interiors/Furniture_shelf01a.mdl",
		viewvec = Vector(30, 40 ,45),
		viewoffset = Vector(0, 0, 10)
	},	
	[13] = {
		name = "Vanity",
		reqlevel = 5,
		crafttime = 3,
		price = 3750,
		xp = 20,
		materials = {
			["mat_oakwood"] = 4,
			["mat_maplewood"] = 4,
		},
		model = "models/props_interiors/Furniture_Vanity01a.mdl",
		viewvec = Vector(30, 40 ,45),
		viewoffset = Vector(0, 0, 10)
	},	
	[14] = {
		name = "Wooden Desk",
		reqlevel = 5,
		crafttime = 3,
		price = 3250,
		xp = 24,
		materials = {
			["mat_oakwood"] = 2,
			["mat_maplewood"] = 4,
		},
		model = "models/props_interiors/Furniture_Desk01a.mdl",
		viewvec = Vector(30, 70, 30),
		viewoffset = Vector(0, 0, 5)
	},	
	
	[15] = {
		name = "Metal Chair",
		reqlevel = 6,
		crafttime = 3,
		price = 5000,
		xp = 32,
		materials = {
			["mat_ironberry"] = 4,
			["mat_ancientsap"] = 1,
		},
		model = "models/props_wasteland/controlroom_chair001a.mdl",
		viewvec = Vector(30, 40, 30),
	},	
	[16] = {
		name = "Comfy Small Couch",
		reqlevel = 6,
		crafttime = 3,
		price = 5500,
		xp = 36,
		materials = {
			["mat_birchwood"] = 4,
			["mat_treecore"] = 1,
			["mat_cloth"] = 2,
		},
		model = "models/props_interiors/Furniture_Couch02a.mdl",
		viewvec = Vector(30, 40, 30),
	},	
	[17] = {
		name = "Bathtub",
		reqlevel = 6,
		crafttime = 3,
		price = 7500,
		xp = 40,
		materials = {
			["mat_ironberry"] = 8,
			["mat_ancientsap"] = 1,
		},
		model = "models/props_c17/FurnitureBathtub001a.mdl",
		viewvec = Vector(30, 40, 30),
	},	
	[18] = {
		name = "Sink",
		reqlevel = 7,
		crafttime = 3,
		price = 6500,
		xp = 38,
		materials = {
			["mat_ironberry"] = 6
		},
		model = "models/props_interiors/SinkKitchen01a.mdl",
		viewvec = Vector(20, 10, 20),
	},	
	[19] = {
		name = "Washing Machine",
		reqlevel = 7,
		crafttime = 3,
		price = 8750,
		xp = 42,
		materials = {
			["mat_ironberry"] = 10
		},
		model = "models/props_c17/FurnitureWashingmachine001a.mdl",
		viewvec = Vector(30, 40, 30),
	},	
	[20] = {
		name = "Porcelain Throne",
		reqlevel = 7,
		crafttime = 3,
		price = 8150,
		xp = 40,
		materials = {
			["mat_ironberry"] = 4,
			["mat_ancientsap"] = 1,
		},
		model = "models/props_c17/FurnitureToilet001a.mdl",
		viewvec = Vector(20, 20, -20),
		viewoffset = Vector(0, 0, -25)
	},	
	[21] = {
		name = "World Globe",
		reqlevel = 7,
		crafttime = 3,
		price = 10000,
		xp = 50,
		materials = {
			["mat_oakwood"] = 8,
			["mat_maplewood"] = 8,
			["mat_birchwood"] = 8
		},
		model = "models/props_combine/breenglobe.mdl",
		viewvec = Vector(10, 10, 10)
	},	
	[22] = {
		name = "Wardrobe",
		reqlevel = 8,
		crafttime = 5,
		price = 14525,
		xp = 65,
		materials = {
			["mat_maplewood"] = 6,
			["mat_treecore"] = 2,
			["mat_birchwood"] = 10
		},
		model = "models/props_c17/FurnitureDresser001a.mdl",
		viewvec = Vector(60, 60, 10)
	},	
	[23] = {
		name = "Lamp",
		reqlevel = 8,
		crafttime = 5,
		price = 8525,
		xp = 60,
		materials = {
			["mat_ironberry"] = 6,
			["mat_cloth"] = 2,
			["mat_embercore"] = 1,
		},
		model = "models/props_interiors/Furniture_Lamp01a.mdl",
		viewvec = Vector(30, 40, 15)
	},	
	[24] = {
		name = "Fancy Door",
		reqlevel = 8,
		crafttime = 5,
		price = 15525,
		xp = 70,
		materials = {
			["mat_ironberry"] = 2,
			["mat_treecore"] = 1,
			["mat_maplewood"] = 10
		},
		model = "models/props_c17/door02_double.mdl",
		viewvec = Vector(30, 40, 15)
	},	
	[24] = {
		name = "Fridge",
		reqlevel = 8,
		crafttime = 5,
		price = 18525,
		xp = 80,
		materials = {
			["mat_ironberry"] = 10,
			["mat_embercore"] = 1,
		},
		model = "models/props_wasteland/kitchen_fridge001a.mdl",
		viewvec = Vector(80, 80, 65),
		viewoffset = Vector(0, 0, 45)
	},	
	[25] = {
		name = "Computer",
		reqlevel = 9,
		crafttime = 5,
		price = 21150,
		xp = 100,
		materials = {
			["mat_ironberry"] = 12,
			["mat_ancientsap"] = 1,
			["mat_embercore"] = 1,
		},
		model = "models/props_lab/monitor02.mdl",
		viewvec = Vector(20, 20, 15),
		viewoffset = Vector(0, 0, 10)
	},	
	[26] = {
		name = "Leather Chair",
		reqlevel = 9,
		crafttime = 5,
		price = 23000,
		xp = 95,
		materials = {
			["mat_birchwood"] = 8,
			["mat_treecore"] = 1,
			["mat_cloth"] = 4,
		},
		model = "models/props_combine/breenchair.mdl",
		viewvec = Vector(40, 40, 35),
		viewoffset = Vector(0, 0, 20)
	},	
	[27] = {
		name = "Lazy Sofa",
		reqlevel = 9,
		crafttime = 5,
		price = 25500,
		xp = 110,
		materials = {
			["mat_oakwood"] = 4,
			["mat_maplewood"] = 4,
			["mat_birchwood"] = 4,
			["mat_treecore"] = 3,
			["mat_cloth"] = 3,
		},
		model = "models/props_interiors/sofa01.mdl",
		viewvec = Vector(70, 70, 45),
		viewoffset = Vector(0, 0, 20)
	},	
	[28] = {
		name = "Simple Bed",
		reqlevel = 9,
		crafttime = 5,
		price = 20150,
		xp = 105,
		materials = {
			["mat_ironberry"] = 7,
			["mat_ancientsap"] = 2,
			["mat_cloth"] = 5,
		},
		model = "models/props/de_inferno/bed.mdl",
		viewvec = Vector(50, 50, 45),
		viewoffset = Vector(0, 0, 20)
	},	
	[29] = {
		name = "Fancy Stove",
		reqlevel = 10,
		crafttime = 5,
		price = 25550,
		xp = 125,
		materials = {
			["mat_ironberry"] = 12,
			["mat_ancientsap"] = 3,
			["mat_embercore"] = 1,
		},
		model = "models/sickness/stove_01.mdl",
		viewvec = Vector(50, 50, 65),
		viewoffset = Vector(0, 0, 20)
	},	
	[30] = {
		name = "Fancy Fridge",
		reqlevel = 10,
		crafttime = 5,
		price = 23550,
		xp = 120,
		materials = {
			["mat_ironberry"] = 10,
			["mat_ancientsap"] = 2,
			["mat_embercore"] = 1,
		},
		model = "models/props_interiors/refrigerator03.mdl",
		viewvec = Vector(50, 50, 45),
		viewoffset = Vector(0, 0, 30)
	},	
	[31] = {
		name = "Table Lamp",
		reqlevel = 10,
		crafttime = 5,
		price = 23550,
		xp = 140,
		materials = {
			["mat_oakwood"] = 6,
			["mat_birchwood"] = 8,
			["mat_ancientsap"] = 2,
			["mat_cloth"] = 2,
			["mat_embercore"] = 1,
		},
		model = "models/wilderness/lamp6.mdl",
		viewvec = Vector(20, 20, 15),
	},	
	[32] = {
		name = "Widescreen TV",
		reqlevel = 10,
		crafttime = 5,
		price = 41250,
		xp = 210,
		materials = {
			["mat_ironberry"] = 20,
			["mat_ancientsap"] = 4,
			["mat_embercore"] = 1,
		},
		model = "models/gmod_tower/suitetv.mdl",
		viewvec = Vector(40, 40, 25),
		viewoffset = Vector(0, 0, 20)
	},	
	[33] = {
		name = "Boardroom Table",
		reqlevel = 10,
		crafttime = 5,
		price = 35250,
		xp = 165,
		materials = {
			["mat_maplewood"] = 20,
			["mat_oakwood"] = 10,
			["mat_treecore"] = 1,
			["mat_ancientsap"] = 5,
		},
		model = "models/props/cs_office/Table_meeting.mdl",
		viewvec = Vector(100, 100, 75),
		viewoffset = Vector(0, 0, 20)
	},	
	[34] = {
		name = "Patio Table",
		reqlevel = 10,
		crafttime = 5,
		price = 39750,
		xp = 195,
		materials = {
			["mat_maplewood"] = 10,
			["mat_oakwood"] = 10,
			["mat_birchwood"] = 10,
			["mat_ancientsap"] = 2,
			["mat_cloth"] = 6,
		},
		model = "models/props/de_tides/patio_table.mdl",
		viewvec = Vector(60, 60, 95),
		viewoffset = Vector(0, 0, 60)
	},	
	[35] = {
		name = "Piano",
		reqlevel = 10,
		crafttime = 5,
		price = 55000,
		xp = 250,
		materials = {
			["mat_birchwood"] = 20,
			["mat_ancientsap"] = 4,
			["mat_embercore"] = 1,
		},
		model = "models/props_furniture/piano.mdl",
		viewvec = Vector(60, 60, 55),
		viewoffset = Vector(0, 0, 30)
	},	
	[36] = {
		name = "Coffee Maker",
		reqlevel = 10,
		crafttime = 5,
		price = 41500,
		xp = 195,
		materials = {
			["mat_ironberry"] = 12,
			["mat_ancientsap"] = 2,
			["mat_embercore"] = 1,
		},
		model = "models/props_interiors/coffee_maker.mdl",
		viewvec = Vector(15, 15, 7),
		viewoffset = Vector(0, 0, 7)
	},		
	[37] = {
		name = "Volt's Fuel Supply",
		reqlevel = 10,
		crafttime = 8,
		price = 85000,
		xp = 325,
		materials = {
			["mat_ironberry"] = 20,
			["mat_treecore"] = 2,
			["mat_embercore"] = 2,
			["mat_ancientsap"] = 2,
		},
		model = "models/items/car_battery01.mdl",
		viewvec = Vector(15, 15, 7),
		viewoffset = Vector(0, 0, 0)
	},
}

CRAFTING_WEAPONS_TBL = {
	[1] = {
		name = "Bayonet Knife",
		reqlevel = 6,
		crafttime = 5,
		price = 250,
		xp = 8,
		materials = {
			["mat_ironberry"] = 1,
		},
		model = "models/weapons/w_csgo_bayonet.mdl",
		ent = "csgo_bayonet",
		viewvec = Vector(10, 10, 5),
		viewoffset = Vector(0, 0, 2)
	},	
	[2] = {
		name = "Flip Knife",
		reqlevel = 6,
		crafttime = 5,
		price = 750,
		xp = 9,
		materials = {
			["mat_ironberry"] = 2,
		},
		model = "models/weapons/w_csgo_flip.mdl",
		ent = "csgo_flip_rustcoat",
		viewvec = Vector(10, 10, 5),
		viewoffset = Vector(0, 0, 2)
	},	
	[3] = {
		name = "Huntsman's Knife",
		reqlevel = 6,
		crafttime = 5,
		price = 1250,
		xp = 10,
		materials = {
			["mat_ironberry"] = 4,
		},
		model = "models/weapons/w_csgo_tactical.mdl",
		ent = "csgo_huntsman_rustcoat",
		viewvec = Vector(10, 10, 5),
		viewoffset = Vector(0, 0, 2)
	},
	[4] = {
		name = "PM",
		reqlevel = 6,
		crafttime = 8,
		price = 750,
		xp = 15,
		materials = {
			["mat_ironberry"] = 2,
		},
		model = "models/weapons/w_pist_p228.mdl",
		ent = "cw_makarov",
		viewvec = Vector(10, 10, 7),
		viewoffset = Vector(0, 0, 4)
	},	
	[5] = {
		name = "M1911",
		reqlevel = 7,
		crafttime = 8,
		price = 750,
		xp = 20,
		materials = {
			["mat_ironberry"] = 6,
			["mat_ancientsap"] = 2,
		},
		model = "models/weapons/cw_pist_m1911.mdl",
		ent = "cw_m1911",
		viewvec = Vector(15, 15, 7),
		viewoffset = Vector(0, 0, 4)
	},	
	[6] = {
		name = "MAC-11",
		reqlevel = 10,
		crafttime = 8,
		price = 2000,
		xp = 75,
		materials = {
			["mat_ironberry"] = 10,
			["mat_monsterparts"] = 10,
		},
		model = "models/weapons/w_cst_mac11.mdl",
		ent = "cw_mac11",
		viewvec = Vector(20, 20, 7),
		viewoffset = Vector(0, 0, 6)
	},	
	[7] = {
		name = "Baseball Bat",
		reqlevel = 10,
		crafttime = 5,
		price = 5500,
		xp = 55,
		materials = {
			["mat_monsterparts"] = 5,
			["mat_oakwood"] = 4,
			["mat_treecore"] = 1,
		},
		model = "models/weapons/melee/w_bat.mdl",
		ent = "crft_baseballbat",
		viewvec = Vector(20, 20, 7),
		viewoffset = Vector(0, 0, 13)
	},
}

CRAFTING_MISC_TBL = {
	[1] = {
		name = "Special Flamethrower",
		reqlevel = 8,
		crafttime = 10,
		price = 2500,
		xp = 30,
		materials = {
			["mat_ironberry"] = 4,
			["mat_ancientsap"] = 1,
		},
		model = "models/weapons/w_immolator.mdl",
		ent = "crft_flamethrower",
		viewvec = Vector(25, 25, 7),
		viewoffset = Vector(0, 0, 3)
	},		
	[2] = {
		name = "Carving Stone",
		reqlevel = 8,
		crafttime = 3,
		price = 5000,
		xp = 50,
		materials = {
			["mat_ironberry"] = 2,
			["mat_treecore"] = 1,
		},
		model = "models/carvingstone/carvingstone.mdl",
		ent = "st_carvingstone",
		viewvec = Vector(15, 15, 7),
		viewoffset = Vector(0, 0, 3)
	},	
	[3] = {
		name = "Russian Roulette Gun",
		reqlevel = 10,
		crafttime = 3,
		price = 5000,
		xp = 75,
		materials = {
			["mat_ironberry"] = 4,
			["mat_monsterparts"] = 4,
		},
		model = "models/weapons/w_357.mdl",
		ent = "st_russianroulette",
		viewvec = Vector(15, 15, 7),
		viewoffset = Vector(0, 0, 3)
	},	
	[4] = {
		name = "Jihad Toy",
		reqlevel = 10,
		crafttime = 3,
		price = 2500,
		xp = 75,
		materials = {
			["mat_monsterparts"] = 8,
		},
		model = "models/weapons/w_c4.mdl",
		ent = "st_jihad",
		viewvec = Vector(8, 8, 7),
		viewoffset = Vector(0, 0, 3)
	},	
	[5] = {
		name = "ACME Device",
		reqlevel = 10,
		crafttime = 3,
		price = 2500,
		xp = 75,
		materials = {
			["mat_monsterparts"] = 4,
			["mat_ironberry"] = 4,
		},
		model = "models/sillytoys/acmedevice/acmedevice.mdl",
		ent = "st_acmedevice",
		viewvec = Vector(4, 4, 8),
		viewoffset = Vector(0, 0, 2)
	},	
	[6] = {
		name = "Odd Skull",
		reqlevel = 10,
		crafttime = 3,
		price = 20000,
		xp = 100,
		materials = {
			["mat_monsterparts"] = 5,
			["mat_treecore"] = 1,
		},
		model = "models/Gibs/HGIBS.mdl",
		ent = "st_mysteriousheart",
		viewvec = Vector(8, 8, 7),
		viewoffset = Vector(0, 0, 0)
	},	
	[7] = {
		name = "Box of Rope",
		reqlevel = 10,
		crafttime = 3,
		price = 50000,
		xp = 100,
		materials = {
			["mat_monsterparts"] = 8,
			["mat_cloth"] = 5,
		},
		model = "models/props_junk/cardboard_box001a.mdl",
		ent = "st_rope",
		viewvec = Vector(38, 38, 17),
		viewoffset = Vector(0, 0, 4)
	},	
	[8] = {
		name = "Diamond Sword",
		reqlevel = 10,
		crafttime = 3,
		price = 50000,
		xp = 100,
		materials = {
			["mat_monsterparts"] = 5,
			["mat_ironberry"] = 12,
		},
		model = "models/sillytoys/w_mcSword.mdl",
		ent = "st_diamondsword",
		viewvec = Vector(10, 10, -60),
		viewoffset = Vector(0, 0, 4)
	},
	[9] = {
		name = "Ancient Grimoire",
		reqlevel = 10,
		crafttime = 5,
		price = 50000,
		xp = 100,
		materials = {
			["mat_monsterparts"] = 15,
		},
		model = "models/sillytoys/grimoire/grimoire.mdl",
		ent = "st_grimoire",
		viewvec = Vector(10, 10, 12),
		viewoffset = Vector(0, 0, 2)
	},	
	[10] = {
		name = "Young White Branch",
		reqlevel = 10,
		crafttime = 5,
		price = 25000,
		xp = 20,
		materials = {
			["mat_monsterparts"] = 5,
			["mat_birchwood"] = 5,
		},
		model = "models/props_foliage/tree_poplar_01.mdl",
		ent = "st_youngwhitebranch",
		viewvec = Vector(300, 300, 120),
		viewoffset = Vector(30, 30, 120)
	},
	
}
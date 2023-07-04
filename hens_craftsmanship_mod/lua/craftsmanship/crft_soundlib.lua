-- Register UI Sounds
print("Initialized Sound for CRAFTSMANSHIP")

sound.Add( {
	name = "crft_uiClick",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 120, 140 },
	sound = "ui/uiClicksfx.mp3"
} )

sound.Add( {
	name = "inv_open",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 95, 110 },
	sound = "ui/invOpen.wav"
} )

sound.Add( {
	name = "inv_close",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 95, 110 },
	sound = "ui/invClose.wav"
} )

sound.Add( {
	name = "crft_lvlup",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 100 },
	sound = "levelupsfx.wav"
} )

sound.Add( {
	name = "crft_successfulcraft",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 100 },
	sound = "ui/uiCraftSuccess.wav"
} )

sound.Add( {
	name = "crft_crafting",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 90, 110 },
	sound = "ui/uiCrafting.mp3"
} )

sound.Add( {
	name = "crft_maxlvl",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 100 },
	sound = "maxlevel2.mp3"
} )

sound.Add( {
	name = "crft_watersfx",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 90, 110 },
	sound = "ui/uiPotion.wav"
} )

sound.Add( {
	name = "crft_woodsfx",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 90, 110 },
	sound = "physics/wood/wood_box_footstep3.wav"
} )

sound.Add( {
	name = "crft_supplysfx",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 90, 110 },
	sound = "ui/uiWoodHit.wav"
} )

sound.Add( {
	name = "crft_pickup",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 90, 110 },
	sound = {"pocket/p1.wav", "pocket/p2.wav", "pocket/p3.wav", "pocket/p4.wav"}
} )

sound.Add( {
	name = "crft_slime",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 90, 110 },
	sound = {"pocket/slime1.wav", "pocket/slime2.wav", "pocket/slime3.wav"}
} )

sound.Add( {
	name = "crft_bushfx",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 90, 110 },
	sound = "pocket/bush.wav"
} )

sound.Add( {
	name = "crft_rockcrumble",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	pitch = { 90, 110 },
	sound = {"pocket/rockcrumble1.wav", "pocket/rockcrumble2.wav", "pocket/rockcrumble3.wav"}
} )
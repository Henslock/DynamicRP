--SERVER MSG PRINTS
if SERVER then
	local PLAYER = FindMetaTable("Player")
	util.AddNetworkString( "ColoredMessage" )
	function BroadcastMsg(...)
		local args = {...}
		net.Start("ColoredMessage")
		net.WriteTable(args)
		net.Broadcast()
	end
	function PLAYER:PlayerMsg(...)
		local args = {...}
		net.Start("ColoredMessage")
		net.WriteTable(args)
		net.Send(self)
	end
	elseif CLIENT then
	net.Receive("ColoredMessage",function(len)local msg = net.ReadTable()
		chat.AddText(unpack(msg))
		chat.PlaySound()
	end)
end

// ** DATA UPDATES ** //

if SERVER then
	util.AddNetworkString("falch_payForMix")
	util.AddNetworkString("falch_giveXP")
	util.AddNetworkString("falch_InitData")
	util.AddNetworkString("falch_InitKnownRecipes")
	util.AddNetworkString("falch_learnRecipe")
	util.AddNetworkString("falch_Empower")
	util.AddNetworkString("falch_addFamiliar")
end

FALCH = FALCH or {}

function FALCH.LoadPlayerInfo(ply, name)
	return file.Read("hens_fancyalchemy/"..ply:UniqueID().."/"..name..".txt")
end

function FALCH.LoadRecipeTable(ply)
	local tbl = (file.Read("hens_fancyalchemy/"..ply:UniqueID().."/recipes.txt"))
	if(tbl ~= nil) then
		return util.JSONToTable(file.Read("hens_fancyalchemy/"..ply:UniqueID().."/recipes.txt"))
	else
		return nil
	end
end

function FALCH.SavePlayerInfo(ply, name, data)
	file.CreateDir("hens_fancyalchemy")
	file.CreateDir("hens_fancyalchemy/"..ply:UniqueID())
	file.Write("hens_fancyalchemy/"..ply:UniqueID().."/"..name..".txt", data)
end

function FALCH.SaveRecipeTable(ply, data)
	local tbl = util.TableToJSON(data)
	file.CreateDir("hens_fancyalchemy")
	file.CreateDir("hens_fancyalchemy/"..ply:UniqueID())
	file.Write("hens_fancyalchemy/"..ply:UniqueID().."/recipes.txt", tbl)
end

function FALCH.LevelUp(ply)
	ply.FALCH.experience = ply.FALCH.experience - FANCYALCHEMY_LEVELTABLE[ply.FALCH.level]
	
	if(ply.FALCH.level < #FANCYALCHEMY_LEVELTABLE) then
		ply.FALCH.level = ply.FALCH.level + 1
		--Update the player level!
		FALCH.SavePlayerInfo(ply, "falch_level", ply.FALCH.level)
		FALCH.UpdatePlayerInfo(ply)
		
		ply:EmitSound("falch_levelup")
		
		ply:PlayerMsg(Color(255, 255, 255), "[Fancy Alchemy] ", Color(255, 142, 245), "You are now level ", Color(255,255,255), ply.FALCH.level, Color(255, 142, 245)," - congratulations!")
		if(ply.FALCH.level == #FANCYALCHEMY_LEVELTABLE) then
			BroadcastMsg(Color(255, 255, 255), "[Fancy Alchemy] ", Color(255, 142, 245), ply:GetName(), " has mastered Alchemy! Congratulations!")
		end
		
		
		if(ply.FALCH.experience >= FANCYALCHEMY_LEVELTABLE[ply.FALCH.level]) then
			FALCH.LevelUp(ply)
		end
		
		local lvl = ents.Create("fancyalchemy_lvltxt")
		lvl:SetPos(ply:GetPos())
		lvl:SetAngles(ply:GetAngles())
		lvl:SetParent(ply)
		lvl:SetLocalPos(Vector(0, 0, 90))
		lvl:Spawn()
		timer.Simple(5, function()
			if(lvl~=NULL) then
				lvl:Remove()
			end
		end)
		return
	end
	
	if(ply.FALCH.level == #FANCYALCHEMY_LEVELTABLE) then
		local stacks = ply:GetNWInt("falch_EmpowerStacks")
		ply:SetNWInt("falch_EmpowerStacks", stacks + 1)
		ply:EmitSound("falch_rankup")
		
		local lvl = ents.Create("fancyalchemy_ranktxt")
		lvl:SetPos(ply:GetPos())
		lvl:SetAngles(ply:GetAngles())
		lvl:SetParent(ply)
		lvl:SetLocalPos(Vector(0, 0, 90))
		lvl:Spawn()
		timer.Simple(5, function()
			if(lvl~=NULL) then
				lvl:Remove()
			end
		end)
	end
end

function FALCH.GiveXP(ply, amnt)
	if(ply == nil) or not (IsValid(ply)) then return end
	if(ply.FALCH == nil) then FALCH.InitializePlayers(ply) end
	ply.FALCH.experience = ply.FALCH.experience + amnt;
	
	if(ply.FALCH.experience >= FANCYALCHEMY_LEVELTABLE[ply.FALCH.level]) then
		FALCH.LevelUp(ply)
	end
	
	FALCH.SavePlayerInfo(ply, "falch_xp", ply.FALCH.experience)
	FALCH.SavePlayerInfo(ply, "falch_level", ply.FALCH.level)
	FALCH.UpdatePlayerInfo(ply)
end

function FALCH.UpdatePlayerInfo(ply)
	ply:SetNWInt("falch_level", ply.FALCH.level)
	ply:SetNWInt("falch_xp", ply.FALCH.experience)
end

-- INITIALIZE DATA
function FALCH.InitializePlayers(ply)
	if not IsValid(ply) then return end

	ply.FALCH = {
		level = tonumber(FALCH.LoadPlayerInfo(ply, "falch_level") or 1),
		experience = tonumber(FALCH.LoadPlayerInfo(ply, "falch_xp") or 0),
	}
	
	FALCH.UpdatePlayerInfo(ply)
	FALCH.InitializeRecipes(ply)
	
end

function FALCH.InitializeRecipes(ply)
	if not IsValid(ply) then return end
	ply.falch_KnownRecipes = ply.falch_KnownRecipes or {}

	for k, v in ipairs(FANCYALCHEMY_RECIPES) do
		ply.falch_KnownRecipes[k] = false
	end
	
	if(FALCH.LoadRecipeTable(ply) ~= nil) then
		ply.falch_KnownRecipes = FALCH.LoadRecipeTable(ply)
	end
	
	FALCH.SaveRecipeTable(ply, ply.falch_KnownRecipes)
end

function FALCH.LearnRecipe(ply, index)
	if not IsValid(ply) then return end
	if ply.falch_KnownRecipes[index] == true then return end
	if ply.falch_KnownRecipes == nil then FALCH.InitializeRecipes(ply) end
	ply.falch_KnownRecipes[index] = true
	FALCH.SaveRecipeTable(ply, ply.falch_KnownRecipes)
	ply:ChatPrint("You've discovered a new recipe!")
end

function FALCH.LearnAllRecipes(ply)
	if not IsValid(ply) then return end
	if ply.falch_KnownRecipes == nil then FALCH.InitializeRecipes(ply) end
	
	for k, v in ipairs(FANCYALCHEMY_RECIPES) do
		ply.falch_KnownRecipes[k] = true
	end
	FALCH.SaveRecipeTable(ply, ply.falch_KnownRecipes)
	ply:ChatPrint("You've discovered all recipes!")
end

function FALCH.ForgetAllRecipes(ply)
	if not IsValid(ply) then return end
	if ply.falch_KnownRecipes == nil then FALCH.InitializeRecipes(ply) end
	
	for k, v in ipairs(FANCYALCHEMY_RECIPES) do
		ply.falch_KnownRecipes[k] = false
	end
	FALCH.SaveRecipeTable(ply, ply.falch_KnownRecipes)
	ply:ChatPrint("You've forgotten all recipes!")
end

// ** NET CODE ** //

net.Receive("falch_payForMix", function()
	local ply = net.ReadEntity()
	local cost = net.ReadFloat()
	
	ply:SetNWBool("falch_empowered", false)
	local money = ply:getDarkRPVar("money")
	if(money >= cost) then
		ply:addMoney(-cost)
	end
end)

net.Receive("falch_giveXP", function()
	local ply = net.ReadEntity()
	local xp = net.ReadFloat()
	
	FALCH.GiveXP(ply, xp)
end)

net.Receive("falch_InitData", function()
	local ply = net.ReadEntity()

	FALCH.InitializePlayers(ply)
end)

net.Receive("falch_InitKnownRecipes", function()
	local ply = net.ReadEntity()
	FALCH.InitializeRecipes(ply)
	print(ply)
end)

net.Receive("falch_learnRecipe", function()
	local ply = net.ReadEntity()
	local recipeindex = net.ReadFloat()
	 FALCH.LearnRecipe(ply, recipeindex)
end)

net.Receive("falch_Empower", function()
	local ply = net.ReadEntity()
	local stacks = ply:GetNWInt("falch_EmpowerStacks")
	stacks = stacks - 1
	if(stacks < 0) then stacks = 0 end
	ply:SetNWInt("falch_EmpowerStacks", stacks)
	ply:SetNWBool("falch_empowered", true)
end)

net.Receive("falch_addFamiliar", function()
	local ply = net.ReadEntity()
	local familiar = net.ReadString()
	local cost = net.ReadFloat()
	
	ply:SetNWBool(familiar, true)

	local money = ply:getDarkRPVar("money")
	if(money >= cost) then
		ply:addMoney(-cost)
	end
end)

--==CONSOLE COMMAND FUNCTIONS==--

function FALCH.ResetPlrStats(ply)

	print("Stats Reset")
	ply.FALCH.experience = 0
	ply.FALCH.level = 1
	crafting.SavePlayerInfo(ply, "falch_level", ply.FALCH.level)
	crafting.SavePlayerInfo(ply, "falch_xp", ply.FALCH.experience)
	
	ply:SetNWInt("falch_level", ply.FALCH.level)
	ply:SetNWInt("falch_xp", ply.FALCH.experience)
	ply:SetNWBool("falch_empowered", false)
	
	for k, v in ipairs(FANCYALCHEMY_FAMILIARS) do
		ply:SetNWBool(v.tag, false)
	end
	
end

--==============--
--CONSOLE COMMANDS
--==============--

--RESET PLR STATS
concommand.Add("falch_resetstats", function(ply)
	FALCH.ResetPlrStats(ply)
end)

--LEARN ALL RECIPES
concommand.Add("falch_learnall", function(ply)
	FALCH.LearnAllRecipes(ply)
end)

--FORGET ALL RECIPES
concommand.Add("falch_forgetall", function(ply)
	FALCH.ForgetAllRecipes(ply)
end)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

if SERVER then

util.AddNetworkString("fa_open_alchemy")
util.AddNetworkString("falch_createPotion")
util.AddNetworkString("falch_InsightCrafting")

end

function ENT:Initialize()

	self:SetModel("models/zerochain/props_halloween/witchcauldron.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	self:DrawShadow(true)
	local phys = self:GetPhysicsObject()
	
	phys:Wake()
	
	self:SetMixing(false)
	self:SetMixingTime(0)
	self:SetStartMixingTime(0)
	self:SetTotalMixingTime(0)
	
end

function ENT:OnRemove()
end

function ENT:Think()
end


function ENT:Use(ply)

	if(self:GetMixing() == true) then
		ply:ChatPrint("You can't use the cauldron while it is brewing a potion!")
		return
	end
	if(ply:Team() == WIZARD) then
		if(ply:GetNWInt("falch_level") == 0) then
			FALCH.InitializePlayers(ply)
			return
		end
		net.Start("fa_open_alchemy")
			net.WriteEntity(self)
			net.WriteTable(ply.falch_KnownRecipes)
		net.Send(ply)
		
		net.Start("fa_open_alchemy")
			net.WriteEntity(self)
			net.WriteTable(ply.falch_KnownRecipes)
		net.Send(ply)
	else
		ply:ChatPrint("You must be a Wizard to use the cauldron!")
	end
end

function ENT:SpawnPotion(potion, quality, double, empowered)
	if(double) then
		local pot = ents.Create(potion)
		if(empowered) then
			pot:SetQuality(5)
		else
			pot:SetQuality(quality)
		end
		pot:SetPos(self:GetPos() + Vector(15,0,55))
		pot:Spawn()
		pot:EmitSound("falch_potion_created")
		
		local phys = pot:GetPhysicsObject()
		phys:Sleep()
		
		local pot = ents.Create(potion)
		if(empowered) then
			pot:SetQuality(5)
		else
			pot:SetQuality(quality)
		end
		pot:SetPos(self:GetPos() + Vector(-15,0,55))
		pot:Spawn()
		pot:EmitSound("falch_potion_created")
		
		local phys = pot:GetPhysicsObject()
		phys:Sleep()
	else
		local pot = ents.Create(potion)
		if(empowered) then
			pot:SetQuality(5)
		else
			pot:SetQuality(quality)
		end
		pot:SetPos(self:GetPos() + Vector(0,0,55))
		pot:Spawn()
		pot:EmitSound("falch_potion_created")
		
		local phys = pot:GetPhysicsObject()
		phys:Sleep()
	end
end

net.Receive("falch_createPotion", function()
	local cauldron = net.ReadEntity()
	local reward = net.ReadString()
	local quality = net.ReadFloat()
	local empowered = net.ReadBool()
	local mixtime = net.ReadFloat()
	local ing = net.ReadTable()
	local success = net.ReadBool()
	local double = net.ReadBool()
	local qualitychance = net.ReadBool()
	
	cauldron:SetMixing(true)
	cauldron:SetMixingTime(mixtime + CurTime())
	cauldron:SetStartMixingTime(CurTime())
	cauldron:SetTotalMixingTime(mixtime)
	
	cauldron:SetIngredientOne(ing[1])
	cauldron:SetIngredientTwo(ing[2])
	cauldron:SetIngredientThree(ing[3])
	
	local sound = CreateSound(cauldron, "falch_active_brewing", 0)
	sound:Play()
	
	if(qualitychance) then
		quality = math.Clamp(quality+1, 0, 4)
	end
	timer.Simple(mixtime, function()
		if(cauldron == nil) or not (IsValid(cauldron)) then return end
		cauldron:SetMixing(false)
		cauldron:SetMixingTime(0)
		cauldron:SetStartMixingTime(0)
		cauldron:SetTotalMixingTime(0)
		sound:Stop()
		if(success) then
			cauldron:EmitSound("falch_brew_success")
			ParticleEffectAttach("falch_brew_success", 1, cauldron,  0 )
			cauldron:SpawnPotion(reward, quality, double, empowered)
			if(qualitychance) then
				cauldron:EmitSound("falch_fam_crow")
			end
			if(double) then
				cauldron:EmitSound("falch_fam_feline")
			end
		else
			cauldron:EmitSound("falch_brew_fail")
			ParticleEffectAttach("falch_brew_fail", 1, cauldron,  0 )
		end
	end)
end)

net.Receive("falch_InsightCrafting", function()
	local ply = net.ReadEntity()
	local cauldron = net.ReadEntity()
	
	if(ply == nil or cauldron == nil) then return end
	
	local newrecipeindex = nil
	for k, v in ipairs(FANCYALCHEMY_RECIPES) do
		if(ply.falch_KnownRecipes[k] == false) then
			newrecipeindex = k
			break
		end
	end
	if(newrecipeindex == nil) then return end
	
	local newrecip = (FANCYALCHEMY_RECIPES[newrecipeindex])
	// This code stores the models of the ingredients we need for the new recipe
	local ingredientmodels = {}
	for ing, num in pairs(newrecip.recipe) do
		for i, j in ipairs(FANCYALCHEMY_INGREDIENTS) do
			if(ing == j.tag) then
				for x = 1, num do table.insert(ingredientmodels, j.model) end
			end
		end
	end
	
	
	local stacks = ply:GetNWInt("falch_EmpowerStacks")
	stacks = stacks - 1
	if(stacks < 0) then stacks = 0 end
	ply:SetNWInt("falch_EmpowerStacks", stacks)
	
	// NOW WE MIX
	cauldron:SetMixing(true)
	cauldron:SetMixingTime(newrecip.time + CurTime())
	cauldron:SetStartMixingTime(CurTime())
	cauldron:SetTotalMixingTime(newrecip.time)
	
	cauldron:SetIngredientOne(ingredientmodels[1])
	cauldron:SetIngredientTwo(ingredientmodels[2])
	cauldron:SetIngredientThree(ingredientmodels[3])
	
	local sound = CreateSound(cauldron, "falch_active_brewing", 0)
	sound:Play()
	
	timer.Simple(newrecip.time, function()
		if(cauldron == nil) or not (IsValid(cauldron)) then return end
		cauldron:SetMixing(false)
		cauldron:SetMixingTime(0)
		cauldron:SetStartMixingTime(0)
		cauldron:SetTotalMixingTime(0)
		sound:Stop()
		
		cauldron:EmitSound("falch_brew_success")
		ParticleEffectAttach("falch_brew_success", 1, cauldron,  0 )
		cauldron:SpawnPotion(newrecip.reward, newrecip.quality, false, false)
		if(ply == nil or not (IsValid(ply))) then return end
		 FALCH.LearnRecipe(ply, newrecipeindex)
	end)
	
end)
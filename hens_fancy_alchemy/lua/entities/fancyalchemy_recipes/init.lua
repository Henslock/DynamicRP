AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("fancyalchemy/falch_data.lua")

if SERVER then

util.AddNetworkString("fa_open_recipes")

end

function ENT:Initialize()

	self:SetModel("models/hpwrewrite/books/book1.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	self:DrawShadow(false)
	phys:Wake()
end

function ENT:OnRemove()
end

function ENT:Think()
end


function ENT:Use(ply)
	if(ply:Team() == WIZARD) then
	
		if(ply.falch_KnownRecipes == nil) then
			 FALCH.InitializeRecipes(ply)
			 return
		end
	
		net.Start("fa_open_recipes")
			net.WriteTable(ply.falch_KnownRecipes)
		net.Send(ply)
	else
		ply:ChatPrint("You must be a Wizard to use the recipe book!")
	end
end
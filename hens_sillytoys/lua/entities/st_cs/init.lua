AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local stoneSounds = {
[0] = "st_cs_hello",
[1] = "st_cs_verygood",
[2] = "st_cs_helpme",
[3] = "st_cs_imsorry",
[4] = "st_cs_thankyou",
}

function ENT:Initialize()

	self.Entity:SetModel("models/carvingstone/carvingstone.mdl") 
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )

	self.Entity:DrawShadow( true )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
end

function ENT:PhysicsCollide()
	self:Explosion()		
end

function ENT:Explosion()

	pos = self.Entity:GetPos()
	local splash = EffectData()
	splash:SetOrigin(pos)
	splash:SetEntity(self.Owner)
	splash:SetScale(10)
	util.Effect("GlassImpact", splash)

	timer.Simple(0.01, function() 
		self.Entity:Remove() 
		self.Entity:EmitSound("physics/concrete/rock_impact_soft1.wav") 
		self.Entity:EmitSound(stoneSounds[self:GetCSState()]) 
	end) --Gay workaround to stopping spam on console

end
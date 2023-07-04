AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local summons = {"npc_zombie", "npc_zombie_torso", "npc_fastzombie_torso", "npc_fastzombie", "npc_crow"}
local DEMONBOSS_CHANCE = 10

function ENT:Initialize()

	self.Entity:SetModel("models/sillytoys/grimoire/grimoire.mdl") 
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )

	self.Entity:DrawShadow( false )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self:EmitSound("ambient/atmosphere/thunder1.wav", 90, 100, 1, CHAN_STATIC)
	self:EmitSound("st_g_buildup")
	
	timer.Simple(1, function()
		ParticleEffectAttach("aura_glow", 1, self,  0 )
	end)
	
	timer.Simple(8, function()
		if(self == NULL) then return end
		self:EmitSound("vo/eli_lab/al_laugh01.wav", 90, 60, 1, CHAN_STATIC)
		self:EmitSound("vo/eli_lab/al_laugh01.wav", 90, 57, 1, CHAN_STATIC)
		self:EmitSound("st_g_thunder")
		util.ScreenShake(self:GetPos(), 15, 33, 3, 500)
		
		if(math.random(100) <= DEMONBOSS_CHANCE) then
				local summon = ents.Create("npc_headcrab_fast")
				summon:SetPos(self:GetPos())
				summon:Spawn()
				
				summon:SetNWBool("st_summonedboss", true)
				summon:SetHealth(2000)
				summon:SetModelScale(4.5, 1.5)
			self:EmitSound("vo/k_lab/kl_lamarr.wav", 90, 100, 1, CHAN_STATIC)
			local pos = self.Entity:GetPos()
			local splash = EffectData()
			splash:SetOrigin(pos)
			splash:SetEntity(self.Owner)
			splash:SetScale(10)
			util.Effect("HelicopterMegaBomb", splash)
			
			for k, v in pairs(player.GetAll()) do
				v:ChatPrint("A demon from the burning hells has risen to consume all!")
			end
		else
			local summon = ents.Create(table.Random(summons))
			summon:SetPos(self:GetPos())
			summon:Spawn()
			
			summon:SetNWBool("st_summonednpc", true)
			summon:SetHealth(300)
			
			local pos = self.Entity:GetPos()
			local splash = EffectData()
			splash:SetOrigin(pos)
			splash:SetEntity(self.Owner)
			splash:SetScale(10)
			util.Effect("HelicopterMegaBomb", splash)
		end
		
		self:Remove()
		
	end)
end

hook.Add("EntityTakeDamage", "ST_ScaleSummonedNPCDmg", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local summonnpc = attacker:GetNWBool("st_summonednpc")
	local summonboss = attacker:GetNWBool("st_summonedboss")
	if !(summonnpc or summonboss) then return end
	
	if(summonnpc) then
		dmginfo:ScaleDamage(5)
	else
		dmginfo:ScaleDamage(20)
	end
end)
AddCSLuaFile()

--Fanatical Particles--
game.AddParticles( "particles/rainbow_glow_particles.pcf")
PrecacheParticleSystem( "rainbow_glow_particles" )

--Success--
game.AddParticles( "particles/falch_brew_success.pcf")
PrecacheParticleSystem( "falch_brew_success_outwardburst" )
PrecacheParticleSystem( "falch_brew_success" )

--Fail--
game.AddParticles( "particles/falch_brew_fail.pcf")
PrecacheParticleSystem( "falch_brew_fail" )
function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	
	local emitter = ParticleEmitter( Pos )
	
	for i = 1,7 do

		local particle = emitter:Add( "particles/fire_glow", Pos + Vector( math.random(-20,20),math.random(-15,15),math.random(0,35) ) ) 
		 
		if particle == nil then particle = emitter:Add( "particles/fire_glow", Pos + Vector(   math.random(-20,20),math.random(-15,15),math.random(0,35) ) ) end
		
		if (particle) then
			particle:SetVelocity(Vector(math.random(0,0),math.random(0,0),math.random(0, 0)))
			particle:SetLifeTime(0) 
			particle:SetDieTime(1) 
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			particle:SetStartSize(math.random(2, 10)) 
			particle:SetEndSize(0.16764085581733)
			particle:SetAngles( Angle(0,0,0) )
			particle:SetAngleVelocity( Angle(math.random(1, 5),0,0) ) 
			particle:SetRoll(math.Rand( 0, 360 ))
			particle:SetColor(math.random(255,255),math.random(255,255),math.random(255,255),math.random(255,255))
			particle:SetGravity( Vector(0,0,math.random(5, 10)) ) 
			particle:SetAirResistance(0 )  
			particle:SetCollide(false)
			particle:SetBounce(0)
		end
	end

	emitter:Finish()
		
end

function EFFECT:Think()		
	return false
end

function EFFECT:Render()
end
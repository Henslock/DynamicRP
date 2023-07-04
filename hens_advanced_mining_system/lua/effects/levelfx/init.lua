function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	
	local emitter = ParticleEmitter( Pos )
	
	for i = 1,50 do

		local particle = emitter:Add( "particles/fire_glow", Pos + Vector( math.random(-15,15),math.random(-20,20),math.random(15,32) ) ) 
		 
		if particle == nil then particle = emitter:Add( "particles/fire_glow", Pos + Vector(   math.random(-15,15),math.random(-20,20),math.random(15,32) ) ) end
		
		if (particle) then
			particle:SetVelocity(Vector(math.random(0,0),math.random(0,0),math.random(0,56)))
			particle:SetLifeTime(0) 
			particle:SetDieTime(math.random(0.1, 1.2)) 
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(25, 60)) 
			particle:SetEndSize(0.5)
			particle:SetAngles( Angle(0,0,0) )
			particle:SetAngleVelocity( Angle(math.random(-10,10),0,0) ) 
			particle:SetRoll(math.Rand( 0, 360 ))
			particle:SetColor(math.random(255,255),math.random(246,255),math.random(0,255),math.random(255,255))
			particle:SetGravity( Vector(0,0,math.random(5, 20)) ) 
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
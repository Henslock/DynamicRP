include("shared.lua")

local falch_ui_lvlTxt =  Material( "materials/fancyalchemy/ui_empowerment.png","smooth"  )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()   
	if self.time == nil then self.time = 0 end
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 1500 then
	
		local Pos = self:GetPos()
		local Eye1 = EyeAngles() 
		local PosOffset = Pos + Vector(0, 0, 0)
		local Ang = Angle(0, Eye1.y, 0)

		Ang:RotateAroundAxis(Ang:Up(), 90)
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		Ang:RotateAroundAxis(Ang:Right(), 180)
		
		cam.Start3D2D(Pos , Ang, 0.28)
				local scaleDown = 0.35
				local width = 768
				local height = 512
				surface.SetDrawColor(Color(255,255,255, Lerp((self.time*self.time*self.time)*500 , 255,0)))
				surface.SetMaterial(falch_ui_lvlTxt)
				surface.DrawTexturedRect( -(width*scaleDown)/2, -(height*scaleDown)/2 - Lerp((self.time)*2.5 , -10,150), width * scaleDown , height * scaleDown)
				draw.NoTexture()
		cam.End3D2D()   
	end
	self.time = self.time + FrameTime()*FrameTime()
end
 
 

include("shared.lua")

local crft_UI_LevelUp =  Material( "materials/UI/ui_levelup.png","smooth"  )

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
		
		cam.Start3D2D(Pos , Ang, 0.45)
				local scaleDown = 0.35
				local width = 768
				local height = 512
				surface.SetDrawColor(Color(255,255,255, Lerp((self.time*self.time*self.time)*500 , 255,0)))
				surface.SetMaterial(crft_UI_LevelUp)
				surface.DrawTexturedRect( -(width*scaleDown)/2, -(height*scaleDown)/2 - Lerp((self.time)*2.5 , -10,150), width * scaleDown , height * scaleDown)
				draw.NoTexture()

				draw.SimpleTextOutlined(string.upper(self:GetMessageText()), "Trebuchet24", 0 , 20 -Lerp((self.time)*2.5 , -10,150), Color(255,255,255,Lerp((self.time*self.time*self.time)*500 , 255,0)), 1, 0, 1, Color(10, 150, 30, Lerp((self.time*self.time*self.time)*500 , 125,0)) )
		cam.End3D2D()   
	end
	self.time = self.time + FrameTime()*FrameTime()
end
 
 

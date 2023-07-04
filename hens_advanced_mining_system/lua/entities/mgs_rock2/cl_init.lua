include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local PosOffset = Vector(0, 0, 5)
	local Eye1 = EyeAngles() 
	local Ang = Angle(0, Eye1.y, 0)

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	surface.SetFont("HUDNumber5")
	local text = ""..math.Truncate(math.Round((100/MGS_ROCK_HEALTH)*self:GetNWInt("health"), 2), 2).."%"
	local TextWidth = surface.GetTextSize(text)
	local width = ((TextWidth+10)/100)*((100/MGS_ROCK_HEALTH)*self:GetNWInt("health"))

	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 180)
	local TextAng = Ang

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 400 then
	
		cam.Start3D2D(Pos+PosOffset+Ang:Up()*20+Ang:Right()*-40, Ang, 0.15)
			draw.SimpleTextOutlined( "Level "..self:GetNWInt("level"), "HUDNumber5", -TextWidth*0.5 + 5, 0, GrabLevelColor(self:GetNWInt("level")), 0, 0, 2, Color(20,50,0) )
		cam.End3D2D()
		
		cam.Start3D2D(Pos+Ang:Up()*20+Ang:Right()*-40, Ang, 0.13)
			draw.RoundedBox( 10, -TextWidth*0.5 , -1, width, 37, GrabLevelColor(self:GetNWInt("level")))
			draw.RoundedBox( 10, -TextWidth*0.5 +1, 0, TextWidth+8, 35, Color(0,0,0,170) )
			draw.SimpleTextOutlined( text, "HUDNumber5", -TextWidth*0.5 + 5, 0, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
		cam.End3D2D()
	end
end
include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	//local owner = self:Getowning_ent()
	//owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")
	local TIMER;
	if (self:GetTimer() < CurTime()) then
		TIMER = 0
	else 
		TIMER = self:GetTimer()-CurTime()
	end
	local width = 0;
	if self:GetGetWoods() > 0 and self:GetTimer() > 0 then 
		width = (self:GetTimer()-CurTime())/(self:GetGetWoods()*SWM_SAW_TIME) * (207)
	end

	surface.SetFont("HUDNumber5")

	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local TextAng = Ang
	
	local process = "Process: "..string.ToMinutesSeconds(TIMER)
	local color
	if (TIMER > 0) then
		color = {175}
	else
		color = {0}
	end
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < SWM_DISTANCE then
		cam.Start3D2D(Pos+Ang:Right()*-20+Ang:Up()*13+Ang:Forward()*-3.5, Ang, 0.15)
			draw.SimpleTextOutlined( "Sawmill", "HUDNumber5", 0, 0, Color(255,255,255,255), 0, 0, 1, Color(0,150,0,150) )
		cam.End3D2D()
		
		cam.Start3D2D(Pos+Ang:Right()*-14.5+Ang:Up()*13+Ang:Forward()*-2.5, Ang, 0.07)
			draw.RoundedBox( 7, -6, -5, width+2, 50, Color(50,205,100,color[1]) )
			draw.SimpleTextOutlined( process, "HUDNumber5", 0, 5, Color(255,255,255,color[1]+50), 0, 0, 1, Color(0,50,0,color[1]+30) )
		cam.End3D2D()


	end
end
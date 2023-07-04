include("shared.lua")
include("craftsmanship/crft_fontgen.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

local barLerp = 0

function ENT:Draw()
	self:DrawModel()
	if self.barLerp == nil then self.barLerp = 0 end
	local Pos = self:GetPos()
	local Eye1 = EyeAngles() 
	local Ang = Angle(0, Eye1.y, 0)

	surface.SetFont("TreeFont")
	local text = "Oak Tree"
	local barwidth = 125
	local TextWidth = surface.GetTextSize(text)
	local width = self:GetTreeHealth()
	
	self.barLerp = (Lerp(FrameTime()*3, self.barLerp, width))
	barPerc = self.barLerp / SWM_TREE_HEALTH

	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 180)
	local TextAng = Ang

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
		if(LocalPlayer():Team() ~= LUMBERJACK) then return end
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 100.0)
		alpha = math.Clamp(2.5 - alpha, 0 ,1)
		
		cam.Start3D2D(Pos+Ang:Up()*20+Ang:Right()*-65, Ang, 0.2)
			draw.RoundedBox( 2, -barwidth*0.5, 25, barwidth, 8, Color(0,0,0,175*alpha) )
			draw.RoundedBox( 2, (-barwidth*0.5 + 3), 27, (barwidth - 6)*barPerc, 4, Color(232, 212, 148,175*alpha) )
			draw.SimpleTextOutlined( text, "TreeFont", -TextWidth*0.5, 0, Color(255,255,255,255*alpha), 0, 0, 1, Color(24, 68, 29, 125*alpha) )
		cam.End3D2D()
	end
end
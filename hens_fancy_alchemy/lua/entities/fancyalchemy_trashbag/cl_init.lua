include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
local vmat = Matrix()

function ENT:Draw()
	self:DrawModel()
	if self.time == nil then self.time = 0 end
	
	vmat:SetScale(Vector(0.75 + math.sin(self.time)*0.02, 0.75 + math.sin(self.time)*0.02, 0.75 + math.sin(self.time)*0.02))
	vmat:SetAngles(Angle(0, RealTime() %360 * 30, 0))
	vmat:SetTranslation(Vector(0, 0, 10))
	self:EnableMatrix("RenderMultiply", vmat)
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 100.0)
		alpha = math.Clamp(2.5 - alpha, 0 ,1)
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		cam.Start3D2D(self:GetPos() + Vector(0,0,50 + (math.sin(self.time*1)*2)), a , 0.11)
			draw.SimpleTextOutlined("Potion Trashbag","FALCH_Stacks", 0,0,Color(255,255,255,255*alpha) , 1, 1, 2, Color(0, 0, 0, 55*alpha))
		cam.End3D2D()
	end
	
	self.time = self.time + FrameTime()
end
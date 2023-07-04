include("shared.lua")

local qualityoffset = {
[0] = Vector(0,0,0),
[1] = Vector(0,0,20),
[2] = Vector(0,0,30),
[3] = Vector(0,0,35),
[4] = Vector(0,0,35),
[5] = Vector(0,0,40),
}

ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:Draw()
	self:DrawModel()
	
	local tag = self:GetQualityName()
	local tagcol = self:GetQualityColour()
	if self.time == nil then self.time = 0 end
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 100.0)
		alpha = math.Clamp(2.5 - alpha, 0 ,1)
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		local offset = qualityoffset[self:GetQuality()]
		cam.Start3D2D(self:GetPos() + offset + Vector(0,0,10 + (math.sin(self.time*1)*2)), a , 0.11)
			tagcol.a = tagcol.a*alpha
			draw.SimpleTextOutlined(tag,"FALCH_Stacks", 0,-35,tagcol , 1, 1, 1, Color(0,0,0, 55*alpha))
			draw.SimpleTextOutlined("Wealth Potion","FALCH_Stacks", 0,0,Color(255,255,255,255*alpha) , 1, 1, 2, Color(0, 0, 0, 55*alpha))
		cam.End3D2D()
	end
	
	self.time = self.time + FrameTime()
end